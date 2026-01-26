{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeApplications #-}

module Main (main) where

import Control.Monad (when)
import Control.Monad.IO.Class (liftIO)
import Data.Word (Word32)
import Foreign.Ptr (nullPtr, ptrToWordPtr, wordPtrToPtr)
import GHC.Generics (Generic)
import Slop hiding (clear, draw, drawMesh, output, pass, postProcess, render, withShader)
import Slop.Pipeline.Graph
import Slop.SDL.Raw (GPUDevice(..), GPUSampler(..), GPUTexture(..))
import Spirdo.Wesl
  ( CompiledShader(..)
  , ToUniform
  , prepareShader
  , wesl
  )
import Spirdo.Wesl.Inputs
  ( SamplerHandle(..)
  , StorageTextureHandle(..)
  , TextureHandle(..)
  , UniformSlot(..)
  , ShaderInputs(..)
  , inputsFromPrepared
  , uniformSlots
  )
import qualified Spirdo.Wesl.Inputs as Inputs

data Params = Params
  { time :: Float
  , width :: Float
  , height :: Float
  , _pad :: Float
  }
  deriving (Generic)

instance ToUniform Params

demoShader :: CompiledShader
demoShader =
  [wesl|
struct Params {
  time: f32,
  width: f32,
  height: f32,
  _pad: f32,
};

@group(3) @binding(0) var<uniform> params: Params;
@group(2) @binding(0) var spriteTex: texture_2d<f32>;
@group(2) @binding(1) var spriteSamp: sampler;
@group(2) @binding(2) var noiseTex: texture_2d<f32>;
@group(2) @binding(3) var noiseSamp: sampler;

@fragment
fn main(@location(0) uv: vec2<f32>, @location(1) inColor: vec4<f32>) -> @location(0) vec4<f32> {
  let center = vec2(0.5, 0.5);
  let offset = uv - center;
  let r = length(offset);
  let barrel = 1.0 + 0.12 * r * r;
  let uvDistorted = center + offset * barrel;

  let chroma = (0.0015 + 0.0015 * sin(params.time * 0.7)) * (1.0 + r * 1.5);
  let sampleR = textureSample(spriteTex, spriteSamp, uvDistorted + vec2(chroma, 0.0));
  let sampleG = textureSample(spriteTex, spriteSamp, uvDistorted);
  let sampleB = textureSample(spriteTex, spriteSamp, uvDistorted - vec2(chroma, 0.0));

  let vignette = 1.0 - smoothstep(0.35, 0.95, r);
  let scan = 0.92 + 0.08 * sin(uv.y * params.height * 0.25 + params.time * 18.0);
  let noise = fract(sin(dot(uv * vec2(12.9898, 78.233), vec2(12.9898, 78.233)) + params.time * 10.0) * 43758.5453);
  let noiseTexSample = textureSample(noiseTex, noiseSamp, uv * vec2(3.0, 3.0) + vec2(params.time * 0.03, params.time * 0.01));

  var color = vec3(sampleR.r, sampleG.g, sampleB.b);
  color = color * vignette * scan;
  color = color + (noise - 0.5) * 0.02;
  color = color * 0.85 + noiseTexSample.rgb * 0.15;

  return vec4(color.r * inColor.r, color.g * inColor.g, color.b * inColor.b, sampleG.a * inColor.a);
}
|]

computeShader :: CompiledShader
computeShader =
  [wesl|
struct Params {
  time: f32;
  width: f32;
  height: f32;
  _pad: f32;
};

@group(1) @binding(0)
var<storage, read_write> out_tex: texture_storage_2d<rgba8unorm, write>;

@group(2) @binding(0)
var<uniform> params: Params;

@compute @workgroup_size(8, 8, 1)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
  if (gid.x >= u32(params.width) || gid.y >= u32(params.height)) {
    return;
  }
  let uv = vec2(f32(gid.x) / params.width, f32(gid.y) / params.height);
  let wave = 0.5 + 0.5 * sin(uv.x * 16.0 + params.time) * cos(uv.y * 10.0 - params.time * 0.7);
  let col = vec3(0.15 + wave * 0.6, 0.2 + wave * 0.4, 0.85 - wave * 0.5);
  textureStore(out_tex, vec2(i32(gid.x), i32(gid.y)), vec4(col.x, col.y, col.z, 1.0));
}
|]

main :: IO ()
main = do
  let cfg =
        defaultConfig
          { windowTitle = "Slop SDL3.4 demo"
          , windowWidth = 960
          , windowHeight = 540
          , windowResizable = True
          , textAtlasSize = Just 1024
          }

  runWindow cfg $ do
    let orCrash label = either (liftIO . ioError . userError . (label <> ": " <>)) pure
    let load label spec = loadAssetAsync spec >>= awaitAsset >>= orCrash label
    let prepareOrCrash label shader = orCrash label (prepareShader shader)
    let inputsOrCrash label prepared builder = orCrash label (inputsFromPrepared prepared builder)

    demoPrepared <- prepareOrCrash "demoShader" demoShader
    computePrepared <- prepareOrCrash "computeShader" computeShader

    computePipe <-
      load "compute pipeline" (ComputePipelineAsset defaultCompute
        { computeShaderCode = shaderSpirv computeShader
        , computeReadwriteStorageTextures = 1
        , computeUniformBuffers = 1
        , computeThreads = (8, 8, 1)
        })

    let computeSize = 256
    computeTex <-
      load "compute texture" (TextureDescAsset (textureDesc computeSize computeSize)
        { texUsage = [TextureSampled, TextureStorageRead, TextureStorageWrite]
        })

    texture <- load "sprite" (TextureAsset "assets/sprite.bmp")
    font <- load "font" (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)
    ambience <- load "ambience" (MusicAsset "assets/ambience - air conditioner.wav")
    ambienceAlt <- load "ambience alt" (MusicAsset "assets/ambience - car sedan idling.wav")
    sfx <- load "air duster" (ChunkAsset "assets/air duster 7.wav")

    sampler <-
      load "sampler" (SamplerAsset defaultSamplerDesc
        { samplerAddressU = SamplerRepeat
        , samplerAddressV = SamplerRepeat
        })

    shader <- load "effect shader" demoShaderAsset
    let noiseSettings =
          defaultNoiseSettings
            { noiseType = NoisePerlin
            , noiseScale = 96
            , noiseOctaves = 4
            }
    noiseTex <- createNoiseTexture2D 256 256 noiseSettings

    blend <- createTrackPool PoolBlend 2
    sfxPool <- createTrackPool PoolRoundRobin 8
    _ <- runLoop (crossfadeToLoop blend ambience 0)

    let groupsX = fromIntegral ((computeSize + 7) `div` 8) :: Word32
    let groupsY = fromIntegral ((computeSize + 7) `div` 8) :: Word32
    let computeGroups = (groupsX, groupsY, 1)

    _ <- loop (0 :: Int) $ \frame active -> do
      let (winWInt, winHInt) = frame.size
      let winW = fromIntegral winWInt
      let winH = fromIntegral winHInt
      let winRect = rect 0 0 winW winH
      let cam2d =
            camera2D
              (V2 (winW / 2 + 40 * sin frame.time) (winH / 2 + 140))
              1
              (winW, winH)
      let params = Params frame.time winW winH 0
      let computeParams = Params frame.time (fromIntegral computeSize) (fromIntegral computeSize) 0

      let computeInputs =
            inputsOrCrash "compute inputs" computePrepared
              ( Inputs.storageTexture @"out_tex" (toStorageHandle computeTex)
                  <> Inputs.uniform @"params" computeParams
              )

      let effectInputs =
            inputsOrCrash "effect inputs" demoPrepared
              ( Inputs.uniform @"params" params
                  <> Inputs.texture @"spriteTex" (toTextureHandle texture)
                  <> Inputs.sampler @"spriteSamp" (toSamplerHandle sampler)
                  <> Inputs.texture @"noiseTex" (toTextureHandle computeTex)
                  <> Inputs.sampler @"noiseSamp" (toSamplerHandle sampler)
              )
      let effect = spriteEffectFrom shader effectInputs

      let pipeline = do
            compute computePipe (computeBindingsFrom computeInputs) computeGroups
            scene <- pass $ do
              clear (rgb 0.06 0.07 0.1)
              draw basicUI (Line (rgb 0.95 0.35 0.35) (point 80 90) (point 400 130))
              draw basicUI (RectOutline (rgb 0.2 0.8 0.9) (rect 80 150 200 120))
              draw basicUI (RectFill (rgba 0.25 0.25 0.8 0.9) (rect 320 150 120 120))
              draw basicUI (Sprite texture Nothing (rect 80 320 160 160) Nothing)
              draw basicUI (Sprite computeTex Nothing (rect 520 70 180 180) Nothing)
              draw basicUI (Sprite noiseTex Nothing (rect 720 70 180 180) Nothing)
              draw basicUI (Sprite texture Nothing (rect 320 320 200 160) (Just effect))
              let titleStyle = defaultTextStyle { textColor = rgb 0.95 0.9 0.6 }
              draw basicUI (textWith titleStyle font "Slop + SDL3.4" 80 40)
              let sceneY = 320
              draw (basic2D cam2d) (RectFill (rgba 0.1 0.1 0.2 0.9) (rect 60 sceneY 560 180))
              draw (basic2D cam2d) (RectOutline (rgb 0.15 0.7 0.6) (rect 60 sceneY 560 180))
              draw (basic2D cam2d) (Line (rgb 0.85 0.75 0.2) (point 80 (sceneY + 30)) (point 560 (sceneY + 30)))
              draw (basic2D cam2d) (Sprite texture Nothing (rect 100 (sceneY + 60) 120 120) Nothing)
              draw (basic2D cam2d) (Sprite computeTex Nothing (rect 260 (sceneY + 60) 120 120) Nothing)
              draw (basic2D cam2d) (Sprite texture Nothing (rect 420 (sceneY + 40) 160 140) (Just effect))
            output scene Nothing winRect

      active' <- if keyPressed KeyB frame.input
        then do
          let next = if active == 0 then 1 else 0
          _ <- if next == 0
            then crossfadeToLoop blend ambience 2.0
            else crossfadeToLoop blend ambienceAlt 2.0
          pure next
        else pure active

      _ <- if keyPressed keySpace frame.input
        then playPool sfxPool sfx
        else pure False

      render (winWInt, winHInt) pipeline
      pure (Continue active')

    removeAllAssets
    pure ()

-- Spirdo bridge helpers (local to the demo).

toTextureHandle :: Texture -> TextureHandle
toTextureHandle texture =
  let GPUTexture ptr = texture.textureHandle
  in TextureHandle (fromIntegral (ptrToWordPtr ptr))

toStorageHandle :: Texture -> StorageTextureHandle
toStorageHandle texture =
  let GPUTexture ptr = texture.textureHandle
  in StorageTextureHandle (fromIntegral (ptrToWordPtr ptr))

toSamplerHandle :: Sampler -> SamplerHandle
toSamplerHandle (Sampler (GPUSampler ptr)) =
  SamplerHandle (fromIntegral (ptrToWordPtr ptr))

textureFromHandle :: TextureHandle -> Texture
textureFromHandle (TextureHandle value) =
  Texture
    { textureHandle = GPUTexture (wordPtrToPtr (fromIntegral value))
    , textureDevice = GPUDevice nullPtr
    , textureWidth = 0
    , textureHeight = 0
    }

storageTextureFromHandle :: StorageTextureHandle -> Texture
storageTextureFromHandle (StorageTextureHandle value) =
  Texture
    { textureHandle = GPUTexture (wordPtrToPtr (fromIntegral value))
    , textureDevice = GPUDevice nullPtr
    , textureWidth = 0
    , textureHeight = 0
    }

samplerFromHandle :: SamplerHandle -> Sampler
samplerFromHandle (SamplerHandle value) =
  Sampler (GPUSampler (wordPtrToPtr (fromIntegral value)))

samplerPairs :: ShaderInputs iface -> [(Texture, Sampler)]
samplerPairs inputs =
  zipWith
    (\tex samp -> (textureFromHandle tex.textureHandle, samplerFromHandle samp.samplerHandle))
    inputs.siTextures
    inputs.siSamplers

uniformBytesFor :: Word32 -> [UniformSlot] -> [ShaderUniform]
uniformBytesFor group slots =
  [ ShaderUniformBytes binding bytes
  | UniformSlot g binding bytes <- slots
  , g == group
  ]

computeUniformBytesFor :: Word32 -> [UniformSlot] -> [ComputeBinding]
computeUniformBytesFor group slots =
  [ computeUniformBytes binding bytes
  | UniformSlot g binding bytes <- slots
  , g == group
  ]

computeBindingsFrom :: ShaderInputs iface -> [ComputeBinding]
computeBindingsFrom inputs =
  let uniforms = computeUniformBytesFor 2 (uniformSlots inputs)
      samplers = zipWith (\slot (tex, samp) -> ComputeSampler slot tex (Just samp)) [0..] (samplerPairs inputs)
      storage =
        [ ComputeStorageTextureRW entry.storageTextureBinding (storageTextureFromHandle entry.storageTextureHandle)
        | entry <- inputs.siStorageTextures
        ]
  in uniforms <> samplers <> storage

spriteEffectFrom :: Shader -> ShaderInputs iface -> SpriteEffect
spriteEffectFrom shader inputs =
  let uniforms = uniformBytesFor 3 (uniformSlots inputs)
      extras = drop 1 (samplerPairs inputs)
      samplers = zipWith (\slot (tex, samp) -> ShaderSamplerWith slot tex samp) [0..] extras
  in SpriteEffect shader (uniforms <> samplers)
