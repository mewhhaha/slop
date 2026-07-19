{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}

module Main (main) where

import Data.Word (Word32)
import qualified Data.Text as T
import Foreign.Ptr (nullPtr, ptrToWordPtr, wordPtrToPtr)
import GHC.Generics (Generic)
import Slop hiding (clear, draw)
import Slop.GPU hiding (drawMesh, output, pass, postProcess, render, withShader)
import Slop.Pipeline.Graph
import Slop.SDL.Raw (GPUDevice(..), GPUTexture(..))
import Spirdo.Wesl.Reflection
  ( ToUniform
  , defaultCompileOptions
  , imports
  , shaderSpirv
  , spirv
  , wesl
  )
import qualified Spirdo.Wesl.Reflection as W
import Spirdo.Wesl.Inputs
  ( InputsError(..)
  , ShaderInputs
  , StorageTextureInput(..)
  , StorageTextureHandle(..)
  , UniformInput(..)
  , inputsFor
  , inputsStorageTextures
  , inputsUniforms
  , storageTexture
  , uniform
  )

data Params = Params
  { time :: Float
  , width :: Float
  , height :: Float
  , _pad :: Float
  }
  deriving (Generic)

instance ToUniform Params

data SliceParams = SliceParams
  { time :: Float
  , width :: Float
  , height :: Float
  , depth :: Float
  }
  deriving (Generic)

instance ToUniform SliceParams

demoShader =
  $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
struct SlopGlobals {
  time: f32,
  _pad0: f32,
  renderSize: vec2<f32>,
  dpiScale: vec2<f32>,
  _pad1: vec2<f32>,
};

@group(3) @binding(0) var<uniform> slop: SlopGlobals;

@fragment
fn main(@location(0) uv: vec2<f32>, @location(1) inColor: vec4<f32>) -> @location(0) vec4<f32> {
  let center = vec2(0.5, 0.5);
  let offset = uv - center;
  let r = length(offset);
  let vignette = 1.0 - smoothstep(0.35, 0.95, r);
  let scan = 0.85 + 0.15 * sin(uv.y * slop.renderSize.y * 0.25 + slop.time * 18.0);
  let noise = fract(sin(dot(uv * vec2(12.9898, 78.233), vec2(39.3468, 11.135)) + slop.time * 9.0) * 43758.5453);
  let hue = vec3(0.2, 0.7, 0.95);
  var color = hue * (0.6 + 0.4 * sin(slop.time + uv.x * 6.0));
  color = color * vignette * scan;
  color = color + (noise - 0.5) * 0.04;

  return vec4(color.r * inColor.r, color.g * inColor.g, color.b * inColor.b, inColor.a);
}
|])

comboShader =
  $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
@group(2) @binding(0) var spriteTex: texture_2d<f32>;
@group(2) @binding(2) var spriteSamp: sampler;
@group(2) @binding(1) var noiseTex: texture_2d<f32>;
@group(2) @binding(3) var noiseSamp: sampler;

@fragment
fn main(@location(0) uv: vec2<f32>, @location(1) inColor: vec4<f32>) -> @location(0) vec4<f32> {
  let base = textureSample(spriteTex, spriteSamp, uv);
  let noise = textureSample(noiseTex, noiseSamp, uv * 3.0);
  let boost = vec3(0.6, 0.6, 0.6);
  let mixed = base.rgb * (boost + noise.rgb * boost);
  return vec4(mixed.r, mixed.g, mixed.b, base.a) * inColor;
}
|])

slice3dShader =
  $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
struct SliceParams {
  time: f32;
  width: f32;
  height: f32;
  depth: f32;
};

@group(1) @binding(0) var<storage> noiseVolume: texture_storage_3d<rgba8unorm, read_write>;
@group(1) @binding(1) var<storage> out_tex: texture_storage_2d<rgba8unorm, read_write>;
@group(2) @binding(0) var<uniform> params: SliceParams;

@compute @workgroup_size(8, 8, 1)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
  if (gid.x >= u32(params.width) || gid.y >= u32(params.height)) {
    return;
  }

  let depthF = max(1.0, params.depth);
  let depthI = i32(depthF);
  let zf = fract(params.time * 0.12) * depthF;
  let z0 = i32(floor(zf));
  let z1 = (z0 + 1) % depthI;
  let t = zf - floor(zf);

  let coord3d = vec3(i32(gid.x), i32(gid.y), z0);
  let coord3dNext = vec3(i32(gid.x), i32(gid.y), z1);
  let a = textureLoad(noiseVolume, coord3d);
  let b = textureLoad(noiseVolume, coord3dNext);
  let col = mix(a, b, vec4(t, t, t, t));
  textureStore(out_tex, vec2(i32(gid.x), i32(gid.y)), vec4(col.x, col.y, col.z, 1.0));
}
|])

computeShader =
  $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
struct Params {
  time: f32;
  width: f32;
  height: f32;
  _pad: f32;
};

@group(1) @binding(0)
var<storage> out_tex: texture_storage_2d<rgba8unorm, write>;

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
|])

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
    let load spec = loadAssetAsync spec >>= awaitAsset
    let inputs label shader builder = either (throwInputsError label) pure (inputsFor shader builder)

    computeLayout <- either throwSlop pure (reflectionFromShader "computeShader" computeShader)
    sliceLayout <- either throwSlop pure (reflectionFromShader "slice3dShader" slice3dShader)
    demoLayout <- either throwSlop pure (reflectionFromShader "demoShader" demoShader)
    comboLayout <- either throwSlop pure (reflectionFromShader "comboShader" comboShader)
    computeDesc <- either throwSlop pure (computeDescFromReflection (shaderSpirv computeShader) (threads3D 8 8 1) computeLayout)
    sliceDesc <- either throwSlop pure (computeDescFromReflection (shaderSpirv slice3dShader) (threads3D 8 8 1) sliceLayout)

    computePipe <-
      load (ComputePipelineAsset computeDesc)
    slicePipe <-
      load (ComputePipelineAsset sliceDesc)

    let computeSize = 256
    computeTex <-
      load (TextureDescAsset (textureDesc computeSize computeSize)
        { texUsage = [TextureSampled, TextureStorageRead, TextureStorageWrite]
        })

    texture <- load (TextureAsset "assets/sprite.bmp")
    font <- load (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)
    ambience <- load (MusicAsset "assets/ambience - air conditioner.wav")
    ambienceAlt <- load (MusicAsset "assets/ambience - car sedan idling.wav")
    sfx <- load (ChunkAsset "assets/air duster 7.wav")

    sampler <-
      load (SamplerAsset defaultSamplerDesc
        { samplerAddressU = SamplerRepeat
        , samplerAddressV = SamplerRepeat
        , samplerAddressW = SamplerRepeat
        })

    shader2d <- load (ReflectedShader2DAsset (shaderSpirv demoShader) demoLayout)
    shader2dCombo <- load (ReflectedShader2DAsset (shaderSpirv comboShader) comboLayout)
    let noiseSize = 512
    let noiseSettings =
          loopNoise2D noiseSize noiseSize
            defaultNoiseSettings
              { noiseType = NoisePerlin
              , noiseScale = 16
              , noiseOctaves = 4
              }
    noiseTex <- load (NoiseTexture2DAsset noiseSize noiseSize noiseSettings)
    let volumeSize = 160
    let volumeSettings =
          loopNoise3D volumeSize volumeSize volumeSize
            defaultNoiseSettings
              { noiseType = NoisePerlin
              , noiseScale = 8
              , noiseOctaves = 5
              , noiseGain = 0.55
              }
    noiseVolume <- load (NoiseTexture3DAsset volumeSize volumeSize volumeSize volumeSettings)
    noiseSliceTex <-
      load (TextureDescAsset (textureDesc volumeSize volumeSize)
        { texUsage = [TextureSampled, TextureStorageRead, TextureStorageWrite]
        })

    blend <- createTrackPool PoolBlend 2
    sfxPool <- createTrackPool PoolRoundRobin 8
    _ <- crossfadeToLoop blend ambience 0

    let groupsX = fromIntegral ((computeSize + 7) `div` 8) :: Word32
    let groupsY = fromIntegral ((computeSize + 7) `div` 8) :: Word32
    let computeGroups = (groupsX, groupsY, 1)
    let sliceGroups = (fromIntegral ((volumeSize + 7) `div` 8), fromIntegral ((volumeSize + 7) `div` 8), 1 :: Word32)
    fx <- spriteEffectNamed shader2d []
    fxCombo <- spriteEffectNamed shader2dCombo [NamedSamplerWith "noiseTex" noiseTex sampler]

    _ <- loop (0 :: Int) $ \frame active -> do
      let (winWInt, winHInt) = frame.renderSize
      let winW = fromIntegral winWInt
      let winH = fromIntegral winHInt
      let winRect = fullscreenRect frame.renderSize
      let cam2d =
            camera2D
              (V2 (winW / 2 + 40 * sin frame.time) (winH / 2 + 140))
              1
              (winW, winH)
      let computeParams = Params frame.time (fromIntegral computeSize) (fromIntegral computeSize) 0
      let sliceParams = SliceParams frame.time (fromIntegral volumeSize) (fromIntegral volumeSize) (fromIntegral volumeSize)

      computeInputs <-
        inputs "computeShader" computeShader
          ( storageTexture @"out_tex" (toStorageHandle computeTex)
              <> uniform @"params" computeParams
          )

      sliceInputs <-
        inputs "slice3dShader" slice3dShader
          ( storageTexture @"noiseVolume" (toStorageHandle noiseVolume)
              <> storageTexture @"out_tex" (toStorageHandle noiseSliceTex)
              <> uniform @"params" sliceParams
          )
      computeBindings <- either throwSlop pure (computeBindingsFromInputs computeLayout computeInputs)
      sliceBindings <- either throwSlop pure (computeBindingsFromInputs sliceLayout sliceInputs)

      let scene =
            pass $ mconcat
              [ clear (rgb 0.06 0.07 0.1)
              , draw basicUI (Line (rgb 0.95 0.35 0.35) (point 80 90) (point 400 130))
              , draw basicUI (RectOutline (rgb 0.2 0.8 0.9) (rect 80 150 200 120))
              , draw basicUI (RectFill (rgba 0.25 0.25 0.8 0.9) (rect 320 150 120 120))
              , draw basicUI (Sprite texture Nothing (rect 80 320 160 160) Nothing)
              , draw basicUI (Sprite computeTex Nothing (rect 520 70 180 180) Nothing)
              , draw basicUI (Sprite noiseTex Nothing (rect 720 70 180 180) Nothing)
              , draw basicUI (Sprite noiseSliceTex Nothing (rect 520 260 180 180) Nothing)
              , draw basicUI (Sprite texture Nothing (rect 320 320 200 160) (Just fxCombo))
              , draw basicUI (textWith (defaultTextStyle { textColor = rgb 0.95 0.9 0.6 }) font "Slop + SDL3.4" 80 40)
              , draw (basic2D cam2d) (RectFill (rgba 0.1 0.1 0.2 0.9) (rect 60 320 560 180))
              , draw (basic2D cam2d) (RectOutline (rgb 0.15 0.7 0.6) (rect 60 320 560 180))
              , draw (basic2D cam2d) (Line (rgb 0.85 0.75 0.2) (point 80 350) (point 560 350))
              , draw (basic2D cam2d) (Sprite texture Nothing (rect 100 380 120 120) Nothing)
              , draw (basic2D cam2d) (Sprite computeTex Nothing (rect 260 380 120 120) Nothing)
              , draw (basic2D cam2d) (Sprite texture Nothing (rect 420 360 160 140) (Just fx))
              ]

      let pipeline =
            compute computePipe computeBindings computeGroups
              *> compute slicePipe sliceBindings sliceGroups
              *> outputOf scene Nothing winRect

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
        else pure ()

      render frame.renderSize pipeline
      pure (Continue active')

    removeAllAssets
    pure ()

-- Spirdo bridge helpers (local to the demo).

toStorageHandle :: Texture -> StorageTextureHandle
toStorageHandle texture =
  let GPUTexture ptr = texture.textureHandle
  in StorageTextureHandle (fromIntegral (ptrToWordPtr ptr))

storageTextureFromHandle :: StorageTextureHandle -> Texture
storageTextureFromHandle (StorageTextureHandle value) =
  Texture
    { textureHandle = GPUTexture (wordPtrToPtr (fromIntegral value))
    , textureDevice = GPUDevice nullPtr
    , textureWidth = 0
    , textureHeight = 0
    , textureDepth = 1
    }

throwInputsError :: T.Text -> InputsError -> WindowM a
throwInputsError shaderName inputError =
  throwSlop
    ( SlopShaderFailure
        "build shader inputs"
        shaderName
        (T.pack <$> inputError.ieBinding)
        (T.pack inputError.ieMessage)
    )

reflectionFromShader :: T.Text -> W.Shader mode iface -> SlopResult ReflectedShaderLayout
reflectionFromShader shaderName shader = do
  bindings <- mapM (reflectedBinding shaderName) (W.shaderPlan shader).bpBindings
  shaderLayoutFromReflection shaderName (reflectedStage (W.shaderStageCached shader)) bindings

reflectedStage :: W.ShaderStage -> ShaderStage
reflectedStage stage =
  case stage of
    W.ShaderStageFragment -> ShaderFragment
    W.ShaderStageVertex -> ShaderVertex
    W.ShaderStageCompute -> ShaderCompute

reflectedBinding :: T.Text -> W.BindingInfo -> SlopResult ReflectedBinding
reflectedBinding shaderName binding = do
  bindingType <- reflectedBindingType shaderName binding
  pure ReflectedBinding
    { reflectedName = T.pack binding.biName
    , reflectedGroup = binding.biGroup
    , reflectedSlot = binding.biBinding
    , reflectedType = bindingType
    }

reflectedBindingType :: T.Text -> W.BindingInfo -> SlopResult ReflectedBindingType
reflectedBindingType shaderName binding =
  case binding.biKind of
    W.BUniform ->
      case uniformLayoutSize binding.biType of
        Just byteSize -> Right (ReflectedUniform byteSize)
        Nothing -> Left (unsupported "uniform reflection did not contain a host-shareable byte size")
    W.BSampler -> Right ReflectedSampler
    W.BSamplerComparison -> Right ReflectedSampler
    W.BTexture1D -> Right ReflectedSampledTexture
    W.BTexture1DArray -> Right ReflectedSampledTexture
    W.BTexture2D -> Right ReflectedSampledTexture
    W.BTexture2DArray -> Right ReflectedSampledTexture
    W.BTexture3D -> Right ReflectedSampledTexture
    W.BTextureCube -> Right ReflectedSampledTexture
    W.BTextureCubeArray -> Right ReflectedSampledTexture
    W.BTextureMultisampled2D -> Right ReflectedSampledTexture
    W.BTextureDepth2D -> Right ReflectedSampledTexture
    W.BTextureDepth2DArray -> Right ReflectedSampledTexture
    W.BTextureDepthCube -> Right ReflectedSampledTexture
    W.BTextureDepthCubeArray -> Right ReflectedSampledTexture
    W.BTextureDepthMultisampled2D -> Right ReflectedSampledTexture
    W.BStorageRead -> Right ReflectedStorageBuffer
    W.BStorageReadWrite -> Right ReflectedStorageBuffer
    W.BStorageTexture1D -> storageTextureType
    W.BStorageTexture2D -> storageTextureType
    W.BStorageTexture2DArray -> storageTextureType
    W.BStorageTexture3D -> storageTextureType
  where
    storageTextureType = ReflectedStorageTexture <$> reflectedStorageAccess binding.biType
    unsupported detail =
      SlopShaderFailure "reflect shader" shaderName (Just (T.pack binding.biName)) detail

reflectedStorageAccess :: W.TypeLayout -> SlopResult ReflectedStorageAccess
reflectedStorageAccess bindingType =
  case bindingType of
    W.TLStorageTexture1D _ access -> fromSpirdoAccess access
    W.TLStorageTexture2D _ access -> fromSpirdoAccess access
    W.TLStorageTexture2DArray _ access -> fromSpirdoAccess access
    W.TLStorageTexture3D _ access -> fromSpirdoAccess access
    _ -> Left (SlopShaderFailure "reflect shader" "unknown" Nothing "storage texture binding has a non-storage type")
  where
    fromSpirdoAccess W.StorageRead = Right ReflectedReadOnly
    fromSpirdoAccess W.StorageWrite = Right ReflectedReadWrite
    fromSpirdoAccess W.StorageReadWrite = Right ReflectedReadWrite

uniformLayoutSize :: W.TypeLayout -> Maybe Int
uniformLayoutSize bindingType =
  case bindingType of
    W.TLScalar _ _ byteSize -> Just (fromIntegral byteSize)
    W.TLVector _ _ _ byteSize -> Just (fromIntegral byteSize)
    W.TLMatrix _ _ _ _ byteSize _ -> Just (fromIntegral byteSize)
    W.TLArray _ _ _ _ byteSize -> Just (fromIntegral byteSize)
    W.TLStruct _ _ _ byteSize -> Just (fromIntegral byteSize)
    _ -> Nothing

computeBindingsFromInputs :: ReflectedShaderLayout -> ShaderInputs iface -> SlopResult [ComputeBinding]
computeBindingsFromInputs layout inputs =
  computeBindingsFromReflection layout (uniforms <> storageTextures)
  where
    uniforms =
      [ ComputeUniformBytesNamed (T.pack entry.uiName) entry.uiBytes
      | entry <- inputsUniforms inputs
      ]
    storageTextures =
      [ ComputeStorageTextureRWNamed
          (T.pack entry.storageTextureName)
          (storageTextureFromHandle entry.storageTextureHandle)
      | entry <- inputsStorageTextures inputs
      ]
