{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE TypeApplications #-}
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
  , BindingPlan(..)
  , ReflectBindings
  , StorageAccess(..)
  , ToUniform
  , TypeLayout(..)
  , biType
  , bindingInfoFor
  , bindingPlan
  , prepareShader
  , uniform
  , wesl
  )
import Spirdo.Wesl.Inputs
  ( HList(..)
  , SamplerHandle(..)
  , TextureHandle(..)
  , StorageTextureHandle(..)
  , UniformSlot(..)
  , SamplerInput(..)
  , TextureInput(..)
  , StorageTextureInput(..)
  , ShaderInputs(..)
  , uniformSlots
  , inputsForPrepared
  )

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
  case spirdoShaderCounts demoShader of
    Left err -> error ("demoShader counts: " <> err)
    Right counts ->
      ShaderAsset
        (shaderSpirv demoShader)
        counts.shaderSamplers
        counts.shaderStorageTextures
        counts.shaderStorageBuffers
        counts.shaderUniformBuffers

spirdoShaderCounts :: ReflectBindings iface => CompiledShader iface -> Either String ShaderCounts
spirdoShaderCounts shader =
  let bindingPlanLocal = bindingPlan shader.shaderInterface
      samplerCount = length bindingPlanLocal.bpSamplers
      textureCount = length bindingPlanLocal.bpTextures
  in if samplerCount /= textureCount
      then Left ("shader has " <> show samplerCount <> " samplers but " <> show textureCount <> " textures")
      else Right ShaderCounts
        { shaderSamplers = fromIntegral samplerCount
        , shaderStorageTextures = fromIntegral (length bindingPlanLocal.bpStorageTextures)
        , shaderStorageBuffers = fromIntegral (length bindingPlanLocal.bpStorageBuffers)
        , shaderUniformBuffers = fromIntegral (length bindingPlanLocal.bpUniforms)
        }

storageAccess :: TypeLayout -> Maybe StorageAccess
storageAccess layout =
  case layout of
    TLStorageTexture1D _ access -> Just access
    TLStorageTexture2D _ access -> Just access
    TLStorageTexture2DArray _ access -> Just access
    TLStorageTexture3D _ access -> Just access
    _ -> Nothing

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

storageBindings :: ShaderInputs iface -> Either String [ComputeBinding]
storageBindings inputs =
  mapM (computeStorage inputs) inputs.siStorageTextures
  where
    computeStorage inp entry = do
      info <- bindingInfoFor entry.storageTextureName inp.siShader.shaderInterface
      case storageAccess (biType info) of
        Just StorageRead ->
          pure (ComputeStorageTexture entry.storageTextureBinding (storageTextureFromHandle entry.storageTextureHandle))
        Just StorageWrite ->
          pure (ComputeStorageTextureRW entry.storageTextureBinding (storageTextureFromHandle entry.storageTextureHandle))
        Just StorageReadWrite ->
          pure (ComputeStorageTextureRW entry.storageTextureBinding (storageTextureFromHandle entry.storageTextureHandle))
        Nothing ->
          Left ("compute storage texture not supported: " <> entry.storageTextureName)

pairSamplers :: String -> [TextureHandle] -> [SamplerHandle] -> [(Texture, Sampler)]
pairSamplers label textures samplers =
  if length textures /= length samplers
    then error (label <> ": sampler/texture count mismatch")
    else zipWith (\t s -> (textureFromHandle t, samplerFromHandle s)) textures samplers

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

data ComputeDemo = ComputeDemo
  { computePipeline :: ComputePipeline
  , computeTexture :: Texture
  , computeWidth :: Int
  , computeHeight :: Int
  , computeGroups :: (Word32, Word32, Word32)
  }

createComputeDemo :: ComputePipeline -> Int -> Int -> WindowM ComputeDemo
createComputeDemo pipeline width height = do
  texture <- createTexture2D (textureDesc width height)
    { texUsage = [TextureSampled, TextureStorageRead, TextureStorageWrite]
    }
  let groupsX = fromIntegral ((width + 7) `div` 8) :: Word32
  let groupsY = fromIntegral ((height + 7) `div` 8) :: Word32
  pure ComputeDemo
    { computePipeline = pipeline
    , computeTexture = texture
    , computeWidth = width
    , computeHeight = height
    , computeGroups = (groupsX, groupsY, 1)
    }

destroyComputeDemo :: ComputeDemo -> WindowM ()
destroyComputeDemo demo =
  destroyTexture demo.computeTexture

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
    let demoPrepared =
          case prepareShader demoShader of
            Left err -> error ("demoShader: " <> err)
            Right value -> value
    let computePrepared =
          case prepareShader computeShader of
            Left err -> error ("computeShader: " <> err)
            Right value -> value
    let crash = either (liftIO . ioError . userError) pure
        (>==) = (>=>)
    computePipelineId <- (loadAsset >== crash) (ComputePipelineAsset defaultCompute
      { computeShaderCode = shaderSpirv computeShader
      , computeReadwriteStorageTextures = 1
      , computeUniformBuffers = 1
      , computeThreads = (8, 8, 1)
      })
    computePipe <- (awaitAsset >== crash) computePipelineId
    computeDemo <- createComputeDemo computePipe 256 256
    texId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")
    fontId <- loadAssetAsync (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)
    ambienceId <- loadAssetAsync (MusicAsset "assets/ambience - air conditioner.wav")
    ambienceAltId <- loadAssetAsync (MusicAsset "assets/ambience - car sedan idling.wav")
    sfxId <- loadAssetAsync (ChunkAsset "assets/air duster 7.wav")

    texture <- (awaitAsset >== crash) texId
    font <- (awaitAsset >== crash) fontId
    ambience <- (awaitAsset >== crash) ambienceId
    ambienceAlt <- (awaitAsset >== crash) ambienceAltId
    sfx <- (awaitAsset >== crash) sfxId
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
      let params = Params frame.time winW winH 0
      let computeParams = Params frame.time (fromIntegral computeDemo.computeWidth) (fromIntegral computeDemo.computeHeight) 0

      let computeInputs =
            case inputsForPrepared computePrepared
              ( StorageTextureHandle (fromIntegral (ptrToWordPtr (let GPUTexture p = computeDemo.computeTexture.textureHandle in p)))
                  :& uniform computeParams
                  :& HNil
              ) of
              Left err -> error ("compute inputs: " <> err)
              Right value -> value
      let computeBinds =
            case storageBindings computeInputs of
              Left err -> error ("compute storage: " <> err)
              Right storageBinds ->
                let uniforms = computeUniformsFor 2 (uniformSlots computeInputs)
                    samplerPairs = pairSamplers "compute" (map (\t -> t.textureHandle) computeInputs.siTextures) (map (\s -> s.samplerHandle) computeInputs.siSamplers)
                    samplers = zipWith (\slot (tex, samp) -> ComputeSampler slot tex (Just samp)) [0..] samplerPairs
                in uniforms <> samplers <> storageBinds

      let effectInputs =
            case inputsForPrepared demoPrepared
              ( uniform params
                  :& TextureHandle (fromIntegral (ptrToWordPtr (let GPUTexture p = texture.textureHandle in p)))
                  :& SamplerHandle (fromIntegral (ptrToWordPtr (let GPUSampler p = case sampler of Sampler s -> s in p)))
                  :& TextureHandle (fromIntegral (ptrToWordPtr (let GPUTexture p = computeDemo.computeTexture.textureHandle in p)))
                  :& SamplerHandle (fromIntegral (ptrToWordPtr (let GPUSampler p = case sampler of Sampler s -> s in p)))
                  :& HNil
              ) of
              Left err -> error ("effect inputs: " <> err)
              Right value -> value
      let effect =
            let uniforms = uniformsFor 3 (uniformSlots effectInputs)
                samplerPairs = pairSamplers "effect" (map (\t -> t.textureHandle) effectInputs.siTextures) (map (\s -> s.samplerHandle) effectInputs.siSamplers)
                extraPairs = drop 1 samplerPairs
                samplers = zipWith (\slot (tex, samp) -> ShaderSamplerWith slot tex samp) [0..] extraPairs
            in SpriteEffect shader (uniforms <> samplers)

      let pipeline = do
            compute computeDemo.computePipeline computeBinds computeDemo.computeGroups
            scene <- pass $ do
              clear (rgb 0.06 0.07 0.1)
              draw as2D (Line (rgb 0.95 0.35 0.35) (point 80 90) (point 400 130))
              draw as2D (RectOutline (rgb 0.2 0.8 0.9) (rect 80 150 200 120))
              draw as2D (RectFill (rgba 0.25 0.25 0.8 0.9) (rect 320 150 120 120))
              draw as2D (Sprite texture Nothing (rect 80 320 160 160) Nothing)
              draw as2D (Sprite computeDemo.computeTexture Nothing (rect 520 70 180 180) Nothing)
              draw as2D (Sprite texture Nothing (rect 320 320 200 160) (Just effect))
              draw as2D (text font "Slop + SDL3.4" 80 40)
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

    destroyComputeDemo computeDemo
    removeAllAssets
    pure ()
