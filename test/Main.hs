{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE TypeApplications #-}

module Main (main) where

import Control.Exception (try)
import Data.Int (Int32)
import qualified Data.Text as T
import Foreign.C.Types (CInt(..), CSize(..))
import Foreign.Ptr (nullPtr)
import Foreign.Storable (Storable, alignment, sizeOf)

import Slop
import Slop.GPU
import qualified Slop.SDL.Raw as SDL

main :: IO ()
main = do
  basicGeometryIsBackendNeutral
  drawContextsEncodeBlendAndCamera
  drawContextRetainsCameraWhenEffectIsAdded
  invalidConfigFailsBeforeSDLInitialization
  advancedCameraIsAvailableFromGPU
  camera2DBehaviorIsPureAndReversible
  cameraViewMovesTheEyeToTheOrigin
  cameraViewPlacesTheTargetAtPositiveDepth
  perspectiveMapsTheDepthRangeToSDLClipSpace
  reflectedCountsIgnoreDeclarationOrder
  duplicateReflectedNamesCarryBindingEvidence
  invalidDescriptorGroupCarriesBindingEvidence
  namedUniformsFollowReflectedSlots
  missingNamedUniformFailsBeforeDrawing
  duplicateNamedUniformFailsBeforeDrawing
  wrongNamedBindingTypeFailsBeforeDrawing
  uniformSizeMismatchIsTyped
  failedWindowSizeQueriesDoNotExposeUninitializedOutputs
  failedRenderPresentationIsObservable
  rawStructLayoutsMatchSDL

basicGeometryIsBackendNeutral :: IO ()
basicGeometryIsBackendNeutral = do
  let rectangle :: FRect
      rectangle = rect 1 2 3 4
  let windowTypeIsPublic :: Maybe Window
      windowTypeIsPublic = Nothing
  rectangle `seq` pure ()
  windowTypeIsPublic `seq` pure ()

drawContextsEncodeBlendAndCamera :: IO ()
drawContextsEncodeBlendAndCamera = do
  let camera = camera2DScreen (640, 360)
  case basic2D camera of
    As2D BlendAlpha (Just actualCamera) Nothing ->
      assertEqual "basic 2D camera" camera actualCamera
    _ -> fail "basic2D did not select alpha blending with its camera"
  case basicUI of
    As2D BlendPremultiplied Nothing Nothing -> pure ()
    _ -> fail "basicUI did not select premultiplied screen-space rendering"
  case basicParticleWithCamera camera of
    As2D BlendAdditive (Just actualCamera) Nothing ->
      assertEqual "particle camera" camera actualCamera
    _ -> fail "basicParticleWithCamera did not select additive blending with its camera"

drawContextRetainsCameraWhenEffectIsAdded :: IO ()
drawContextRetainsCameraWhenEffectIsAdded = do
  let camera = camera2DScreen (640, 360)
      effect = spriteEffect (error "test effect shader was evaluated") []
      context = (basic2D camera) { draw2DEffect = Just effect }
  case context of
    As2D BlendAlpha (Just actualCamera) (Just _) ->
      assertEqual "effect context camera" camera actualCamera
    _ -> fail "adding a sprite effect discarded the 2D camera context"

invalidConfigFailsBeforeSDLInitialization :: IO ()
invalidConfigFailsBeforeSDLInitialization = do
  result <- try (runWindow defaultConfig { windowWidth = 0 } (pure ())) :: IO (Either Error ())
  case result of
    Left IOFailure { errorResource = "windowWidth", errorDetail = detail }
      | "got 0" `T.isInfixOf` detail -> pure ()
    Left err -> fail ("expected invalid windowWidth evidence, got " <> T.unpack (renderError err))
    Right _ -> fail "invalid window width reached SDL initialization"

advancedCameraIsAvailableFromGPU :: IO ()
advancedCameraIsAvailableFromGPU = do
  let camera = camera3D (V3 0 0 5) (V3 0 0 0) (V3 0 1 0) (pi / 3) (16 / 9) 0.1 100
  camera `seq` pure ()

camera2DBehaviorIsPureAndReversible :: IO ()
camera2DBehaviorIsPureAndReversible = do
  let camera = camera2D (V2 320 180) 1 (640, 360)
      followed = followCamera2D 8 0.1 (V2 420 180) camera
      clamped = clampCamera2D (640, 360) (rect 0 0 800 600) (camera { camera2DPosition = V2 900 (-20) })
      shaken = shakeCamera2D (V2 4 (-3)) camera
      worldPoint = V2 400 210
      screenPoint = worldToScreen (640, 360) camera worldPoint
  case screenToWorld (640, 360) camera screenPoint of
    Nothing -> fail "invertible 2D camera rejected screen-to-world conversion"
    Just restored -> assertV2Near "2D camera coordinate round trip" worldPoint restored
  assertEqual "camera following advances toward its target" True (followed.camera2DPosition /= camera.camera2DPosition)
  assertEqual
    "invalid camera response leaves the camera unchanged"
    camera
    (followCamera2D (0 / 0) 0.1 (V2 420 180) camera)
  assertEqual "camera bounds retain the visible viewport" (V2 480 180) clamped.camera2DPosition
  assertEqual "camera shake adds an authored offset" (V2 324 177) shaken.camera2DPosition
  assertEqual
    "empty render sizes cannot be converted to world coordinates"
    Nothing
    (screenToWorld (0, 360) camera screenPoint)

cameraViewMovesTheEyeToTheOrigin :: IO ()
cameraViewMovesTheEyeToTheOrigin = do
  let eye = V3 2 3 5
      camera = camera3D eye (V3 0 0 0) (V3 0 1 0) (pi / 3) (16 / 9) 0.1 100
  assertV3Near "camera eye in view space" (V3 0 0 0) (transformPoint (camera3DView camera) eye)

cameraViewPlacesTheTargetAtPositiveDepth :: IO ()
cameraViewPlacesTheTargetAtPositiveDepth = do
  let target = V3 0 0 0
      camera = camera3D (V3 0 0 5) target (V3 0 1 0) (pi / 3) (16 / 9) 0.1 100
      V3 _ _ targetDepth = transformPoint (camera3DView camera) target
  assertNear "camera target depth" 5 targetDepth

perspectiveMapsTheDepthRangeToSDLClipSpace :: IO ()
perspectiveMapsTheDepthRangeToSDLClipSpace = do
  let near = 0.1
      far = 100
      projection = perspective (pi / 2) 1 near far :: M44 Float
      V3 _ _ nearDepth = transformPoint projection (V3 0 0 near)
      V3 _ _ farDepth = transformPoint projection (V3 0 0 far)
  assertNear "near clipping plane" 0 nearDepth
  assertNear "far clipping plane" 1 farDepth

reflectedCountsIgnoreDeclarationOrder :: IO ()
reflectedCountsIgnoreDeclarationOrder = do
  layout <- expectRight $ shaderLayoutFromReflection "post-process" ShaderFragment
    [ ReflectedBinding "noise" 2 1 ReflectedSampledTexture
    , ReflectedBinding "globals" 3 0 (ReflectedUniform 32)
    , ReflectedBinding "source" 2 0 ReflectedSampledTexture
    ]
  let ShaderCounts samplers storageTextures storageBuffers uniforms = shaderCountsFromReflection layout
  assertEqual "sampler count" 2 samplers
  assertEqual "storage texture count" 0 storageTextures
  assertEqual "storage buffer count" 0 storageBuffers
  assertEqual "uniform count" 1 uniforms

duplicateReflectedNamesCarryBindingEvidence :: IO ()
duplicateReflectedNamesCarryBindingEvidence =
  case shaderLayoutFromReflection "duplicate-test" ShaderFragment
    [ ReflectedBinding "source" 2 0 ReflectedSampledTexture
    , ReflectedBinding "source" 2 1 ReflectedSampledTexture
    ] of
    Left ShaderFailure { errorResource = shaderName, errorBinding = Just bindingName } -> do
      assertEqual "shader name" "duplicate-test" shaderName
      assertEqual "binding name" "source" bindingName
    Left err -> fail ("expected shader and binding evidence, got " <> T.unpack (renderError err))
    Right _ -> fail "duplicate reflected binding name was accepted"

invalidDescriptorGroupCarriesBindingEvidence :: IO ()
invalidDescriptorGroupCarriesBindingEvidence =
  case shaderLayoutFromReflection "wrong-group" ShaderFragment
    [ReflectedBinding "params" 2 0 (ReflectedUniform 4)] of
    Left ShaderFailure { errorBinding = Just "params" } -> pure ()
    Left err -> fail ("expected descriptor group evidence, got " <> T.unpack (renderError err))
    Right _ -> fail "fragment uniform in the wrong descriptor group was accepted"

namedUniformsFollowReflectedSlots :: IO ()
namedUniformsFollowReflectedSlots = do
  layout <- expectRight $ shaderLayoutFromReflection "uniform-order" ShaderFragment
    [ ReflectedBinding "second" 3 1 (ReflectedUniform 4)
    , ReflectedBinding "first" 3 0 (ReflectedUniform 4)
    ]
  bindings <- expectRight $ resolveReflectedUniforms layout
    [ NamedUniform "second" (2 :: Int32)
    , NamedUniform "first" (1 :: Int32)
    ]
  case bindings of
    [ShaderUniform secondSlot _, ShaderUniform firstSlot _] -> do
      assertEqual "second reflected slot" 1 secondSlot
      assertEqual "first reflected slot" 0 firstSlot
    _ -> fail "reflected uniforms did not resolve to uniform bindings"

missingNamedUniformFailsBeforeDrawing :: IO ()
missingNamedUniformFailsBeforeDrawing = do
  layout <- expectRight $ shaderLayoutFromReflection "missing-uniform" ShaderFragment
    [ ReflectedBinding "globals" 3 0 (ReflectedUniform 32)
    , ReflectedBinding "params" 3 1 (ReflectedUniform 4)
    ]
  case resolveReflectedUniforms layout [] of
    Left ShaderFailure { errorBinding = Just "params" } -> pure ()
    Left err -> fail ("expected missing params evidence, got " <> T.unpack (renderError err))
    Right _ -> fail "missing reflected uniform was accepted"

duplicateNamedUniformFailsBeforeDrawing :: IO ()
duplicateNamedUniformFailsBeforeDrawing = do
  layout <- expectRight $ shaderLayoutFromReflection "duplicate-uniform" ShaderFragment
    [ ReflectedBinding "globals" 3 0 (ReflectedUniform 32)
    , ReflectedBinding "params" 3 1 (ReflectedUniform 4)
    ]
  case resolveReflectedUniforms layout
    [ NamedUniform "params" (1 :: Int32)
    , NamedUniform "params" (2 :: Int32)
    ] of
    Left ShaderFailure { errorBinding = Just "params" } -> pure ()
    Left err -> fail ("expected duplicate params evidence, got " <> T.unpack (renderError err))
    Right _ -> fail "duplicate reflected uniform was accepted"

wrongNamedBindingTypeFailsBeforeDrawing :: IO ()
wrongNamedBindingTypeFailsBeforeDrawing = do
  layout <- expectRight $ shaderLayoutFromReflection "wrong-binding-type" ShaderFragment
    [ReflectedBinding "source" 2 0 ReflectedSampledTexture]
  case resolveReflectedUniforms layout [NamedUniform "source" (1 :: Int32)] of
    Left ShaderFailure { errorBinding = Just "source" } -> pure ()
    Left err -> fail ("expected binding type evidence, got " <> T.unpack (renderError err))
    Right _ -> fail "uniform value was accepted for a sampled texture"

uniformSizeMismatchIsTyped :: IO ()
uniformSizeMismatchIsTyped =
  case shaderUniformSized 3 16 (1 :: Int32) of
    Left ShaderFailure { errorBinding = Just "3" } -> pure ()
    Left err -> fail ("expected uniform slot evidence, got " <> T.unpack (renderError err))
    Right _ -> fail "uniform size mismatch was accepted"

failedWindowSizeQueriesDoNotExposeUninitializedOutputs :: IO ()
failedWindowSizeQueriesDoNotExposeUninitializedOutputs = do
  logicalSize <- SDL.sdlGetWindowSize (SDL.Window nullPtr)
  pixelSize <- SDL.sdlGetWindowSizeInPixels (SDL.Window nullPtr)
  assertEqual "invalid logical window size" Nothing logicalSize
  assertEqual "invalid pixel window size" Nothing pixelSize

failedRenderPresentationIsObservable :: IO ()
failedRenderPresentationIsObservable = do
  presented <- SDL.sdlRenderPresent (SDL.Renderer nullPtr)
  assertEqual "invalid renderer presentation" False presented

rawStructLayoutsMatchSDL :: IO ()
rawStructLayoutsMatchSDL =
  mapM_ assertLayout (zip [0 ..] haskellLayouts)
  where
    assertLayout (index, (label, haskellSize, haskellAlignment)) = do
      nativeSize <- fromIntegral <$> c_slop_abi_size index
      nativeAlignment <- fromIntegral <$> c_slop_abi_alignment index
      assertEqual (label <> " size") nativeSize haskellSize
      assertEqual (label <> " alignment") nativeAlignment haskellAlignment

haskellLayouts :: [(String, Int, Int)]
haskellLayouts =
  [ layoutOf @SDL.SDL_TextInputEvent "SDL_TextInputEvent"
  , layoutOf @SDL.SDL_MouseWheelEvent "SDL_MouseWheelEvent"
  , layoutOf @SDL.FPoint "SDL_FPoint"
  , layoutOf @SDL.IRect "SDL_Rect"
  , layoutOf @SDL.FRect "SDL_FRect"
  , layoutOf @SDL.FColor "SDL_FColor"
  , layoutOf @SDL.GPUTextureSamplerBinding "SDL_GPUTextureSamplerBinding"
  , layoutOf @SDL.GPUStorageBufferReadWriteBinding "SDL_GPUStorageBufferReadWriteBinding"
  , layoutOf @SDL.GPUStorageTextureReadWriteBinding "SDL_GPUStorageTextureReadWriteBinding"
  , layoutOf @SDL.GPUBufferBinding "SDL_GPUBufferBinding"
  , layoutOf @SDL.GPUViewport "SDL_GPUViewport"
  , layoutOf @SDL.GPUVertexBufferDescription "SDL_GPUVertexBufferDescription"
  , layoutOf @SDL.GPUVertexAttribute "SDL_GPUVertexAttribute"
  , layoutOf @SDL.GPUVertexInputState "SDL_GPUVertexInputState"
  , layoutOf @SDL.GPUColorTargetBlendState "SDL_GPUColorTargetBlendState"
  , layoutOf @SDL.GPUColorTargetDescription "SDL_GPUColorTargetDescription"
  , layoutOf @SDL.GPUGraphicsPipelineTargetInfo "SDL_GPUGraphicsPipelineTargetInfo"
  , layoutOf @SDL.GPURasterizerState "SDL_GPURasterizerState"
  , layoutOf @SDL.GPUMultisampleState "SDL_GPUMultisampleState"
  , layoutOf @SDL.GPUStencilOpState "SDL_GPUStencilOpState"
  , layoutOf @SDL.GPUDepthStencilState "SDL_GPUDepthStencilState"
  , layoutOf @SDL.GPUShaderCreateInfo "SDL_GPUShaderCreateInfo"
  , layoutOf @SDL.GPUSamplerCreateInfo "SDL_GPUSamplerCreateInfo"
  , layoutOf @SDL.GPURenderStateCreateInfo "SDL_GPURenderStateCreateInfo"
  , layoutOf @SDL.GPUComputePipelineCreateInfo "SDL_GPUComputePipelineCreateInfo"
  , layoutOf @SDL.GPUGraphicsPipelineCreateInfo "SDL_GPUGraphicsPipelineCreateInfo"
  , layoutOf @SDL.GPUTextureCreateInfo "SDL_GPUTextureCreateInfo"
  , layoutOf @SDL.GPUBufferCreateInfo "SDL_GPUBufferCreateInfo"
  , layoutOf @SDL.GPUTransferBufferCreateInfo "SDL_GPUTransferBufferCreateInfo"
  , layoutOf @SDL.GPUTextureTransferInfo "SDL_GPUTextureTransferInfo"
  , layoutOf @SDL.GPUTransferBufferLocation "SDL_GPUTransferBufferLocation"
  , layoutOf @SDL.GPUTextureRegion "SDL_GPUTextureRegion"
  , layoutOf @SDL.GPUBufferRegion "SDL_GPUBufferRegion"
  , layoutOf @SDL.GPUColorTargetInfo "SDL_GPUColorTargetInfo"
  , layoutOf @SDL.GPUDepthStencilTargetInfo "SDL_GPUDepthStencilTargetInfo"
  , layoutOf @SDL.SurfaceInfo "SDL_Surface"
  , layoutOf @SDL.TTF_GPUAtlasDrawSequence "TTF_GPUAtlasDrawSequence"
  ]

layoutOf :: forall a. Storable a => String -> (String, Int, Int)
layoutOf label =
  (label, sizeOf (undefined :: a), alignment (undefined :: a))

foreign import ccall unsafe "slop_abi_size"
  c_slop_abi_size :: CInt -> IO CSize

foreign import ccall unsafe "slop_abi_alignment"
  c_slop_abi_alignment :: CInt -> IO CSize

expectRight :: Result a -> IO a
expectRight result =
  case result of
    Left err -> fail (T.unpack (renderError err))
    Right value -> pure value

assertEqual :: (Eq a, Show a) => String -> a -> a -> IO ()
assertEqual label expected actual =
  if expected == actual
    then pure ()
    else fail (label <> ": expected " <> show expected <> ", got " <> show actual)

assertV3Near :: String -> V3 Float -> V3 Float -> IO ()
assertV3Near label (V3 expectedX expectedY expectedZ) (V3 actualX actualY actualZ) = do
  assertNear (label <> " x") expectedX actualX
  assertNear (label <> " y") expectedY actualY
  assertNear (label <> " z") expectedZ actualZ

assertV2Near :: String -> V2 Float -> V2 Float -> IO ()
assertV2Near label (V2 expectedX expectedY) (V2 actualX actualY) = do
  assertNear (label <> " x") expectedX actualX
  assertNear (label <> " y") expectedY actualY

assertNear :: String -> Float -> Float -> IO ()
assertNear label expected actual =
  if abs (expected - actual) <= 0.0001
    then pure ()
    else fail (label <> ": expected " <> show expected <> ", got " <> show actual)
