{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -Wno-partial-type-signatures #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}

module Main (main) where

import Control.Monad ((>=>))
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
  , TextureHandle(..)
  , StorageTextureHandle(..)
  , UniformSlot(..)
  , SamplerInput(..)
  , TextureInput(..)
  , StorageTextureInput(..)
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

demoShaderAsset :: ShaderAsset
demoShaderAsset =
  ShaderAsset
    (shaderSpirv demoShader)
    2
    0
    0
    1

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

spirdoTexture :: Texture -> TextureHandle
spirdoTexture texture =
  let GPUTexture ptr = texture.textureHandle
  in TextureHandle (fromIntegral (ptrToWordPtr ptr))

spirdoStorageTexture :: Texture -> StorageTextureHandle
spirdoStorageTexture texture =
  let GPUTexture ptr = texture.textureHandle
  in StorageTextureHandle (fromIntegral (ptrToWordPtr ptr))

spirdoSampler :: Sampler -> SamplerHandle
spirdoSampler (Sampler (GPUSampler ptr)) =
  SamplerHandle (fromIntegral (ptrToWordPtr ptr))

storageBindings :: ShaderInputs iface -> [ComputeBinding]
storageBindings inputs =
  [ ComputeStorageTextureRW entry.storageTextureBinding (storageTextureFromHandle entry.storageTextureHandle)
  | entry <- inputs.siStorageTextures
  ]

pairSamplers :: [TextureHandle] -> [SamplerHandle] -> [(Texture, Sampler)]
pairSamplers textures samplers =
  zipWith (\t s -> (textureFromHandle t, samplerFromHandle s)) textures samplers

samplerPairs :: ShaderInputs iface -> [(Texture, Sampler)]
samplerPairs inputs =
  pairSamplers (map (\t -> t.textureHandle) inputs.siTextures) (map (\s -> s.samplerHandle) inputs.siSamplers)

uniformsFor :: Word32 -> [UniformSlot] -> [ShaderUniform]
uniformsFor group slots =
  [ ShaderUniformBytes binding bytes
  | UniformSlot g binding bytes <- slots
  , g == group
  ]

computeUniformsFor :: Word32 -> [UniformSlot] -> [ComputeBinding]
computeUniformsFor group slots =
  [ computeUniformBytes binding bytes
  | UniformSlot g binding bytes <- slots
  , g == group
  ]

computeBindings :: ShaderInputs iface -> [ComputeBinding]
computeBindings inputs =
  let uniforms = computeUniformsFor 2 (uniformSlots inputs)
      samplers = zipWith (\slot (tex, samp) -> ComputeSampler slot tex (Just samp)) [0..] (samplerPairs inputs)
      storage = storageBindings inputs
  in uniforms <> samplers <> storage

spriteEffectFrom :: Shader -> ShaderInputs iface -> SpriteEffect
spriteEffectFrom shader inputs =
  let uniforms = uniformsFor 3 (uniformSlots inputs)
      extras = drop 1 (samplerPairs inputs)
      samplers = zipWith (\slot (tex, samp) -> ShaderSamplerWith slot tex samp) [0..] extras
  in SpriteEffect shader (uniforms <> samplers)

data ComputeDemo = ComputeDemo
  { computePipeline :: ComputePipeline
  , computeTexture :: Texture
  , computeWidth :: Int
  , computeHeight :: Int
  , computeGroups :: (Word32, Word32, Word32)
  }

createComputeDemo :: ComputePipeline -> Texture -> Int -> Int -> ComputeDemo
createComputeDemo pipeline texture width height =
  let groupsX = fromIntegral ((width + 7) `div` 8) :: Word32
      groupsY = fromIntegral ((height + 7) `div` 8) :: Word32
  in ComputeDemo
      { computePipeline = pipeline
      , computeTexture = texture
      , computeWidth = width
      , computeHeight = height
      , computeGroups = (groupsX, groupsY, 1)
      }

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
    let unsafePrepare label shader =
          case prepareShader shader of
            Left err -> error (label <> ": " <> err)
            Right value -> value
    let unsafeInputs label prepared inputs =
          case inputsFromPrepared prepared inputs of
            Left err -> error (label <> ": " <> err)
            Right value -> value
    let demoPrepared = unsafePrepare "demoShader" demoShader
    let computePrepared = unsafePrepare "computeShader" computeShader
    let crash = either (liftIO . ioError . userError) pure
        (>==) = (>=>)
        load :: AssetLoader spec => spec -> WindowM (AssetType spec)
        load spec = loadAssetAsync spec >>= (awaitAsset >== crash)
    computePipelineId <- (loadAsset >== crash) (ComputePipelineAsset defaultCompute
      { computeShaderCode = shaderSpirv computeShader
      , computeReadwriteStorageTextures = 1
      , computeUniformBuffers = 1
      , computeThreads = (8, 8, 1)
      })
    computePipe <- (awaitAsset >== crash) computePipelineId
    computeTexId <- loadAssetAsync (TextureDescAsset (textureDesc 256 256)
      { texUsage = [TextureSampled, TextureStorageRead, TextureStorageWrite]
      })
    computeTex <- (awaitAsset >== crash) computeTexId
    let computeDemo = createComputeDemo computePipe computeTex 256 256
    texture <- load (TextureAsset "assets/sprite.bmp")
    font <- load (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)
    ambience <- load (MusicAsset "assets/ambience - air conditioner.wav")
    ambienceAlt <- load (MusicAsset "assets/ambience - car sedan idling.wav")
    sfx <- load (ChunkAsset "assets/air duster 7.wav")
    samplerId <- (loadAsset >== crash) (SamplerAsset defaultSamplerDesc
      { samplerAddressU = SamplerRepeat
      , samplerAddressV = SamplerRepeat
      })
    sampler <- (awaitAsset >== crash) samplerId

    shaderId <- (loadAsset >== crash) demoShaderAsset
    shader <- (awaitAsset >== crash) shaderId

    blend <- createTrackPool PoolBlend 2
    sfxPool <- createTrackPool PoolRoundRobin 8
    _ <- runLoop (crossfadeToLoop blend ambience 0)

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
      let computeParams = Params frame.time (fromIntegral computeDemo.computeWidth) (fromIntegral computeDemo.computeHeight) 0

      let computeInputs =
            unsafeInputs "compute inputs" computePrepared
              ( Inputs.storageTexture @"out_tex" (spirdoStorageTexture computeDemo.computeTexture)
                  <> Inputs.uniform @"params" computeParams
              )
      let computeBinds = computeBindings computeInputs

      let effectInputs =
            unsafeInputs "effect inputs" demoPrepared
              ( Inputs.uniform @"params" params
                  <> Inputs.texture @"spriteTex" (spirdoTexture texture)
                  <> Inputs.sampler @"spriteSamp" (spirdoSampler sampler)
                  <> Inputs.texture @"noiseTex" (spirdoTexture computeDemo.computeTexture)
                  <> Inputs.sampler @"noiseSamp" (spirdoSampler sampler)
              )
      let effect = spriteEffectFrom shader effectInputs

      let pipeline = do
            compute computeDemo.computePipeline computeBinds computeDemo.computeGroups
            scene <- pass $ do
              clear (rgb 0.06 0.07 0.1)
              draw basicUI (Line (rgb 0.95 0.35 0.35) (point 80 90) (point 400 130))
              draw basicUI (RectOutline (rgb 0.2 0.8 0.9) (rect 80 150 200 120))
              draw basicUI (RectFill (rgba 0.25 0.25 0.8 0.9) (rect 320 150 120 120))
              draw basicUI (Sprite texture Nothing (rect 80 320 160 160) Nothing)
              draw basicUI (Sprite computeDemo.computeTexture Nothing (rect 520 70 180 180) Nothing)
              draw basicUI (Sprite texture Nothing (rect 320 320 200 160) (Just effect))
              draw basicUI (text font "Slop + SDL3.4" 80 40)
              let sceneY = 320
              draw (basic2D cam2d) (RectFill (rgba 0.1 0.1 0.2 0.9) (rect 60 sceneY 560 180))
              draw (basic2D cam2d) (RectOutline (rgb 0.15 0.7 0.6) (rect 60 sceneY 560 180))
              draw (basic2D cam2d) (Line (rgb 0.85 0.75 0.2) (point 80 (sceneY + 30)) (point 560 (sceneY + 30)))
              draw (basic2D cam2d) (Sprite texture Nothing (rect 100 (sceneY + 60) 120 120) Nothing)
              draw (basic2D cam2d) (Sprite computeDemo.computeTexture Nothing (rect 260 (sceneY + 60) 120 120) Nothing)
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
