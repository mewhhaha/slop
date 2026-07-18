{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

module Slop.Internal
  ( Config(..)
  , defaultConfig
  , ConfigPatch(..)
  , applyConfigPatch
  , Window(..)
  , WindowM
  , Resource(..)
  , withResource
  , releaseResource
  , runWindow
  , askWindow
  , logDebug
  , startTextInput
  , stopTextInput
  , loop
  , clear
  , setDrawColor
  , drawLine
  , drawRect
  , fillRect
  , drawTexture
  , drawMesh
  , TextureUsage(..)
  , TextureDesc(..)
  , textureDesc
  , textureDescSize
  , Positive(..)
  , mkPositive
  , positive
  , Size2D(..)
  , Size3D(..)
  , mkSize2D
  , mkSize3D
  , size2D
  , size3D
  , size2DToTuple
  , size3DToTuple
  , Threads2D(..)
  , Threads3D(..)
  , mkThreads2D
  , mkThreads3D
  , threads2D
  , threads3D
  , threads2DToInts
  , threads3DToInts
  , createTexture2D
  , createTexture2DSize
  , createNoiseTexture2D
  , createNoiseTexture2DSize
  , createNoiseTexture3D
  , createNoiseTexture3DSize
  , NoiseType(..)
  , NoiseSettings(..)
  , defaultNoiseSettings
  , loopNoise2D
  , loopNoise3D
  , VertexAttrFormat(..)
  , VertexAttr(..)
  , VertexLayout(..)
  , Primitive(..)
  , Mesh(..)
  , Mesh3D(..)
  , mesh3D
  , Pipeline(..)
  , VertexShader(..)
  , FragmentShader
  , Shader2D
  , ShaderCounts(..)
  , ReflectedBindingType(..)
  , ReflectedStorageAccess(..)
  , ReflectedBinding(..)
  , ReflectedShaderLayout
  , shaderLayoutFromReflection
  , shaderCountsFromReflection
  , createFragmentShaderReflected
  , createShader2DReflected
  , BindingSlot(..)
  , Shader2DLayout(..)
  , TargetFormat(..)
  , BlendMode(..)
  , DepthMode(..)
  , GraphicsDesc(..)
  , defaultGraphics
  , graphicsPipeline
  , defaultCompute
  , computeDescFromReflection
  , computePipeline
  , Binding(..)
  , ComputePipeline(..)
  , ComputeDesc(..)
  , ComputeBinding(..)
  , NamedComputeBinding(..)
  , computeBindingsFromReflection
  , createMesh
  , createTransientMesh
  , createMesh3D
  , createTransientMesh3D
  , destroyMesh
  , createPipeline
  , destroyPipeline
  , swapchainFormat
  , createVertexShader
  , destroyVertexShader
  , createFragmentShader
  , destroyFragmentShader
  , createShader2D
  , destroyShader2D
  , destroyComputePipeline
  , dispatchCompute
  , spriteLayout
  , mesh3DLayout
  , spritePipeline
  , spriteBindings
  , spriteMesh
  , spriteMeshTransient
  , vUniform
  , vUniformBytes
  , fUniform
  , fUniformBytes
  , fSampler
  , fSamplerWith
  , fStorageTexture
  , computeUniform
  , computeUniformBytes
  , computeSampler
  , computeSamplerWith
  , computeStorageTexture
  , computeStorageTextureRW
  , RenderTarget
  , createRenderTarget
  , createRenderTargetSize
  , withRenderTarget
  , destroyTarget
  , render
  , output
  , postProcess
  , TargetRef(..)
  , RenderPlan
  , PlanM(..)
  , PassM(..)
  , plan
  , pass
  , runPlan
  , passClear
  , passDraw
  , passBlit
  , passWithShader
  , passPostProcess
  , loadTexture
  , destroyTexture
  , loadFont
  , loadFontSDF
  , closeFont
  , createText
  , destroyText
  , drawText
  , drawTextWith
  , drawTextRaw
  , drawTextRawWith
  , measureText
  , textColor
  , textShader
  , textBlend
  , TextStyle(..)
  , defaultTextStyle
  , textWith
  , Frame(..)
  , SlopGlobals(..)
  , slopGlobals
  , LoopControl(..)
  , LoopExit(..)
  , InputState(..)
  , InputFrame(..)
  , InputEvent(..)
  , Modifiers(..)
  , inputPrev
  , inputNow
  , inputText
  , inputWheel
  , inputMods
  , inputEvents
  , Key(..)
  , MouseButton(..)
  , mouseLeft
  , mouseMiddle
  , mouseRight
  , mouseX1
  , mouseX2
  , keySpace
  , keyDown
  , keyPressed
  , keyReleased
  , mouseButtonDown
  , mouseButtonPressed
  , mouseButtonReleased
  , Color(..)
  , module Slop.Math
  , camera2D
  , camera2DWindow
  , camera2DScreen
  , Camera2D(..)
  , camera2DMatrix
  , camera3D
  , Camera3D(..)
  , camera3DView
  , camera3DProj
  , camera3DViewProj
  , camera3DMVP
  , Vertex3D(..)
  , rect
  , fullscreenRect
  , point
  , rgb
  , rgba
  , Texture(..)
  , Font (..)
  , Track(..)
  , ShaderAsset(..)
  , Shader2DAsset(..)
  , ReflectedShader2DAsset(..)
  , Shader2DLayoutAsset(..)
  , VertexShaderAsset(..)
  , ComputePipelineAsset(..)
  , PipelineAsset(..)
  , SamplerAsset(..)
  , SdfFontAsset(..)
  , Text
  , Audio(..)
  , Shader
  , Sampler(..)
  , SamplerDesc(..)
  , SamplerFilter(..)
  , SamplerMipmap(..)
  , SamplerAddress(..)
  , SamplerCompare(..)
  , defaultSamplerDesc
  , createSampler
  , destroySampler
  , Draw(..)
  , As2D(..)
  , As3D(..)
  , basic2D
  , basicUI
  , basicUIWith
  , basicUIWithCamera
  , basicParticle
  , basicParticleWith
  , basicParticleWithCamera
  , basic3D
  , AsMesh(..)
  , asMesh
  , DrawItem(..)
  , Line(..)
  , RectOutline(..)
  , RectFill(..)
  , Sprite(..)
  , SpriteEffect(..)
  , spriteEffect
  , spriteEffectNamed
  , Label(..)
  , TextDraw(..)
  , text
  , ShaderUniform(..)
  , shaderUniformSized
  , shaderUniformBytesSized
  , SlopError(..)
  , SlopResult
  , renderSlopError
  , throwSlop
  , Patch(..)
  , TextStylePatch(..)
  , textStylePatch
  , patchTextColor
  , patchTextShader
  , patchTextBlend
  , applyTextStylePatch
  , ShaderStage(..)
  , ShaderBindings(..)
  , NamedUniform(..)
  , emptyShaderBindings
  , setShaderBindings
  , setShader2DBindings
  , getShaderBindings
  , resolveNamedUniforms
  , resolveReflectedUniforms
  , normalizeBindings
  , normalizeBindingsSparse
  , normalizeUniforms
  , AssetId(..)
  , AnyAssetId(..)
  , AssetStatus(..)
  , AssetUpdate
  , AssetLoader(..)
  , AssetThread(..)
  , TextureAsset(..)
  , TextureDescAsset(..)
  , NoiseTexture2DAsset(..)
  , NoiseTexture3DAsset(..)
  , FontAsset(..)
  , TextAsset(..)
  , MusicAsset(..)
  , ChunkAsset(..)
  , loadAsset
  , loadAssetResult
  , loadAssetAsync
  , processMainAssets
  , awaitAsset
  , awaitAssetResult
  , getAsset
  , assetReady
  , getAssetStatus
  , removeAsset
  , removeAssets
  , removeAssets_
  , removeAllAssets
  , enableHotReload
  , disableHotReload
  , reloadAssetAsync
  , awaitAssetUpdate
  , awaitAssetUpdateResult
  , playMusic
  , playMusicLoop
  , playSound
  , TrackPool
  , PoolPolicy(..)
  , createTrackPool
  , createTrackPoolFrom
  , playPool
  , playPoolLoop
  , playPoolPriority
  , playPoolPriorityLoop
  , stopPool
  , trackPlaying
  , crossfadeTo
  , crossfadeToLoop
  , updateBlend
  , createTrack
  , destroyTrack
  , playOn
  , playOnLoop
  , stopTrack
  , withShaderBindings
  , withShader
  ) where

import Control.Exception (Exception (..), SomeAsyncException, SomeException, bracket, bracket_, finally, fromException, mask_, onException, throwIO, try)
import Control.Monad (foldM, forM_, replicateM, unless, void, when)
import Control.Concurrent (forkFinally, forkIO, modifyMVar, modifyMVar_, newMVar, threadDelay)
import Control.Concurrent.STM
  ( TMVar
  , TQueue
  , TVar
  , atomically
  , newEmptyTMVar
  , newEmptyTMVarIO
  , newTQueueIO
  , newTVarIO
  , modifyTVar'
  , orElse
  , putTMVar
  , readTMVar
  , readTQueue
  , readTVar
  , tryReadTQueue
  , tryPutTMVar
  , writeTQueue
  , writeTVar
  )
import Control.Monad.Reader (MonadReader (..), ReaderT (..))
import Control.Monad.Writer.Strict (Writer, execWriter, runWriter, tell)
import Control.Monad.IO.Class (MonadIO (..))
import Data.Bits ((.&.), (.|.), shiftL)
import Data.Bifunctor (first)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Internal as BSI
import Data.Dynamic (Dynamic, fromDynamic, toDyn)
import qualified Data.IntMap.Strict as IntMap
import Data.IntSet (IntSet)
import qualified Data.IntSet as IntSet
import Data.Kind (Type)
import Data.IORef (IORef, atomicModifyIORef', modifyIORef', newIORef, readIORef, writeIORef)
import Data.List (elemIndex)
import Data.Maybe (catMaybes, fromMaybe, isJust, listToMaybe)
import Data.Monoid (Last (..))
import qualified Data.Map.Strict as Map
import qualified Data.Text as T
import Data.Proxy (Proxy (..))
import Data.Time.Clock (UTCTime)
import Data.Typeable (TypeRep, Typeable, typeOf, typeRep)
import Data.Word (Word8, Word32, Word64)
import GHC.Conc (getNumCapabilities)
import Foreign (Ptr, Storable (..), alloca, castPtr, nullPtr, peek, peekElemOff, poke, pokeByteOff)
import Foreign.C.String (peekCString, withCString)
import Foreign.C.Types (CFloat (..), CInt)
import Foreign.Marshal.Array (peekArray, withArray, withArrayLen)
import Foreign.Marshal.Utils (copyBytes)
import System.Directory (getModificationTime)
import System.IO (hPutStrLn, stderr)

import Slop.Internal.DList (DList, singleton, toList)
import Slop.Math
import qualified Slop.SDL.Raw as SDL
import Slop.SDL.Raw
  ( FPoint (..)
  , FRect (..)
  , FColor (..)
  , Font (..)
  , Mixer (..)
  , Track (..)
  , Surface (..)
  , SurfaceInfo (..)
  , TTF_GPUAtlasDrawSequence (..)
  , SDL_GPUFilter
  , SDL_GPUSamplerMipmapMode
  , SDL_GPUSamplerAddressMode
  , SDL_GPUCompareOp
  , SDL_GPUShaderStage
  , SDL_GPUTextureFormat
  , SDL_GPUTextureUsageFlags
  , SDL_GPUPrimitiveType
  , SDL_Keymod
  , GPUDevice (..)
  , GPUCommandBuffer (..)
  , GPUComputePipeline (..)
  , GPURenderPass (..)
  , GPUGraphicsPipeline (..)
  , GPUTexture (..)
  , GPUShader (..)
  , GPUBuffer (..)
  , GPUTransferBuffer (..)
  , GPUCopyPass (..)
  , GPUSampler (..)
  , GPUTextureSamplerBinding (..)
  , GPUStorageTextureReadWriteBinding (..)
  , GPUBufferBinding (..)
  , GPUViewport (..)
  , GPUVertexBufferDescription (..)
  , GPUVertexAttribute (..)
  , GPUVertexInputState (..)
  , GPUColorTargetBlendState (..)
  , GPUColorTargetDescription (..)
  , GPUGraphicsPipelineTargetInfo (..)
  , GPURasterizerState (..)
  , GPUMultisampleState (..)
  , GPUStencilOpState (..)
  , GPUDepthStencilState (..)
  , GPUGraphicsPipelineCreateInfo (..)
  , GPUComputePipelineCreateInfo (..)
  , GPUTextureCreateInfo (..)
  , GPUBufferCreateInfo (..)
  , GPUTransferBufferCreateInfo (..)
  , GPUTextureTransferInfo (..)
  , GPUTransferBufferLocation (..)
  , GPUTextureRegion (..)
  , GPUBufferRegion (..)
  , GPUColorTargetInfo (..)
  , GPUDepthStencilTargetInfo (..)
  , GPUSamplerCreateInfo (..)
  , GPUShaderCreateInfo (..)
  , Text (..)
  , TextEngine (..)
  , mixCreateMixerDevice
  , mixInit
  , mixQuit
  , mixDestroyMixer
  , mixCreateTrack
  , mixDestroyTrack
  , mixSetTrackAudio
  , mixSetTrackIOStream
  , mixPlayTrack
  , mixSetTrackLoops
  , mixSetTrackGain
  , sdlIOFromFile
  , mixStopTrack
  , mixTrackPlaying
  , sdlAudioDeviceDefaultPlayback
  , sdlCreateGPUDevice
  , sdlDestroyGPUDevice
  , sdlClaimWindowForGPUDevice
  , sdlReleaseWindowFromGPUDevice
  , sdlGetGPUSwapchainTextureFormat
  , sdlWaitAndAcquireGPUSwapchainTexture
  , sdlAcquireGPUCommandBuffer
  , sdlSubmitGPUCommandBuffer
  , sdlBeginGPURenderPass
  , sdlEndGPURenderPass
  , sdlBindGPUGraphicsPipeline
  , sdlSetGPUViewport
  , sdlBindGPUVertexBuffers
  , sdlBindGPUFragmentSamplers
  , sdlBindGPUFragmentStorageTextures
  , sdlDrawGPUPrimitives
  , sdlPushGPUVertexUniformData
  , sdlPushGPUFragmentUniformData
  , sdlBeginGPUComputePass
  , sdlEndGPUComputePass
  , sdlBindGPUComputePipeline
  , sdlBindGPUComputeSamplers
  , sdlBindGPUComputeStorageTextures
  , sdlPushGPUComputeUniformData
  , sdlDispatchGPUCompute
  , sdlCreateGPUGraphicsPipeline
  , sdlReleaseGPUGraphicsPipeline
  , sdlCreateGPUComputePipeline
  , sdlReleaseGPUComputePipeline
  , sdlCreateGPUTexture
  , sdlReleaseGPUTexture
  , sdlCreateGPUBuffer
  , sdlReleaseGPUBuffer
  , sdlCreateGPUTransferBuffer
  , sdlReleaseGPUTransferBuffer
  , sdlMapGPUTransferBuffer
  , sdlUnmapGPUTransferBuffer
  , sdlBeginGPUCopyPass
  , sdlEndGPUCopyPass
  , sdlUploadToGPUTexture
  , sdlUploadToGPUBuffer
  , sdlGetGPUTextureFormatFromPixelFormat
  , sdlCreateGPUShader
  , sdlCreateGPUSampler
  , sdlCreateProperties
  , sdlCreateWindow
  , sdlDestroyProperties
  , sdlReleaseGPUSampler
  , sdlDestroyWindow
  , sdlSetPointerProperty
  , sdlSetNumberProperty
  , sdlShowWindow
  , sdlEventQuit
  , sdlEventTextInput
  , sdlEventMouseWheel
  , sdlMouseWheelFlipped
  , sdlGetError
  , sdlGetKeyboardState
  , sdlGetKeyFromScancode
  , sdlGetTicks
  , sdlGPUShaderFormatSpirv
  , sdlGPUShaderStageVertex
  , sdlGPUShaderStageFragment
  , sdlGPUCompareOpInvalid
  , sdlGPUCompareOpLessOrEqual
  , sdlGPUCompareOpAlways
  , sdlInit
  , sdlInitAudio
  , sdlInitVideo
  , sdlGetWindowSize
  , sdlGetWindowSizeInPixels
  , sdlGetMouseState
  , sdlPollEvent
  , sdlPumpEvents
  , peekTextInputEvent
  , peekMouseWheelEvent
  , sdlQuit
  , sdlReleaseGPUShader
  , sdlSetWindowResizable
  , sdlPixelFormatRGBA8888
  , sdlGPUTextureFormatRGBA8
  , sdlGPUTextureFormatD16UNORM
  , sdlGPUTextureFormatD24UNORM
  , sdlGPUTextureFormatD32Float
  , sdlGPUTextureFormatD24UNORMS8UINT
  , sdlGPUTextureFormatD32FloatS8UINT
  , sdlGPUTextureType2D
  , sdlGPUTextureType3D
  , sdlGPUTextureUsageSampler
  , sdlGPUTextureUsageColorTarget
  , sdlGPUTextureUsageDepthStencilTarget
  , sdlGPUTextureUsageComputeStorageRead
  , sdlGPUTextureUsageComputeStorageWrite
  , sdlGPUTextureUsageComputeStorageSimultaneousReadWrite
  , sdlGPUBufferUsageVertex
  , sdlGPUTransferBufferUsageUpload
  , sdlGPUPrimitiveTypeTriangleList
  , sdlGPUPrimitiveTypeLineList
  , sdlGPULoadOpLoad
  , sdlGPULoadOpClear
  , sdlGPUStoreOpStore
  , sdlGPUSampleCount1
  , sdlGPUVertexElementFormatFloat2
  , sdlGPUVertexElementFormatFloat4
  , sdlGPUVertexInputRateVertex
  , sdlGPUBlendOpAdd
  , sdlGPUBlendFactorOne
  , sdlGPUBlendFactorZero
  , sdlGPUBlendFactorSrcAlpha
  , sdlGPUBlendFactorOneMinusSrcAlpha
  , sdlGPUColorComponentRGBA
  , sdlGPUFillModeFill
  , sdlGPUCullModeNone
  , sdlGPUFrontFaceCounterClockwise
  , sdlGPUStencilOpKeep
  , imgLoadSurface
  , sdlDestroySurface
  , sdlLockSurface
  , sdlUnlockSurface
  , sdlConvertSurface
  , ttfCreateGPUTextEngine
  , ttfCreateGPUTextEngineWithProperties
  , ttfDestroyGPUTextEngine
  , ttfCreateText
  , ttfDestroyText
  , ttfGetGPUTextDrawData
  , ttfInit
  , ttfOpenFont
  , ttfQuit
  , ttfCloseFont
  , ttfSetFontSDF
  , ttfSetTextPosition
  , allocaEvent
  , peekEventType
  )

data Config = Config
  { windowTitle :: String
  , windowWidth :: Int
  , windowHeight :: Int
  , windowResizable :: Bool
  , textAtlasSize :: Maybe Int
  , assetWorkers :: Int
  , debugLog :: Bool
  }
  deriving (Eq, Show)

data ConfigPatch = ConfigPatch
  { patchWindowTitle :: Last String
  , patchWindowWidth :: Last Int
  , patchWindowHeight :: Last Int
  , patchWindowResizable :: Last Bool
  , patchTextAtlasSize :: Last (Maybe Int)
  , patchAssetWorkers :: Last Int
  , patchDebugLog :: Last Bool
  }
  deriving (Eq, Show)

instance Semigroup ConfigPatch where
  ConfigPatch a b c d e f g <> ConfigPatch a' b' c' d' e' f' g' =
    ConfigPatch (a <> a') (b <> b') (c <> c') (d <> d') (e <> e') (f <> f') (g <> g')

instance Monoid ConfigPatch where
  mempty = ConfigPatch mempty mempty mempty mempty mempty mempty mempty

applyConfigPatch :: Config -> ConfigPatch -> Config
applyConfigPatch cfg patch =
  cfg
    { windowTitle = pick cfg.windowTitle patch.patchWindowTitle
    , windowWidth = pick cfg.windowWidth patch.patchWindowWidth
    , windowHeight = pick cfg.windowHeight patch.patchWindowHeight
    , windowResizable = pick cfg.windowResizable patch.patchWindowResizable
    , textAtlasSize = pick cfg.textAtlasSize patch.patchTextAtlasSize
    , assetWorkers = pick cfg.assetWorkers patch.patchAssetWorkers
    , debugLog = pick cfg.debugLog patch.patchDebugLog
    }
  where
    pick def (Last value) = fromMaybe def value

defaultConfig :: Config
defaultConfig = Config
  { windowTitle = "Slop"
  , windowWidth = 1280
  , windowHeight = 720
  , windowResizable = True
  , textAtlasSize = Nothing
  , assetWorkers = 0
  , debugLog = False
  }

data HotReloadConfig = HotReloadConfig
  { hrEnabled :: !Bool
  , hrInterval :: !Float
  , hrElapsed :: !Float
  }
  deriving (Eq, Show)

data Window = Window
  { appWindow :: SDL.Window
  , appGPUDevice :: GPUDevice
  , appSwapchainFormat :: SDL_GPUTextureFormat
  , appDefaultSampler :: Sampler
  , appTextEngine :: TextEngine
  , appMixer :: Mixer
  , appMusicTrack :: IORef (Maybe Track)
  , appBlendPools :: IORef [TrackPool]
  , appAssets :: AssetManager
  , appMainAssetQueue :: TQueue AssetCommand
  , appTargets :: IORef (Map.Map (Ptr ()) Texture)
  , appPipelineTargets :: IORef (IntMap.IntMap (RenderTarget, (Int, Int)))
  , appDepthFormat :: SDL_GPUTextureFormat
  , appDepthTarget :: IORef (Maybe DepthTarget)
  , appDepthTargets :: IORef (Map.Map (Ptr ()) DepthTarget)
  , appRenderState :: IORef RenderState
  , appHotReload :: IORef HotReloadConfig
  , appFrameContext :: RecordingContext
  , appRecording :: IORef (Maybe Recording)
  , appWindowSize :: IORef (Int, Int)
  , appDrawableSize :: IORef (Int, Int)
  , appWhiteTexture :: Texture
  , appVertexShader :: GPUShader
  , appVertexShader3D :: GPUShader
  , appDefaultShader :: Shader
  , appPipelines :: IORef (Map.Map PipelineKey GPUGraphicsPipeline)
  , appDrawColor :: IORef Color
  , appDebugLog :: Bool
  , appGlobalsUniform :: IORef (Maybe ByteString)
  , appOwnedResources :: IORef OwnedResources
  }

data OwnedResourceKind
  = OwnedTexture
  | OwnedFont
  | OwnedText
  | OwnedMesh
  | OwnedPipeline
  | OwnedVertexShader
  | OwnedFragmentShader
  | OwnedComputePipeline
  | OwnedSampler
  | OwnedTrack
  deriving (Eq, Ord, Show)

data OwnedResourceKey = OwnedResourceKey !OwnedResourceKind !(Ptr ())
  deriving (Eq, Ord, Show)

data OwnedResources = OwnedResources
  { ownedNextId :: !Int
  , ownedById :: !(IntMap.IntMap (OwnedResourceKey, IO ()))
  , ownedIds :: !(Map.Map OwnedResourceKey Int)
  }

emptyOwnedResources :: OwnedResources
emptyOwnedResources = OwnedResources 0 IntMap.empty Map.empty

registerOwnedResource :: Window -> OwnedResourceKey -> IO () -> IO ()
registerOwnedResource window key release =
  atomicModifyIORef' window.appOwnedResources $ \resources ->
    case Map.lookup key resources.ownedIds of
      Just _ -> (resources, ())
      Nothing ->
        let resourceId = resources.ownedNextId
        in ( resources
              { ownedNextId = resourceId + 1
              , ownedById = IntMap.insert resourceId (key, release) resources.ownedById
              , ownedIds = Map.insert key resourceId resources.ownedIds
              }
           , ()
           )

releaseOwnedResource :: Window -> OwnedResourceKey -> IO () -> IO ()
releaseOwnedResource window key fallback = do
  release <- atomicModifyIORef' window.appOwnedResources $ \resources ->
    case Map.lookup key resources.ownedIds of
      Nothing -> (resources, fallback)
      Just resourceId ->
        let registered = maybe fallback snd (IntMap.lookup resourceId resources.ownedById)
        in ( resources
              { ownedById = IntMap.delete resourceId resources.ownedById
              , ownedIds = Map.delete key resources.ownedIds
              }
           , registered
           )
  release

forgetOwnedResource :: Window -> OwnedResourceKey -> IO ()
forgetOwnedResource window key =
  atomicModifyIORef' window.appOwnedResources $ \resources ->
    case Map.lookup key resources.ownedIds of
      Nothing -> (resources, ())
      Just resourceId ->
        ( resources
            { ownedById = IntMap.delete resourceId resources.ownedById
            , ownedIds = Map.delete key resources.ownedIds
            }
        , ()
        )

cleanupOwnedResources :: Window -> IO ()
cleanupOwnedResources window = do
  releases <- atomicModifyIORef' window.appOwnedResources $ \resources ->
    (emptyOwnedResources, map (snd . snd) (IntMap.toDescList resources.ownedById))
  releaseAll releases
  where
    releaseAll [] = pure ()
    releaseAll (release : remaining) =
      release `finally` releaseAll remaining

textureResourceKey :: Texture -> OwnedResourceKey
textureResourceKey texture =
  let GPUTexture pointer = texture.textureHandle
  in OwnedResourceKey OwnedTexture (castPtr pointer)

fontResourceKey :: Font -> OwnedResourceKey
fontResourceKey (Font pointer) = OwnedResourceKey OwnedFont (castPtr pointer)

textResourceKey :: Text -> OwnedResourceKey
textResourceKey (Text pointer) = OwnedResourceKey OwnedText (castPtr pointer)

meshResourceKey :: Mesh -> OwnedResourceKey
meshResourceKey mesh =
  let GPUBuffer pointer = mesh.meshBuffer
  in OwnedResourceKey OwnedMesh (castPtr pointer)

pipelineResourceKey :: Pipeline -> OwnedResourceKey
pipelineResourceKey pipeline =
  let GPUGraphicsPipeline pointer = pipeline.pipelineHandle
  in OwnedResourceKey OwnedPipeline (castPtr pointer)

vertexShaderResourceKey :: VertexShader -> OwnedResourceKey
vertexShaderResourceKey shader =
  let GPUShader pointer = shader.vertexShaderHandle
  in OwnedResourceKey OwnedVertexShader (castPtr pointer)

fragmentShaderResourceKey :: Shader -> OwnedResourceKey
fragmentShaderResourceKey shader =
  let GPUShader pointer = shader.shaderHandle
  in OwnedResourceKey OwnedFragmentShader (castPtr pointer)

computePipelineResourceKey :: ComputePipeline -> OwnedResourceKey
computePipelineResourceKey pipeline =
  let GPUComputePipeline pointer = pipeline.computeHandle
  in OwnedResourceKey OwnedComputePipeline (castPtr pointer)

samplerResourceKey :: Sampler -> OwnedResourceKey
samplerResourceKey (Sampler (GPUSampler pointer)) = OwnedResourceKey OwnedSampler (castPtr pointer)

trackResourceKey :: Track -> OwnedResourceKey
trackResourceKey (Track pointer) = OwnedResourceKey OwnedTrack (castPtr pointer)

newtype WindowM a = WindowM (ReaderT Window IO a)
  deriving (Functor, Applicative, Monad, MonadIO, MonadReader Window)

data Resource a = Resource
  { resourceValue :: a
  , resourceRelease :: WindowM ()
  }

releaseResource :: Resource a -> WindowM ()
releaseResource = (.resourceRelease)

withResource :: WindowM (Resource a) -> (a -> WindowM b) -> WindowM b
withResource acquire use = do
  window <- ask
  liftIO $
    bracket
      (runWindowM window acquire)
      (\res -> runWindowM window (releaseResource res))
      (\res -> runWindowM window (use res.resourceValue))

data RenderState = RenderState
  { rsTextCache :: !(Map.Map TextCacheKey CachedText)
  , rsFrameId :: !Word64
  }

type TextCacheKey = (Ptr (), T.Text)

data CachedText = CachedText
  { ctText :: !Text
  , ctLastUsed :: !Word64
  }

data RecordingContext = RecordingContext
  { rcCommands :: IORef [RecordedOp]
  , rcShaderStack :: IORef [ShaderContext]
  }

newtype Recording = Recording RecordingContext

data ShaderContext = ShaderContext
  { ctxShader :: Shader
  , ctxUniforms :: [UniformBinding]
  , ctxSamplers :: [SamplerBindingSpec]
  , ctxStorage :: [StorageBinding]
  , ctxBlend :: BlendMode
  , ctxCamera :: Maybe Camera2D
  }

data DrawShape
  = ShapeLine Color FPoint FPoint
  | ShapeRectOutline Color FRect
  | ShapeRectFill Color FRect
  | ShapeSprite Texture (Maybe FRect) FRect
  | ShapeText Text Float Float Color

data DrawCmd = DrawCmd DrawShape (Maybe ShaderContext)

data RecordedOp
  = RecordedClear Color
  | RecordedDraw DrawCmd
  | RecordedMesh Pipeline Mesh [Binding]

data VertexAttrFormat
  = VertexFloat2
  | VertexFloat4
  deriving (Eq, Ord, Show)

data VertexAttr = VertexAttr
  { attrLocation :: Word32
  , attrFormat :: VertexAttrFormat
  , attrOffset :: Word32
  }
  deriving (Eq, Ord, Show)

data VertexLayout = VertexLayout
  { layoutStride :: Word32
  , layoutAttrs :: [VertexAttr]
  }
  deriving (Eq, Ord, Show)

data Primitive
  = PrimTriangles
  | PrimLines
  deriving (Eq, Ord, Show)

data Mesh = Mesh
  { meshBuffer :: GPUBuffer
  , meshVertexCount :: Word32
  , meshLayout :: VertexLayout
  , meshReleaseOnDraw :: Bool
  }
  deriving (Eq, Show)

data Mesh3D = Mesh3D
  { mesh3DMesh :: Mesh
  , mesh3DModel :: M44 Float
  , mesh3DBindings :: [Binding]
  }

data VertexShader = VertexShader
  { vertexShaderHandle :: GPUShader
  , vertexShaderDevice :: GPUDevice
  }
  deriving (Eq, Show)

type FragmentShader = Shader

newtype Shader2D = Shader2D Shader

unwrapShader2D :: Shader2D -> Shader
unwrapShader2D (Shader2D shader) = shader

data ShaderCounts = ShaderCounts
  { shaderSamplers :: Word32
  , shaderStorageTextures :: Word32
  , shaderStorageBuffers :: Word32
  , shaderUniformBuffers :: Word32
  }
  deriving (Eq, Show)

data ReflectedBindingType
  = ReflectedUniform !Int
  | ReflectedSampler
  | ReflectedSampledTexture
  | ReflectedStorageTexture !ReflectedStorageAccess
  | ReflectedStorageBuffer
  deriving (Eq, Show)

data ReflectedStorageAccess
  = ReflectedReadOnly
  | ReflectedReadWrite
  deriving (Eq, Show)

data ReflectedBinding = ReflectedBinding
  { reflectedName :: !T.Text
  , reflectedGroup :: !Word32
  , reflectedSlot :: !Word32
  , reflectedType :: !ReflectedBindingType
  }
  deriving (Eq, Show)

data ReflectedShaderLayout = ReflectedShaderLayout
  { reflectedShaderName :: !T.Text
  , reflectedShaderStage :: !ShaderStage
  , reflectedShaderCounts :: !ShaderCounts
  , reflectedShaderBindings :: !(Map.Map T.Text ReflectedBinding)
  }
  deriving (Eq, Show)

shaderLayoutFromReflection :: T.Text -> ShaderStage -> [ReflectedBinding] -> SlopResult ReflectedShaderLayout
shaderLayoutFromReflection shaderName stage bindings = do
  bindingMap <- foldM insertBinding Map.empty bindings
  validateBindingSlots shaderName stage bindings
  pure ReflectedShaderLayout
    { reflectedShaderName = shaderName
    , reflectedShaderStage = stage
    , reflectedShaderCounts = reflectedCounts bindings
    , reflectedShaderBindings = bindingMap
    }
  where
    insertBinding existing binding =
      case Map.lookup binding.reflectedName existing of
        Just _ -> Left (reflectionError shaderName (Just binding.reflectedName) "duplicate binding name")
        Nothing ->
          if any (sameLocation binding) (Map.elems existing)
            then Left (reflectionError shaderName (Just binding.reflectedName) ("duplicate group " <> showText binding.reflectedGroup <> " slot " <> showText binding.reflectedSlot))
            else Right (Map.insert binding.reflectedName binding existing)
    sameLocation binding existing =
      binding.reflectedGroup == existing.reflectedGroup
        && binding.reflectedSlot == existing.reflectedSlot

shaderCountsFromReflection :: ReflectedShaderLayout -> ShaderCounts
shaderCountsFromReflection = (.reflectedShaderCounts)

validateBindingSlots :: T.Text -> ShaderStage -> [ReflectedBinding] -> SlopResult ()
validateBindingSlots shaderName stage bindings = do
  mapM_ validateGroup bindings
  validateContiguous isUniformBinding "uniform"
  validateContiguous (== ReflectedSampledTexture) "sampled texture"
  validateContiguous isStorageTextureBinding "storage texture"
  validateContiguous (== ReflectedStorageBuffer) "storage buffer"
  where
    validateGroup binding =
      case expectedBindingGroup stage binding.reflectedType of
        Nothing -> Left (reflectionError shaderName (Just binding.reflectedName) "binding type is not supported by the combined-sampler SDL_gpu ABI")
        Just expected
          | binding.reflectedGroup == expected -> Right ()
          | otherwise -> Left (reflectionError shaderName (Just binding.reflectedName) ("expected group " <> showText expected <> ", got " <> showText binding.reflectedGroup))
    validateContiguous matchesType label =
      let slots = Map.keys (Map.fromList [(binding.reflectedSlot, ()) | binding <- bindings, matchesType binding.reflectedType])
      in case slots of
          [] -> Right ()
          _
            | slots == [0 .. last slots] -> Right ()
            | otherwise -> Left (reflectionError shaderName Nothing (label <> " slots must be contiguous from 0; got " <> T.pack (show slots)))

expectedBindingGroup :: ShaderStage -> ReflectedBindingType -> Maybe Word32
expectedBindingGroup stage bindingType =
  case (stage, bindingType) of
    (ShaderFragment, ReflectedUniform {}) -> Just 3
    (ShaderFragment, ReflectedSampledTexture) -> Just 2
    (ShaderFragment, ReflectedStorageTexture ReflectedReadOnly) -> Just 2
    (ShaderVertex, ReflectedUniform {}) -> Just 1
    (ShaderCompute, ReflectedUniform {}) -> Just 2
    (ShaderCompute, ReflectedSampledTexture) -> Just 2
    (ShaderCompute, ReflectedStorageTexture {}) -> Just 1
    (ShaderCompute, ReflectedStorageBuffer) -> Just 1
    _ -> Nothing

reflectedCounts :: [ReflectedBinding] -> ShaderCounts
reflectedCounts bindings = ShaderCounts
  { shaderSamplers = count (== ReflectedSampledTexture)
  , shaderStorageTextures = count isStorageTextureBinding
  , shaderStorageBuffers = count (== ReflectedStorageBuffer)
  , shaderUniformBuffers = count isUniformBinding
  }
  where
    count matchesType =
      case [binding.reflectedSlot | binding <- bindings, matchesType binding.reflectedType] of
        [] -> 0
        slots -> maximum slots + 1

isUniformBinding :: ReflectedBindingType -> Bool
isUniformBinding ReflectedUniform {} = True
isUniformBinding _ = False

isStorageTextureBinding :: ReflectedBindingType -> Bool
isStorageTextureBinding ReflectedStorageTexture {} = True
isStorageTextureBinding _ = False

reflectionError :: T.Text -> Maybe T.Text -> T.Text -> SlopError
reflectionError shaderName binding =
  SlopShaderFailure "derive reflected layout" shaderName binding

showText :: Show a => a -> T.Text
showText = T.pack . show

data BindingSlot = BindingSlot
  { slotGroup :: Word32
  , slotBinding :: Word32
  }
  deriving (Eq, Show)

data Shader2DLayout = Shader2DLayout
  { layoutSamplers :: [BindingSlot]
  , layoutUniforms :: [BindingSlot]
  , layoutStorageTextures :: [BindingSlot]
  , layoutStorageBuffers :: [BindingSlot]
  }
  deriving (Eq, Show)

data Pipeline = Pipeline
  { pipelineHandle :: GPUGraphicsPipeline
  , pipelineVertex :: GPUShader
  , pipelineFragment :: GPUShader
  , pipelineLayout :: VertexLayout
  , pipelinePrimitive :: Primitive
  , pipelineTargetFormat :: SDL_GPUTextureFormat
  , pipelineBlend :: BlendMode
  , pipelineDepthMode :: DepthMode
  , pipelineDepthFormat :: SDL_GPUTextureFormat
  }
  deriving (Eq, Show)

data TargetFormat
  = TargetSwapchain
  | TargetFormat SDL_GPUTextureFormat
  deriving (Eq, Show)

data BlendMode
  = BlendAlpha
  | BlendAdditive
  | BlendPremultiplied
  | BlendNone
  deriving (Eq, Show, Ord)

data DepthMode
  = DepthNone
  | DepthTest
  | DepthTestWrite
  deriving (Eq, Show, Ord)

data GraphicsDesc = GraphicsDesc
  { gfxVertex :: VertexShader
  , gfxFragment :: FragmentShader
  , gfxLayout :: VertexLayout
  , gfxPrimitive :: Primitive
  , gfxTarget :: TargetFormat
  , gfxBlend :: BlendMode
  , gfxDepth :: DepthMode
  , gfxDepthFormat :: SDL_GPUTextureFormat
  }

data BindingValue where
  BindingValue :: Storable a => a -> BindingValue
  BindingBytes :: ByteString -> BindingValue

data Binding
  = BindVertexUniform Word32 BindingValue
  | BindFragmentUniform Word32 BindingValue
  | BindFragmentSampler Word32 Texture (Maybe Sampler)
  | BindFragmentStorageTexture Word32 Texture

data AsMesh = AsMesh Pipeline [Binding]

asMesh :: Pipeline -> [Binding] -> AsMesh
asMesh = AsMesh

data ComputePipeline = ComputePipeline
  { computeHandle :: GPUComputePipeline
  , computeDevice :: GPUDevice
  }
  deriving (Eq, Show)

data ComputeDesc = ComputeDesc
  { computeShaderCode :: ByteString
  , computeSamplers :: Word32
  , computeReadonlyStorageTextures :: Word32
  , computeReadonlyStorageBuffers :: Word32
  , computeReadwriteStorageTextures :: Word32
  , computeReadwriteStorageBuffers :: Word32
  , computeUniformBuffers :: Word32
  , computeThreads :: Threads3D
  }
  deriving (Eq, Show)

data ComputeBinding
  = ComputeUniform Word32 BindingValue
  | ComputeSampler Word32 Texture (Maybe Sampler)
  | ComputeStorageTexture Word32 Texture
  | ComputeStorageTextureRW Word32 Texture

data NamedComputeBinding where
  ComputeUniformNamed :: Storable a => T.Text -> a -> NamedComputeBinding
  ComputeUniformBytesNamed :: T.Text -> ByteString -> NamedComputeBinding
  ComputeSamplerNamed :: T.Text -> Texture -> NamedComputeBinding
  ComputeSamplerWithNamed :: T.Text -> Texture -> Sampler -> NamedComputeBinding
  ComputeStorageTextureNamed :: T.Text -> Texture -> NamedComputeBinding
  ComputeStorageTextureRWNamed :: T.Text -> Texture -> NamedComputeBinding

computeBindingsFromReflection :: ReflectedShaderLayout -> [NamedComputeBinding] -> SlopResult [ComputeBinding]
computeBindingsFromReflection layout values = do
  unless (layout.reflectedShaderStage == ShaderCompute) $
    Left (reflectionError layout.reflectedShaderName Nothing "expected a compute shader layout")
  (resolved, supplied) <- foldM resolveOne ([], Map.empty) values
  case [binding.reflectedName | binding <- Map.elems layout.reflectedShaderBindings, Map.notMember binding.reflectedName supplied] of
    [] -> Right (reverse resolved)
    name : _ -> Left (reflectionError layout.reflectedShaderName (Just name) "required binding was not supplied")
  where
    resolveOne (resolved, supplied) value = do
      let name = namedComputeBindingName value
      when (Map.member name supplied) $
        Left (reflectionError layout.reflectedShaderName (Just name) "binding was supplied more than once")
      binding <- case Map.lookup name layout.reflectedShaderBindings of
        Nothing -> Left (reflectionError layout.reflectedShaderName (Just name) "binding is not present in the reflected layout")
        Just found -> Right found
      result <- resolveValue binding value
      Right (result : resolved, Map.insert name () supplied)
    resolveValue binding value =
      case (binding.reflectedType, value) of
        (ReflectedUniform expectedBytes, ComputeUniformNamed _ uniformValue) ->
          if sizeOf uniformValue == expectedBytes
            then Right (ComputeUniform binding.reflectedSlot (BindingValue uniformValue))
            else Left (uniformBindingSizeError binding expectedBytes (sizeOf uniformValue))
        (ReflectedUniform expectedBytes, ComputeUniformBytesNamed _ bytes) ->
          if BS.length bytes == expectedBytes
            then Right (ComputeUniform binding.reflectedSlot (BindingBytes bytes))
            else Left (uniformBindingSizeError binding expectedBytes (BS.length bytes))
        (ReflectedSampledTexture, ComputeSamplerNamed _ texture) ->
          Right (ComputeSampler binding.reflectedSlot texture Nothing)
        (ReflectedSampledTexture, ComputeSamplerWithNamed _ texture sampler) ->
          Right (ComputeSampler binding.reflectedSlot texture (Just sampler))
        (ReflectedStorageTexture ReflectedReadOnly, ComputeStorageTextureNamed _ texture) ->
          Right (ComputeStorageTexture binding.reflectedSlot texture)
        (ReflectedStorageTexture ReflectedReadWrite, ComputeStorageTextureRWNamed _ texture) ->
          Right (ComputeStorageTextureRW binding.reflectedSlot texture)
        _ -> Left (reflectionError layout.reflectedShaderName (Just binding.reflectedName) ("expected " <> T.pack (show binding.reflectedType) <> ", got " <> namedComputeBindingType value))
    uniformBindingSizeError binding expectedBytes actualBytes =
      reflectionError layout.reflectedShaderName (Just binding.reflectedName)
        ("expected " <> showText expectedBytes <> " uniform bytes, got " <> showText actualBytes)

namedComputeBindingName :: NamedComputeBinding -> T.Text
namedComputeBindingName value =
  case value of
    ComputeUniformNamed name _ -> name
    ComputeUniformBytesNamed name _ -> name
    ComputeSamplerNamed name _ -> name
    ComputeSamplerWithNamed name _ _ -> name
    ComputeStorageTextureNamed name _ -> name
    ComputeStorageTextureRWNamed name _ -> name

namedComputeBindingType :: NamedComputeBinding -> T.Text
namedComputeBindingType value =
  case value of
    ComputeUniformNamed {} -> "uniform"
    ComputeUniformBytesNamed {} -> "uniform bytes"
    ComputeSamplerNamed {} -> "sampled texture"
    ComputeSamplerWithNamed {} -> "sampled texture with sampler"
    ComputeStorageTextureNamed {} -> "read-only storage texture"
    ComputeStorageTextureRWNamed {} -> "read-write storage texture"

data PipelineKey = PipelineKey
  { pipelineVertexShader :: Ptr ()
  , pipelineFragmentShader :: Ptr ()
  , pipelineLayoutKey :: VertexLayout
  , pipelinePrimitiveKey :: SDL_GPUPrimitiveType
  , pipelineFormat :: SDL_GPUTextureFormat
  , pipelineBlendKey :: BlendMode
  , pipelineDepthModeKey :: DepthMode
  , pipelineDepthFormatKey :: SDL_GPUTextureFormat
  }
  deriving (Eq, Ord, Show)

data Vertex = Vertex
  { vertexX :: !CFloat
  , vertexY :: !CFloat
  , vertexU :: !CFloat
  , vertexV :: !CFloat
  , vertexR :: !CFloat
  , vertexG :: !CFloat
  , vertexB :: !CFloat
  , vertexA :: !CFloat
  }
  deriving (Eq, Show)

data Vertex3D = Vertex3D
  { vertex3DX :: !CFloat
  , vertex3DY :: !CFloat
  , vertex3DZ :: !CFloat
  , vertex3DW :: !CFloat
  , vertex3DU :: !CFloat
  , vertex3DV :: !CFloat
  , vertex3DR :: !CFloat
  , vertex3DG :: !CFloat
  , vertex3DB :: !CFloat
  , vertex3DA :: !CFloat
  }
  deriving (Eq, Show)

runWindowM :: Window -> WindowM a -> IO a
runWindowM window (WindowM action) =
  runReaderT action window

runWindow :: Config -> WindowM a -> IO a
runWindow cfg action = runWindowIO cfg (\window -> runWindowM window action)

askWindow :: WindowM Window
askWindow = ask

liftWindow :: (Window -> IO a) -> WindowM a
liftWindow f = do
  window <- ask
  liftIO (f window)

logDebug :: T.Text -> WindowM ()
logDebug msg = do
  window <- ask
  when window.appDebugLog (liftIO (putStrLn (T.unpack msg)))

startTextInput :: WindowM ()
startTextInput = do
  window <- ask
  ok <- liftIO (SDL.sdlStartTextInput window.appWindow)
  unless ok $ do
    detail <- liftIO sdlGetError
    throwSlop (SlopSDLFailure "SDL_StartTextInput" (T.pack detail))

stopTextInput :: WindowM ()
stopTextInput = do
  window <- ask
  ok <- liftIO (SDL.sdlStopTextInput window.appWindow)
  unless ok $ do
    detail <- liftIO sdlGetError
    throwSlop (SlopSDLFailure "SDL_StopTextInput" (T.pack detail))

-- Asset manager

newtype AssetId a = AssetId { unAssetId :: Int }
  deriving (Eq, Ord, Show)

data AnyAssetId where
  AnyAssetId :: AssetId a -> AnyAssetId

data AssetStatus a
  = AssetLoading
  | AssetReady a
  | AssetFailed SlopError
  deriving (Eq, Show)

data SlopError
  = SlopSDLFailure
      { errorOperation :: !T.Text
      , errorDetail :: !T.Text
      }
  | SlopAssetFailure
      { errorOperation :: !T.Text
      , errorResource :: !T.Text
      , errorDetail :: !T.Text
      }
  | SlopShaderFailure
      { errorOperation :: !T.Text
      , errorResource :: !T.Text
      , errorBinding :: !(Maybe T.Text)
      , errorDetail :: !T.Text
      }
  | SlopIOFailure
      { errorOperation :: !T.Text
      , errorResource :: !T.Text
      , errorDetail :: !T.Text
      }
  | SlopInvariantViolation
      { errorOperation :: !T.Text
      , errorDetail :: !T.Text
      }
  deriving (Eq, Show)

instance Exception SlopError where
  displayException = T.unpack . renderSlopError

type SlopResult a = Either SlopError a

renderSlopError :: SlopError -> T.Text
renderSlopError err =
  case err of
    SlopSDLFailure operation detail ->
      operation <> " failed: " <> detail
    SlopAssetFailure operation resource detail ->
      operation <> " for asset " <> resource <> " failed: " <> detail
    SlopShaderFailure operation shader binding detail ->
      operation <> " for shader " <> shader <> maybe "" (" binding " <>) binding <> " failed: " <> detail
    SlopIOFailure operation resource detail ->
      operation <> (if T.null resource then "" else " for " <> resource) <> " failed: " <> detail
    SlopInvariantViolation operation detail ->
      operation <> " violated an internal invariant: " <> detail

throwSlop :: MonadIO m => SlopError -> m a
throwSlop = liftIO . throwIO

assetOperationError :: T.Text -> T.Text -> SlopError -> SlopError
assetOperationError operation resource err =
  case err of
    SlopAssetFailure {} -> err
    SlopShaderFailure {} -> err
    _ -> SlopAssetFailure operation resource (renderSlopError err)

exceptionAssetError :: T.Text -> T.Text -> SomeException -> SlopError
exceptionAssetError operation resource exception =
  case fromException exception of
    Just err -> assetOperationError operation resource err
    Nothing -> SlopAssetFailure operation resource (T.pack (displayException exception))

trySyncException :: IO a -> IO (Either SomeException a)
trySyncException action = do
  result <- try action
  case result of
    Left exception ->
      case fromException exception :: Maybe SomeAsyncException of
        Just _ -> throwIO exception
        Nothing -> pure result
    Right _ -> pure result

newtype AssetUpdate = AssetUpdate (TMVar (SlopResult ()))

data AssetThread
  = AssetAny
  | AssetMain
  deriving (Eq, Show)

class (Typeable spec, Typeable (AssetType spec)) => AssetLoader spec where
  type AssetType spec
  loadAssetIO :: Window -> spec -> IO (SlopResult (AssetType spec))
  unloadAssetIO :: Window -> spec -> AssetType spec -> IO ()
  assetLabel :: spec -> T.Text
  assetFiles :: spec -> [FilePath]
  assetFiles _ = []
  assetThread :: spec -> AssetThread
  assetThread _ = AssetAny

newtype TextureAsset = TextureAsset FilePath
  deriving (Eq, Show)

newtype TextureDescAsset = TextureDescAsset TextureDesc
  deriving (Eq, Show)

data NoiseTexture2DAsset = NoiseTexture2DAsset Int Int NoiseSettings
  deriving (Eq, Show)

data NoiseTexture3DAsset = NoiseTexture3DAsset Int Int Int NoiseSettings
  deriving (Eq, Show)

data FontAsset = FontAsset FilePath Float
  deriving (Eq, Show)

data TextAsset = TextAsset Font T.Text
  deriving (Eq, Show)

newtype MusicAsset = MusicAsset FilePath
  deriving (Eq, Show)

newtype ChunkAsset = ChunkAsset FilePath
  deriving (Eq, Show)

data Audio
  = AudioLoaded SDL.Audio
  | AudioStream FilePath
  deriving (Eq, Show)

data SdfFontAsset = SdfFontAsset FilePath Float
  deriving (Eq, Show)

data ShaderAsset = ShaderAsset
  { shaderSpirvBytes :: !ByteString
  , shaderSamplers :: !Word32
  , shaderStorageTextures :: !Word32
  , shaderStorageBuffers :: !Word32
  , shaderUniformBuffers :: !Word32
  }

data Shader2DAsset = Shader2DAsset
  { shader2DSpirvBytes :: !ByteString
  , shader2DCounts :: !ShaderCounts
  }

data ReflectedShader2DAsset = ReflectedShader2DAsset
  { reflectedShader2DSpirvBytes :: !ByteString
  , reflectedShader2DLayout :: !ReflectedShaderLayout
  }
  deriving (Eq, Show)

data Shader2DLayoutAsset = Shader2DLayoutAsset
  { shader2DLayoutSpirvBytes :: !ByteString
  , shader2DLayoutSpec :: !Shader2DLayout
  }
  deriving (Eq, Show)

data VertexShaderAsset = VertexShaderAsset
  { vertexShaderSpirvBytes :: !ByteString
  , vertexShaderCounts :: !ShaderCounts
  }
  deriving (Eq, Show)

newtype ComputePipelineAsset = ComputePipelineAsset
  { computePipelineDesc :: ComputeDesc
  }
  deriving (Eq, Show)

newtype PipelineAsset = PipelineAsset
  { pipelineDesc :: GraphicsDesc
  }

newtype SamplerAsset = SamplerAsset
  { samplerDesc :: SamplerDesc
  }
  deriving (Eq, Show)

instance AssetLoader TextureAsset where
  type AssetType TextureAsset = Texture
  loadAssetIO app (TextureAsset path) = do
    result <- trySyncException (loadTextureIO app path)
    case result of
      Right tex -> pure (Right tex)
      Left err -> pure (Left (exceptionAssetError "load texture" (T.pack path) err))
  unloadAssetIO _ _ = destroyTextureIO
  assetLabel (TextureAsset path) = T.pack path
  assetFiles (TextureAsset path) = [path]
  assetThread _ = AssetMain

instance AssetLoader TextureDescAsset where
  type AssetType TextureDescAsset = Texture
  loadAssetIO app (TextureDescAsset desc) = Right <$> createTexture2DIO app desc
  unloadAssetIO _ _ = destroyTextureIO
  assetLabel _ = "texture-desc"
  assetThread _ = AssetMain

instance AssetLoader NoiseTexture2DAsset where
  type AssetType NoiseTexture2DAsset = Texture
  loadAssetIO app (NoiseTexture2DAsset width height settings) =
    Right <$> createNoiseTexture2DIO app width height settings
  unloadAssetIO _ _ = destroyTextureIO
  assetLabel _ = "noise-texture-2d"
  assetThread _ = AssetMain

instance AssetLoader NoiseTexture3DAsset where
  type AssetType NoiseTexture3DAsset = Texture
  loadAssetIO app (NoiseTexture3DAsset width height depth settings) =
    Right <$> createNoiseTexture3DIO app width height depth settings
  unloadAssetIO _ _ = destroyTextureIO
  assetLabel _ = "noise-texture-3d"
  assetThread _ = AssetMain

instance AssetLoader FontAsset where
  type AssetType FontAsset = Font
  loadAssetIO _ (FontAsset path size) = do
    result <- ttfOpenFont path size
    case result of
      Nothing -> Left . SlopAssetFailure "open font" (T.pack path) . T.pack <$> sdlGetError
      Just font -> pure (Right font)
  unloadAssetIO _ _ = ttfCloseFont
  assetLabel (FontAsset path _) = T.pack path
  assetFiles (FontAsset path _) = [path]

instance AssetLoader TextAsset where
  type AssetType TextAsset = Text
  loadAssetIO app (TextAsset font str) = do
    result <- ttfCreateText (app.appTextEngine) font (T.unpack str)
    case result of
      Nothing -> Left . SlopAssetFailure "create text" str . T.pack <$> sdlGetError
      Just textObj -> pure (Right textObj)
  unloadAssetIO _ _ = ttfDestroyText
  assetLabel (TextAsset _ str) = str
  assetThread _ = AssetMain

instance AssetLoader MusicAsset where
  type AssetType MusicAsset = Audio
  loadAssetIO _ (MusicAsset path) =
    pure (Right (AudioStream path))
  unloadAssetIO _ _ _ = pure ()
  assetLabel (MusicAsset path) = T.pack path
  assetFiles (MusicAsset path) = [path]

instance AssetLoader ChunkAsset where
  type AssetType ChunkAsset = Audio
  loadAssetIO _ (ChunkAsset path) =
    pure (Right (AudioStream path))
  unloadAssetIO _ _ _ = pure ()
  assetLabel (ChunkAsset path) = T.pack path
  assetFiles (ChunkAsset path) = [path]

instance AssetLoader SdfFontAsset where
  type AssetType SdfFontAsset = Font
  loadAssetIO _ (SdfFontAsset path size) = do
    result <- ttfOpenFont path size
    case result of
      Nothing -> Left . SlopAssetFailure "open SDF font" (T.pack path) . T.pack <$> sdlGetError
      Just font -> do
        ok <- ttfSetFontSDF font True
        if ok
          then pure (Right font)
          else do
            ttfCloseFont font
            Left . SlopAssetFailure "enable SDF font" (T.pack path) . T.pack <$> sdlGetError
  unloadAssetIO _ _ = ttfCloseFont
  assetLabel (SdfFontAsset path _) = T.pack path
  assetFiles (SdfFontAsset path _) = [path]

instance AssetLoader ShaderAsset where
  type AssetType ShaderAsset = Shader
  loadAssetIO app spec = do
    let bytes = spec.shaderSpirvBytes
    let samplers = spec.shaderSamplers
    let storageTextures = spec.shaderStorageTextures
    let storageBuffers = spec.shaderStorageBuffers
    let uniformBuffers = spec.shaderUniformBuffers
    Right <$> createShaderFromSpirvWithIO app bytes samplers storageTextures storageBuffers uniformBuffers
  unloadAssetIO _ _ = destroyShaderIO
  assetLabel _ = "shader"
  assetThread _ = AssetMain

instance AssetLoader Shader2DAsset where
  type AssetType Shader2DAsset = Shader2D
  loadAssetIO app spec = do
    validateShader2DCounts spec.shader2DCounts
    Right . Shader2D <$>
      createShaderFromSpirvWithIO app spec.shader2DSpirvBytes
        spec.shader2DCounts.shaderSamplers
        spec.shader2DCounts.shaderStorageTextures
        spec.shader2DCounts.shaderStorageBuffers
        spec.shader2DCounts.shaderUniformBuffers
  unloadAssetIO _ _ (Shader2D shader) = destroyShaderIO shader
  assetLabel _ = "shader-2d"
  assetThread _ = AssetMain

instance AssetLoader ReflectedShader2DAsset where
  type AssetType ReflectedShader2DAsset = Shader2D
  loadAssetIO app spec = do
    let layout = spec.reflectedShader2DLayout
    if layout.reflectedShaderStage /= ShaderFragment
      then pure (Left (reflectionError layout.reflectedShaderName Nothing "expected a fragment shader layout"))
      else do
        validateShader2DCounts layout.reflectedShaderCounts
        shader <- createShaderFromSpirvWithIO app spec.reflectedShader2DSpirvBytes
          layout.reflectedShaderCounts.shaderSamplers
          layout.reflectedShaderCounts.shaderStorageTextures
          layout.reflectedShaderCounts.shaderStorageBuffers
          layout.reflectedShaderCounts.shaderUniformBuffers
        writeIORef shader.shaderBindingTable (reflectedBindingsTable layout)
        pure (Right (Shader2D shader { shaderReflectedLayout = Just layout }))
  unloadAssetIO _ _ (Shader2D shader) = destroyShaderIO shader
  assetLabel spec = spec.reflectedShader2DLayout.reflectedShaderName
  assetThread _ = AssetMain

instance AssetLoader Shader2DLayoutAsset where
  type AssetType Shader2DLayoutAsset = Shader2D
  loadAssetIO app spec = do
    case validateShader2DLayout spec.shader2DLayoutSpec of
      Left err -> pure (Left err)
      Right counts' -> do
        Right . Shader2D <$>
          createShaderFromSpirvWithIO app spec.shader2DLayoutSpirvBytes
            counts'.shaderSamplers
            counts'.shaderStorageTextures
            counts'.shaderStorageBuffers
            counts'.shaderUniformBuffers
  unloadAssetIO _ _ (Shader2D shader) = destroyShaderIO shader
  assetLabel _ = "shader-2d-layout"
  assetThread _ = AssetMain

instance AssetLoader VertexShaderAsset where
  type AssetType VertexShaderAsset = VertexShader
  loadAssetIO app spec =
    Right <$> createVertexShaderIO app spec.vertexShaderSpirvBytes spec.vertexShaderCounts
  unloadAssetIO _ _ shader =
    sdlReleaseGPUShader shader.vertexShaderDevice shader.vertexShaderHandle
  assetLabel _ = "vertex-shader"
  assetThread _ = AssetMain

instance AssetLoader ComputePipelineAsset where
  type AssetType ComputePipelineAsset = ComputePipeline
  loadAssetIO app spec =
    Right <$> createComputePipelineIO app spec.computePipelineDesc
  unloadAssetIO _ _ pipeline =
    sdlReleaseGPUComputePipeline pipeline.computeDevice pipeline.computeHandle
  assetLabel _ = "compute-pipeline"
  assetThread _ = AssetMain

instance AssetLoader PipelineAsset where
  type AssetType PipelineAsset = Pipeline
  loadAssetIO app spec = do
    let desc = spec.pipelineDesc
    let fmt =
          case desc.gfxTarget of
            TargetSwapchain -> app.appSwapchainFormat
            TargetFormat value -> value
    let depthFormat =
          if desc.gfxDepth == DepthNone
            then 0
            else if desc.gfxDepthFormat == 0 then app.appDepthFormat else desc.gfxDepthFormat
    pipelineHandle <- createGraphicsPipeline app
      desc.gfxVertex.vertexShaderHandle
      desc.gfxFragment.shaderHandle
      desc.gfxLayout
      (primitiveToSDL desc.gfxPrimitive)
      fmt
      desc.gfxBlend
      desc.gfxDepth
      depthFormat
    pure (Right Pipeline
      { pipelineHandle = pipelineHandle
      , pipelineVertex = desc.gfxVertex.vertexShaderHandle
      , pipelineFragment = desc.gfxFragment.shaderHandle
      , pipelineLayout = desc.gfxLayout
      , pipelinePrimitive = desc.gfxPrimitive
      , pipelineTargetFormat = fmt
      , pipelineBlend = desc.gfxBlend
      , pipelineDepthMode = desc.gfxDepth
      , pipelineDepthFormat = depthFormat
      })
  unloadAssetIO app _ pipeline =
    sdlReleaseGPUGraphicsPipeline app.appGPUDevice pipeline.pipelineHandle
  assetLabel _ = "graphics-pipeline"
  assetThread _ = AssetMain

instance AssetLoader SamplerAsset where
  type AssetType SamplerAsset = Sampler
  loadAssetIO app spec = do
    sampler <- require "SDL_CreateGPUSampler"
      (sdlCreateGPUSampler app.appGPUDevice (samplerDescToCreateInfo spec.samplerDesc))
    pure (Right (Sampler sampler))
  unloadAssetIO app _ (Sampler sampler) =
    sdlReleaseGPUSampler app.appGPUDevice sampler
  assetLabel _ = "sampler"
  assetThread _ = AssetMain

data AssetManager = AssetManager
  { amState :: !(TVar ManagerState)
  , amQueue :: !(TQueue AssetCommand)
  , amWorkerCompletions :: ![TMVar ()]
  }

data ManagerState = ManagerState
  { msNextId :: !Int
  , msAssets :: !(IntMap.IntMap AssetSlot)
  }

data HotReloadInfo = HotReloadInfo
  { hrFiles :: ![FilePath]
  , hrTimes :: !(Map.Map FilePath (Maybe UTCTime))
  , hrReload :: !(IO ())
  }

data AssetSlot = AssetSlot
  { slotType :: !TypeRep
  , slotState :: !SlotState
  , slotHotReload :: !(Maybe HotReloadInfo)
  }

data SlotState
  = SlotLoading !(TMVar (SlopResult ()))
  | SlotReady !Dynamic !(IO ())
  | SlotFailed !SlopError

data RequestMode = RequestLoad | RequestReload

data AssetCommand where
  AssetCommand :: AssetLoader spec => Int -> spec -> RequestMode -> Maybe (TMVar (SlopResult ())) -> AssetCommand
  StopCommand :: AssetCommand

newAssetManager :: IO AssetManager
newAssetManager = do
  stateVar <- newTVarIO ManagerState { msNextId = 0, msAssets = IntMap.empty }
  queue <- newTQueueIO
  pure AssetManager
    { amState = stateVar
    , amQueue = queue
    , amWorkerCompletions = []
    }

startAssetWorkers :: Window -> Int -> AssetManager -> IO AssetManager
startAssetWorkers app workerCount manager = mask_ $ do
  let count = max 1 workerCount
  startedWorkers <- newIORef []
  workerCompletions <-
    replicateM count (do
      completion <- newEmptyTMVarIO
      void $ forkFinally
        (assetWorker app manager.amState manager.amQueue)
        (\result ->
          (case result of
            Left exception -> hPutStrLn stderr ("slop asset worker exited: " <> displayException exception)
            Right () -> pure ())
          `finally` atomically (putTMVar completion ()))
      modifyIORef' startedWorkers (completion :)
      pure completion)
      `onException` (readIORef startedWorkers >>= stopAssetWorkers manager.amQueue)
  pure manager { amWorkerCompletions = workerCompletions }

shutdownAssetManager :: Window -> AssetManager -> IO ()
shutdownAssetManager app mgr = do
  stopAssetWorkers mgr.amQueue mgr.amWorkerCompletions
  removeAllAssetsIO app mgr

stopAssetWorkers :: TQueue AssetCommand -> [TMVar ()] -> IO ()
stopAssetWorkers queue workerCompletions = do
  atomically $ forM_ workerCompletions (const (writeTQueue queue StopCommand))
  mapM_ (atomically . readTMVar) workerCompletions

removeAllAssetsIO :: Window -> AssetManager -> IO ()
removeAllAssetsIO app mgr = do
  entries <- atomically $ do
    st <- readTVar (mgr.amState)
    writeTVar (mgr.amState) st { msAssets = IntMap.empty }
    pure (map snd (IntMap.toDescList (st.msAssets)))
  finalizeEntries entries
  where
    finalizeEntries [] = pure ()
    finalizeEntries (entry : remaining) =
      finalizeEntry app entry `finally` finalizeEntries remaining
    finalizeEntry _ (AssetSlot _ (SlotFailed _) _) = pure ()
    finalizeEntry _ (AssetSlot _ (SlotLoading var) _) =
      void (atomically (tryPutTMVar var (Left (SlopAssetFailure "remove" "all assets" "asset removed"))))
    finalizeEntry app' (AssetSlot _ (SlotReady dyn finalizer) _) = do
      case fromDynamic dyn :: Maybe Font of
        Just font -> evictTextCacheForFontIO app' font
        Nothing -> pure ()
      finalizer

assetWorker :: Window -> TVar ManagerState -> TQueue AssetCommand -> IO ()
assetWorker app stateVar queue = go
  where
    go = do
      cmd <- atomically (readTQueue queue)
      continue <- handleAssetCommand app stateVar cmd
      when continue go

handleAssetCommand :: Window -> TVar ManagerState -> AssetCommand -> IO Bool
handleAssetCommand app stateVar cmd =
  case cmd of
    StopCommand -> pure False
    AssetCommand assetId spec mode notify -> do
      result <- trySyncException (loadAssetIO app spec)
      let resolved = case result of
            Left exception -> Left (exceptionAssetError "load" (assetLabel spec) exception)
            Right loaded -> first (assetOperationError "load" (assetLabel spec)) loaded
      case mode of
        RequestLoad -> finishLoad app stateVar assetId spec resolved notify
        RequestReload -> finishReload app stateVar assetId spec resolved notify
      pure True

finishLoad :: forall spec. AssetLoader spec => Window -> TVar ManagerState -> Int -> spec -> SlopResult (AssetType spec) -> Maybe (TMVar (SlopResult ())) -> IO ()
finishLoad app stateVar assetId spec result _ = case result of
  Left err -> do
    atomically $ do
      st <- readTVar stateVar
      case IntMap.lookup assetId (st.msAssets) of
        Just slot@AssetSlot { slotState = SlotLoading var } -> do
          let slot' = slot { slotState = SlotFailed err }
          writeTVar stateVar st { msAssets = IntMap.insert assetId slot' (st.msAssets) }
          void (tryPutTMVar var (Left err))
        _ -> pure ()
  Right asset -> do
    let dyn = toDyn asset
    let finalizer = unloadAssetIO app spec asset
    let typ = typeOf asset
    cancelled <- atomically $ do
      st <- readTVar stateVar
      case IntMap.lookup assetId (st.msAssets) of
        Just slot@AssetSlot { slotState = SlotLoading var } -> do
          let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
          writeTVar stateVar st { msAssets = IntMap.insert assetId slot' (st.msAssets) }
          void (tryPutTMVar var (Right ()))
          pure False
        Nothing -> pure True
        _ -> pure False
    when cancelled $ do
      cleanupResult <- trySyncException finalizer
      case cleanupResult of
        Left exception ->
          let err = exceptionAssetError "load cancellation cleanup" (assetLabel spec) exception
          in hPutStrLn stderr ("slop asset cleanup failed: " <> T.unpack (renderSlopError err))
        Right () -> pure ()

finishReload :: forall spec. AssetLoader spec => Window -> TVar ManagerState -> Int -> spec -> SlopResult (AssetType spec) -> Maybe (TMVar (SlopResult ())) -> IO ()
finishReload app stateVar assetId spec result notify = case result of
  Left err -> completeReload (Left err)
  Right asset -> do
    let dyn = toDyn asset
    let finalizer = unloadAssetIO app spec asset
    let typ = typeOf asset
    (oldFinalizer, missing) <- atomically $ do
      st <- readTVar stateVar
      case IntMap.lookup assetId (st.msAssets) of
        Nothing -> pure (Nothing, True)
        Just slot@AssetSlot { slotState = SlotReady _ oldFin } -> do
          let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
          writeTVar stateVar st { msAssets = IntMap.insert assetId slot' (st.msAssets) }
          pure (Just oldFin, False)
        Just slot@AssetSlot { slotState = SlotFailed _ } -> do
          let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
          writeTVar stateVar st { msAssets = IntMap.insert assetId slot' (st.msAssets) }
          pure (Nothing, False)
        Just slot@AssetSlot { slotState = SlotLoading _ } -> do
          let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
          writeTVar stateVar st { msAssets = IntMap.insert assetId slot' (st.msAssets) }
          pure (Nothing, False)
    if missing
      then do
        cleanupResult <- runFinalizer finalizer
        case cleanupResult of
          Left err -> completeReload (Left err)
          Right () -> case notify of
            Nothing -> pure ()
            Just _ -> completeReload (Left (SlopAssetFailure "reload" ("#" <> T.pack (show assetId)) "asset not found"))
      else do
        cleanupResult <- maybe (pure (Right ())) runFinalizer oldFinalizer
        completeReload cleanupResult
  where
    runFinalizer finalizer =
      first (exceptionAssetError "reload cleanup" (assetLabel spec)) <$> trySyncException finalizer

    completeReload reloadResult = case notify of
      Just var -> atomically (void (tryPutTMVar var reloadResult))
      Nothing -> case reloadResult of
        Left err -> hPutStrLn stderr ("slop asset reload failed: " <> T.unpack (renderSlopError err))
        Right () -> pure ()

registerLoading :: forall a. Typeable a => AssetManager -> IO (AssetId a, TMVar (SlopResult ()))
registerLoading mgr = atomically $ do
  st <- readTVar (mgr.amState)
  var <- newEmptyTMVar
  let newId = st.msNextId
  let slot = AssetSlot (typeRep (Proxy :: Proxy a)) (SlotLoading var) Nothing
  writeTVar (mgr.amState) st { msNextId = newId + 1, msAssets = IntMap.insert newId slot (st.msAssets) }
  pure (AssetId newId, var)

loadAsset :: forall spec. AssetLoader spec => spec -> WindowM (AssetId (AssetType spec))
loadAsset spec = loadAssetResult spec >>= either throwSlop pure

loadAssetResult :: forall spec. AssetLoader spec => spec -> WindowM (SlopResult (AssetId (AssetType spec)))
loadAssetResult spec = do
  app <- ask
  let mgr = app.appAssets
  let label = assetLabel spec
  (assetId, _) <- liftIO (registerLoading @(AssetType spec) mgr)
  liftIO (installHotReloadInfo app assetId spec)
  result <- liftIO (trySyncException (loadAssetIO app spec))
  let resolved = case result of
        Left exception -> Left (exceptionAssetError "load" label exception)
        Right loaded -> first (assetOperationError "load" label) loaded
  liftIO $ case resolved of
    Left err -> do
      atomically $ do
        st <- readTVar (mgr.amState)
        case IntMap.lookup (assetId.unAssetId) (st.msAssets) of
          Just slot@AssetSlot { slotState = SlotLoading var } -> do
            let slot' = slot { slotState = SlotFailed err }
            writeTVar (mgr.amState) st { msAssets = IntMap.insert (assetId.unAssetId) slot' (st.msAssets) }
            void (tryPutTMVar var (Left err))
          _ -> pure ()
    Right asset -> do
      let dyn = toDyn asset
      let finalizer = unloadAssetIO app spec asset
      let typ = typeOf asset
      cancelled <- atomically $ do
        st <- readTVar (mgr.amState)
        case IntMap.lookup (assetId.unAssetId) (st.msAssets) of
          Just slot@AssetSlot { slotState = SlotLoading var } -> do
            let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
            writeTVar (mgr.amState) st { msAssets = IntMap.insert (assetId.unAssetId) slot' (st.msAssets) }
            void (tryPutTMVar var (Right ()))
            pure False
          Nothing -> pure True
          _ -> pure False
      if cancelled then finalizer else pure ()
  pure (fmap (const assetId) resolved)

loadAssetAsync :: forall spec. AssetLoader spec => spec -> WindowM (AssetId (AssetType spec))
loadAssetAsync spec = do
  case assetThread spec of
    AssetMain -> do
      app <- ask
      let mgr = app.appAssets
      (assetId, _) <- liftIO (registerLoading @(AssetType spec) mgr)
      liftIO (installHotReloadInfo app assetId spec)
      liftIO $ atomically $
        writeTQueue (app.appMainAssetQueue) (AssetCommand (assetId.unAssetId) spec RequestLoad Nothing)
      pure assetId
    AssetAny -> do
      app <- ask
      let mgr = app.appAssets
      (assetId, _) <- liftIO (registerLoading @(AssetType spec) mgr)
      liftIO (installHotReloadInfo app assetId spec)
      liftIO $ atomically $
        writeTQueue (mgr.amQueue) (AssetCommand (assetId.unAssetId) spec RequestLoad Nothing)
      pure assetId

processMainAssets :: WindowM ()
processMainAssets = do
  app <- ask
  let queue = app.appMainAssetQueue
  let stateVar = app.appAssets.amState
  liftIO (drain app stateVar queue)
  where
    drain app stateVar queue = do
      mCmd <- atomically (tryReadTQueue queue)
      case mCmd of
        Nothing -> pure ()
        Just cmd -> do
          case cmd of
            StopCommand -> pure ()
            _ -> void (handleAssetCommand app stateVar cmd)
          drain app stateVar queue

awaitWithMainQueue :: Window -> TMVar a -> IO a
awaitWithMainQueue app var = go
  where
    queue = app.appMainAssetQueue
    stateVar = app.appAssets.amState
    go = do
      next <- atomically $
        (Right <$> readTMVar var)
          `orElse`
        (Left <$> readTQueue queue)
      case next of
        Right value -> pure value
        Left cmd -> do
          case cmd of
            StopCommand -> pure ()
            _ -> void (handleAssetCommand app stateVar cmd)
          go

reloadAssetAsync :: forall spec. AssetLoader spec => AssetId (AssetType spec) -> spec -> WindowM AssetUpdate
reloadAssetAsync assetId spec = do
  app <- ask
  let mgr = app.appAssets
  notify <- liftIO newEmptyTMVarIO
  exists <- liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    pure (IntMap.member (assetId.unAssetId) (st.msAssets))
  if exists
    then do
      liftIO (installHotReloadInfo app assetId spec)
      liftIO $ atomically $
        case assetThread spec of
          AssetMain -> writeTQueue (app.appMainAssetQueue) (AssetCommand (assetId.unAssetId) spec RequestReload (Just notify))
          AssetAny -> writeTQueue (mgr.amQueue) (AssetCommand (assetId.unAssetId) spec RequestReload (Just notify))
      pure (AssetUpdate notify)
    else do
      liftIO $ atomically (putTMVar notify (Left (assetIdError "reload" assetId "asset not found")))
      pure (AssetUpdate notify)

awaitAssetUpdate :: AssetUpdate -> WindowM ()
awaitAssetUpdate update = awaitAssetUpdateResult update >>= either throwSlop pure

awaitAssetUpdateResult :: AssetUpdate -> WindowM (SlopResult ())
awaitAssetUpdateResult (AssetUpdate var) = do
  app <- ask
  liftIO (awaitWithMainQueue app var)

awaitAsset :: forall a. Typeable a => AssetId a -> WindowM a
awaitAsset assetId = awaitAssetResult assetId >>= either throwSlop pure

awaitAssetResult :: forall a. Typeable a => AssetId a -> WindowM (SlopResult a)
awaitAssetResult assetId = do
  app <- ask
  let mgr = app.appAssets
  mWait <- liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    case IntMap.lookup (assetId.unAssetId) (st.msAssets) of
      Just (AssetSlot _ (SlotLoading var) _) -> pure (Just var)
      _ -> pure Nothing
  case mWait of
    Just var -> do
      _ <- liftIO (awaitWithMainQueue app var)
      getAfterWait
    Nothing -> getAfterWait
  where
    getAfterWait = do
      status <- getAssetStatus assetId
      case status of
        Nothing -> pure (Left (assetIdError "await" assetId "asset not found"))
        Just AssetLoading -> pure (Left (assetIdError "await" assetId "asset still loading"))
        Just (AssetFailed err) -> pure (Left err)
        Just (AssetReady value) -> pure (Right value)

assetIdError :: T.Text -> AssetId a -> T.Text -> SlopError
assetIdError operation assetId =
  SlopAssetFailure operation ("#" <> T.pack (show assetId.unAssetId))

getAsset :: forall (a :: Type). Typeable a => AssetId a -> WindowM (Maybe a)
getAsset assetId = do
  status <- getAssetStatus assetId
  case status of
    Just (AssetReady value) -> pure (Just value)
    _ -> pure Nothing

assetReady :: forall (a :: Type). Typeable a => AssetId a -> WindowM Bool
assetReady assetId = isJust <$> getAsset assetId

getAssetStatus :: forall a. Typeable a => AssetId a -> WindowM (Maybe (AssetStatus a))
getAssetStatus assetId = do
  app <- ask
  let mgr = app.appAssets
  liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    pure $ do
      slot <- IntMap.lookup (assetId.unAssetId) (st.msAssets)
      let typ = slot.slotType
      let slotState' = slot.slotState
      if typ /= typeRep (Proxy :: Proxy a)
        then Nothing
        else case slotState' of
          SlotLoading _ -> Just AssetLoading
          SlotFailed err -> Just (AssetFailed err)
          SlotReady dyn _ -> fromDynamic dyn >>= \value -> Just (AssetReady value)

removeAsset :: AssetId a -> WindowM Bool
removeAsset assetId = do
  app <- ask
  let mgr = app.appAssets
  toFinalize <- liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    case IntMap.lookup (assetId.unAssetId) (st.msAssets) of
      Nothing -> pure (Left False)
      Just slot -> do
        writeTVar (mgr.amState) st { msAssets = IntMap.delete (assetId.unAssetId) (st.msAssets) }
        case slot.slotState of
          SlotLoading var -> do
            void (tryPutTMVar var (Left (assetIdError "remove" assetId "asset removed")))
            pure (Left True)
          SlotFailed _ -> pure (Left True)
          SlotReady dyn finalizer -> pure (Right (dyn, finalizer))
  case toFinalize of
    Left ok -> pure ok
    Right (dyn, finalizer) -> do
      case fromDynamic dyn :: Maybe Font of
        Just font -> liftIO (evictTextCacheForFontIO app font)
        Nothing -> pure ()
      liftIO finalizer
      pure True

removeAssets :: [AnyAssetId] -> WindowM [Bool]
removeAssets = mapM (\(AnyAssetId assetId) -> removeAsset assetId)

removeAssets_ :: [AnyAssetId] -> WindowM ()
removeAssets_ assetIds = do
  _ <- removeAssets assetIds
  pure ()

removeAllAssets :: WindowM ()
removeAllAssets = do
  app <- ask
  liftIO (removeAllAssetsIO app (app.appAssets))

enableHotReload :: Float -> WindowM ()
enableHotReload interval = do
  window <- ask
  let interval' = max 0 interval
  liftIO (writeIORef window.appHotReload (HotReloadConfig True interval' 0))

disableHotReload :: WindowM ()
disableHotReload = do
  window <- ask
  liftIO (modifyIORef' window.appHotReload (\cfg -> cfg { hrEnabled = False }))

installHotReloadInfo :: forall spec. AssetLoader spec => Window -> AssetId (AssetType spec) -> spec -> IO ()
installHotReloadInfo app assetId spec = do
  let mgr = app.appAssets
  let files = assetFiles spec
  info <- case files of
    [] -> pure Nothing
    _ -> do
      times <- loadHotReloadTimes files
      let reloadAction = atomically $ case assetThread spec of
            AssetMain -> writeTQueue (app.appMainAssetQueue) (AssetCommand (assetId.unAssetId) spec RequestReload Nothing)
            AssetAny -> writeTQueue (mgr.amQueue) (AssetCommand (assetId.unAssetId) spec RequestReload Nothing)
      pure (Just HotReloadInfo
        { hrFiles = files
        , hrTimes = times
        , hrReload = reloadAction
        })
  atomically $ modifyTVar' (mgr.amState) $ \st ->
    st { msAssets = IntMap.adjust (\slot -> slot { slotHotReload = info }) (assetId.unAssetId) (st.msAssets) }

loadHotReloadTimes :: [FilePath] -> IO (Map.Map FilePath (Maybe UTCTime))
loadHotReloadTimes files = do
  pairs <- mapM (\path -> do time <- safeGetModTime path; pure (path, time)) files
  pure (Map.fromList pairs)

safeGetModTime :: FilePath -> IO (Maybe UTCTime)
safeGetModTime path = do
  result <- trySyncException (getModificationTime path)
  case result of
    Left _ -> pure Nothing
    Right time -> pure (Just time)

refreshHotReloadInfo :: HotReloadInfo -> IO (HotReloadInfo, Bool)
refreshHotReloadInfo info = do
  (times', changed) <- foldM update (info.hrTimes, False) (info.hrFiles)
  pure (info { hrTimes = times' }, changed)
  where
    update (times, changed) path = do
      mTime <- safeGetModTime path
      case mTime of
        Nothing -> pure (times, changed)
        Just time -> do
          let old = Map.findWithDefault Nothing path times
          let changed' = changed || maybe True (time >) old
          pure (Map.insert path (Just time) times, changed')

hotReloadAssets :: WindowM ()
hotReloadAssets = do
  app <- ask
  let mgr = app.appAssets
  entries <- liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    pure (IntMap.toList (st.msAssets))
  updates <- liftIO $ mapM checkEntry entries
  let updates' = catMaybes updates
  liftIO $ atomically $ modifyTVar' (mgr.amState) $ \st ->
    let assets' = foldl'
          (\assets (assetId, info) -> IntMap.adjust (\slot -> slot { slotHotReload = Just info }) assetId assets)
          (st.msAssets)
          updates'
    in st { msAssets = assets' }
  where
    checkEntry (_, AssetSlot _ _ Nothing) = pure Nothing
    checkEntry (assetId, AssetSlot _ slotState (Just info)) = do
      (info', changed) <- refreshHotReloadInfo info
      let shouldReload = changed && case slotState of
            SlotReady {} -> True
            SlotFailed {} -> True
            SlotLoading {} -> False
      when shouldReload (info'.hrReload)
      pure (Just (assetId, info'))


data Frame = Frame
  { delta :: !Float
  , time :: !Float
  , ticks :: !Word64
  , quitRequested :: !Bool
  , size :: !(Int, Int)
  , renderSize :: !(Int, Int)
  , dpiScale :: !(V2 Float)
  , input :: !InputFrame
  }
  deriving (Eq, Show)

data SlopGlobals = SlopGlobals
  { globalsTime :: !Float
  , globalsRenderSize :: !(V2 Float)
  , globalsDpiScale :: !(V2 Float)
  }
  deriving (Eq, Show)

instance Storable SlopGlobals where
  sizeOf _ = 32
  alignment _ = 16
  peek ptr = do
    time <- peekByteOff ptr 0
    renderW <- peekByteOff ptr 8
    renderH <- peekByteOff ptr 12
    dpiX <- peekByteOff ptr 16
    dpiY <- peekByteOff ptr 20
    pure SlopGlobals
      { globalsTime = time
      , globalsRenderSize = V2 renderW renderH
      , globalsDpiScale = V2 dpiX dpiY
      }
  poke ptr SlopGlobals { globalsTime = time, globalsRenderSize = V2 renderW renderH, globalsDpiScale = V2 dpiX dpiY } = do
    pokeByteOff ptr 0 time
    pokeByteOff ptr 4 (0 :: Float)
    pokeByteOff ptr 8 renderW
    pokeByteOff ptr 12 renderH
    pokeByteOff ptr 16 dpiX
    pokeByteOff ptr 20 dpiY
    pokeByteOff ptr 24 (0 :: Float)
    pokeByteOff ptr 28 (0 :: Float)

slopGlobals :: Frame -> SlopGlobals
slopGlobals frame =
  let (rw, rh) = frame.renderSize
  in SlopGlobals
      { globalsTime = frame.time
      , globalsRenderSize = V2 (fromIntegral rw) (fromIntegral rh)
      , globalsDpiScale = frame.dpiScale
      }

updateGlobalsUniform :: Window -> Frame -> IO ()
updateGlobalsUniform window frame = do
  bytes <- toBytes (slopGlobals frame)
  writeIORef window.appGlobalsUniform (Just bytes)

data LoopControl a
  = Continue a
  | Quit a
  deriving (Eq, Show)

data LoopExit a
  = ExitQuitRequested a
  | ExitStopped a
  deriving (Eq, Show)

data Key
  = KeyA
  | KeyB
  | KeyC
  | KeyD
  | KeyE
  | KeyF
  | KeyG
  | KeyH
  | KeyI
  | KeyJ
  | KeyK
  | KeyL
  | KeyM
  | KeyN
  | KeyO
  | KeyP
  | KeyQ
  | KeyR
  | KeyS
  | KeyT
  | KeyU
  | KeyV
  | KeyW
  | KeyX
  | KeyY
  | KeyZ
  | Key0
  | Key1
  | Key2
  | Key3
  | Key4
  | Key5
  | Key6
  | Key7
  | Key8
  | Key9
  | KeySpace
  | KeyEnter
  | KeyEscape
  | KeyTab
  | KeyBackspace
  | KeyLeft
  | KeyRight
  | KeyUp
  | KeyDown
  | KeyShiftLeft
  | KeyShiftRight
  | KeyCtrlLeft
  | KeyCtrlRight
  | KeyAltLeft
  | KeyAltRight
  deriving (Eq, Ord, Show)

newtype MouseButton = MouseButton Word32
  deriving (Eq, Ord, Show)

data InputState = InputState
  { inputKeysDown :: !IntSet
  , inputMouseButtonsDown :: !Word32
  , inputMousePos :: !(V2 Float)
  }
  deriving (Eq, Show)

data Modifiers = Modifiers
  { modShift :: !Bool
  , modCtrl :: !Bool
  , modAlt :: !Bool
  , modGui :: !Bool
  , modNum :: !Bool
  , modCaps :: !Bool
  , modMode :: !Bool
  , modScroll :: !Bool
  }
  deriving (Eq, Show)

data InputFrame = InputFrame
  { inputPrev :: !InputState
  , inputNow :: !InputState
  , inputText :: !T.Text
  , inputWheel :: !(V2 Float)
  , inputMods :: !Modifiers
  , inputEvents :: ![InputEvent]
  }
  deriving (Eq, Show)

data InputEvent
  = EventText T.Text
  | EventMouseWheel (V2 Float)
  | EventQuit
  deriving (Eq, Show)

inputPrev :: InputFrame -> InputState
inputPrev = (.inputPrev)

inputNow :: InputFrame -> InputState
inputNow = (.inputNow)

inputText :: InputFrame -> T.Text
inputText = (.inputText)

inputWheel :: InputFrame -> V2 Float
inputWheel = (.inputWheel)

inputMods :: InputFrame -> Modifiers
inputMods = (.inputMods)

inputEvents :: InputFrame -> [InputEvent]
inputEvents = (.inputEvents)

mouseLeft :: MouseButton
mouseLeft = MouseButton 1

mouseMiddle :: MouseButton
mouseMiddle = MouseButton 2

mouseRight :: MouseButton
mouseRight = MouseButton 3

mouseX1 :: MouseButton
mouseX1 = MouseButton 4

mouseX2 :: MouseButton
mouseX2 = MouseButton 5

keySpace :: Key
keySpace = KeySpace

mouseButtonMask :: MouseButton -> Word32
mouseButtonMask (MouseButton button) = 1 `shiftL` fromIntegral (button - 1)

keyDown :: Key -> InputState -> Bool
keyDown key InputState { inputKeysDown = keys } =
  IntSet.member (keycodeValue key) keys

keyPressed :: Key -> InputFrame -> Bool
keyPressed key InputFrame { inputPrev = prevState, inputNow = nowState } =
  keyDown key nowState && not (keyDown key prevState)

keyReleased :: Key -> InputFrame -> Bool
keyReleased key InputFrame { inputPrev = prevState, inputNow = nowState } =
  not (keyDown key nowState) && keyDown key prevState

keycodeValue :: Key -> Int
keycodeValue key =
  case key of
    KeyA -> fromEnum 'a'
    KeyB -> fromEnum 'b'
    KeyC -> fromEnum 'c'
    KeyD -> fromEnum 'd'
    KeyE -> fromEnum 'e'
    KeyF -> fromEnum 'f'
    KeyG -> fromEnum 'g'
    KeyH -> fromEnum 'h'
    KeyI -> fromEnum 'i'
    KeyJ -> fromEnum 'j'
    KeyK -> fromEnum 'k'
    KeyL -> fromEnum 'l'
    KeyM -> fromEnum 'm'
    KeyN -> fromEnum 'n'
    KeyO -> fromEnum 'o'
    KeyP -> fromEnum 'p'
    KeyQ -> fromEnum 'q'
    KeyR -> fromEnum 'r'
    KeyS -> fromEnum 's'
    KeyT -> fromEnum 't'
    KeyU -> fromEnum 'u'
    KeyV -> fromEnum 'v'
    KeyW -> fromEnum 'w'
    KeyX -> fromEnum 'x'
    KeyY -> fromEnum 'y'
    KeyZ -> fromEnum 'z'
    Key1 -> fromEnum '1'
    Key2 -> fromEnum '2'
    Key3 -> fromEnum '3'
    Key4 -> fromEnum '4'
    Key5 -> fromEnum '5'
    Key6 -> fromEnum '6'
    Key7 -> fromEnum '7'
    Key8 -> fromEnum '8'
    Key9 -> fromEnum '9'
    Key0 -> fromEnum '0'
    KeyEnter -> fromEnum '\r'
    KeyEscape -> fromEnum '\ESC'
    KeyBackspace -> fromEnum '\b'
    KeyTab -> fromEnum '\t'
    KeySpace -> fromEnum ' '
    KeyLeft -> scancodeToKeycode 80
    KeyRight -> scancodeToKeycode 79
    KeyUp -> scancodeToKeycode 82
    KeyDown -> scancodeToKeycode 81
    KeyCtrlLeft -> scancodeToKeycode 224
    KeyShiftLeft -> scancodeToKeycode 225
    KeyAltLeft -> scancodeToKeycode 226
    KeyCtrlRight -> scancodeToKeycode 228
    KeyShiftRight -> scancodeToKeycode 229
    KeyAltRight -> scancodeToKeycode 230

scancodeToKeycode :: Int -> Int
scancodeToKeycode scancode = scancode .|. 0x40000000

mouseButtonDown :: MouseButton -> InputState -> Bool
mouseButtonDown button InputState { inputMouseButtonsDown = buttons } =
  buttons .&. mouseButtonMask button /= 0

mouseButtonPressed :: MouseButton -> InputFrame -> Bool
mouseButtonPressed button InputFrame { inputPrev = prevState, inputNow = nowState } =
  mouseButtonDown button nowState && not (mouseButtonDown button prevState)

mouseButtonReleased :: MouseButton -> InputFrame -> Bool
mouseButtonReleased button InputFrame { inputPrev = prevState, inputNow = nowState } =
  not (mouseButtonDown button nowState) && mouseButtonDown button prevState

modifiersFromKeymod :: SDL_Keymod -> Modifiers
modifiersFromKeymod mods =
  Modifiers
    { modShift = mods .&. SDL.sdlKmodShift /= 0
    , modCtrl = mods .&. SDL.sdlKmodCtrl /= 0
    , modAlt = mods .&. SDL.sdlKmodAlt /= 0
    , modGui = mods .&. SDL.sdlKmodGui /= 0
    , modNum = mods .&. SDL.sdlKmodNum /= 0
    , modCaps = mods .&. SDL.sdlKmodCaps /= 0
    , modMode = mods .&. SDL.sdlKmodMode /= 0
    , modScroll = mods .&. SDL.sdlKmodScroll /= 0
    }


data Color = Color
  { colorR :: !Float
  , colorG :: !Float
  , colorB :: !Float
  , colorA :: !Float
  }
  deriving (Eq, Show)

data Texture = Texture
  { textureHandle :: GPUTexture
  , textureDevice :: GPUDevice
  , textureWidth :: Int
  , textureHeight :: Int
  , textureDepth :: Int
  }
  deriving (Eq, Show)

data TextureUsage
  = TextureSampled
  | TextureColorTarget
  | TextureDepthTarget
  | TextureStorageRead
  | TextureStorageWrite
  deriving (Eq, Show)

data TextureDesc = TextureDesc
  { texWidth :: Int
  , texHeight :: Int
  , texFormat :: SDL_GPUTextureFormat
  , texUsage :: [TextureUsage]
  }
  deriving (Eq, Show)

newtype Positive = Positive { unPositive :: Int }
  deriving (Eq, Ord, Show)

mkPositive :: Int -> Maybe Positive
mkPositive value
  | value > 0 = Just (Positive value)
  | otherwise = Nothing

positive :: Int -> Positive
positive value = Positive (max 1 value)

data Size2D = Size2D
  { sizeWidth :: Positive
  , sizeHeight :: Positive
  }
  deriving (Eq, Show)

data Size3D = Size3D
  { sizeWidth :: Positive
  , sizeHeight :: Positive
  , sizeDepth :: Positive
  }
  deriving (Eq, Show)

mkSize2D :: Int -> Int -> Maybe Size2D
mkSize2D width height =
  Size2D <$> mkPositive width <*> mkPositive height

mkSize3D :: Int -> Int -> Int -> Maybe Size3D
mkSize3D width height depth =
  Size3D <$> mkPositive width <*> mkPositive height <*> mkPositive depth

size2D :: Int -> Int -> Size2D
size2D width height = Size2D (positive width) (positive height)

size3D :: Int -> Int -> Int -> Size3D
size3D width height depth = Size3D (positive width) (positive height) (positive depth)

size2DToTuple :: Size2D -> (Int, Int)
size2DToTuple (Size2D (Positive width) (Positive height)) = (width, height)

size3DToTuple :: Size3D -> (Int, Int, Int)
size3DToTuple (Size3D (Positive width) (Positive height) (Positive depth)) = (width, height, depth)

data Threads2D = Threads2D
  { threadsX :: Positive
  , threadsY :: Positive
  }
  deriving (Eq, Show)

data Threads3D = Threads3D
  { threadsX :: Positive
  , threadsY :: Positive
  , threadsZ :: Positive
  }
  deriving (Eq, Show)

mkThreads2D :: Int -> Int -> Maybe Threads2D
mkThreads2D x y = Threads2D <$> mkPositive x <*> mkPositive y

mkThreads3D :: Int -> Int -> Int -> Maybe Threads3D
mkThreads3D x y z = Threads3D <$> mkPositive x <*> mkPositive y <*> mkPositive z

threads2D :: Int -> Int -> Threads2D
threads2D x y = Threads2D (positive x) (positive y)

threads3D :: Int -> Int -> Int -> Threads3D
threads3D x y z = Threads3D (positive x) (positive y) (positive z)

threads2DToInts :: Threads2D -> (Int, Int)
threads2DToInts (Threads2D (Positive x) (Positive y)) = (x, y)

threads3DToInts :: Threads3D -> (Int, Int, Int)
threads3DToInts (Threads3D (Positive x) (Positive y) (Positive z)) = (x, y, z)

threads3DToWord32 :: Threads3D -> (Word32, Word32, Word32)
threads3DToWord32 (Threads3D (Positive x) (Positive y) (Positive z)) =
  (fromIntegral x, fromIntegral y, fromIntegral z)

data NoiseType
  = NoiseWhite
  | NoiseValue
  | NoisePerlin
  | NoiseVoronoi
  | NoiseSimplex
  | NoiseSimplex2
  deriving (Eq, Show)

data NoiseSettings = NoiseSettings
  { noiseType :: NoiseType
  , noiseSeed :: Word32
  , noiseScale :: Float
  , noiseOctaves :: Int
  , noiseLacunarity :: Float
  , noiseGain :: Float
  , noiseVoronoiJitter :: Float
  , noiseContrast :: Float
  , noiseBrightness :: Float
  , noisePeriod2D :: Maybe (Int, Int)
  , noisePeriod3D :: Maybe (Int, Int, Int)
  , noiseComputeShader2D :: Maybe ByteString
  , noiseComputeShader3D :: Maybe ByteString
  , noiseComputeThreads2D :: Threads2D
  , noiseComputeThreads3D :: Threads3D
  }
  deriving (Eq, Show)

defaultNoiseSettings :: NoiseSettings
defaultNoiseSettings =
  NoiseSettings
    { noiseType = NoiseValue
    , noiseSeed = 1337
    , noiseScale = 64
    , noiseOctaves = 3
    , noiseLacunarity = 2
    , noiseGain = 0.5
    , noiseVoronoiJitter = 1
    , noiseContrast = 1
    , noiseBrightness = 0
    , noisePeriod2D = Nothing
    , noisePeriod3D = Nothing
    , noiseComputeShader2D = Nothing
    , noiseComputeShader3D = Nothing
    , noiseComputeThreads2D = threads2D 8 8
    , noiseComputeThreads3D = threads3D 4 4 4
    }

noisePeriodFromScale :: Int -> Float -> Int
noisePeriodFromScale size scale =
  let safeScale = max 0.0001 scale
  in max 1 (round (fromIntegral size / safeScale))

loopNoise2D :: Int -> Int -> NoiseSettings -> NoiseSettings
loopNoise2D width height settings =
  settings
    { noisePeriod2D =
        Just
          ( noisePeriodFromScale width settings.noiseScale
          , noisePeriodFromScale height settings.noiseScale
          )
    }

loopNoise3D :: Int -> Int -> Int -> NoiseSettings -> NoiseSettings
loopNoise3D width height depth settings =
  settings
    { noisePeriod3D =
        Just
          ( noisePeriodFromScale width settings.noiseScale
          , noisePeriodFromScale height settings.noiseScale
          , noisePeriodFromScale depth settings.noiseScale
          )
    }

data NoiseParams = NoiseParams
  { noiseParamsDims :: V4 Float
  , noiseParamsScale :: V4 Float
  , noiseParamsExtras :: V4 Float
  , noiseParamsPeriod :: V4 Float
  }
  deriving (Eq, Show)

noiseTypeCode :: NoiseType -> Word32
noiseTypeCode noise =
  case noise of
    NoiseWhite -> 0
    NoiseValue -> 1
    NoisePerlin -> 2
    NoiseVoronoi -> 3
    NoiseSimplex -> 4
    NoiseSimplex2 -> 5

noiseParams2D :: Int -> Int -> NoiseSettings -> NoiseParams
noiseParams2D width height settings =
  let (px, py) = maybe (0, 0) id settings.noisePeriod2D
      jitter = clamp01 settings.noiseVoronoiJitter
  in NoiseParams
      { noiseParamsDims =
          V4
            (fromIntegral width)
            (fromIntegral height)
            1
            (fromIntegral (noiseTypeCode settings.noiseType))
      , noiseParamsScale =
          V4
            settings.noiseScale
            (fromIntegral (max 1 settings.noiseOctaves))
            settings.noiseLacunarity
            settings.noiseGain
      , noiseParamsExtras =
          V4
            (fromIntegral settings.noiseSeed)
            jitter
            settings.noiseContrast
            settings.noiseBrightness
      , noiseParamsPeriod =
          V4
            (fromIntegral px)
            (fromIntegral py)
            0
            0
      }

noiseParams3D :: Int -> Int -> Int -> NoiseSettings -> NoiseParams
noiseParams3D width height depth settings =
  let (px, py, pz) = maybe (0, 0, 0) id settings.noisePeriod3D
      jitter = clamp01 settings.noiseVoronoiJitter
  in NoiseParams
      { noiseParamsDims =
          V4
            (fromIntegral width)
            (fromIntegral height)
            (fromIntegral depth)
            (fromIntegral (noiseTypeCode settings.noiseType))
      , noiseParamsScale =
          V4
            settings.noiseScale
            (fromIntegral (max 1 settings.noiseOctaves))
            settings.noiseLacunarity
            settings.noiseGain
      , noiseParamsExtras =
          V4
            (fromIntegral settings.noiseSeed)
            jitter
            settings.noiseContrast
            settings.noiseBrightness
      , noiseParamsPeriod =
          V4
            (fromIntegral px)
            (fromIntegral py)
            (fromIntegral pz)
            0
      }

clamp01 :: Float -> Float
clamp01 v
  | v < 0 = 0
  | v > 1 = 1
  | otherwise = v

textureDesc :: Int -> Int -> TextureDesc
textureDesc width height =
  TextureDesc
    { texWidth = width
    , texHeight = height
    , texFormat = sdlGPUTextureFormatRGBA8
    , texUsage = [TextureSampled]
    }

textureDescSize :: Size2D -> TextureDesc
textureDescSize size =
  let (width, height) = size2DToTuple size
  in textureDesc width height

rgb :: Float -> Float -> Float -> Color
rgb r g b = Color r g b 1

rgba :: Float -> Float -> Float -> Float -> Color
rgba = Color

data Camera2D = Camera2D
  { camera2DPosition :: V2 Float
  , camera2DZoom :: Float
  , camera2DRotation :: Float
  , camera2DViewport :: Maybe (Float, Float)
  }
  deriving (Eq, Show)

camera2D :: V2 Float -> Float -> (Float, Float) -> Camera2D
camera2D pos zoom viewport =
  Camera2D
    { camera2DPosition = pos
    , camera2DZoom = zoom
    , camera2DRotation = 0
    , camera2DViewport = Just viewport
    }

camera2DWindow :: V2 Float -> Float -> Camera2D
camera2DWindow pos zoom =
  Camera2D
    { camera2DPosition = pos
    , camera2DZoom = zoom
    , camera2DRotation = 0
    , camera2DViewport = Nothing
    }

camera2DScreen :: (Float, Float) -> Camera2D
camera2DScreen (vw, vh) =
  camera2D (V2 (vw / 2) (vh / 2)) 1 (vw, vh)

camera2DMatrix :: (Int, Int) -> Camera2D -> M44 Float
camera2DMatrix size cam =
  let V2 px py = cam.camera2DPosition
      (vw, vh) =
        case cam.camera2DViewport of
          Just value -> value
          Nothing ->
            let (w, h) = size
            in (fromIntegral w, fromIntegral h)
      zoom = cam.camera2DZoom
      rot = cam.camera2DRotation
      halfW = vw / (2 * zoom)
      halfH = vh / (2 * zoom)
      left = px - halfW
      right = px + halfW
      top = py - halfH
      bottom = py + halfH
      proj = ortho left right bottom top 0 1
      c = cos (-rot)
      s = sin (-rot)
      rotZ =
        M44 c (-s) 0 0
             s c 0 0
             0 0 1 0
             0 0 0 1
      view =
        M44 1 0 0 (-px)
             0 1 0 (-py)
             0 0 1 0
             0 0 0 1
      scaleMat =
        M44 zoom 0 0 0
             0 zoom 0 0
             0 0 1 0
             0 0 0 1
  in proj * (rotZ * (scaleMat * view))

data Camera3D = Camera3D
  { camera3DEye :: V3 Float
  , camera3DTarget :: V3 Float
  , camera3DUp :: V3 Float
  , camera3DFovY :: Float
  , camera3DAspect :: Float
  , camera3DNear :: Float
  , camera3DFar :: Float
  }
  deriving (Eq, Show)

camera3D :: V3 Float -> V3 Float -> V3 Float -> Float -> Float -> Float -> Float -> Camera3D
camera3D eye target up fovY aspect nearZ farZ =
  Camera3D
    { camera3DEye = eye
    , camera3DTarget = target
    , camera3DUp = up
    , camera3DFovY = fovY
    , camera3DAspect = aspect
    , camera3DNear = nearZ
    , camera3DFar = farZ
    }

camera3DView :: Camera3D -> M44 Float
camera3DView cam =
  lookAt cam.camera3DEye cam.camera3DTarget cam.camera3DUp

camera3DProj :: Camera3D -> M44 Float
camera3DProj cam =
  perspective cam.camera3DFovY cam.camera3DAspect cam.camera3DNear cam.camera3DFar

camera3DViewProj :: Camera3D -> M44 Float
camera3DViewProj cam =
  camera3DProj cam * camera3DView cam

camera3DMVP :: Camera3D -> M44 Float -> M44 Float
camera3DMVP cam model =
  camera3DViewProj cam * model


instance Storable NoiseParams where
  sizeOf _ = 4 * sizeOf (undefined :: V4 Float)
  alignment _ = alignment (undefined :: V4 Float)
  peek ptr = do
    let step = sizeOf (undefined :: V4 Float)
    dims <- peekByteOff ptr 0
    scale <- peekByteOff ptr step
    extras <- peekByteOff ptr (2 * step)
    period <- peekByteOff ptr (3 * step)
    pure (NoiseParams dims scale extras period)
  poke ptr (NoiseParams dims scale extras period) = do
    let step = sizeOf (undefined :: V4 Float)
    pokeByteOff ptr 0 dims
    pokeByteOff ptr step scale
    pokeByteOff ptr (2 * step) extras
    pokeByteOff ptr (3 * step) period


instance Storable Vertex where
  sizeOf _ = 8 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
    x <- peekByteOff ptr 0 :: IO CFloat
    y <- peekByteOff ptr step :: IO CFloat
    u <- peekByteOff ptr (2 * step) :: IO CFloat
    v <- peekByteOff ptr (3 * step) :: IO CFloat
    r <- peekByteOff ptr (4 * step) :: IO CFloat
    g <- peekByteOff ptr (5 * step) :: IO CFloat
    b <- peekByteOff ptr (6 * step) :: IO CFloat
    a <- peekByteOff ptr (7 * step) :: IO CFloat
    pure (Vertex x y u v r g b a)
  poke ptr (Vertex x y u v r g b a) = do
    let step = sizeOf (undefined :: CFloat)
    pokeByteOff ptr 0 x
    pokeByteOff ptr step y
    pokeByteOff ptr (2 * step) u
    pokeByteOff ptr (3 * step) v
    pokeByteOff ptr (4 * step) r
    pokeByteOff ptr (5 * step) g
    pokeByteOff ptr (6 * step) b
    pokeByteOff ptr (7 * step) a

instance Storable Vertex3D where
  sizeOf _ = 10 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
    x <- peekByteOff ptr 0 :: IO CFloat
    y <- peekByteOff ptr step :: IO CFloat
    z <- peekByteOff ptr (2 * step) :: IO CFloat
    w <- peekByteOff ptr (3 * step) :: IO CFloat
    u <- peekByteOff ptr (4 * step) :: IO CFloat
    v <- peekByteOff ptr (5 * step) :: IO CFloat
    r <- peekByteOff ptr (6 * step) :: IO CFloat
    g <- peekByteOff ptr (7 * step) :: IO CFloat
    b <- peekByteOff ptr (8 * step) :: IO CFloat
    a <- peekByteOff ptr (9 * step) :: IO CFloat
    pure (Vertex3D x y z w u v r g b a)
  poke ptr (Vertex3D x y z w u v r g b a) = do
    let step = sizeOf (undefined :: CFloat)
    pokeByteOff ptr 0 x
    pokeByteOff ptr step y
    pokeByteOff ptr (2 * step) z
    pokeByteOff ptr (3 * step) w
    pokeByteOff ptr (4 * step) u
    pokeByteOff ptr (5 * step) v
    pokeByteOff ptr (6 * step) r
    pokeByteOff ptr (7 * step) g
    pokeByteOff ptr (8 * step) b
    pokeByteOff ptr (9 * step) a

rect :: Float -> Float -> Float -> Float -> FRect
rect x y w h = FRect (realToFrac x) (realToFrac y) (realToFrac w) (realToFrac h)

fullscreenRect :: (Int, Int) -> FRect
fullscreenRect (w, h) = rect 0 0 (fromIntegral w) (fromIntegral h)

point :: Float -> Float -> FPoint
point x y = FPoint (realToFrac x) (realToFrac y)

data As2D = As2D
  { draw2DBlend :: BlendMode
  , draw2DCamera :: Maybe Camera2D
  , draw2DEffect :: Maybe SpriteEffect
  }

newtype As3D = As3D Camera3D

basic2D :: Camera2D -> As2D
basic2D camera = As2D BlendAlpha (Just camera) Nothing

basicUI :: As2D
basicUI = As2D BlendPremultiplied Nothing Nothing

basicUIWith :: Shader2D -> [ShaderUniform] -> As2D
basicUIWith shader uniforms =
  basicUI { draw2DEffect = Just (SpriteEffect shader uniforms) }

basicUIWithCamera :: Camera2D -> As2D
basicUIWithCamera camera =
  basicUI { draw2DCamera = Just camera }

basicParticle :: As2D
basicParticle = As2D BlendAdditive Nothing Nothing

basicParticleWith :: Shader2D -> [ShaderUniform] -> As2D
basicParticleWith shader uniforms =
  basicParticle { draw2DEffect = Just (SpriteEffect shader uniforms) }

basicParticleWithCamera :: Camera2D -> As2D
basicParticleWithCamera camera =
  basicParticle { draw2DCamera = Just camera }

basic3D :: Camera3D -> As3D
basic3D = As3D

class Draw ctx a where
  draw :: ctx -> a -> WindowM ()

data DrawItem where
  DrawItem :: Draw ctx a => ctx -> a -> DrawItem

data Line = Line Color FPoint FPoint
  deriving (Eq, Show)

data RectOutline = RectOutline Color FRect
  deriving (Eq, Show)

data RectFill = RectFill Color FRect
  deriving (Eq, Show)

data Sprite = Sprite Texture (Maybe FRect) FRect (Maybe SpriteEffect)

data SpriteEffect = SpriteEffect Shader2D [ShaderUniform]

spriteEffect :: Shader2D -> [ShaderUniform] -> SpriteEffect
spriteEffect = SpriteEffect

spriteEffectNamed :: Shader2D -> [NamedUniform] -> WindowM SpriteEffect
spriteEffectNamed shader2d named = do
  let shader = unwrapShader2D shader2d
  uniforms <- case shader.shaderReflectedLayout of
    Nothing -> do
      table <- getShaderBindings shader
      liftIO (resolveNamedUniforms table named)
    Just layout ->
      either throwSlop pure (resolveReflectedUniforms layout named)
  pure (SpriteEffect shader2d uniforms)

data TextStyle = TextStyle
  { textColor :: Color
  , textShader :: Maybe SpriteEffect
  , textBlend :: Maybe BlendMode
  }

defaultTextStyle :: TextStyle
defaultTextStyle =
  TextStyle
    { textColor = rgb 1 1 1
    , textShader = Nothing
    , textBlend = Nothing
    }

data Patch a
  = Keep
  | Set a
  deriving (Eq, Show)

instance Semigroup (Patch a) where
  Keep <> b = b
  Set a <> Keep = Set a
  Set _ <> Set b = Set b

instance Monoid (Patch a) where
  mempty = Keep

data TextStylePatch = TextStylePatch
  { patchTextColor :: Patch Color
  , patchTextShader :: Patch (Maybe SpriteEffect)
  , patchTextBlend :: Patch (Maybe BlendMode)
  }

instance Semigroup TextStylePatch where
  TextStylePatch c s b <> TextStylePatch c' s' b' =
    TextStylePatch (c <> c') (s <> s') (b <> b')

instance Monoid TextStylePatch where
  mempty = TextStylePatch mempty mempty mempty

textStylePatch :: TextStylePatch
textStylePatch = mempty

patchTextColor :: Color -> TextStylePatch
patchTextColor color = mempty { patchTextColor = Set color }

patchTextShader :: Maybe SpriteEffect -> TextStylePatch
patchTextShader shader = mempty { patchTextShader = Set shader }

patchTextBlend :: Maybe BlendMode -> TextStylePatch
patchTextBlend blend = mempty { patchTextBlend = Set blend }

applyPatch :: Patch a -> a -> a
applyPatch patch value =
  case patch of
    Keep -> value
    Set newValue -> newValue

applyTextStylePatch :: TextStyle -> TextStylePatch -> TextStyle
applyTextStylePatch style patch =
  TextStyle
    { textColor = applyPatch patch.patchTextColor style.textColor
    , textShader = applyPatch patch.patchTextShader style.textShader
    , textBlend = applyPatch patch.patchTextBlend style.textBlend
    }

textColor :: Color -> TextStyle -> TextStyle
textColor color style = style { textColor = color }

textShader :: SpriteEffect -> TextStyle -> TextStyle
textShader shader style = style { textShader = Just shader }

textBlend :: BlendMode -> TextStyle -> TextStyle
textBlend blend style = style { textBlend = Just blend }

data Label = Label Text Float Float TextStyle

data TextDraw = TextDraw Font T.Text Float Float TextStyle

text :: Font -> T.Text -> Float -> Float -> TextDraw
text font str x y = TextDraw font str x y defaultTextStyle

textWith :: TextStyle -> Font -> T.Text -> Float -> Float -> TextDraw
textWith style font str x y = TextDraw font str x y style

data ShaderUniform where
  ShaderUniform :: Storable a => Word32 -> a -> ShaderUniform
  ShaderUniformBytes :: Word32 -> ByteString -> ShaderUniform
  ShaderSampler :: Word32 -> Texture -> ShaderUniform
  ShaderSamplerWith :: Word32 -> Texture -> Sampler -> ShaderUniform
  ShaderStorageTexture :: Word32 -> Texture -> ShaderUniform

shaderUniformSized :: Storable a => Word32 -> Int -> a -> SlopResult ShaderUniform
shaderUniformSized slot expectedBytes value =
  let actual = sizeOf value
  in if actual /= expectedBytes
      then Left (uniformSizeError slot expectedBytes actual)
      else Right (ShaderUniform slot value)

shaderUniformBytesSized :: Word32 -> Int -> ByteString -> SlopResult ShaderUniform
shaderUniformBytesSized slot expectedBytes bytes =
  let actual = BS.length bytes
  in if actual /= expectedBytes
      then Left (uniformSizeError slot expectedBytes actual)
      else Right (ShaderUniformBytes slot bytes)

uniformSizeError :: Word32 -> Int -> Int -> SlopError
uniformSizeError slot expectedBytes actualBytes =
  SlopShaderFailure
    "bind uniform"
    "unnamed"
    (Just (T.pack (show slot)))
    ("expected " <> T.pack (show expectedBytes) <> " bytes, got " <> T.pack (show actualBytes))

data ShaderStage
  = ShaderFragment
  | ShaderVertex
  | ShaderCompute
  deriving (Eq, Ord, Show)

data ShaderBindings = ShaderBindings
  { shaderUniformSlots :: Map.Map String Word32
  , shaderSamplerSlots :: Map.Map String Word32
  , shaderStorageTextureSlots :: Map.Map String Word32
  }
  deriving (Eq, Show)

instance Semigroup ShaderBindings where
  ShaderBindings u s st <> ShaderBindings u' s' st' =
    ShaderBindings (Map.union u' u) (Map.union s' s) (Map.union st' st)

instance Monoid ShaderBindings where
  mempty = emptyShaderBindings

emptyShaderBindings :: ShaderBindings
emptyShaderBindings = ShaderBindings Map.empty Map.empty Map.empty

reflectedBindingsTable :: ReflectedShaderLayout -> ShaderBindings
reflectedBindingsTable layout =
  foldl' insertBinding emptyShaderBindings (Map.elems layout.reflectedShaderBindings)
  where
    insertBinding table binding =
      let name = T.unpack binding.reflectedName
          slot = binding.reflectedSlot
      in case binding.reflectedType of
          ReflectedUniform {} ->
            table { shaderUniformSlots = Map.insert name slot table.shaderUniformSlots }
          ReflectedSampledTexture ->
            table { shaderSamplerSlots = Map.insert name slot table.shaderSamplerSlots }
          ReflectedStorageTexture {} ->
            table { shaderStorageTextureSlots = Map.insert name slot table.shaderStorageTextureSlots }
          ReflectedSampler -> table
          ReflectedStorageBuffer -> table

data NamedUniform where
  NamedUniform :: Storable a => String -> a -> NamedUniform
  NamedUniformBytes :: String -> ByteString -> NamedUniform
  NamedSampler :: String -> Texture -> NamedUniform
  NamedSamplerWith :: String -> Texture -> Sampler -> NamedUniform
  NamedStorageTexture :: String -> Texture -> NamedUniform

data UniformBinding = UniformBinding !Word32 !ByteString

data DrawBindings = DrawBindings
  { dbVertexUniforms :: [UniformBinding]
  , dbFragmentUniforms :: [UniformBinding]
  , dbSamplers :: [SamplerBindingSpec]
  , dbStorageTextures :: [StorageBinding]
  }

data ComputeBindings = ComputeBindings
  { cbUniforms :: [UniformBinding]
  , cbSamplers :: [SamplerBindingSpec]
  , cbReadOnlyTextures :: [Texture]
  , cbReadWriteTextures :: [Texture]
  }

newtype Sampler = Sampler GPUSampler
  deriving (Eq, Show)

data SamplerFilter
  = SamplerNearest
  | SamplerLinear
  deriving (Eq, Show)

data SamplerMipmap
  = SamplerMipmapNearest
  | SamplerMipmapLinear
  deriving (Eq, Show)

data SamplerAddress
  = SamplerRepeat
  | SamplerMirroredRepeat
  | SamplerClampToEdge
  deriving (Eq, Show)

data SamplerCompare
  = SamplerCompareInvalid
  | SamplerCompareNever
  | SamplerCompareLess
  | SamplerCompareEqual
  | SamplerCompareLessOrEqual
  | SamplerCompareGreater
  | SamplerCompareNotEqual
  | SamplerCompareGreaterOrEqual
  | SamplerCompareAlways
  deriving (Eq, Show)

data SamplerDesc = SamplerDesc
  { samplerMinFilter :: SamplerFilter
  , samplerMagFilter :: SamplerFilter
  , samplerMipmapMode :: SamplerMipmap
  , samplerAddressU :: SamplerAddress
  , samplerAddressV :: SamplerAddress
  , samplerAddressW :: SamplerAddress
  , samplerMipLodBias :: Float
  , samplerMaxAnisotropy :: Float
  , samplerCompareOp :: SamplerCompare
  , samplerMinLod :: Float
  , samplerMaxLod :: Float
  , samplerEnableAnisotropy :: Bool
  , samplerEnableCompare :: Bool
  }
  deriving (Eq, Show)

data SamplerBindingSpec = SamplerBindingSpec !Word32 !Texture !(Maybe Sampler)

data StorageBinding = StorageBinding !Word32 !Texture

newtype RenderTarget = RenderTarget Texture

data DepthTarget = DepthTarget
  { depthTexture :: Texture
  , depthSize :: (Int, Int)
  , depthFormat :: SDL_GPUTextureFormat
  }

data TargetRef
  = WindowTarget
  | Target RenderTarget

data Op
  = OpClear Color
  | OpDraw DrawItem
  | OpBlit RenderTarget (Maybe FRect) FRect
  | OpShader Shader [ShaderUniform] [Op]

data Pass = Pass TargetRef [Op]

newtype RenderPlan = RenderPlan [Pass]

instance Semigroup RenderPlan where
  RenderPlan a <> RenderPlan b = RenderPlan (a <> b)

instance Monoid RenderPlan where
  mempty = RenderPlan []

newtype PassM a = PassM (Writer (DList Op) a)
  deriving (Functor, Applicative)

newtype PlanM a = PlanM (Writer (DList Pass) a)
  deriving (Functor, Applicative)

instance Semigroup a => Semigroup (PassM a) where
  PassM a <> PassM b = PassM (liftA2 (<>) a b)

instance Monoid a => Monoid (PassM a) where
  mempty = pure mempty

instance Semigroup a => Semigroup (PlanM a) where
  PlanM a <> PlanM b = PlanM (liftA2 (<>) a b)

instance Monoid a => Monoid (PlanM a) where
  mempty = pure mempty

instance Draw As2D Line where
  draw ctx (Line color p1 p2) =
    withAs2D ctx (drawLine color p1 p2)

instance Draw As2D RectOutline where
  draw ctx (RectOutline color rectShape) =
    withAs2D ctx (drawRect color rectShape)

instance Draw As2D RectFill where
  draw ctx (RectFill color rectShape) =
    withAs2D ctx (fillRect color rectShape)

instance Draw As2D Sprite where
  draw ctx (Sprite texture src dst effect) =
    withAs2DOverrides ctx Nothing effect (drawTexture texture src dst)

instance Draw As2D Label where
  draw ctx (Label textObj x y style) =
    withAs2DStyle ctx style (drawTextRaw textObj x y style.textColor)

instance Draw As2D TextDraw where
  draw ctx (TextDraw font str x y style) =
    withAs2DStyle ctx style (drawTextCachedWith font str x y style.textColor)

drawItem :: DrawItem -> WindowM ()
drawItem (DrawItem ctx item) = draw ctx item

instance Draw ctx a => Draw ctx [a] where
  draw ctx = mapM_ (draw ctx)

withAs2D :: As2D -> WindowM a -> WindowM a
withAs2D ctx =
  withAs2DOverrides ctx Nothing Nothing

withAs2DStyle :: As2D -> TextStyle -> WindowM a -> WindowM a
withAs2DStyle ctx style =
  withAs2DOverrides ctx style.textBlend style.textShader

withAs2DOverrides :: As2D -> Maybe BlendMode -> Maybe SpriteEffect -> WindowM a -> WindowM a
withAs2DOverrides ctx blendOverride effectOverride action =
  let blend = fromMaybe ctx.draw2DBlend blendOverride
      effect =
        case effectOverride of
          Just override -> Just override
          Nothing -> ctx.draw2DEffect
  in with2DContext blend ctx.draw2DCamera effect action

with2DContext :: BlendMode -> Maybe Camera2D -> Maybe SpriteEffect -> WindowM a -> WindowM a
with2DContext blend camera effect action =
  case effect of
    Nothing -> do
      window <- ask
      merged <- liftIO (mergeUniformBindings window window.appDefaultShader [])
      let shaderContext = ShaderContext window.appDefaultShader merged [] [] blend camera
      liftIO (withShaderContext window shaderContext (runWindowM window action))
    Just (SpriteEffect shader uniforms) -> do
      collected <- liftIO (collectShaderBindings uniforms)
      withShaderBindingsInternalBlend blend (unwrapShader2D shader) collected camera action


runWindowIO :: Config -> (Window -> IO a) -> IO a
runWindowIO cfg action = do
  either throwIO pure (validateConfig cfg)
  withInitializedSubsystems $ do
    let title = cfg.windowTitle
    let width = cfg.windowWidth
    let height = cfg.windowHeight
    window <- require "SDL_CreateWindow" (sdlCreateWindow title width height 0)
    bracket (pure window) sdlDestroyWindow $ \win -> do
      void $ sdlSetWindowResizable win (cfg.windowResizable)
      okShow <- sdlShowWindow win
      unless okShow (die "SDL_ShowWindow")
      bracket_ (void (SDL.sdlStartTextInput win)) (void (SDL.sdlStopTextInput win)) $ do
        sdlPumpEvents
        gpu <- require "SDL_CreateGPUDevice" (sdlCreateGPUDevice sdlGPUShaderFormatSpirv False)
        bracket (pure gpu) sdlDestroyGPUDevice $ \dev -> do
          okClaim <- sdlClaimWindowForGPUDevice dev win
          unless okClaim (die "SDL_ClaimWindowForGPUDevice")
          let releaseWindow = sdlReleaseWindowFromGPUDevice dev win
          bracket_ (pure ()) releaseWindow $ do
            swapFmt <- sdlGetGPUSwapchainTextureFormat dev win
            depthFormat <- chooseDepthFormat dev
            sampler <- require "SDL_CreateGPUSampler" (sdlCreateGPUSampler dev defaultSamplerCreateInfo)
            let defaultSampler = Sampler sampler
            bracket (pure sampler) (sdlReleaseGPUSampler dev) $ \_ -> do
              textEngine <- case cfg.textAtlasSize of
                Nothing ->
                  require "TTF_CreateGPUTextEngine" (ttfCreateGPUTextEngine dev)
                Just size ->
                  bracket sdlCreateProperties sdlDestroyProperties $ \props -> do
                    when (props == 0) (die "SDL_CreateProperties")
                    let GPUDevice devPtr = dev
                    let propDevice = "SDL_ttf.gpu_text_engine.create.device"
                    let propAtlas = "SDL_ttf.gpu_text_engine.create.atlas_texture_size"
                    okDev <- sdlSetPointerProperty props propDevice (castPtr devPtr)
                    unless okDev (die "SDL_SetPointerProperty (TTF device)")
                    okSize <- sdlSetNumberProperty props propAtlas (fromIntegral size)
                    unless okSize (die "SDL_SetNumberProperty (TTF atlas size)")
                    require "TTF_CreateGPUTextEngineWithProperties" (ttfCreateGPUTextEngineWithProperties props)
              bracket (pure textEngine) ttfDestroyGPUTextEngine $ \engine -> do
                mixer <- require "MIX_CreateMixerDevice" (mixCreateMixerDevice sdlAudioDeviceDefaultPlayback)
                bracket (pure mixer) mixDestroyMixer $ \mix -> do
                  vertexShader <- require "SDL_CreateGPUShader (vertex)" (createRawShader dev defaultVertexSpirv sdlGPUShaderStageVertex 0 0 0 0)
                  bracket (pure vertexShader) (sdlReleaseGPUShader dev) $ \vertShader -> do
                    vertexShader3D <- require "SDL_CreateGPUShader (vertex3d)" (createRawShader dev defaultVertex3DSpirv sdlGPUShaderStageVertex 0 0 0 1)
                    bracket (pure vertexShader3D) (sdlReleaseGPUShader dev) $ \vertShader3D -> do
                      defaultShader <- createShaderFromSpirvWithDevice dev defaultFragmentSpirv 1 0 0 0
                      bracket (pure defaultShader) destroyShaderIO $ \defShader -> do
                        whiteTex <- createSolidTexture dev sdlGPUTextureFormatRGBA8 1 1 255 255 255 255
                        bracket (pure whiteTex) destroyTextureIO $ \whiteTexture -> do
                          musicTrackRef <- newIORef Nothing
                          blendPools <- newIORef []
                          mainAssetQueue <- newTQueueIO
                          targets <- newIORef Map.empty
                          pipelineTargets <- newIORef IntMap.empty
                          depthTarget <- newIORef Nothing
                          depthTargets <- newIORef Map.empty
                          renderState <- newIORef (RenderState Map.empty 0)
                          hotReload <- newIORef (HotReloadConfig True 0.5 0)
                          frameCommands <- newIORef []
                          frameShaders <- newIORef []
                          recording <- newIORef Nothing
                          winSize <- sdlGetWindowSize win
                          drawableSize <- sdlGetWindowSizeInPixels win
                          windowSize <- newIORef winSize
                          drawableSizeRef <- newIORef drawableSize
                          globalsUniform <- newIORef Nothing
                          ownedResources <- newIORef emptyOwnedResources
                          assetsWithoutWorkers <- newAssetManager
                          pipelines <- newIORef Map.empty
                          drawColor <- newIORef (rgba 1 1 1 1)
                          let frameContext = RecordingContext frameCommands frameShaders
                          let windowBase = Window
                                { appWindow = win
                                , appGPUDevice = dev
                                , appSwapchainFormat = swapFmt
                                , appDefaultSampler = defaultSampler
                                , appTextEngine = engine
                                , appMixer = mix
                                , appMusicTrack = musicTrackRef
                                , appBlendPools = blendPools
                                , appAssets = assetsWithoutWorkers
                                , appMainAssetQueue = mainAssetQueue
                                , appTargets = targets
                                , appPipelineTargets = pipelineTargets
                                , appDepthFormat = depthFormat
                                , appDepthTarget = depthTarget
                                , appDepthTargets = depthTargets
                                , appRenderState = renderState
                                , appHotReload = hotReload
                                , appFrameContext = frameContext
                                , appRecording = recording
                                , appWindowSize = windowSize
                                , appDrawableSize = drawableSizeRef
                                , appWhiteTexture = whiteTexture
                                , appVertexShader = vertShader
                                , appVertexShader3D = vertShader3D
                                , appDefaultShader = defShader
                                , appPipelines = pipelines
                                , appDrawColor = drawColor
                                , appDebugLog = cfg.debugLog
                                , appGlobalsUniform = globalsUniform
                                , appOwnedResources = ownedResources
                                }
                          workerCount <-
                            if cfg.assetWorkers <= 0
                              then max 1 <$> getNumCapabilities
                              else pure cfg.assetWorkers
                          bracket (startAssetWorkers windowBase workerCount assetsWithoutWorkers) (shutdownAssetManager windowBase) $ \assets -> do
                            let windowHandle = windowBase { appAssets = assets }
                            action windowHandle `finally`
                              (cleanupOwnedResources windowHandle `finally`
                                (cleanupPipelines windowHandle `finally`
                                  (cleanupRenderTargets windowHandle `finally`
                                    cleanupDepthTargets windowHandle)))
  where
    withInitializedSubsystems body =
      bracket_ (initializeSubsystem "SDL_Init" (sdlInit (sdlInitVideo .|. sdlInitAudio))) sdlQuit $
        bracket_ (initializeSubsystem "MIX_Init" mixInit) mixQuit $
          bracket_ (initializeSubsystem "TTF_Init" ttfInit) ttfQuit body
    initializeSubsystem label initialize = do
      initialized <- initialize
      unless initialized (die label)
    die label = do
      err <- sdlGetError
      throwIO (SlopSDLFailure (T.pack label) (T.pack err))

validateConfig :: Config -> SlopResult ()
validateConfig cfg = do
  positiveCInt "windowWidth" cfg.windowWidth
  positiveCInt "windowHeight" cfg.windowHeight
  case cfg.textAtlasSize of
    Just size -> positiveCInt "textAtlasSize" size
    Nothing -> pure ()
  when (cfg.assetWorkers < 0) $
    Left (invalid "assetWorkers" "expected zero or a positive worker count" cfg.assetWorkers)
  where
    positiveCInt field value
      | value <= 0 = Left (invalid field "expected a positive value" value)
      | toInteger value > toInteger (maxBound :: CInt) =
          Left (invalid field ("maximum is " <> showText (maxBound :: CInt)) value)
      | otherwise = Right ()
    invalid field expectation value =
      SlopIOFailure "validate config" field (expectation <> ", got " <> showText value)


require :: String -> IO (Maybe a) -> IO a
require label action = do
  result <- action
  case result of
    Just value -> pure value
    Nothing -> do
      err <- sdlGetError
      throwIO (SlopSDLFailure (T.pack label) (T.pack err))

readInputState :: IO InputState
readInputState = do
  (keysPtr, keyCount) <- sdlGetKeyboardState
  keys <- readKeySet keysPtr keyCount
  (buttons, pos) <- readMouseState
  pure InputState
    { inputKeysDown = keys
    , inputMouseButtonsDown = buttons
    , inputMousePos = pos
    }

renderTargetKey :: Texture -> Ptr ()
renderTargetKey texture =
  case texture.textureHandle of
    GPUTexture ptr -> castPtr ptr

registerRenderTarget :: Window -> Texture -> IO ()
registerRenderTarget window tex =
  atomicModifyIORef' (window.appTargets) $ \targets ->
    (Map.insert (renderTargetKey tex) tex targets, ())

unregisterRenderTarget :: Window -> Texture -> IO Bool
unregisterRenderTarget window tex =
  atomicModifyIORef' (window.appTargets) $ \targets ->
    let key = renderTargetKey tex
    in if Map.member key targets
         then (Map.delete key targets, True)
         else (targets, False)

cleanupDepthTargets :: Window -> IO ()
cleanupDepthTargets window = do
  swapchainTarget <- atomicModifyIORef' window.appDepthTarget $ \target ->
    (Nothing, target)
  targets <- atomicModifyIORef' (window.appDepthTargets) $ \targets ->
    (Map.empty, Map.elems targets)
  case swapchainTarget of
    Nothing -> pure ()
    Just target -> destroyTextureIO target.depthTexture
  mapM_ (\target -> destroyTextureIO target.depthTexture) targets

ensureSwapchainDepthTarget :: Window -> (Int, Int) -> IO DepthTarget
ensureSwapchainDepthTarget window size = mask_ $ do
  current <- readIORef window.appDepthTarget
  case current of
    Just target | target.depthSize == size -> pure target
    Just target -> do
      newTarget <- createDepthTargetIO window (fst size) (snd size)
      writeIORef window.appDepthTarget (Just newTarget)
      destroyTextureIO target.depthTexture
      pure newTarget
    Nothing -> do
      newTarget <- createDepthTargetIO window (fst size) (snd size)
      writeIORef window.appDepthTarget (Just newTarget)
      pure newTarget

ensureRenderTargetDepth :: Window -> Texture -> (Int, Int) -> IO DepthTarget
ensureRenderTargetDepth window colorTex size = mask_ $ do
  targets <- readIORef window.appDepthTargets
  let key = renderTargetKey colorTex
  case Map.lookup key targets of
    Just target | target.depthSize == size -> pure target
    current -> do
      newTarget <- createDepthTargetIO window (fst size) (snd size)
      atomicModifyIORef' window.appDepthTargets $ \m ->
        (Map.insert key newTarget m, ())
      case current of
        Nothing -> pure ()
        Just target -> destroyTextureIO target.depthTexture
      pure newTarget

cleanupRenderTargets :: Window -> IO ()
cleanupRenderTargets window = do
  targets <- atomicModifyIORef' (window.appTargets) $ \targets ->
    (Map.empty, Map.elems targets)
  mapM_ destroyTextureIO targets

cleanupPipelines :: Window -> IO ()
cleanupPipelines window = do
  pipelines <- atomicModifyIORef' (window.appPipelines) $ \cache ->
    (Map.empty, Map.elems cache)
  mapM_ (sdlReleaseGPUGraphicsPipeline window.appGPUDevice) pipelines

readKeySet :: Ptr Word8 -> Int -> IO IntSet
readKeySet ptr count = go 0 IntSet.empty
  where
    go idx acc
      | idx >= count = pure acc
      | otherwise = do
          value <- peekByteOff ptr idx :: IO Word8
          if value == 0
            then go (idx + 1) acc
            else do
              keycode <- sdlGetKeyFromScancode idx 0 False
              let acc' = IntSet.insert (fromIntegral keycode) acc
              go (idx + 1) acc'

readMouseState :: IO (Word32, V2 Float)
readMouseState =
  alloca $ \xPtr ->
    alloca $ \yPtr -> do
      buttons <- sdlGetMouseState xPtr yPtr
      x <- peek xPtr
      y <- peek yPtr
      pure (buttons, V2 (realToFrac x) (realToFrac y))

clearIO :: Window -> Color -> IO ()
clearIO window color = recordClear window color

presentIO :: Window -> IO ()
presentIO = flushFrame

setDrawColorIO :: Window -> Color -> IO ()
setDrawColorIO window color =
  writeIORef window.appDrawColor color

drawLineIO :: Window -> Color -> FPoint -> FPoint -> IO ()
drawLineIO window color p1 p2 =
  recordDraw window (ShapeLine color p1 p2)

drawRectIO :: Window -> Color -> FRect -> IO ()
drawRectIO window color rectShape =
  recordDraw window (ShapeRectOutline color rectShape)

fillRectIO :: Window -> Color -> FRect -> IO ()
fillRectIO window color rectShape =
  recordDraw window (ShapeRectFill color rectShape)

drawTextureIO :: Window -> Texture -> Maybe FRect -> FRect -> IO ()
drawTextureIO window texture src dst =
  recordDraw window (ShapeSprite texture src dst)


loadTextureIO :: Window -> FilePath -> IO Texture
loadTextureIO window path =
  bracket
    (require "IMG_Load" (imgLoadSurface path))
    sdlDestroySurface
    (loadTextureFromSurface window)

destroyTextureIO :: Texture -> IO ()
destroyTextureIO texture =
  sdlReleaseGPUTexture texture.textureDevice texture.textureHandle

loadTextureFromSurface :: Window -> Surface -> IO Texture
loadTextureFromSurface window surface = do
  surfaceInfo <- peekSurfaceInfo surface
  gpuFormat <- sdlGetGPUTextureFormatFromPixelFormat surfaceInfo.surfaceInfoFormat
  if gpuFormat == 0
    then
      if surfaceInfo.surfaceInfoFormat == sdlPixelFormatRGBA8888
        then uploadSurface window surface sdlGPUTextureFormatRGBA8
        else
          bracket
            (require "SDL_ConvertSurface" (sdlConvertSurface surface sdlPixelFormatRGBA8888))
            sdlDestroySurface
            (loadTextureFromSurface window)
    else do
      uploadSurface window surface gpuFormat

uploadSurface :: Window -> Surface -> SDL_GPUTextureFormat -> IO Texture
uploadSurface window surface gpuFormat = do
  surfaceInfo <- peekSurfaceInfo surface
  let width = fromIntegral surfaceInfo.surfaceInfoWidth
  let height = fromIntegral surfaceInfo.surfaceInfoHeight
  let texUsage = sdlGPUTextureUsageSampler
  tex <- createTexture window.appGPUDevice gpuFormat texUsage width height
  flip onException (destroyTextureIO tex) $
    bracket_ lockSurface (sdlUnlockSurface surface) $ do
      surfaceInfo' <- peekSurfaceInfo surface
      let pitch = fromIntegral surfaceInfo'.surfaceInfoPitch
      let byteSize = pitch * height
      transfer <- require "SDL_CreateGPUTransferBuffer"
        (sdlCreateGPUTransferBuffer window.appGPUDevice
          GPUTransferBufferCreateInfo
            { gpuTransferUsage = sdlGPUTransferBufferUsageUpload
            , gpuTransferSize = fromIntegral byteSize
            , gpuTransferProps = 0
            })
      flip finally (sdlReleaseGPUTransferBuffer window.appGPUDevice transfer) $ do
        ptr <- require "SDL_MapGPUTransferBuffer" (sdlMapGPUTransferBuffer window.appGPUDevice transfer False)
        copyBytes ptr surfaceInfo'.surfaceInfoPixels byteSize
        sdlUnmapGPUTransferBuffer window.appGPUDevice transfer
        cmd <- require "SDL_AcquireGPUCommandBuffer" (sdlAcquireGPUCommandBuffer window.appGPUDevice)
        copyPass <- require "SDL_BeginGPUCopyPass" (sdlBeginGPUCopyPass cmd)
        let bpp = max 1 (pitch `div` max 1 width)
        let transferInfo = GPUTextureTransferInfo
              { gpuTransferBuffer = transfer
              , gpuTransferOffset = 0
              , gpuTransferPixelsPerRow = fromIntegral (pitch `div` bpp)
              , gpuTransferRowsPerLayer = fromIntegral height
              }
        let region = GPUTextureRegion
              { gpuTextureRegionTexture = tex.textureHandle
              , gpuTextureRegionMipLevel = 0
              , gpuTextureRegionLayer = 0
              , gpuTextureRegionX = 0
              , gpuTextureRegionY = 0
              , gpuTextureRegionZ = 0
              , gpuTextureRegionW = fromIntegral width
              , gpuTextureRegionH = fromIntegral height
              , gpuTextureRegionD = 1
              }
        sdlUploadToGPUTexture copyPass transferInfo region False
        sdlEndGPUCopyPass copyPass
        okSubmit <- sdlSubmitGPUCommandBuffer cmd
        unless okSubmit $ do
          err <- sdlGetError
          throwIO (SlopSDLFailure "SDL_SubmitGPUCommandBuffer" (T.pack err))
        pure tex
  where
    lockSurface = do
      ok <- sdlLockSurface surface
      unless ok $ do
        err <- sdlGetError
        throwIO (SlopSDLFailure "SDL_LockSurface" (T.pack err))

createSolidTexture :: GPUDevice -> SDL_GPUTextureFormat -> Int -> Int -> Word8 -> Word8 -> Word8 -> Word8 -> IO Texture
createSolidTexture device fmt width height r g b a = do
  let texUsage = sdlGPUTextureUsageSampler
  tex <- createTexture device fmt texUsage width height
  flip onException (destroyTextureIO tex) $ do
    let byteSize = width * height * 4
    transfer <- require "SDL_CreateGPUTransferBuffer"
      (sdlCreateGPUTransferBuffer device
        GPUTransferBufferCreateInfo
          { gpuTransferUsage = sdlGPUTransferBufferUsageUpload
          , gpuTransferSize = fromIntegral byteSize
          , gpuTransferProps = 0
          })
    flip finally (sdlReleaseGPUTransferBuffer device transfer) $ do
      ptr <- require "SDL_MapGPUTransferBuffer" (sdlMapGPUTransferBuffer device transfer False)
      let fill = [r, g, b, a]
      let bytes = BS.pack (concat (replicate (width * height) fill))
      BS.useAsCStringLen bytes $ \(src, _) ->
        copyBytes ptr (castPtr src) byteSize
      sdlUnmapGPUTransferBuffer device transfer
      cmd <- require "SDL_AcquireGPUCommandBuffer" (sdlAcquireGPUCommandBuffer device)
      copyPass <- require "SDL_BeginGPUCopyPass" (sdlBeginGPUCopyPass cmd)
      let transferInfo = GPUTextureTransferInfo
            { gpuTransferBuffer = transfer
            , gpuTransferOffset = 0
            , gpuTransferPixelsPerRow = fromIntegral width
            , gpuTransferRowsPerLayer = fromIntegral height
            }
      let region = GPUTextureRegion
            { gpuTextureRegionTexture = tex.textureHandle
            , gpuTextureRegionMipLevel = 0
            , gpuTextureRegionLayer = 0
            , gpuTextureRegionX = 0
            , gpuTextureRegionY = 0
            , gpuTextureRegionZ = 0
            , gpuTextureRegionW = fromIntegral width
            , gpuTextureRegionH = fromIntegral height
            , gpuTextureRegionD = 1
            }
      sdlUploadToGPUTexture copyPass transferInfo region False
      sdlEndGPUCopyPass copyPass
      okSubmit <- sdlSubmitGPUCommandBuffer cmd
      unless okSubmit $ do
        err <- sdlGetError
        throwIO (SlopSDLFailure "SDL_SubmitGPUCommandBuffer" (T.pack err))
      pure tex

createNoiseTexture2D :: Int -> Int -> NoiseSettings -> WindowM Texture
createNoiseTexture2D width height settings = do
  window <- ask
  texture <- liftIO (createNoiseTexture2DIO window width height settings)
  liftIO (registerOwnedResource window (textureResourceKey texture) (destroyTextureIO texture))
  pure texture

createNoiseTexture2DSize :: Size2D -> NoiseSettings -> WindowM Texture
createNoiseTexture2DSize size settings =
  let (width, height) = size2DToTuple size
  in createNoiseTexture2D width height settings

ceilDiv :: Int -> Int -> Word32
ceilDiv numerator denom =
  let d = max 1 denom
  in fromIntegral ((numerator + d - 1) `div` d)

createNoiseTexture2DIO :: Window -> Int -> Int -> NoiseSettings -> IO Texture
createNoiseTexture2DIO window width height settings = do
  let texUsage = sdlGPUTextureUsageSampler .|. sdlGPUTextureUsageComputeStorageSimultaneousReadWrite
  tex <- createTexture window.appGPUDevice sdlGPUTextureFormatRGBA8 texUsage width height
  let (threadsX, threadsY) = threads2DToInts settings.noiseComputeThreads2D
  let shaderCode = fromMaybe noise2DComputeSpirv settings.noiseComputeShader2D
  let desc =
        defaultCompute
          { computeShaderCode = shaderCode
          , computeReadwriteStorageTextures = 1
          , computeUniformBuffers = 1
          , computeThreads = threads3D threadsX threadsY 1
          }
  flip onException (destroyTextureIO tex) $ do
    pipeline <- createComputePipelineIO window desc
    let releasePipeline = sdlReleaseGPUComputePipeline pipeline.computeDevice pipeline.computeHandle
    flip finally releasePipeline $ do
      let params = noiseParams2D width height settings
      let groupsX = ceilDiv width threadsX
      let groupsY = ceilDiv height threadsY
      dispatchComputeIO window pipeline
        [ computeUniform 0 params
        , computeStorageTextureRW 0 tex
        ]
        (groupsX, groupsY, 1)
      pure tex

createNoiseTexture3D :: Int -> Int -> Int -> NoiseSettings -> WindowM Texture
createNoiseTexture3D width height depth settings = do
  window <- ask
  texture <- liftIO (createNoiseTexture3DIO window width height depth settings)
  liftIO (registerOwnedResource window (textureResourceKey texture) (destroyTextureIO texture))
  pure texture

createNoiseTexture3DSize :: Size3D -> NoiseSettings -> WindowM Texture
createNoiseTexture3DSize size settings =
  let (width, height, depth) = size3DToTuple size
  in createNoiseTexture3D width height depth settings

createNoiseTexture3DIO :: Window -> Int -> Int -> Int -> NoiseSettings -> IO Texture
createNoiseTexture3DIO window width height depth settings = do
  let texUsage = sdlGPUTextureUsageSampler .|. sdlGPUTextureUsageComputeStorageSimultaneousReadWrite
  tex <- createTexture3D window.appGPUDevice sdlGPUTextureFormatRGBA8 texUsage width height depth
  let (threadsX, threadsY, threadsZ) = threads3DToInts settings.noiseComputeThreads3D
  let shaderCode = fromMaybe noise3DComputeSpirv settings.noiseComputeShader3D
  let desc =
        defaultCompute
          { computeShaderCode = shaderCode
          , computeReadwriteStorageTextures = 1
          , computeUniformBuffers = 1
          , computeThreads = threads3D threadsX threadsY threadsZ
          }
  flip onException (destroyTextureIO tex) $ do
    pipeline <- createComputePipelineIO window desc
    let releasePipeline = sdlReleaseGPUComputePipeline pipeline.computeDevice pipeline.computeHandle
    flip finally releasePipeline $ do
      let params = noiseParams3D width height depth settings
      let groupsX = ceilDiv width threadsX
      let groupsY = ceilDiv height threadsY
      let groupsZ = ceilDiv depth threadsZ
      dispatchComputeIO window pipeline
        [ computeUniform 0 params
        , computeStorageTextureRW 0 tex
        ]
        (groupsX, groupsY, groupsZ)
      pure tex

createTexture3D :: GPUDevice -> SDL_GPUTextureFormat -> SDL_GPUTextureUsageFlags -> Int -> Int -> Int -> IO Texture
createTexture3D device fmt usage width height depth = do
  gpuWidth <- textureDimension "create 3D texture" "width" width
  gpuHeight <- textureDimension "create 3D texture" "height" height
  gpuDepth <- textureDimension "create 3D texture" "depth" depth
  gpuTex <- require "SDL_CreateGPUTexture"
    (sdlCreateGPUTexture device
      GPUTextureCreateInfo
        { gpuTextureType = sdlGPUTextureType3D
        , gpuTextureFormat = fmt
        , gpuTextureUsage = usage
        , gpuTextureWidth = gpuWidth
        , gpuTextureHeight = gpuHeight
        , gpuTextureLayerCountOrDepth = gpuDepth
        , gpuTextureNumLevels = 1
        , gpuTextureSampleCount = sdlGPUSampleCount1
        , gpuTextureProps = 0
        })
  pure Texture
    { textureHandle = gpuTex
    , textureDevice = device
    , textureWidth = width
    , textureHeight = height
    , textureDepth = depth
    }

createTexture :: GPUDevice -> SDL_GPUTextureFormat -> SDL_GPUTextureUsageFlags -> Int -> Int -> IO Texture
createTexture device fmt usage width height = do
  gpuWidth <- textureDimension "create 2D texture" "width" width
  gpuHeight <- textureDimension "create 2D texture" "height" height
  gpuTex <- require "SDL_CreateGPUTexture"
    (sdlCreateGPUTexture device
      GPUTextureCreateInfo
        { gpuTextureType = sdlGPUTextureType2D
        , gpuTextureFormat = fmt
        , gpuTextureUsage = usage
        , gpuTextureWidth = gpuWidth
        , gpuTextureHeight = gpuHeight
        , gpuTextureLayerCountOrDepth = 1
        , gpuTextureNumLevels = 1
        , gpuTextureSampleCount = sdlGPUSampleCount1
        , gpuTextureProps = 0
        })
  pure Texture
    { textureHandle = gpuTex
    , textureDevice = device
    , textureWidth = width
    , textureHeight = height
    , textureDepth = 1
    }

textureDimension :: T.Text -> T.Text -> Int -> IO Word32
textureDimension operation dimension value
  | value <= 0 = throwIO (invalid "expected a positive value")
  | toInteger value > toInteger (maxBound :: Word32) =
      throwIO (invalid ("maximum is " <> showText (maxBound :: Word32)))
  | otherwise = pure (fromIntegral value)
  where
    invalid expectation =
      SlopIOFailure operation dimension (expectation <> ", got " <> showText value)

createRenderTargetTexture :: Window -> Int -> Int -> IO Texture
createRenderTargetTexture window width height =
  createTexture
    window.appGPUDevice
    window.appSwapchainFormat
    (sdlGPUTextureUsageSampler .|. sdlGPUTextureUsageColorTarget)
    width
    height

chooseDepthFormat :: GPUDevice -> IO SDL_GPUTextureFormat
chooseDepthFormat device = do
  let candidates =
        [ sdlGPUTextureFormatD24UNORMS8UINT
        , sdlGPUTextureFormatD32FloatS8UINT
        , sdlGPUTextureFormatD24UNORM
        , sdlGPUTextureFormatD32Float
        , sdlGPUTextureFormatD16UNORM
        ]
  let tryFormat fmt = do
        let info =
              GPUTextureCreateInfo
                { gpuTextureType = sdlGPUTextureType2D
                , gpuTextureFormat = fmt
                , gpuTextureUsage = sdlGPUTextureUsageDepthStencilTarget
                , gpuTextureWidth = 1
                , gpuTextureHeight = 1
                , gpuTextureLayerCountOrDepth = 1
                , gpuTextureNumLevels = 1
                , gpuTextureSampleCount = sdlGPUSampleCount1
                , gpuTextureProps = 0
                }
        mTex <- sdlCreateGPUTexture device info
        case mTex of
          Nothing -> pure Nothing
          Just tex -> do
            sdlReleaseGPUTexture device tex
            pure (Just fmt)
  let go [] = throwIO (SlopSDLFailure "choose depth format" "no supported depth format found")
      go (fmt:rest) = do
        ok <- tryFormat fmt
        maybe (go rest) pure ok
  go candidates

createDepthTargetIO :: Window -> Int -> Int -> IO DepthTarget
createDepthTargetIO window width height = do
  let fmt = window.appDepthFormat
  let usage = sdlGPUTextureUsageDepthStencilTarget
  tex <- createTexture window.appGPUDevice fmt usage width height
  pure DepthTarget
    { depthTexture = tex
    , depthSize = (width, height)
    , depthFormat = fmt
    }

peekSurfaceInfo :: Surface -> IO SurfaceInfo
peekSurfaceInfo (Surface ptr) =
  peek (castPtr ptr :: Ptr SurfaceInfo)

loadFontIO :: FilePath -> Float -> IO Font
loadFontIO path size = require "TTF_OpenFont" (ttfOpenFont path size)

closeFontIO :: Font -> IO ()
closeFontIO = ttfCloseFont

setFontSDF :: Font -> Bool -> IO ()
setFontSDF font enabled = do
  ok <- ttfSetFontSDF font enabled
  unless ok $ do
    err <- sdlGetError
    throwIO (SlopSDLFailure "TTF_SetFontSDF" (T.pack err))

loadFontSDFIO :: FilePath -> Float -> IO Font
loadFontSDFIO path size = do
  font <- loadFontIO path size
  setFontSDF font True `onException` closeFontIO font
  pure font

createTextIO :: Window -> Font -> T.Text -> IO Text
createTextIO window font str =
  require "TTF_CreateText" (ttfCreateText (window.appTextEngine) font (T.unpack str))

destroyTextIO :: Text -> IO ()
destroyTextIO = ttfDestroyText

drawTextIO :: Window -> Text -> Float -> Float -> Color -> IO ()
drawTextIO window textObj x y color =
  recordDraw window (ShapeText textObj x y color)

setFrameId :: Window -> Word64 -> IO ()
setFrameId window frameId =
  atomicModifyIORef' (window.appRenderState) $ \st ->
    (st { rsFrameId = frameId }, ())

pruneTextCache :: Window -> IO ()
pruneTextCache window = do
  stale <- atomicModifyIORef' (window.appRenderState) $ \st ->
    let (keep, dropMap) = Map.partition (\ct -> ct.ctLastUsed == st.rsFrameId) (st.rsTextCache)
        st' = st { rsTextCache = keep }
    in (st', map (\ct -> ct.ctText) (Map.elems dropMap))
  mapM_ ttfDestroyText stale

currentRecordingContext :: Window -> IO RecordingContext
currentRecordingContext window = do
  active <- readIORef window.appRecording
  pure (maybe window.appFrameContext (\(Recording ctx) -> ctx) active)

withShaderContext :: Window -> ShaderContext -> IO a -> IO a
withShaderContext window ctx action = do
  recCtx <- currentRecordingContext window
  bracket_
    (modifyIORef' recCtx.rcShaderStack (ctx :))
    (modifyIORef' recCtx.rcShaderStack (\stack -> case stack of
      [] -> []
      (_:rest) -> rest))
    action

recordClear :: Window -> Color -> IO ()
recordClear window color = do
  recCtx <- currentRecordingContext window
  modifyIORef' recCtx.rcCommands (RecordedClear color :)

recordDraw :: Window -> DrawShape -> IO ()
recordDraw window shape = do
  recCtx <- currentRecordingContext window
  shaderStack <- readIORef recCtx.rcShaderStack
  let ctx = case shaderStack of
        [] -> Nothing
        (top:_) -> Just top
  modifyIORef' recCtx.rcCommands (RecordedDraw (DrawCmd shape ctx) :)

recordMesh :: Window -> Pipeline -> Mesh -> [Binding] -> IO ()
recordMesh window pipeline mesh bindings = do
  recCtx <- currentRecordingContext window
  modifyIORef' recCtx.rcCommands (RecordedMesh pipeline mesh bindings :)

drainRecording :: RecordingContext -> IO [RecordedOp]
drainRecording recCtx =
  atomicModifyIORef' recCtx.rcCommands (\ops -> ([], reverse ops))

resetRecording :: RecordingContext -> IO ()
resetRecording recCtx = do
  writeIORef recCtx.rcCommands []
  writeIORef recCtx.rcShaderStack []

withRecording :: Window -> RenderTarget -> (RecordingContext -> IO a) -> IO a
withRecording window _target action = do
  recCtx <- newRecordingContext
  let recording = Recording recCtx
  prev <- atomicModifyIORef' window.appRecording (\old -> (Just recording, old))
  action recCtx `finally` writeIORef window.appRecording prev
  where
    newRecordingContext = RecordingContext <$> newIORef [] <*> newIORef []

data PreparedDraw = PreparedDraw
  { pdPipeline :: GPUGraphicsPipeline
  , pdPrimitive :: SDL_GPUPrimitiveType
  , pdVertexBuffer :: GPUBuffer
  , pdVertexCount :: Word32
  , pdVertexByteSize :: Word32
  , pdTransferBuffer :: Maybe GPUTransferBuffer
  , pdReleaseBuffer :: Bool
  , pdSamplers :: [GPUTextureSamplerBinding]
  , pdStorageTextures :: [GPUTexture]
  , pdVertexUniforms :: [UniformBinding]
  , pdFragmentUniforms :: [UniformBinding]
  , pdDepthMode :: DepthMode
  }

flushFrame :: Window -> IO ()
flushFrame window = do
  ops <- drainRecording window.appFrameContext
  unless (null ops) $ do
    cmd <- require "SDL_AcquireGPUCommandBuffer" (sdlAcquireGPUCommandBuffer window.appGPUDevice)
    (swapTex, w, h) <- require "SDL_WaitAndAcquireGPUSwapchainTexture" (sdlWaitAndAcquireGPUSwapchainTexture cmd window.appWindow)
    let size = (fromIntegral w, fromIntegral h)
    flushOps window cmd window.appSwapchainFormat swapTex size (ensureSwapchainDepthTarget window size) ops

flushTarget :: Window -> RenderTarget -> [RecordedOp] -> IO ()
flushTarget window (RenderTarget tex) ops =
  unless (null ops) $
    do
      cmd <- require "SDL_AcquireGPUCommandBuffer" (sdlAcquireGPUCommandBuffer window.appGPUDevice)
      let size = (tex.textureWidth, tex.textureHeight)
      flushOps window cmd window.appSwapchainFormat tex.textureHandle size (ensureRenderTargetDepth window tex size) ops

flushOps :: Window -> GPUCommandBuffer -> SDL_GPUTextureFormat -> GPUTexture -> (Int, Int) -> IO DepthTarget -> [RecordedOp] -> IO ()
flushOps window cmd fmt targetTex (w, h) getDepth ops = do
  let (clearColor, drawOps) = extractClear ops
  prepared <- prepareDraws window fmt (w, h) drawOps
  flip finally (mapM_ (releasePrepared window) prepared) $ do
    unless (null prepared) $ do
      copyPass <- require "SDL_BeginGPUCopyPass" (sdlBeginGPUCopyPass cmd)
      mapM_ (uploadPrepared cmd copyPass) prepared
      sdlEndGPUCopyPass copyPass
    let needsDepth = any (\pd -> pd.pdDepthMode /= DepthNone) prepared
    depthInfo <- if needsDepth
      then do
        depthTarget <- getDepth
        let GPUTexture depthPtr = depthTarget.depthTexture.textureHandle
        pure (Just GPUDepthStencilTargetInfo
          { gpuDepthStencilTexture = depthPtr
          , gpuDepthStencilClearDepth = 1
          , gpuDepthStencilLoadOp = sdlGPULoadOpClear
          , gpuDepthStencilStoreOp = sdlGPUStoreOpStore
          , gpuDepthStencilStencilLoadOp = sdlGPULoadOpClear
          , gpuDepthStencilStencilStoreOp = sdlGPUStoreOpStore
          , gpuDepthStencilCycle = 0
          , gpuDepthStencilClearStencil = 0
          , gpuDepthStencilMipLevel = 0
          , gpuDepthStencilLayer = 0
          })
      else pure Nothing
    let clearF = maybe (FColor 0 0 0 0) toFColor clearColor
    let loadOp = if clearColor == Nothing then sdlGPULoadOpLoad else sdlGPULoadOpClear
    let targetInfo = GPUColorTargetInfo
          { gpuColorTargetTexture = let GPUTexture ptr = targetTex in ptr
          , gpuColorTargetMipLevel = 0
          , gpuColorTargetLayer = 0
          , gpuColorTargetClearColor = clearF
          , gpuColorTargetLoadOp = loadOp
          , gpuColorTargetStoreOp = sdlGPUStoreOpStore
          , gpuColorTargetResolveTexture = nullPtr
          , gpuColorTargetResolveMipLevel = 0
          , gpuColorTargetResolveLayer = 0
          , gpuColorTargetCycle = 0
          , gpuColorTargetCycleResolve = 0
          , gpuColorTargetPadding1 = 0
          , gpuColorTargetPadding2 = 0
          }
    renderPass <- require "SDL_BeginGPURenderPass" (sdlBeginGPURenderPass cmd targetInfo depthInfo)
    sdlSetGPUViewport renderPass (GPUViewport 0 0 (fromIntegral w) (fromIntegral h) 0 1)
    mapM_ (executePrepared cmd renderPass) prepared
    sdlEndGPURenderPass renderPass
    ok <- sdlSubmitGPUCommandBuffer cmd
    unless ok $ do
      err <- sdlGetError
      throwIO (SlopSDLFailure "SDL_SubmitGPUCommandBuffer" (T.pack err))

uploadPrepared :: GPUCommandBuffer -> GPUCopyPass -> PreparedDraw -> IO ()
uploadPrepared _ copyPass prepared =
  case prepared.pdTransferBuffer of
    Nothing -> pure ()
    Just transfer ->
      let source = GPUTransferBufferLocation
            { gpuTransferLocationBuffer = transfer
            , gpuTransferLocationOffset = 0
            }
          dest = GPUBufferRegion
            { gpuBufferRegionBuffer = prepared.pdVertexBuffer
            , gpuBufferRegionOffset = 0
            , gpuBufferRegionSize = prepared.pdVertexByteSize
            }
      in sdlUploadToGPUBuffer copyPass source dest False

executePrepared :: GPUCommandBuffer -> GPURenderPass -> PreparedDraw -> IO ()
executePrepared cmd renderPass prepared = do
  sdlBindGPUGraphicsPipeline renderPass prepared.pdPipeline
  sdlBindGPUVertexBuffers renderPass 0 [GPUBufferBinding prepared.pdVertexBuffer 0]
  sdlBindGPUFragmentSamplers renderPass 0 prepared.pdSamplers
  unless (null prepared.pdStorageTextures) $
    sdlBindGPUFragmentStorageTextures renderPass 0 prepared.pdStorageTextures
  mapM_ (pushUniformVertex cmd) prepared.pdVertexUniforms
  mapM_ (pushUniformFragment cmd) prepared.pdFragmentUniforms
  sdlDrawGPUPrimitives renderPass prepared.pdVertexCount 1 0 0
  where
    pushUniformVertex cmd' (UniformBinding slot bytes) =
      BS.useAsCStringLen bytes $ \(ptr, byteLen) ->
        sdlPushGPUVertexUniformData cmd' slot (castPtr ptr) (fromIntegral byteLen)
    pushUniformFragment cmd' (UniformBinding slot bytes) =
      BS.useAsCStringLen bytes $ \(ptr, byteLen) ->
        sdlPushGPUFragmentUniformData cmd' slot (castPtr ptr) (fromIntegral byteLen)

releasePrepared :: Window -> PreparedDraw -> IO ()
releasePrepared window prepared = do
  when prepared.pdReleaseBuffer $
    sdlReleaseGPUBuffer window.appGPUDevice prepared.pdVertexBuffer
  case prepared.pdTransferBuffer of
    Nothing -> pure ()
    Just transfer -> sdlReleaseGPUTransferBuffer window.appGPUDevice transfer

extractClear :: [RecordedOp] -> (Maybe Color, [RecordedOp])
extractClear ops =
  case ops of
    (RecordedClear color : rest) ->
      (Just color, filter (not . isClear) rest)
    _ -> (Nothing, filter (not . isClear) ops)
  where
    isClear op =
      case op of
        RecordedClear {} -> True
        _ -> False

toFColor :: Color -> FColor
toFColor (Color r g b a) =
  FColor (realToFrac r) (realToFrac g) (realToFrac b) (realToFrac a)

prepareDraws :: Window -> SDL_GPUTextureFormat -> (Int, Int) -> [RecordedOp] -> IO [PreparedDraw]
prepareDraws window fmt size = collect []
  where
    collect prepared [] = pure (reverse prepared)
    collect prepared (op : remaining) = do
      result <- try @SomeException $
        case op of
          RecordedDraw cmd -> prepareDraw window fmt size cmd
          RecordedMesh pipeline mesh bindings -> prepareMeshDraw window fmt pipeline mesh bindings
          RecordedClear {} -> pure []
      case result of
        Left exception -> mapM_ (releasePrepared window) prepared >> throwIO exception
        Right next -> collect (reverse next <> prepared) remaining

prepareDraw :: Window -> SDL_GPUTextureFormat -> (Int, Int) -> DrawCmd -> IO [PreparedDraw]
prepareDraw window fmt size (DrawCmd shape maybeCtx) = do
  ctx <- resolveShaderContext window maybeCtx
  resolved <- buildShapeDraws window size shape ctx
  reverse <$> foldM prepareOne [] resolved
  where
    prepareOne prepared resolvedDraw = do
      result <- try @SomeException $ do
        if null resolvedDraw.rdVertices
          then pure Nothing
          else do
            pipeline <- getPipeline
              window
              window.appVertexShader
              resolvedDraw.rdShaderCtx.ctxShader.shaderHandle
              spriteLayout
              resolvedDraw.rdPrimitive
              fmt
              resolvedDraw.rdShaderCtx.ctxBlend
              DepthNone
              0
            (buffer, transfer, count) <- createVertexBuffer window resolvedDraw.rdVertices
            let releaseBuffers = do
                  sdlReleaseGPUBuffer window.appGPUDevice buffer
                  sdlReleaseGPUTransferBuffer window.appGPUDevice transfer
            flip onException releaseBuffers $ do
              samplers <- buildSamplerBindings window resolvedDraw.rdShaderCtx resolvedDraw.rdTexture
              storage <- buildStorageBindings resolvedDraw.rdShaderCtx
              pure (Just PreparedDraw
                { pdPipeline = pipeline
                , pdPrimitive = resolvedDraw.rdPrimitive
                , pdVertexBuffer = buffer
                , pdVertexCount = count
                , pdVertexByteSize = fromIntegral (count * fromIntegral (sizeOf (undefined :: Vertex)))
                , pdTransferBuffer = Just transfer
                , pdReleaseBuffer = True
                , pdSamplers = samplers
                , pdStorageTextures = storage
                , pdVertexUniforms = []
                , pdFragmentUniforms = resolvedDraw.rdShaderCtx.ctxUniforms
                , pdDepthMode = DepthNone
                })
      case result of
        Left exception -> mapM_ (releasePrepared window) prepared >> throwIO exception
        Right Nothing -> pure prepared
        Right (Just next) -> pure (next : prepared)

prepareMeshDraw :: Window -> SDL_GPUTextureFormat -> Pipeline -> Mesh -> [Binding] -> IO [PreparedDraw]
prepareMeshDraw window fmt pipeline mesh bindings = do
  when (pipeline.pipelineTargetFormat /= fmt) $
    throwIO (SlopInvariantViolation "draw mesh" "pipeline target format does not match render target format")
  when (pipeline.pipelineLayout /= mesh.meshLayout) $
    throwIO (SlopInvariantViolation "draw mesh" "mesh layout does not match pipeline layout")
  resolved <- collectBindings bindings
  samplers <- buildSamplerBindingsExplicit window resolved.dbSamplers
  storage <- buildStorageBindingsExplicit resolved.dbStorageTextures
  when mesh.meshReleaseOnDraw $
    forgetOwnedResource window (meshResourceKey mesh)
  pure
    [ PreparedDraw
        { pdPipeline = pipeline.pipelineHandle
        , pdPrimitive = primitiveToSDL pipeline.pipelinePrimitive
        , pdVertexBuffer = mesh.meshBuffer
        , pdVertexCount = mesh.meshVertexCount
        , pdVertexByteSize = mesh.meshVertexCount * pipeline.pipelineLayout.layoutStride
        , pdTransferBuffer = Nothing
        , pdReleaseBuffer = mesh.meshReleaseOnDraw
        , pdSamplers = samplers
        , pdStorageTextures = storage
        , pdVertexUniforms = resolved.dbVertexUniforms
        , pdFragmentUniforms = resolved.dbFragmentUniforms
        , pdDepthMode = pipeline.pipelineDepthMode
        }
    ]

data ResolvedDraw = ResolvedDraw
  { rdPrimitive :: SDL_GPUPrimitiveType
  , rdVertices :: [Vertex]
  , rdTexture :: GPUTexture
  , rdShaderCtx :: ShaderContext
  }

resolveShaderContext :: Window -> Maybe ShaderContext -> IO ShaderContext
resolveShaderContext window ctx =
  case ctx of
    Just value -> pure value
    Nothing -> do
      defaults <- mergeUniformBindings window window.appDefaultShader []
      pure ShaderContext
        { ctxShader = window.appDefaultShader
        , ctxUniforms = defaults
        , ctxSamplers = []
        , ctxStorage = []
        , ctxBlend = BlendAlpha
        , ctxCamera = Nothing
        }

buildShapeDraws :: Window -> (Int, Int) -> DrawShape -> ShaderContext -> IO [ResolvedDraw]
buildShapeDraws window size shape ctx =
  case shape of
    ShapeLine color p1 p2 ->
      pure [ResolvedDraw sdlGPUPrimitiveTypeLineList (lineVertices size ctx.ctxCamera color p1 p2) (window.appWhiteTexture.textureHandle) ctx]
    ShapeRectOutline color rectShape ->
      pure [ResolvedDraw sdlGPUPrimitiveTypeLineList (rectOutlineVertices size ctx.ctxCamera color rectShape) (window.appWhiteTexture.textureHandle) ctx]
    ShapeRectFill color rectShape ->
      pure [ResolvedDraw sdlGPUPrimitiveTypeTriangleList (rectFillVertices size ctx.ctxCamera color rectShape) (window.appWhiteTexture.textureHandle) ctx]
    ShapeSprite tex src dst ->
      pure [ResolvedDraw sdlGPUPrimitiveTypeTriangleList (spriteVertices size ctx.ctxCamera tex src dst) tex.textureHandle ctx]
    ShapeText textObj x y color ->
      textVertices size textObj x y color ctx

lineVertices :: (Int, Int) -> Maybe Camera2D -> Color -> FPoint -> FPoint -> [Vertex]
lineVertices size camera color p1 p2 =
  [ mkVertex size camera p1 (V2 0 0) color
  , mkVertex size camera p2 (V2 0 0) color
  ]

rectOutlineVertices :: (Int, Int) -> Maybe Camera2D -> Color -> FRect -> [Vertex]
rectOutlineVertices size camera color (FRect x y w h) =
  let p1 = FPoint x y
      p2 = FPoint (x + w) y
      p3 = FPoint (x + w) (y + h)
      p4 = FPoint x (y + h)
  in [ mkVertex size camera p1 (V2 0 0) color
     , mkVertex size camera p2 (V2 0 0) color
     , mkVertex size camera p2 (V2 0 0) color
     , mkVertex size camera p3 (V2 0 0) color
     , mkVertex size camera p3 (V2 0 0) color
     , mkVertex size camera p4 (V2 0 0) color
     , mkVertex size camera p4 (V2 0 0) color
     , mkVertex size camera p1 (V2 0 0) color
     ]

rectFillVertices :: (Int, Int) -> Maybe Camera2D -> Color -> FRect -> [Vertex]
rectFillVertices size camera color (FRect x y w h) =
  let p1 = FPoint x y
      p2 = FPoint (x + w) y
      p3 = FPoint (x + w) (y + h)
      p4 = FPoint x (y + h)
      uv1 = V2 0 0
      uv2 = V2 1 0
      uv3 = V2 1 1
      uv4 = V2 0 1
  in [ mkVertex size camera p1 uv1 color
     , mkVertex size camera p2 uv2 color
     , mkVertex size camera p4 uv4 color
     , mkVertex size camera p2 uv2 color
     , mkVertex size camera p3 uv3 color
     , mkVertex size camera p4 uv4 color
     ]

spriteVertices :: (Int, Int) -> Maybe Camera2D -> Texture -> Maybe FRect -> FRect -> [Vertex]
spriteVertices size camera tex src dst =
  let (FRect dx dy dw dh) = dst
      (u0, v0, u1, v1) =
        case src of
          Nothing -> (0, 0, 1, 1)
          Just (FRect sx sy sw sh) ->
            let tw = max 1 tex.textureWidth
                th = max 1 tex.textureHeight
                sx' = realToFrac sx :: Float
                sy' = realToFrac sy :: Float
                sw' = realToFrac sw :: Float
                sh' = realToFrac sh :: Float
                tw' = fromIntegral tw :: Float
                th' = fromIntegral th :: Float
            in (sx' / tw', sy' / th', (sx' + sw') / tw', (sy' + sh') / th')
      p1 = FPoint dx dy
      p2 = FPoint (dx + dw) dy
      p3 = FPoint (dx + dw) (dy + dh)
      p4 = FPoint dx (dy + dh)
      uv1 = V2 u0 v0
      uv2 = V2 u1 v0
      uv3 = V2 u1 v1
      uv4 = V2 u0 v1
      white = rgba 1 1 1 1
  in [ mkVertex size camera p1 uv1 white
     , mkVertex size camera p2 uv2 white
     , mkVertex size camera p4 uv4 white
     , mkVertex size camera p2 uv2 white
     , mkVertex size camera p3 uv3 white
     , mkVertex size camera p4 uv4 white
     ]

textVertices :: (Int, Int) -> Text -> Float -> Float -> Color -> ShaderContext -> IO [ResolvedDraw]
textVertices size textObj x y color ctx = do
  setTextPositionChecked textObj (round x) (round y)
  seqPtr <- ttfGetGPUTextDrawData textObj
  go seqPtr []
  where
    go ptr acc
      | ptr == nullPtr = pure (reverse acc)
      | otherwise = do
          seqInfo <- peek ptr
          let numVerts = fromIntegral seqInfo.ttfAtlasNumVertices
          let numIdx = fromIntegral seqInfo.ttfAtlasNumIndices
          when (numVerts < 0) $
            throwIO (atlasDrawError ("negative vertex count " <> showText numVerts))
          when (numIdx < 0) $
            throwIO (atlasDrawError ("negative index count " <> showText numIdx))
          when (numVerts > 0 && seqInfo.ttfAtlasXY == nullPtr) $
            throwIO (atlasDrawError ("missing position array for " <> showText numVerts <> " vertices"))
          when (numVerts > 0 && seqInfo.ttfAtlasUV == nullPtr) $
            throwIO (atlasDrawError ("missing UV array for " <> showText numVerts <> " vertices"))
          when (numIdx > 0 && seqInfo.ttfAtlasIndices == nullPtr) $
            throwIO (atlasDrawError ("missing index array for " <> showText numIdx <> " indices"))
          indices <- peekArray numIdx seqInfo.ttfAtlasIndices
          vertices <- mapM (vertexFrom numVerts seqInfo.ttfAtlasXY seqInfo.ttfAtlasUV) indices
          let resolvedDraw = ResolvedDraw sdlGPUPrimitiveTypeTriangleList vertices seqInfo.ttfAtlasTexture ctx
          go seqInfo.ttfAtlasNext (resolvedDraw : acc)
    vertexFrom vertexCount xy uv rawIndex = do
      let index = fromIntegral rawIndex
      when (index < 0 || index >= vertexCount) $
        throwIO
          (atlasDrawError
            ( "index " <> showText index
                <> " is outside vertex range 0.." <> showText (vertexCount - 1)
            ))
      FPoint px py <- peekElemOff xy index
      FPoint u v <- peekElemOff uv index
      let uvVec = V2 (realToFrac u) (realToFrac v)
      pure (mkVertex size ctx.ctxCamera (FPoint px py) uvVec color)

atlasDrawError :: T.Text -> SlopError
atlasDrawError = SlopSDLFailure "TTF_GetGPUTextDrawData"

setTextPositionChecked :: Text -> Int -> Int -> IO ()
setTextPositionChecked textObj x y = do
  positioned <- ttfSetTextPosition textObj x y
  unless positioned $ do
    detail <- sdlGetError
    throwIO (SlopSDLFailure "TTF_SetTextPosition" (T.pack detail))

mkVertex :: (Int, Int) -> Maybe Camera2D -> FPoint -> V2 Float -> Color -> Vertex
mkVertex (w, h) camera (FPoint x y) (V2 u v) (Color r g b a) =
  let (nx, ny) =
        case camera of
          Nothing ->
            let wf = max 1 (fromIntegral w :: Float)
                hf = max 1 (fromIntegral h :: Float)
            in ( (realToFrac x / wf) * 2 - 1
               , 1 - (realToFrac y / hf) * 2
               )
          Just activeCamera ->
            let mat = camera2DMatrix (w, h) activeCamera
                V4 tx ty _ tw = m44MulV4 mat (V4 (realToFrac x) (realToFrac y) 0 1)
                invW = if tw == 0 then 1 else 1 / tw
            in (tx * invW, ty * invW)
  in Vertex
      (realToFrac nx)
      (realToFrac ny)
      (realToFrac u)
      (realToFrac v)
      (realToFrac r)
      (realToFrac g)
      (realToFrac b)
      (realToFrac a)

createVertexBuffer :: Window -> [Vertex] -> IO (GPUBuffer, GPUTransferBuffer, Word32)
createVertexBuffer window vertices = do
  let byteSize = length vertices * sizeOf (undefined :: Vertex)
  buffer <- require "SDL_CreateGPUBuffer"
    (sdlCreateGPUBuffer window.appGPUDevice
      GPUBufferCreateInfo
        { gpuBufferUsage = sdlGPUBufferUsageVertex
        , gpuBufferSize = fromIntegral byteSize
        , gpuBufferProps = 0
        })
  flip onException (sdlReleaseGPUBuffer window.appGPUDevice buffer) $ do
    transfer <- require "SDL_CreateGPUTransferBuffer"
      (sdlCreateGPUTransferBuffer window.appGPUDevice
        GPUTransferBufferCreateInfo
          { gpuTransferUsage = sdlGPUTransferBufferUsageUpload
          , gpuTransferSize = fromIntegral byteSize
          , gpuTransferProps = 0
          })
    flip onException (sdlReleaseGPUTransferBuffer window.appGPUDevice transfer) $ do
      ptr <- require "SDL_MapGPUTransferBuffer" (sdlMapGPUTransferBuffer window.appGPUDevice transfer False)
      withArrayLen vertices $ \_ src ->
        copyBytes ptr (castPtr src) byteSize
      sdlUnmapGPUTransferBuffer window.appGPUDevice transfer
      pure (buffer, transfer, fromIntegral (length vertices))

createMeshIO :: forall a. Storable a => Window -> VertexLayout -> [a] -> IO Mesh
createMeshIO window layout vertices = do
  let byteSize = length vertices * sizeOf (undefined :: a)
  buffer <- require "SDL_CreateGPUBuffer"
    (sdlCreateGPUBuffer window.appGPUDevice
      GPUBufferCreateInfo
        { gpuBufferUsage = sdlGPUBufferUsageVertex
        , gpuBufferSize = fromIntegral byteSize
        , gpuBufferProps = 0
        })
  flip onException (sdlReleaseGPUBuffer window.appGPUDevice buffer) $ do
    transfer <- require "SDL_CreateGPUTransferBuffer"
      (sdlCreateGPUTransferBuffer window.appGPUDevice
        GPUTransferBufferCreateInfo
          { gpuTransferUsage = sdlGPUTransferBufferUsageUpload
          , gpuTransferSize = fromIntegral byteSize
          , gpuTransferProps = 0
          })
    flip finally (sdlReleaseGPUTransferBuffer window.appGPUDevice transfer) $ do
      ptr <- require "SDL_MapGPUTransferBuffer" (sdlMapGPUTransferBuffer window.appGPUDevice transfer False)
      withArrayLen vertices $ \_ src ->
        copyBytes ptr (castPtr src) byteSize
      sdlUnmapGPUTransferBuffer window.appGPUDevice transfer
      cmd <- require "SDL_AcquireGPUCommandBuffer" (sdlAcquireGPUCommandBuffer window.appGPUDevice)
      copyPass <- require "SDL_BeginGPUCopyPass" (sdlBeginGPUCopyPass cmd)
      let source = GPUTransferBufferLocation
            { gpuTransferLocationBuffer = transfer
            , gpuTransferLocationOffset = 0
            }
      let dest = GPUBufferRegion
            { gpuBufferRegionBuffer = buffer
            , gpuBufferRegionOffset = 0
            , gpuBufferRegionSize = fromIntegral byteSize
            }
      sdlUploadToGPUBuffer copyPass source dest False
      sdlEndGPUCopyPass copyPass
      ok <- sdlSubmitGPUCommandBuffer cmd
      unless ok $ do
        err <- sdlGetError
        throwIO (SlopSDLFailure "SDL_SubmitGPUCommandBuffer" (T.pack err))
      pure Mesh
        { meshBuffer = buffer
        , meshVertexCount = fromIntegral (length vertices)
        , meshLayout = layout
        , meshReleaseOnDraw = False
        }

createTransientMeshIO :: Storable a => Window -> VertexLayout -> [a] -> IO Mesh
createTransientMeshIO window layout vertices = do
  mesh <- createMeshIO window layout vertices
  pure mesh { meshReleaseOnDraw = True }

createMesh :: Storable a => VertexLayout -> [a] -> WindowM Mesh
createMesh layout vertices = do
  window <- ask
  mesh <- liftIO (createMeshIO window layout vertices)
  liftIO (registerOwnedResource window (meshResourceKey mesh) (sdlReleaseGPUBuffer window.appGPUDevice mesh.meshBuffer))
  pure mesh

createTransientMesh :: Storable a => VertexLayout -> [a] -> WindowM Mesh
createTransientMesh layout vertices = do
  window <- ask
  mesh <- liftIO (createTransientMeshIO window layout vertices)
  liftIO (registerOwnedResource window (meshResourceKey mesh) (sdlReleaseGPUBuffer window.appGPUDevice mesh.meshBuffer))
  pure mesh

createMesh3D :: [Vertex3D] -> WindowM Mesh
createMesh3D vertices =
  createMesh mesh3DLayout vertices

createTransientMesh3D :: [Vertex3D] -> WindowM Mesh
createTransientMesh3D vertices =
  createTransientMesh mesh3DLayout vertices

mesh3D :: Mesh -> M44 Float -> [Binding] -> Mesh3D
mesh3D = Mesh3D

destroyMesh :: Mesh -> WindowM ()
destroyMesh mesh = do
  window <- ask
  liftIO (releaseOwnedResource window (meshResourceKey mesh) (sdlReleaseGPUBuffer window.appGPUDevice mesh.meshBuffer))

buildSamplerBindings :: Window -> ShaderContext -> GPUTexture -> IO [GPUTextureSamplerBinding]
buildSamplerBindings window ctx baseTexture = do
  let samplerCount = fromIntegral ctx.ctxShader.shaderSamplerCount :: Int
  if samplerCount <= 0
    then do
      unless (null ctx.ctxSamplers) $
        throwIO (SlopShaderFailure "bind sampler" "unnamed" Nothing "shader declares no samplers")
      pure []
    else do
      extras <- normalizeBindingsSparseIO "sampler" (map (\(SamplerBindingSpec slot tex sampler) -> (slot, (tex, sampler))) ctx.ctxSamplers)
      when (any (\(slot, _) -> slot >= samplerCount) extras) $
        throwIO (SlopShaderFailure "bind sampler" "unnamed" Nothing "binding slot exceeds shader sampler count")
      let baseSampler = window.appDefaultSampler
      let baseBinding = GPUTextureSamplerBinding baseTexture (unwrapSampler baseSampler)
      let extraMap = Map.fromList extras
      let bindings =
            [ if slot == 0
                then baseBinding
                else case Map.lookup slot extraMap of
                  Just (tex, sampler) ->
                    GPUTextureSamplerBinding tex.textureHandle (unwrapSampler (fromMaybe baseSampler sampler))
                  Nothing -> baseBinding
            | slot <- [0 .. samplerCount - 1]
            ]
      pure bindings
  where
    unwrapSampler (Sampler s) = s

buildSamplerBindingsExplicit :: Window -> [SamplerBindingSpec] -> IO [GPUTextureSamplerBinding]
buildSamplerBindingsExplicit window specs = do
  bindings <- normalizeBindingsSparseIO "sampler" (map (\(SamplerBindingSpec slot tex sampler) -> (slot, (tex, sampler))) specs)
  let baseSampler = window.appDefaultSampler
  let fallback = window.appWhiteTexture.textureHandle
  let fallbackBinding = GPUTextureSamplerBinding fallback (unwrapSampler baseSampler)
  let mapBindings = Map.fromList bindings
  let maxSlot = maybe 0 fst (listToMaybe (reverse bindings))
  pure
    [ case Map.lookup slot mapBindings of
        Just (tex, sampler) ->
          GPUTextureSamplerBinding tex.textureHandle (unwrapSampler (fromMaybe baseSampler sampler))
        Nothing -> fallbackBinding
    | slot <- [0 .. maxSlot]
    ]
  where
    unwrapSampler (Sampler s) = s

buildStorageBindingsExplicit :: [StorageBinding] -> IO [GPUTexture]
buildStorageBindingsExplicit specs = do
  storage <- normalizeBindingsIO "storage texture" (map (\(StorageBinding slot tex) -> (slot, tex)) specs)
  pure (map (\tex -> tex.textureHandle) storage)

buildStorageBindings :: ShaderContext -> IO [GPUTexture]
buildStorageBindings ctx = do
  storage <- normalizeBindingsIO "storage texture" (map (\(StorageBinding slot tex) -> (slot, tex)) ctx.ctxStorage)
  pure (map (\tex -> tex.textureHandle) storage)

getPipeline :: Window -> GPUShader -> GPUShader -> VertexLayout -> SDL_GPUPrimitiveType -> SDL_GPUTextureFormat -> BlendMode -> DepthMode -> SDL_GPUTextureFormat -> IO GPUGraphicsPipeline
getPipeline window vertexShader fragmentShader layout primitive fmt blendEnabled depthMode depthFormat = do
  let GPUShader vsPtr = vertexShader
  let GPUShader fsPtr = fragmentShader
  let key = PipelineKey (castPtr vsPtr) (castPtr fsPtr) layout primitive fmt blendEnabled depthMode depthFormat
  cache <- readIORef window.appPipelines
  case Map.lookup key cache of
    Just pipeline -> pure pipeline
    Nothing -> do
      pipeline <- createGraphicsPipeline window vertexShader fragmentShader layout primitive fmt blendEnabled depthMode depthFormat
      writeIORef window.appPipelines (Map.insert key pipeline cache)
      pure pipeline

createGraphicsPipeline :: Window -> GPUShader -> GPUShader -> VertexLayout -> SDL_GPUPrimitiveType -> SDL_GPUTextureFormat -> BlendMode -> DepthMode -> SDL_GPUTextureFormat -> IO GPUGraphicsPipeline
createGraphicsPipeline window vertexShader fragmentShader layout primitive fmt blendEnabled depthMode depthFormat =
  withArray [vertexBufferDesc] $ \bufferPtr ->
    withArray vertexAttributes $ \attrPtr ->
      withArray [colorTargetDesc] $ \colorPtr -> do
        let vertexInput = GPUVertexInputState
              { gpuVertexInputBufferDescriptions = bufferPtr
              , gpuVertexInputNumBuffers = 1
              , gpuVertexInputAttributes = attrPtr
              , gpuVertexInputNumAttributes = fromIntegral (length vertexAttributes)
              }
        let targetInfo = GPUGraphicsPipelineTargetInfo
              { gpuPipelineColorTargetDescriptions = colorPtr
              , gpuPipelineNumColorTargets = 1
              , gpuPipelineDepthStencilFormat = if depthMode == DepthNone then 0 else depthFormat
              , gpuPipelineHasDepthStencil = if depthMode == DepthNone then 0 else 1
              , gpuPipelinePadding1 = 0
              , gpuPipelinePadding2 = 0
              , gpuPipelinePadding3 = 0
              }
        let GPUShader vs = vertexShader
        let GPUShader fs = fragmentShader
        let createInfo = GPUGraphicsPipelineCreateInfo
              { gpuPipelineVertexShader = vs
              , gpuPipelineFragmentShader = fs
              , gpuPipelineVertexInputState = vertexInput
              , gpuPipelinePrimitiveType = primitive
              , gpuPipelineRasterizerState = rasterizerState
              , gpuPipelineMultisampleState = multisampleState
              , gpuPipelineDepthStencilState = depthStencilState
              , gpuPipelineTargetInfo = targetInfo
              , gpuPipelineProps = 0
              }
        require "SDL_CreateGPUGraphicsPipeline" (sdlCreateGPUGraphicsPipeline window.appGPUDevice createInfo)
  where
    vertexBufferDesc =
      GPUVertexBufferDescription
        { gpuVertexBufferSlot = 0
        , gpuVertexBufferPitch = layout.layoutStride
        , gpuVertexBufferInputRate = sdlGPUVertexInputRateVertex
        , gpuVertexBufferInstanceStepRate = 0
        }
    vertexAttributes =
      map toAttr layout.layoutAttrs
    toAttr attr =
      GPUVertexAttribute
        (attr.attrLocation)
        0
        (vertexFormatToSDL attr.attrFormat)
        (attr.attrOffset)
    vertexFormatToSDL fmt' =
      case fmt' of
        VertexFloat2 -> sdlGPUVertexElementFormatFloat2
        VertexFloat4 -> sdlGPUVertexElementFormatFloat4
    blendState =
      let (enabled, srcColor, dstColor, srcAlpha, dstAlpha) =
            case blendEnabled of
              BlendNone ->
                (False, sdlGPUBlendFactorOne, sdlGPUBlendFactorZero, sdlGPUBlendFactorOne, sdlGPUBlendFactorZero)
              BlendAdditive ->
                (True, sdlGPUBlendFactorOne, sdlGPUBlendFactorOne, sdlGPUBlendFactorOne, sdlGPUBlendFactorOne)
              BlendPremultiplied ->
                (True, sdlGPUBlendFactorOne, sdlGPUBlendFactorOneMinusSrcAlpha, sdlGPUBlendFactorOne, sdlGPUBlendFactorOneMinusSrcAlpha)
              BlendAlpha ->
                (True, sdlGPUBlendFactorSrcAlpha, sdlGPUBlendFactorOneMinusSrcAlpha, sdlGPUBlendFactorOne, sdlGPUBlendFactorOneMinusSrcAlpha)
      in GPUColorTargetBlendState
        { gpuBlendSrcColor = srcColor
        , gpuBlendDstColor = dstColor
        , gpuBlendColorOp = sdlGPUBlendOpAdd
        , gpuBlendSrcAlpha = srcAlpha
        , gpuBlendDstAlpha = dstAlpha
        , gpuBlendAlphaOp = sdlGPUBlendOpAdd
        , gpuBlendColorWriteMask = sdlGPUColorComponentRGBA
        , gpuBlendEnable = if enabled then 1 else 0
        , gpuBlendEnableColorWriteMask = if enabled then 1 else 0
        , gpuBlendPadding1 = 0
        , gpuBlendPadding2 = 0
        }
    colorTargetDesc =
      GPUColorTargetDescription
        { gpuColorTargetFormat = fmt
        , gpuColorTargetBlend = blendState
        }
    rasterizerState =
      GPURasterizerState
        { gpuRasterizerFillMode = sdlGPUFillModeFill
        , gpuRasterizerCullMode = sdlGPUCullModeNone
        , gpuRasterizerFrontFace = sdlGPUFrontFaceCounterClockwise
        , gpuRasterizerDepthBiasConstantFactor = 0
        , gpuRasterizerDepthBiasClamp = 0
        , gpuRasterizerDepthBiasSlopeFactor = 0
        , gpuRasterizerEnableDepthBias = 0
        , gpuRasterizerEnableDepthClip = 1
        , gpuRasterizerPadding1 = 0
        , gpuRasterizerPadding2 = 0
        }
    multisampleState =
      GPUMultisampleState
        { gpuMultisampleCount = sdlGPUSampleCount1
        , gpuMultisampleMask = maxBound
        , gpuMultisampleEnableMask = 0
        , gpuMultisampleEnableAlphaToCoverage = 0
        , gpuMultisamplePadding2 = 0
        , gpuMultisamplePadding3 = 0
        }
    stencilState =
      GPUStencilOpState
        { gpuStencilFailOp = sdlGPUStencilOpKeep
        , gpuStencilPassOp = sdlGPUStencilOpKeep
        , gpuStencilDepthFailOp = sdlGPUStencilOpKeep
        , gpuStencilCompareOp = sdlGPUCompareOpInvalid
        }
    depthStencilState =
      let (enableTest, enableWrite, cmp) =
            case depthMode of
              DepthNone -> (0, 0, sdlGPUCompareOpAlways)
              DepthTest -> (1, 0, sdlGPUCompareOpLessOrEqual)
              DepthTestWrite -> (1, 1, sdlGPUCompareOpLessOrEqual)
      in GPUDepthStencilState
        { gpuDepthCompareOp = cmp
        , gpuDepthBackStencilState = stencilState
        , gpuDepthFrontStencilState = stencilState
        , gpuDepthCompareMask = 0
        , gpuDepthWriteMask = if enableWrite == 0 then 0 else 0xFF
        , gpuDepthEnableDepthTest = enableTest
        , gpuDepthEnableDepthWrite = enableWrite
        , gpuDepthEnableStencilTest = 0
        , gpuDepthPadding1 = 0
        , gpuDepthPadding2 = 0
        , gpuDepthPadding3 = 0
        }

primitiveToSDL :: Primitive -> SDL_GPUPrimitiveType
primitiveToSDL prim =
  case prim of
    PrimTriangles -> sdlGPUPrimitiveTypeTriangleList
    PrimLines -> sdlGPUPrimitiveTypeLineList

defaultGraphics :: WindowM GraphicsDesc
defaultGraphics = do
  window <- ask
  let vertex = VertexShader window.appVertexShader window.appGPUDevice
  pure GraphicsDesc
    { gfxVertex = vertex
    , gfxFragment = window.appDefaultShader
    , gfxLayout = spriteLayout
    , gfxPrimitive = PrimTriangles
    , gfxTarget = TargetSwapchain
    , gfxBlend = BlendAlpha
    , gfxDepth = DepthNone
    , gfxDepthFormat = 0
    }

graphicsPipeline :: GraphicsDesc -> WindowM Pipeline
graphicsPipeline desc = do
  window <- ask
  let fmt =
        case desc.gfxTarget of
          TargetSwapchain -> window.appSwapchainFormat
          TargetFormat value -> value
  let depthFormat =
        if desc.gfxDepth == DepthNone
          then 0
          else if desc.gfxDepthFormat == 0 then window.appDepthFormat else desc.gfxDepthFormat
  createPipeline desc.gfxVertex desc.gfxFragment desc.gfxLayout desc.gfxPrimitive fmt desc.gfxBlend desc.gfxDepth depthFormat

createPipeline :: VertexShader -> FragmentShader -> VertexLayout -> Primitive -> SDL_GPUTextureFormat -> BlendMode -> DepthMode -> SDL_GPUTextureFormat -> WindowM Pipeline
createPipeline vertexShader fragmentShader layout prim fmt blendEnabled depthMode depthFormat = do
  window <- ask
  pipelineHandle <- liftIO $
    createGraphicsPipeline window
      vertexShader.vertexShaderHandle
      fragmentShader.shaderHandle
      layout
      (primitiveToSDL prim)
      fmt
      blendEnabled
      depthMode
      depthFormat
  let pipeline = Pipeline
        { pipelineHandle = pipelineHandle
        , pipelineVertex = vertexShader.vertexShaderHandle
        , pipelineFragment = fragmentShader.shaderHandle
        , pipelineLayout = layout
        , pipelinePrimitive = prim
        , pipelineTargetFormat = fmt
        , pipelineBlend = blendEnabled
        , pipelineDepthMode = depthMode
        , pipelineDepthFormat = depthFormat
        }
  liftIO (registerOwnedResource window (pipelineResourceKey pipeline) (sdlReleaseGPUGraphicsPipeline window.appGPUDevice pipeline.pipelineHandle))
  pure pipeline

destroyPipeline :: Pipeline -> WindowM ()
destroyPipeline pipeline = do
  window <- ask
  liftIO (releaseOwnedResource window (pipelineResourceKey pipeline) (sdlReleaseGPUGraphicsPipeline window.appGPUDevice pipeline.pipelineHandle))

swapchainFormat :: WindowM SDL_GPUTextureFormat
swapchainFormat = do
  window <- ask
  pure window.appSwapchainFormat

spriteLayout :: VertexLayout
spriteLayout =
  let stride = fromIntegral (sizeOf (undefined :: Vertex))
      posOffset = 0
      uvOffset = fromIntegral (2 * sizeOf (undefined :: CFloat))
      colorOffset = fromIntegral (4 * sizeOf (undefined :: CFloat))
  in VertexLayout
      { layoutStride = stride
      , layoutAttrs =
          [ VertexAttr 0 VertexFloat2 posOffset
          , VertexAttr 1 VertexFloat2 uvOffset
          , VertexAttr 2 VertexFloat4 colorOffset
          ]
      }

mesh3DLayout :: VertexLayout
mesh3DLayout =
  let stride = fromIntegral (sizeOf (undefined :: Vertex3D))
      posOffset = 0
      uvOffset = fromIntegral (4 * sizeOf (undefined :: CFloat))
      colorOffset = fromIntegral (6 * sizeOf (undefined :: CFloat))
  in VertexLayout
      { layoutStride = stride
      , layoutAttrs =
          [ VertexAttr 0 VertexFloat4 posOffset
          , VertexAttr 1 VertexFloat2 uvOffset
          , VertexAttr 2 VertexFloat4 colorOffset
          ]
      }

spritePipeline :: WindowM Pipeline
spritePipeline = defaultGraphics >>= graphicsPipeline

spriteBindings :: Texture -> [Binding]
spriteBindings tex = [BindFragmentSampler 0 tex Nothing]

spriteMesh :: (Int, Int) -> Texture -> Maybe FRect -> FRect -> WindowM Mesh
spriteMesh size tex src dst =
  createMesh spriteLayout (spriteVertices size Nothing tex src dst)

spriteMeshTransient :: (Int, Int) -> Texture -> Maybe FRect -> FRect -> WindowM Mesh
spriteMeshTransient size tex src dst =
  createTransientMesh spriteLayout (spriteVertices size Nothing tex src dst)

-- WindowM wrappers

loop :: a -> (Frame -> a -> WindowM (LoopControl a)) -> WindowM (LoopExit a)
loop initialState onFrame = do
  window <- ask
  start <- liftIO sdlGetTicks
  liftIO sdlPumpEvents
  initialInput <- liftIO readInputState
  let go previous frameId prevInput state = do
        liftIO sdlPumpEvents
        liftIO (resetRecording window.appFrameContext)
        (quitRequested, inputText', inputWheel', inputEvents') <- liftIO pollInputEvents
        now <- liftIO sdlGetTicks
        currentInput <- liftIO readInputState
        inputMods' <- liftIO (modifiersFromKeymod <$> SDL.sdlGetModState)
        (winW, winH) <- liftIO (sdlGetWindowSize (window.appWindow))
        (drawW, drawH) <- liftIO (sdlGetWindowSizeInPixels (window.appWindow))
        liftIO (writeIORef window.appWindowSize (winW, winH))
        liftIO (writeIORef window.appDrawableSize (drawW, drawH))
        let dt = fromIntegral (now - previous) / 1000
            t = fromIntegral (now - start) / 1000
            nextFrame = frameId + 1
            dpiX =
              if winW > 0
                then fromIntegral drawW / fromIntegral winW
                else 1
            dpiY =
              if winH > 0
                then fromIntegral drawH / fromIntegral winH
                else 1
        liftIO (setFrameId window nextFrame)
        let frame = Frame
              { delta = dt
              , time = t
              , ticks = now
              , quitRequested = quitRequested
              , size = (winW, winH)
              , renderSize = (drawW, drawH)
              , dpiScale = V2 dpiX dpiY
              , input = InputFrame prevInput currentInput inputText' inputWheel' inputMods' inputEvents'
              }
        liftIO (updateGlobalsUniform window frame)
        autoUpdateBlendPools dt
        autoHotReload dt
        processMainAssets
        control <- onFrame frame state
        liftIO (pruneTextCache window)
        liftIO (presentIO window)
        case control of
          Quit result -> pure (ExitStopped result)
          Continue result ->
            if quitRequested
              then pure (ExitQuitRequested result)
              else go now nextFrame currentInput result
  go start 0 initialInput initialState
  where
    pollInputEvents = allocaEvent $ \eventPtr ->
      let step quitSeen textChunks wheelAcc events = do
            has <- sdlPollEvent eventPtr
            if not has
              then pure (quitSeen, T.concat (reverse textChunks), wheelAcc, reverse events)
              else do
                eventType <- peekEventType eventPtr
                let quitNow = quitSeen || eventType == sdlEventQuit
                let events' = if eventType == sdlEventQuit then EventQuit : events else events
                if eventType == sdlEventTextInput
                  then do
                    ev <- peekTextInputEvent eventPtr
                    chunk <-
                      if ev.textInputText == nullPtr
                        then pure T.empty
                        else T.pack <$> peekCString ev.textInputText
                    step quitNow (chunk : textChunks) wheelAcc (EventText chunk : events')
                  else if eventType == sdlEventMouseWheel
                    then do
                      ev <- peekMouseWheelEvent eventPtr
                      let dx = realToFrac ev.mouseWheelX
                      let dy = realToFrac ev.mouseWheelY
                      let flipped = ev.mouseWheelDirection == sdlMouseWheelFlipped
                      let delta = if flipped then V2 (-dx) (-dy) else V2 dx dy
                      step quitNow textChunks (wheelAcc + delta) (EventMouseWheel delta : events')
                    else step quitNow textChunks wheelAcc events'
      in step False [] (V2 0 0) []

autoUpdateBlendPools :: Float -> WindowM ()
autoUpdateBlendPools delta = do
  window <- ask
  pools <- liftIO (readIORef window.appBlendPools)
  mapM_ (\pool -> updateBlend pool delta) pools

autoHotReload :: Float -> WindowM ()
autoHotReload delta = do
  window <- ask
  cfg <- liftIO (readIORef window.appHotReload)
  if not cfg.hrEnabled
    then pure ()
    else do
      let interval = cfg.hrInterval
      let elapsed' = cfg.hrElapsed + delta
      if interval > 0 && elapsed' < interval
        then liftIO (writeIORef window.appHotReload cfg { hrElapsed = elapsed' })
        else do
          let leftover = if interval <= 0 then 0 else elapsed' - interval
          liftIO (writeIORef window.appHotReload cfg { hrElapsed = max 0 leftover })
          hotReloadAssets

clear :: Color -> WindowM ()
clear color = liftWindow (\window -> clearIO window color)

setDrawColor :: Color -> WindowM ()
setDrawColor color = liftWindow (\window -> setDrawColorIO window color)

drawLine :: Color -> FPoint -> FPoint -> WindowM ()
drawLine color p1 p2 = liftWindow (\window -> drawLineIO window color p1 p2)

drawRect :: Color -> FRect -> WindowM ()
drawRect color rectShape = liftWindow (\window -> drawRectIO window color rectShape)

fillRect :: Color -> FRect -> WindowM ()
fillRect color rectShape = liftWindow (\window -> fillRectIO window color rectShape)

drawTexture :: Texture -> Maybe FRect -> FRect -> WindowM ()
drawTexture texture src dst = liftWindow (\window -> drawTextureIO window texture src dst)

textureUsageFlags :: [TextureUsage] -> SDL_GPUTextureUsageFlags
textureUsageFlags usages =
  let hasRead = TextureStorageRead `elem` usages
      hasWrite = TextureStorageWrite `elem` usages
      base0 = 0
      base1 = if TextureSampled `elem` usages then base0 .|. sdlGPUTextureUsageSampler else base0
      base2 = if TextureColorTarget `elem` usages then base1 .|. sdlGPUTextureUsageColorTarget else base1
      base3 = if TextureDepthTarget `elem` usages then base2 .|. sdlGPUTextureUsageDepthStencilTarget else base2
      storage
        | hasRead && hasWrite = sdlGPUTextureUsageComputeStorageSimultaneousReadWrite
        | otherwise =
            (if hasRead then sdlGPUTextureUsageComputeStorageRead else 0)
              .|. (if hasWrite then sdlGPUTextureUsageComputeStorageWrite else 0)
  in base3 .|. storage

createTexture2DIO :: Window -> TextureDesc -> IO Texture
createTexture2DIO window desc = do
  let info =
        GPUTextureCreateInfo
          { gpuTextureType = sdlGPUTextureType2D
          , gpuTextureFormat = desc.texFormat
          , gpuTextureUsage = textureUsageFlags desc.texUsage
          , gpuTextureWidth = fromIntegral desc.texWidth
          , gpuTextureHeight = fromIntegral desc.texHeight
          , gpuTextureLayerCountOrDepth = 1
          , gpuTextureNumLevels = 1
          , gpuTextureSampleCount = sdlGPUSampleCount1
          , gpuTextureProps = 0
          }
  tex <- require "SDL_CreateGPUTexture" (sdlCreateGPUTexture window.appGPUDevice info)
  pure Texture
    { textureHandle = tex
    , textureDevice = window.appGPUDevice
    , textureWidth = desc.texWidth
    , textureHeight = desc.texHeight
    , textureDepth = 1
    }

createTexture2D :: TextureDesc -> WindowM Texture
createTexture2D desc = do
  window <- ask
  texture <- liftIO (createTexture2DIO window desc)
  liftIO (registerOwnedResource window (textureResourceKey texture) (destroyTextureIO texture))
  pure texture

createTexture2DSize :: Size2D -> WindowM Texture
createTexture2DSize size =
  createTexture2D (textureDescSize size)

drawMesh :: Pipeline -> Mesh -> [Binding] -> WindowM ()
drawMesh pipeline mesh bindings =
  liftWindow (\window -> recordMesh window pipeline mesh bindings)

drawMesh3DWith :: Shader -> [Binding] -> Mesh -> WindowM ()
drawMesh3DWith shader bindings mesh =
  liftWindow $ \window -> do
    let fmt = window.appSwapchainFormat
    pipelineHandle <- getPipeline
      window
      window.appVertexShader3D
      shader.shaderHandle
      mesh3DLayout
      (primitiveToSDL PrimTriangles)
      fmt
      BlendNone
      DepthTestWrite
      window.appDepthFormat
    let pipeline = Pipeline
          { pipelineHandle = pipelineHandle
          , pipelineVertex = window.appVertexShader3D
          , pipelineFragment = shader.shaderHandle
          , pipelineLayout = mesh3DLayout
          , pipelinePrimitive = PrimTriangles
          , pipelineTargetFormat = fmt
          , pipelineBlend = BlendNone
          , pipelineDepthMode = DepthTestWrite
          , pipelineDepthFormat = window.appDepthFormat
          }
    recordMesh window pipeline mesh bindings

instance Draw AsMesh Mesh where
  draw (AsMesh pipeline bindings) mesh = drawMesh pipeline mesh bindings

instance Draw As3D Mesh3D where
  draw (As3D cam) (Mesh3D mesh model bindings) = do
    window <- ask
    let mvp = camera3DMVP cam model
    let mergedBindings = bindMesh3DMVP mvp bindings
    drawMesh3DWith window.appDefaultShader mergedBindings mesh

bindMesh3DMVP :: M44 Float -> [Binding] -> [Binding]
bindMesh3DMVP mvp bindings =
  let filtered = filter (not . isSlot0Binding) bindings
  in BindVertexUniform 0 (BindingValue mvp) : filtered

isSlot0Binding :: Binding -> Bool
isSlot0Binding binding =
  case binding of
    BindVertexUniform slot _ -> slot == 0
    BindFragmentUniform {} -> False
    BindFragmentSampler {} -> False
    BindFragmentStorageTexture {} -> False

createRenderTarget :: Int -> Int -> WindowM RenderTarget
createRenderTarget width height = do
  window <- ask
  tex <- liftIO $ mask_ $ do
    texture <- createRenderTargetTexture window width height
    registerRenderTarget window texture
    pure texture
  pure (RenderTarget tex)

createRenderTargetSize :: Size2D -> WindowM RenderTarget
createRenderTargetSize size =
  let (width, height) = size2DToTuple size
  in createRenderTarget width height

withRenderTarget :: Int -> Int -> (RenderTarget -> WindowM a) -> WindowM a
withRenderTarget width height action = do
  window <- ask
  liftIO $
    bracket
      (runWindowM window (createRenderTarget width height))
      (\target -> runWindowM window (destroyTarget target))
      (\target -> runWindowM window (action target))

destroyTarget :: RenderTarget -> WindowM ()
destroyTarget (RenderTarget tex) = do
  window <- ask
  liftIO $ mask_ $ do
    removed <- unregisterRenderTarget window tex
    when removed $ do
      depthTarget <- atomicModifyIORef' window.appDepthTargets $ \targets ->
        let key = renderTargetKey tex
        in (Map.delete key targets, Map.lookup key targets)
      case depthTarget of
        Nothing -> destroyTextureIO tex
        Just depth ->
          destroyTextureIO depth.depthTexture `finally` destroyTextureIO tex

render :: RenderTarget -> WindowM () -> WindowM ()
render target action = do
  window <- ask
  let runWithContext ctx = do
        result <- runWindowM window action
        ops <- drainRecording ctx
        flushTarget window target ops
        pure result
  liftIO (withRecording window target runWithContext)

output :: RenderTarget -> Maybe FRect -> FRect -> WindowM ()
output (RenderTarget texture) src dst =
  drawTexture texture src dst

postProcess :: RenderTarget -> RenderTarget -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> WindowM ()
postProcess (RenderTarget inputTex) (RenderTarget outputTex) shader uniforms src dst = do
  render (RenderTarget outputTex) $
    withShaderBindings shader uniforms (drawTexture inputTex src dst)

plan :: PlanM a -> RenderPlan
plan (PlanM action) = RenderPlan (toList (execWriter action))

pass :: TargetRef -> PassM a -> PlanM a
pass passTarget (PassM action) =
  PlanM $ do
    let (value, opsList) = runWriter action
    tell (singleton (Pass passTarget (toList opsList)))
    pure value

passClear :: Color -> PassM ()
passClear color = PassM (tell (singleton (OpClear color)))

passDraw :: Draw ctx a => ctx -> a -> PassM ()
passDraw ctx item = PassM (tell (singleton (OpDraw (DrawItem ctx item))))

passBlit :: RenderTarget -> Maybe FRect -> FRect -> PassM ()
passBlit target src dst = PassM (tell (singleton (OpBlit target src dst)))

passWithShader :: Shader -> [ShaderUniform] -> PassM a -> PassM a
passWithShader shader uniforms (PassM action) =
  PassM $ do
    let (value, opsList) = runWriter action
    tell (singleton (OpShader shader uniforms (toList opsList)))
    pure value

passPostProcess :: RenderTarget -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> PassM ()
passPostProcess input shader uniforms src dst =
  passWithShader shader uniforms (passBlit input src dst)

runPlan :: RenderPlan -> WindowM ()
runPlan (RenderPlan passes) = mapM_ runPass passes
  where
    runPass (Pass targetRef opsList) =
      case targetRef of
        WindowTarget -> runOps opsList
        Target target -> render target (runOps opsList)
    runOps = mapM_ runOp
    runOp op =
      case op of
        OpClear color -> clear color
        OpDraw item -> drawItem item
        OpBlit target src dst -> output target src dst
        OpShader shader uniforms opsList ->
          withShaderBindings shader uniforms (runOps opsList)

loadTexture :: FilePath -> WindowM Texture
loadTexture path = do
  window <- ask
  texture <- liftIO (loadTextureIO window path)
  liftIO (registerOwnedResource window (textureResourceKey texture) (destroyTextureIO texture))
  pure texture

destroyTexture :: Texture -> WindowM ()
destroyTexture texture = do
  window <- ask
  liftIO (releaseOwnedResource window (textureResourceKey texture) (destroyTextureIO texture))

loadFont :: FilePath -> Float -> WindowM Font
loadFont path size = do
  window <- ask
  font <- liftIO (loadFontIO path size)
  liftIO (registerOwnedResource window (fontResourceKey font) (closeFontIO font))
  pure font

loadFontSDF :: FilePath -> Float -> WindowM Font
loadFontSDF path size = do
  window <- ask
  font <- liftIO (loadFontSDFIO path size)
  liftIO (registerOwnedResource window (fontResourceKey font) (closeFontIO font))
  pure font

closeFont :: Font -> WindowM ()
closeFont font = do
  window <- ask
  liftIO (evictTextCacheForFontIO window font)
  liftIO (releaseOwnedResource window (fontResourceKey font) (closeFontIO font))

createText :: Font -> T.Text -> WindowM Text
createText font str = do
  window <- ask
  textObject <- liftIO (createTextIO window font str)
  liftIO (registerOwnedResource window (textResourceKey textObject) (destroyTextIO textObject))
  pure textObject

destroyText :: Text -> WindowM ()
destroyText textObject = do
  window <- ask
  liftIO (releaseOwnedResource window (textResourceKey textObject) (destroyTextIO textObject))

drawTextRaw :: Text -> Float -> Float -> Color -> WindowM ()
drawTextRaw textObj x y color =
  liftWindow (\window -> drawTextIO window textObj x y color)

drawTextRawWith :: TextStyle -> Text -> Float -> Float -> WindowM ()
drawTextRawWith style textObj x y =
  let action = liftWindow (\window -> drawTextIO window textObj x y style.textColor)
      blend = fromMaybe BlendAlpha style.textBlend
  in with2DContext blend Nothing style.textShader action

drawText :: Font -> T.Text -> Float -> Float -> WindowM ()
drawText font str x y = drawTextWith defaultTextStyle font str x y

drawTextWith :: TextStyle -> Font -> T.Text -> Float -> Float -> WindowM ()
drawTextWith style font str x y =
  let action = drawTextCachedWith font str x y style.textColor
      blend = fromMaybe BlendAlpha style.textBlend
  in with2DContext blend Nothing style.textShader action

drawTextCachedWith :: Font -> T.Text -> Float -> Float -> Color -> WindowM ()
drawTextCachedWith font str x y color = do
    window <- ask
    frameId <- liftIO $ atomicModifyIORef' (window.appRenderState) (\st -> (st, st.rsFrameId))
    let Font fontPtr = font
    let key = (castPtr fontPtr, str)
    cached <- liftIO $ atomicModifyIORef' (window.appRenderState) $ \st ->
      case Map.lookup key (st.rsTextCache) of
        Just entry ->
          let entry' = entry { ctLastUsed = frameId }
              cache' = Map.insert key entry' (st.rsTextCache)
          in (st { rsTextCache = cache' }, Just (entry.ctText))
        Nothing -> (st, Nothing)
    textObj <- case cached of
      Just t -> pure t
      Nothing -> do
        t <- liftIO (createTextIO window font str)
        liftIO $ atomicModifyIORef' (window.appRenderState) $ \st ->
          let cache' = Map.insert key (CachedText t frameId) (st.rsTextCache)
          in (st { rsTextCache = cache' }, ())
        pure t
    liftIO (recordDraw window (ShapeText textObj x y color))

measureText :: Font -> T.Text -> WindowM (V2 Float)
measureText = measureTextCached

measureTextCached :: Font -> T.Text -> WindowM (V2 Float)
measureTextCached font str = liftWindow (\window -> measureTextCachedIO window font str)

measureTextCachedIO :: Window -> Font -> T.Text -> IO (V2 Float)
measureTextCachedIO window font str = do
  frameId <- atomicModifyIORef' (window.appRenderState) (\st -> (st, st.rsFrameId))
  let Font fontPtr = font
  let key = (castPtr fontPtr, str)
  cached <- atomicModifyIORef' (window.appRenderState) $ \st ->
    case Map.lookup key (st.rsTextCache) of
      Just entry ->
        let entry' = entry { ctLastUsed = frameId }
            cache' = Map.insert key entry' (st.rsTextCache)
        in (st { rsTextCache = cache' }, Just (entry.ctText))
      Nothing -> (st, Nothing)
  textObj <- case cached of
    Just t -> pure t
    Nothing -> do
      t <- createTextIO window font str
      atomicModifyIORef' (window.appRenderState) $ \st ->
        let cache' = Map.insert key (CachedText t frameId) (st.rsTextCache)
        in (st { rsTextCache = cache' }, ())
      pure t
  measureTextObj textObj

measureTextObj :: Text -> IO (V2 Float)
measureTextObj textObj = do
  setTextPositionChecked textObj 0 0
  seqPtr <- ttfGetGPUTextDrawData textObj
  bounds <- go seqPtr Nothing
  pure $ case bounds of
    Nothing -> V2 0 0
    Just (minX, minY, maxX, maxY) -> V2 (maxX - minX) (maxY - minY)
  where
    go ptr acc
      | ptr == nullPtr = pure acc
      | otherwise = do
          seqInfo <- peek ptr
          let numVerts = fromIntegral seqInfo.ttfAtlasNumVertices
          when (numVerts < 0) $
            throwIO (atlasDrawError ("negative vertex count " <> showText numVerts))
          when (numVerts > 0 && seqInfo.ttfAtlasXY == nullPtr) $
            throwIO (atlasDrawError ("missing position array for " <> showText numVerts <> " vertices"))
          points <- peekArray numVerts seqInfo.ttfAtlasXY
          let acc' = foldl' updateBounds acc points
          go seqInfo.ttfAtlasNext acc'
    updateBounds Nothing (FPoint x y) =
      let fx = realToFrac x
          fy = realToFrac y
      in Just (fx, fy, fx, fy)
    updateBounds (Just (minX, minY, maxX, maxY)) (FPoint x y) =
      let fx = realToFrac x
          fy = realToFrac y
      in Just (min minX fx, min minY fy, max maxX fx, max maxY fy)

setTrackAudioSource :: Window -> Track -> Audio -> IO Bool
setTrackAudioSource _ track source =
  case source of
    AudioLoaded audio ->
      mixSetTrackAudio track audio
    AudioStream path -> do
      stream <- sdlIOFromFile path "rb"
      case stream of
        Nothing -> pure False
        Just ioStream -> mixSetTrackIOStream track ioStream True

requireAudioSuccess :: T.Text -> Bool -> WindowM ()
requireAudioSuccess operation succeeded =
  unless succeeded $ do
    detail <- liftIO sdlGetError
    let evidence = if null detail then "operation returned false" else T.pack detail
    throwSlop (SlopSDLFailure operation evidence)

requireAudioPlaybackIO :: T.Text -> Audio -> Bool -> IO ()
requireAudioPlaybackIO operation audio succeeded =
  unless succeeded $ do
    detail <- sdlGetError
    let evidence = if null detail then "operation returned false" else T.pack detail
    case audio of
      AudioStream path -> throwIO (SlopAssetFailure operation (T.pack path) evidence)
      AudioLoaded _ -> throwIO (SlopSDLFailure operation evidence)

startTrackPlaybackIO :: T.Text -> Window -> Track -> Audio -> Int -> IO ()
startTrackPlaybackIO operation window track audio loops = do
  inputSet <- setTrackAudioSource window track audio
  requireAudioPlaybackIO (operation <> " input") audio inputSet
  started <- mixPlayTrack track 0
  requireAudioPlaybackIO operation audio started
  loopsSet <- mixSetTrackLoops track loops
  requireAudioPlaybackIO (operation <> " loops") audio loopsSet

playMusic :: Audio -> Int -> WindowM ()
playMusic audio loops = do
  window <- ask
  mTrack <- liftIO $ do
    existing <- readIORef window.appMusicTrack
    case existing of
      Just track -> pure (Just track)
      Nothing -> do
        created <- mixCreateTrack window.appMixer
        case created of
          Nothing -> pure Nothing
          Just track -> do
            writeIORef window.appMusicTrack (Just track)
            registerOwnedResource window (trackResourceKey track) (mixDestroyTrack track)
            pure (Just track)
  case mTrack of
    Nothing -> requireAudioSuccess "MIX_CreateTrack" False
    Just track -> liftIO (startTrackPlaybackIO "play music" window track audio loops)

playMusicLoop :: Audio -> WindowM ()
playMusicLoop audio = playMusic audio (-1)

playSound :: Audio -> WindowM ()
playSound audio = do
  window <- ask
  mTrack <- liftIO (mixCreateTrack window.appMixer)
  case mTrack of
    Nothing -> requireAudioSuccess "MIX_CreateTrack" False
    Just track -> do
      released <- liftIO (newMVar False)
      let release = modifyMVar_ released $ \alreadyReleased ->
            if alreadyReleased
              then pure True
              else mixDestroyTrack track >> pure True
      liftIO (registerOwnedResource window (trackResourceKey track) release)
      liftIO $ startTrackPlaybackIO "play sound" window track audio 0
        `onException` releaseOwnedResource window (trackResourceKey track) release
      _ <- liftIO $ forkIO $ do
        let waitDone = do
              playing <- modifyMVar released $ \alreadyReleased ->
                if alreadyReleased
                  then pure (True, False)
                  else do
                    trackIsPlaying <- mixTrackPlaying track
                    pure (False, trackIsPlaying)
              if playing
                then threadDelay 10000 >> waitDone
                else releaseOwnedResource window (trackResourceKey track) release
        waitDone
      pure ()

data PoolPolicy
  = PoolRoundRobin
  | PoolOldest
  | PoolPriority
  | PoolBlend
  deriving (Eq, Show)

data TrackPool = TrackPool
  { poolPolicy :: !PoolPolicy
  , poolTracks :: ![Track]
  , poolState :: !(IORef PoolState)
  }

data PoolState = PoolState
  { psNext :: !Int
  , psLastUsed :: !(Map.Map Int Word64)
  , psPriorities :: !(Map.Map Int Int)
  , psActive :: !Int
  , psBlend :: !(Maybe BlendState)
  }

createTrackPool :: PoolPolicy -> Int -> WindowM TrackPool
createTrackPool policy count = do
  window <- ask
  let count' = if policy == PoolBlend then max 2 count else count
  tracks <- liftIO (createTracks window (max 0 count'))
  liftIO $ forM_ tracks $ \track ->
    registerOwnedResource window (trackResourceKey track) (mixDestroyTrack track)
  createTrackPoolFrom policy tracks
  where
    createTracks _ 0 = pure []
    createTracks window remaining = do
      track <- do
        created <- mixCreateTrack window.appMixer
        case created of
          Just value -> pure value
          Nothing -> do
            detail <- sdlGetError
            let evidence = if null detail then "operation returned no track" else T.pack detail
            throwIO (SlopSDLFailure "MIX_CreateTrack" evidence)
      rest <- createTracks window (remaining - 1) `onException` mixDestroyTrack track
      pure (track : rest)

createTrackPoolFrom :: PoolPolicy -> [Track] -> WindowM TrackPool
createTrackPoolFrom policy tracks = do
  state <- liftIO (newIORef (PoolState 0 Map.empty Map.empty 0 Nothing))
  pool <- pure TrackPool
    { poolPolicy = policy
    , poolTracks = tracks
    , poolState = state
    }
  when (policy == PoolBlend) (registerBlendPool pool)
  pure pool

registerBlendPool :: TrackPool -> WindowM ()
registerBlendPool pool = do
  window <- ask
  liftIO (modifyIORef' window.appBlendPools (pool :))

trackPlaying :: Track -> WindowM Bool
trackPlaying track = liftIO (mixTrackPlaying track)

playPool :: TrackPool -> Audio -> WindowM ()
playPool pool audio = playPoolWith pool 0 Nothing audio

playPoolLoop :: TrackPool -> Audio -> WindowM ()
playPoolLoop pool audio = playPoolWith pool (-1) Nothing audio

playPoolPriority :: TrackPool -> Int -> Audio -> WindowM ()
playPoolPriority pool priority audio = playPoolWith pool 0 (Just priority) audio

playPoolPriorityLoop :: TrackPool -> Int -> Audio -> WindowM ()
playPoolPriorityLoop pool priority audio = playPoolWith pool (-1) (Just priority) audio

stopPool :: TrackPool -> WindowM ()
stopPool pool = do
  stopped <- mapM (liftIO . (`mixStopTrack` 0)) pool.poolTracks
  requireAudioSuccess "stop track pool" (and stopped)

playPoolWith :: TrackPool -> Int -> Maybe Int -> Audio -> WindowM ()
playPoolWith pool loops mPriority audio = do
  window <- ask
  let tracks = pool.poolTracks
  case tracks of
    [] -> requireAudioSuccess "play track pool" False
    _ -> do
      state <- liftIO (readIORef pool.poolState)
      infos <- mapM (buildInfo state) (zip [0 ..] tracks)
      ticks <- liftIO sdlGetTicks
      let chooseResult = case pool.poolPolicy of
            PoolRoundRobin -> chooseRoundRobin state infos
            PoolOldest -> chooseOldest infos
            PoolPriority -> choosePriority infos (fromMaybe 0 mPriority)
            PoolBlend -> chooseRoundRobin state infos
      case chooseResult of
        Nothing -> requireAudioSuccess "play track pool" False
        Just (idx, info) -> do
          when info.tiPlaying $ do
            stopped <- liftIO (mixStopTrack info.tiTrack 0)
            requireAudioSuccess "stop track for pool playback" stopped
          liftIO (startTrackPlaybackIO "play track pool" window info.tiTrack audio loops)
          let priorityValue = fromMaybe (Map.findWithDefault 0 idx state.psPriorities) mPriority
          let state' = state
                { psNext = (idx + 1) `mod` length tracks
                , psLastUsed = Map.insert idx ticks state.psLastUsed
                , psPriorities = Map.insert idx priorityValue state.psPriorities
                }
          liftIO (writeIORef pool.poolState state')
  where
    buildInfo state (idx, track) = do
      playing <- liftIO (mixTrackPlaying track)
      let lastUsed = Map.findWithDefault 0 idx state.psLastUsed
      let priorityValue = Map.findWithDefault 0 idx state.psPriorities
      pure TrackInfo
        { tiIndex = idx
        , tiTrack = track
        , tiPlaying = playing
        , tiLastUsed = lastUsed
        , tiPriority = priorityValue
        }

data TrackInfo = TrackInfo
  { tiIndex :: !Int
  , tiTrack :: !Track
  , tiPlaying :: !Bool
  , tiLastUsed :: !Word64
  , tiPriority :: !Int
  }

chooseRoundRobin :: PoolState -> [TrackInfo] -> Maybe (Int, TrackInfo)
chooseRoundRobin state infos =
  case infos of
    [] -> Nothing
    _ ->
      let idx = state.psNext `mod` length infos
      in lookupInfo idx infos

chooseOldest :: [TrackInfo] -> Maybe (Int, TrackInfo)
chooseOldest infos =
  case filter (\info -> not info.tiPlaying) infos of
    (info : _) -> Just (info.tiIndex, info)
    [] -> pickMinBy infos (\info -> info.tiLastUsed)

choosePriority :: [TrackInfo] -> Int -> Maybe (Int, TrackInfo)
choosePriority infos newPriority =
  case filter (\info -> not info.tiPlaying) infos of
    (info : _) -> Just (info.tiIndex, info)
    [] ->
      case pickMinBy infos (\info -> info.tiPriority) of
        Nothing -> Nothing
        Just (idx, info) ->
          if newPriority < info.tiPriority
            then Nothing
            else Just (idx, info)

pickMinBy :: Ord b => [TrackInfo] -> (TrackInfo -> b) -> Maybe (Int, TrackInfo)
pickMinBy infos f =
  case infos of
    [] -> Nothing
    (info : rest) ->
      let best = foldl' (\acc item -> if f item < f acc then item else acc) info rest
      in Just (best.tiIndex, best)

lookupInfo :: Int -> [TrackInfo] -> Maybe (Int, TrackInfo)
lookupInfo idx infos =
  case infos of
    [] -> Nothing
    (info : rest) ->
      if info.tiIndex == idx
        then Just (idx, info)
        else lookupInfo idx rest

data BlendState = BlendState
  { bsFrom :: !Track
  , bsTo :: !Track
  , bsDuration :: !Float
  , bsElapsed :: !Float
  }

crossfadeTo :: TrackPool -> Audio -> Float -> WindowM ()
crossfadeTo pool audio duration = crossfadeToWith pool audio duration 0

crossfadeToLoop :: TrackPool -> Audio -> Float -> WindowM ()
crossfadeToLoop pool audio duration = crossfadeToWith pool audio duration (-1)

updateBlend :: TrackPool -> Float -> WindowM ()
updateBlend pool delta = do
  if pool.poolPolicy /= PoolBlend
    then pure ()
    else do
      state <- liftIO (readIORef pool.poolState)
      case state.psBlend of
        Nothing -> pure ()
        Just blend -> do
          let duration = max 0 blend.bsDuration
          let elapsed' = min duration (blend.bsElapsed + delta)
          let t = if duration <= 0 then 1 else elapsed' / duration
          fromGainSet <- liftIO (mixSetTrackGain blend.bsFrom (1 - t))
          toGainSet <- liftIO (mixSetTrackGain blend.bsTo t)
          if elapsed' >= duration
            then do
              fromStopped <- liftIO (mixStopTrack blend.bsFrom 0)
              finalGainSet <- liftIO (mixSetTrackGain blend.bsTo 1)
              let activeIdx = trackIndex pool blend.bsTo
              requireAudioSuccess "finish track crossfade" (fromGainSet && toGainSet && fromStopped && finalGainSet)
              liftIO (writeIORef pool.poolState state { psBlend = Nothing, psActive = activeIdx })
            else
              do
                requireAudioSuccess "update track crossfade" (fromGainSet && toGainSet)
                liftIO (writeIORef pool.poolState state { psBlend = Just blend { bsElapsed = elapsed' } })

crossfadeToWith :: TrackPool -> Audio -> Float -> Int -> WindowM ()
crossfadeToWith pool audio duration loops =
  if pool.poolPolicy /= PoolBlend
    then playPoolWith pool loops Nothing audio
    else do
      window <- ask
      let tracks = pool.poolTracks
      case tracks of
        [] -> requireAudioSuccess "crossfade track pool" False
        [track] -> do
          gainSet <- liftIO (mixSetTrackGain track 1)
          requireAudioSuccess "set crossfade track gain" gainSet
          liftIO (startTrackPlaybackIO "crossfade track pool" window track audio loops)
        (trackA : trackB : _) -> do
          state <- liftIO (readIORef pool.poolState)
          settledState <- case state.psBlend of
            Just blend -> do
              stopped <- liftIO (mixStopTrack blend.bsFrom 0)
              requireAudioSuccess "stop replaced crossfade track" stopped
              gainSet <- liftIO (mixSetTrackGain blend.bsTo 1)
              requireAudioSuccess "restore replaced crossfade gain" gainSet
              let state' = state { psBlend = Nothing, psActive = trackIndex pool blend.bsTo }
              liftIO (writeIORef pool.poolState state')
              pure state'
            Nothing -> pure state
          let activeIdx = settledState.psActive `mod` 2
          let fromTrack = if activeIdx == 0 then trackA else trackB
          let toTrack = if activeIdx == 0 then trackB else trackA
          if duration <= 0 || fromTrack == toTrack
            then do
              gainSet <- liftIO (mixSetTrackGain fromTrack 1)
              requireAudioSuccess "set crossfade track gain" gainSet
              liftIO (startTrackPlaybackIO "crossfade track pool" window fromTrack audio loops)
              liftIO (writeIORef pool.poolState settledState { psActive = trackIndex pool fromTrack })
            else do
              toGainSet <- liftIO (mixSetTrackGain toTrack 0)
              requireAudioSuccess "set incoming crossfade gain" toGainSet
              liftIO (startTrackPlaybackIO "crossfade track pool" window toTrack audio loops)
              fromGainSet <- liftIO (mixSetTrackGain fromTrack 1)
              requireAudioSuccess "set outgoing crossfade gain" fromGainSet
              let blend = BlendState
                    { bsFrom = fromTrack
                    , bsTo = toTrack
                    , bsDuration = duration
                    , bsElapsed = 0
                    }
              liftIO (writeIORef pool.poolState settledState { psBlend = Just blend })

trackIndex :: TrackPool -> Track -> Int
trackIndex pool track =
  fromMaybe 0 (elemIndex track pool.poolTracks)

createTrack :: WindowM Track
createTrack = do
  window <- ask
  track <- liftIO (mixCreateTrack window.appMixer)
  case track of
    Nothing -> do
      detail <- liftIO sdlGetError
      let evidence = if null detail then "operation returned no track" else T.pack detail
      throwSlop (SlopSDLFailure "MIX_CreateTrack" evidence)
    Just created -> do
      liftIO (registerOwnedResource window (trackResourceKey created) (mixDestroyTrack created))
      pure created

destroyTrack :: Track -> WindowM ()
destroyTrack track = do
  window <- ask
  liftIO (releaseOwnedResource window (trackResourceKey track) (mixDestroyTrack track))

playOn :: Track -> Audio -> WindowM ()
playOn track audio = do
  window <- ask
  liftIO (startTrackPlaybackIO "play track" window track audio 0)

playOnLoop :: Track -> Audio -> WindowM ()
playOnLoop track audio = do
  window <- ask
  liftIO (startTrackPlaybackIO "play track loop" window track audio (-1))

stopTrack :: Track -> WindowM ()
stopTrack track = do
  stopped <- liftIO (mixStopTrack track 0)
  requireAudioSuccess "stop track" stopped

-- Shaders

data Shader = Shader
  { shaderHandle :: GPUShader
  , shaderDevice :: GPUDevice
  , shaderSamplerCount :: Word32
  , shaderStorageTextureCount :: Word32
  , shaderStorageBufferCount :: Word32
  , shaderUniformBufferCount :: Word32
  , shaderBindingTable :: IORef ShaderBindings
  , shaderReflectedLayout :: Maybe ReflectedShaderLayout
  }

defaultSamplerDesc :: SamplerDesc
defaultSamplerDesc = SamplerDesc
  { samplerMinFilter = SamplerLinear
  , samplerMagFilter = SamplerLinear
  , samplerMipmapMode = SamplerMipmapLinear
  , samplerAddressU = SamplerClampToEdge
  , samplerAddressV = SamplerClampToEdge
  , samplerAddressW = SamplerClampToEdge
  , samplerMipLodBias = 0
  , samplerMaxAnisotropy = 1
  , samplerCompareOp = SamplerCompareInvalid
  , samplerMinLod = 0
  , samplerMaxLod = 0
  , samplerEnableAnisotropy = False
  , samplerEnableCompare = False
  }

samplerFilterToSDL :: SamplerFilter -> SDL_GPUFilter
samplerFilterToSDL filterMode =
  case filterMode of
    SamplerNearest -> 0
    SamplerLinear -> 1

samplerMipmapToSDL :: SamplerMipmap -> SDL_GPUSamplerMipmapMode
samplerMipmapToSDL mode =
  case mode of
    SamplerMipmapNearest -> 0
    SamplerMipmapLinear -> 1

samplerAddressToSDL :: SamplerAddress -> SDL_GPUSamplerAddressMode
samplerAddressToSDL mode =
  case mode of
    SamplerRepeat -> 0
    SamplerMirroredRepeat -> 1
    SamplerClampToEdge -> 2

samplerCompareToSDL :: SamplerCompare -> SDL_GPUCompareOp
samplerCompareToSDL mode =
  case mode of
    SamplerCompareInvalid -> 0
    SamplerCompareNever -> 1
    SamplerCompareLess -> 2
    SamplerCompareEqual -> 3
    SamplerCompareLessOrEqual -> 4
    SamplerCompareGreater -> 5
    SamplerCompareNotEqual -> 6
    SamplerCompareGreaterOrEqual -> 7
    SamplerCompareAlways -> 8

samplerDescToCreateInfo :: SamplerDesc -> GPUSamplerCreateInfo
samplerDescToCreateInfo desc = GPUSamplerCreateInfo
  { gpuSamplerMinFilter = samplerFilterToSDL desc.samplerMinFilter
  , gpuSamplerMagFilter = samplerFilterToSDL desc.samplerMagFilter
  , gpuSamplerMipmapMode = samplerMipmapToSDL desc.samplerMipmapMode
  , gpuSamplerAddressModeU = samplerAddressToSDL desc.samplerAddressU
  , gpuSamplerAddressModeV = samplerAddressToSDL desc.samplerAddressV
  , gpuSamplerAddressModeW = samplerAddressToSDL desc.samplerAddressW
  , gpuSamplerMipLodBias = realToFrac desc.samplerMipLodBias
  , gpuSamplerMaxAnisotropy = realToFrac desc.samplerMaxAnisotropy
  , gpuSamplerCompareOp = samplerCompareToSDL desc.samplerCompareOp
  , gpuSamplerMinLod = realToFrac desc.samplerMinLod
  , gpuSamplerMaxLod = realToFrac desc.samplerMaxLod
  , gpuSamplerEnableAnisotropy = if desc.samplerEnableAnisotropy then 1 else 0
  , gpuSamplerEnableCompare = if desc.samplerEnableCompare then 1 else 0
  , gpuSamplerPadding1 = 0
  , gpuSamplerPadding2 = 0
  , gpuSamplerProps = 0
  }

defaultSamplerCreateInfo :: GPUSamplerCreateInfo
defaultSamplerCreateInfo = samplerDescToCreateInfo defaultSamplerDesc

createSampler :: SamplerDesc -> WindowM Sampler
createSampler desc = do
  window <- ask
  sampler <- liftIO $ require "SDL_CreateGPUSampler" (sdlCreateGPUSampler window.appGPUDevice (samplerDescToCreateInfo desc))
  let result = Sampler sampler
  liftIO (registerOwnedResource window (samplerResourceKey result) (sdlReleaseGPUSampler window.appGPUDevice sampler))
  pure result

destroySampler :: Sampler -> WindowM ()
destroySampler (Sampler sampler) = do
  window <- ask
  let result = Sampler sampler
  liftIO (releaseOwnedResource window (samplerResourceKey result) (sdlReleaseGPUSampler window.appGPUDevice sampler))

setShaderBindings :: Shader -> ShaderBindings -> WindowM ()
setShaderBindings shader bindings =
  liftIO (writeIORef shader.shaderBindingTable bindings)

setShader2DBindings :: Shader2D -> ShaderBindings -> WindowM ()
setShader2DBindings shader bindings =
  setShaderBindings (unwrapShader2D shader) bindings

getShaderBindings :: Shader -> WindowM ShaderBindings
getShaderBindings shader =
  liftIO (readIORef shader.shaderBindingTable)

createShaderFromSpirvWithIO :: Window -> ByteString -> Word32 -> Word32 -> Word32 -> Word32 -> IO Shader
createShaderFromSpirvWithIO window spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers =
  createShaderFromSpirvWithDevice window.appGPUDevice spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers

createShaderFromSpirvWithDevice :: GPUDevice -> ByteString -> Word32 -> Word32 -> Word32 -> Word32 -> IO Shader
createShaderFromSpirvWithDevice device spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers = do
  when (numUniformBuffers > 4) $
    throwIO (SlopShaderFailure "create" "unnamed" Nothing "SDL_gpu supports at most 4 uniform buffers per fragment shader")
  shader <- require "SDL_CreateGPUShader" (createRawShader device spirv sdlGPUShaderStageFragment numSamplers numStorageTextures numStorageBuffers numUniformBuffers)
  bindingsRef <- newIORef emptyShaderBindings
  pure Shader
    { shaderHandle = shader
    , shaderDevice = device
    , shaderSamplerCount = numSamplers
    , shaderStorageTextureCount = numStorageTextures
    , shaderStorageBufferCount = numStorageBuffers
    , shaderUniformBufferCount = numUniformBuffers
    , shaderBindingTable = bindingsRef
    , shaderReflectedLayout = Nothing
    }

validateShader2DCounts :: ShaderCounts -> IO ()
validateShader2DCounts counts = do
  when (counts.shaderStorageTextures /= 0) $
    throwIO (SlopShaderFailure "create 2D shader" "unnamed" Nothing "storage textures are not supported")
  when (counts.shaderStorageBuffers /= 0) $
    throwIO (SlopShaderFailure "create 2D shader" "unnamed" Nothing "storage buffers are not supported")
  when (counts.shaderUniformBuffers > 4) $
    throwIO (SlopShaderFailure "create 2D shader" "unnamed" Nothing "SDL_gpu supports at most 4 uniform buffers")

validateShader2DLayout :: Shader2DLayout -> SlopResult ShaderCounts
validateShader2DLayout layout = do
  if null layout.layoutStorageTextures
    then pure ()
    else Left (layoutError "storage textures are not supported")
  if null layout.layoutStorageBuffers
    then pure ()
    else Left (layoutError "storage buffers are not supported")
  samplerCount <- validateSlots "sampler" 2 layout.layoutSamplers
  uniformCount <- validateSlots "uniform" 3 layout.layoutUniforms
  if uniformCount > 4
    then Left (layoutError "SDL_gpu supports at most 4 uniform buffers per fragment shader")
    else pure ()
  pure ShaderCounts
    { shaderSamplers = samplerCount
    , shaderStorageTextures = 0
    , shaderStorageBuffers = 0
    , shaderUniformBuffers = uniformCount
    }
  where
    validateSlots :: String -> Word32 -> [BindingSlot] -> SlopResult Word32
    validateSlots label expectedGroup slots =
      case slots of
        [] -> Right 0
        _ -> do
          if all (\slot -> slot.slotGroup == expectedGroup) slots
            then pure ()
            else Left (layoutError (label <> " bindings must use group " <> show expectedGroup))
          let indices = fmap (fromIntegral . (.slotBinding)) slots :: [Int]
          let unique = IntSet.fromList indices
          if IntSet.size unique /= length indices
            then Left (layoutError (label <> " bindings contain duplicate slots"))
            else pure ()
          let minIx = minimum indices
          let maxIx = maximum indices
          if minIx /= 0
            then Left (layoutError (label <> " bindings must start at 0"))
            else if IntSet.size unique /= maxIx + 1
              then Left (layoutError (label <> " bindings must be contiguous 0.." <> show maxIx))
              else Right (fromIntegral (maxIx + 1))
    layoutError detail =
      SlopShaderFailure "validate 2D layout" "unnamed" Nothing (T.pack detail)

createRawShader :: GPUDevice -> ByteString -> SDL_GPUShaderStage -> Word32 -> Word32 -> Word32 -> Word32 -> IO (Maybe GPUShader)
createRawShader device spirv stage numSamplers numStorageTextures numStorageBuffers numUniformBuffers =
  BS.useAsCStringLen spirv $ \(ptr, byteLen) ->
    withCString "main" $ \entry -> do
      let createInfo = GPUShaderCreateInfo
            { gpuShaderCodeSize = fromIntegral byteLen
            , gpuShaderCode = castPtr ptr
            , gpuShaderEntryPoint = entry
            , gpuShaderFormat = sdlGPUShaderFormatSpirv
            , gpuShaderStage = stage
            , gpuShaderNumSamplers = numSamplers
            , gpuShaderNumStorageTextures = numStorageTextures
            , gpuShaderNumStorageBuffers = numStorageBuffers
            , gpuShaderNumUniformBuffers = numUniformBuffers
            , gpuShaderProps = 0
            }
      sdlCreateGPUShader device createInfo

createVertexShaderIO :: Window -> ByteString -> ShaderCounts -> IO VertexShader
createVertexShaderIO window spirv counts = do
  let device = window.appGPUDevice
  shader <- require "SDL_CreateGPUShader (vertex)"
    (createRawShader device spirv sdlGPUShaderStageVertex
      counts.shaderSamplers
      counts.shaderStorageTextures
      counts.shaderStorageBuffers
      counts.shaderUniformBuffers)
  pure VertexShader
    { vertexShaderHandle = shader
    , vertexShaderDevice = device
    }

createVertexShader :: ByteString -> ShaderCounts -> WindowM VertexShader
createVertexShader spirv counts = do
  window <- ask
  shader <- liftIO (createVertexShaderIO window spirv counts)
  liftIO (registerOwnedResource window (vertexShaderResourceKey shader) (sdlReleaseGPUShader shader.vertexShaderDevice shader.vertexShaderHandle))
  pure shader

destroyVertexShader :: VertexShader -> WindowM ()
destroyVertexShader shader = do
  window <- ask
  liftIO (releaseOwnedResource window (vertexShaderResourceKey shader) (sdlReleaseGPUShader shader.vertexShaderDevice shader.vertexShaderHandle))

createFragmentShader :: ByteString -> ShaderCounts -> WindowM FragmentShader
createFragmentShader spirv counts = do
  window <- ask
  shader <- liftIO (createShaderFromSpirvWithIO window spirv counts.shaderSamplers counts.shaderStorageTextures counts.shaderStorageBuffers counts.shaderUniformBuffers)
  liftIO (registerOwnedResource window (fragmentShaderResourceKey shader) (destroyShaderIO shader))
  pure shader

createFragmentShaderReflected :: ByteString -> ReflectedShaderLayout -> WindowM FragmentShader
createFragmentShaderReflected spirv layout = do
  unless (layout.reflectedShaderStage == ShaderFragment) $
    throwSlop (reflectionError layout.reflectedShaderName Nothing "expected a fragment shader layout")
  shader <- createFragmentShader spirv layout.reflectedShaderCounts
  let bindings = reflectedBindingsTable layout
  liftIO (writeIORef shader.shaderBindingTable bindings)
  pure shader { shaderReflectedLayout = Just layout }

destroyFragmentShader :: FragmentShader -> WindowM ()
destroyFragmentShader shader = do
  window <- ask
  liftIO (releaseOwnedResource window (fragmentShaderResourceKey shader) (destroyShaderIO shader))

createShader2D :: ByteString -> ShaderCounts -> WindowM Shader2D
createShader2D spirv counts = do
  liftIO (validateShader2DCounts counts)
  Shader2D <$> createFragmentShader spirv counts

createShader2DReflected :: ByteString -> ReflectedShaderLayout -> WindowM Shader2D
createShader2DReflected spirv layout = do
  let counts = layout.reflectedShaderCounts
  liftIO (validateShader2DCounts counts)
  Shader2D <$> createFragmentShaderReflected spirv layout

destroyShader2D :: Shader2D -> WindowM ()
destroyShader2D (Shader2D shader) = destroyFragmentShader shader

createComputePipelineIO :: Window -> ComputeDesc -> IO ComputePipeline
createComputePipelineIO window desc = do
  let device = window.appGPUDevice
  BS.useAsCStringLen desc.computeShaderCode $ \(ptr, byteLen) ->
    withCString "main" $ \entry -> do
      let (threadsX, threadsY, threadsZ) = threads3DToWord32 desc.computeThreads
      let createInfo =
            GPUComputePipelineCreateInfo
            { gpuComputeCodeSize = fromIntegral byteLen
              , gpuComputeCode = castPtr ptr
              , gpuComputeEntryPoint = entry
              , gpuComputeFormat = sdlGPUShaderFormatSpirv
              , gpuComputeNumSamplers = desc.computeSamplers
              , gpuComputeNumReadonlyStorageTextures = desc.computeReadonlyStorageTextures
              , gpuComputeNumReadonlyStorageBuffers = desc.computeReadonlyStorageBuffers
              , gpuComputeNumReadwriteStorageTextures = desc.computeReadwriteStorageTextures
              , gpuComputeNumReadwriteStorageBuffers = desc.computeReadwriteStorageBuffers
              , gpuComputeNumUniformBuffers = desc.computeUniformBuffers
              , gpuComputeThreadCountX = threadsX
              , gpuComputeThreadCountY = threadsY
              , gpuComputeThreadCountZ = threadsZ
              , gpuComputeProps = 0
              }
      pipeline <- require "SDL_CreateGPUComputePipeline" (sdlCreateGPUComputePipeline device createInfo)
      pure ComputePipeline
        { computeHandle = pipeline
        , computeDevice = device
        }

computePipeline :: ComputeDesc -> WindowM ComputePipeline
computePipeline desc = do
  window <- ask
  pipeline <- liftIO (createComputePipelineIO window desc)
  liftIO (registerOwnedResource window (computePipelineResourceKey pipeline) (sdlReleaseGPUComputePipeline pipeline.computeDevice pipeline.computeHandle))
  pure pipeline

defaultCompute :: ComputeDesc
defaultCompute =
  ComputeDesc
    { computeShaderCode = mempty
    , computeSamplers = 0
    , computeReadonlyStorageTextures = 0
    , computeReadonlyStorageBuffers = 0
    , computeReadwriteStorageTextures = 0
    , computeReadwriteStorageBuffers = 0
    , computeUniformBuffers = 0
    , computeThreads = threads3D 1 1 1
    }

computeDescFromReflection :: ByteString -> Threads3D -> ReflectedShaderLayout -> SlopResult ComputeDesc
computeDescFromReflection spirv threads layout = do
  unless (layout.reflectedShaderStage == ShaderCompute) $
    Left (reflectionError layout.reflectedShaderName Nothing "expected a compute shader layout")
  let bindings = Map.elems layout.reflectedShaderBindings
  case [binding | binding <- bindings, binding.reflectedType == ReflectedStorageBuffer] of
    binding : _ -> Left (reflectionError layout.reflectedShaderName (Just binding.reflectedName) "storage buffers are not supported by the compute binding API")
    [] -> Right ()
  readonlyTextures <- reflectedSlotCount layout ReflectedReadOnly
  readwriteTextures <- reflectedSlotCount layout ReflectedReadWrite
  pure defaultCompute
    { computeShaderCode = spirv
    , computeSamplers = layout.reflectedShaderCounts.shaderSamplers
    , computeReadonlyStorageTextures = readonlyTextures
    , computeReadwriteStorageTextures = readwriteTextures
    , computeUniformBuffers = layout.reflectedShaderCounts.shaderUniformBuffers
    , computeThreads = threads
    }

reflectedSlotCount :: ReflectedShaderLayout -> ReflectedStorageAccess -> SlopResult Word32
reflectedSlotCount layout access =
  let slots =
        [ binding.reflectedSlot
        | binding <- Map.elems layout.reflectedShaderBindings
        , binding.reflectedType == ReflectedStorageTexture access
        ]
  in case slots of
      [] -> Right 0
      _
        | Map.keys (Map.fromList [(slot, ()) | slot <- slots]) == [0 .. maximum slots] -> Right (maximum slots + 1)
        | otherwise -> Left (reflectionError layout.reflectedShaderName Nothing (T.pack (show access) <> " storage texture slots must be contiguous from 0"))

destroyComputePipeline :: ComputePipeline -> WindowM ()
destroyComputePipeline pipeline = do
  window <- ask
  liftIO (releaseOwnedResource window (computePipelineResourceKey pipeline) (sdlReleaseGPUComputePipeline pipeline.computeDevice pipeline.computeHandle))

dispatchCompute :: ComputePipeline -> [ComputeBinding] -> (Word32, Word32, Word32) -> WindowM ()
dispatchCompute pipeline bindings (groupX, groupY, groupZ) = do
  window <- ask
  liftIO (dispatchComputeIO window pipeline bindings (groupX, groupY, groupZ))

dispatchComputeIO :: Window -> ComputePipeline -> [ComputeBinding] -> (Word32, Word32, Word32) -> IO ()
dispatchComputeIO window pipeline bindings (groupX, groupY, groupZ) = do
  resolved <- collectComputeBindings bindings
  let rwBindings =
        map (\tex ->
          GPUStorageTextureReadWriteBinding
            { gpuStorageTexture = tex.textureHandle
            , gpuStorageMipLevel = 0
            , gpuStorageLayer = 0
            , gpuStorageCycle = 0
            , gpuStoragePadding1 = 0
            , gpuStoragePadding2 = 0
            , gpuStoragePadding3 = 0
            }) resolved.cbReadWriteTextures
  cmd <- require "SDL_AcquireGPUCommandBuffer" (sdlAcquireGPUCommandBuffer window.appGPUDevice)
  computePass <- require "SDL_BeginGPUComputePass" (sdlBeginGPUComputePass cmd rwBindings [])
  sdlBindGPUComputePipeline computePass pipeline.computeHandle
  samplers <- buildSamplerBindingsExplicit window resolved.cbSamplers
  sdlBindGPUComputeSamplers computePass 0 samplers
  let readOnlyTextures = map (\tex -> tex.textureHandle) resolved.cbReadOnlyTextures
  sdlBindGPUComputeStorageTextures computePass 0 readOnlyTextures
  forM_ resolved.cbUniforms $ \(UniformBinding slot bytes) ->
    BS.useAsCStringLen bytes $ \(ptr, byteLen) ->
      sdlPushGPUComputeUniformData cmd slot (castPtr ptr) (fromIntegral byteLen)
  sdlDispatchGPUCompute computePass groupX groupY groupZ
  sdlEndGPUComputePass computePass
  ok <- sdlSubmitGPUCommandBuffer cmd
  unless ok $ do
    err <- sdlGetError
    throwIO (SlopSDLFailure "SDL_SubmitGPUCommandBuffer" (T.pack err))

destroyShaderIO :: Shader -> IO ()
destroyShaderIO shader =
  sdlReleaseGPUShader (shader.shaderDevice) (shader.shaderHandle)

toBytes :: Storable a => a -> IO ByteString
toBytes value =
  BSI.create (sizeOf value) $ \ptr ->
    poke (castPtr ptr) value

bindingValueBytes :: BindingValue -> IO ByteString
bindingValueBytes value =
  case value of
    BindingValue v -> toBytes v
    BindingBytes bytes -> pure bytes

vUniform :: Storable a => Word32 -> a -> Binding
vUniform slot value = BindVertexUniform slot (BindingValue value)

vUniformBytes :: Word32 -> ByteString -> Binding
vUniformBytes slot bytes = BindVertexUniform slot (BindingBytes bytes)

fUniform :: Storable a => Word32 -> a -> Binding
fUniform slot value = BindFragmentUniform slot (BindingValue value)

fUniformBytes :: Word32 -> ByteString -> Binding
fUniformBytes slot bytes = BindFragmentUniform slot (BindingBytes bytes)

fSampler :: Word32 -> Texture -> Binding
fSampler slot tex = BindFragmentSampler slot tex Nothing

fSamplerWith :: Word32 -> Texture -> Sampler -> Binding
fSamplerWith slot tex sampler = BindFragmentSampler slot tex (Just sampler)

fStorageTexture :: Word32 -> Texture -> Binding
fStorageTexture slot tex = BindFragmentStorageTexture slot tex

computeUniform :: Storable a => Word32 -> a -> ComputeBinding
computeUniform slot value = ComputeUniform slot (BindingValue value)

computeUniformBytes :: Word32 -> ByteString -> ComputeBinding
computeUniformBytes slot bytes = ComputeUniform slot (BindingBytes bytes)

computeSampler :: Word32 -> Texture -> ComputeBinding
computeSampler slot tex = ComputeSampler slot tex Nothing

computeSamplerWith :: Word32 -> Texture -> Sampler -> ComputeBinding
computeSamplerWith slot tex sampler = ComputeSampler slot tex (Just sampler)

computeStorageTexture :: Word32 -> Texture -> ComputeBinding
computeStorageTexture slot tex = ComputeStorageTexture slot tex

computeStorageTextureRW :: Word32 -> Texture -> ComputeBinding
computeStorageTextureRW slot tex = ComputeStorageTextureRW slot tex

collectShaderBindings :: [ShaderUniform] -> IO ([UniformBinding], [SamplerBindingSpec], [StorageBinding])
collectShaderBindings = foldM step ([], [], [])
  where
    step (uniforms, samplers, storage) binding =
      case binding of
        ShaderUniform slot value -> do
          bytes <- toBytes value
          pure (UniformBinding slot bytes : uniforms, samplers, storage)
        ShaderUniformBytes slot bytes ->
          pure (UniformBinding slot bytes : uniforms, samplers, storage)
        ShaderSampler slot tex ->
          pure (uniforms, SamplerBindingSpec slot tex Nothing : samplers, storage)
        ShaderSamplerWith slot tex sampler ->
          pure (uniforms, SamplerBindingSpec slot tex (Just sampler) : samplers, storage)
        ShaderStorageTexture slot tex ->
          pure (uniforms, samplers, StorageBinding slot tex : storage)

collectBindings :: [Binding] -> IO DrawBindings
collectBindings bindings = do
  (vUniforms, fUniforms, samplers, storage) <- foldM step ([], [], [], []) bindings
  vUniforms' <- normalizeUniformsIO "vertex uniform" vUniforms
  fUniforms' <- normalizeUniformsIO "fragment uniform" fUniforms
  samplerValues <- normalizeBindingsIO "sampler" (map (\(SamplerBindingSpec slot tex sampler) -> (slot, (tex, sampler))) samplers)
  storageValues <- normalizeBindingsIO "storage texture" (map (\(StorageBinding slot tex) -> (slot, tex)) storage)
  pure DrawBindings
    { dbVertexUniforms = vUniforms'
    , dbFragmentUniforms = fUniforms'
    , dbSamplers = zipWith (\slot (tex, sampler) -> SamplerBindingSpec slot tex sampler) [0..] samplerValues
    , dbStorageTextures = zipWith StorageBinding [0..] storageValues
    }
  where
    step (vAcc, fAcc, sAcc, stAcc) binding =
      case binding of
        BindVertexUniform slot value -> do
          bytes <- bindingValueBytes value
          pure (UniformBinding slot bytes : vAcc, fAcc, sAcc, stAcc)
        BindFragmentUniform slot value -> do
          bytes <- bindingValueBytes value
          pure (vAcc, UniformBinding slot bytes : fAcc, sAcc, stAcc)
        BindFragmentSampler slot tex sampler ->
          pure (vAcc, fAcc, SamplerBindingSpec slot tex sampler : sAcc, stAcc)
        BindFragmentStorageTexture slot tex ->
          pure (vAcc, fAcc, sAcc, StorageBinding slot tex : stAcc)

collectComputeBindings :: [ComputeBinding] -> IO ComputeBindings
collectComputeBindings bindings = do
  (uniforms, samplers, readOnly, readWrite) <- foldM step ([], [], [], []) bindings
  uniforms' <- normalizeUniformsIO "compute uniform" uniforms
  samplerValues <- normalizeBindingsIO "compute sampler" (map (\(SamplerBindingSpec slot tex sampler) -> (slot, (tex, sampler))) samplers)
  readOnlyValues <- normalizeBindingsIO "compute storage texture" (map (\(slot, tex) -> (slot, tex)) readOnly)
  readWriteValues <- normalizeBindingsIO "compute storage texture (rw)" (map (\(slot, tex) -> (slot, tex)) readWrite)
  pure ComputeBindings
    { cbUniforms = uniforms'
    , cbSamplers = zipWith (\slot (tex, sampler) -> SamplerBindingSpec slot tex sampler) [0..] samplerValues
    , cbReadOnlyTextures = readOnlyValues
    , cbReadWriteTextures = readWriteValues
    }
  where
    step (uAcc, sAcc, roAcc, rwAcc) binding =
      case binding of
        ComputeUniform slot value -> do
          bytes <- bindingValueBytes value
          pure (UniformBinding slot bytes : uAcc, sAcc, roAcc, rwAcc)
        ComputeSampler slot tex sampler ->
          pure (uAcc, SamplerBindingSpec slot tex sampler : sAcc, roAcc, rwAcc)
        ComputeStorageTexture slot tex ->
          pure (uAcc, sAcc, (slot, tex) : roAcc, rwAcc)
        ComputeStorageTextureRW slot tex ->
          pure (uAcc, sAcc, roAcc, (slot, tex) : rwAcc)

mergeUniformBindings :: Window -> Shader -> [UniformBinding] -> IO [UniformBinding]
mergeUniformBindings window shader explicit = do
  globals <- readIORef window.appGlobalsUniform
  let implicit =
        case globals of
          Just bytes | shader.shaderUniformBufferCount > 0 -> Map.singleton 0 bytes
          _ -> Map.empty
  let explicitMap = Map.fromList [ (slot, bytes) | UniformBinding slot bytes <- explicit ]
  when (shader.shaderUniformBufferCount == 0 && not (Map.null explicitMap)) $
    throwIO (SlopShaderFailure "bind uniform" "unnamed" Nothing "shader declares no uniform buffers")
  let merged = Map.union explicitMap implicit
  case Map.keys merged of
    [] -> pure ()
    keys ->
      let maxSlot = last keys
          count = shader.shaderUniformBufferCount
      in when (fromIntegral maxSlot >= count) $
        throwIO (SlopShaderFailure "bind uniform" "unnamed" (Just (showText maxSlot)) "binding slot exceeds shader uniform buffer count")
  pure (map (uncurry UniformBinding) (Map.toAscList merged))

normalizeBindings :: String -> [(Word32, a)] -> SlopResult [a]
normalizeBindings label bindings =
  case bindings of
    [] -> Right []
    _ -> do
      let pairs = map (\(slot, value) -> (fromIntegral slot :: Int, value)) bindings
      let mapSlots = Map.fromList pairs
      when (Map.size mapSlots /= length pairs) $
        Left (bindingSlotsError label "duplicate binding slot")
      let slots = Map.keys mapSlots
      let maxSlot = last slots
      let expected = [0 .. maxSlot]
      when (slots /= expected) $
        Left (bindingSlotsError label ("binding slots are not contiguous; expected 0.." <> show maxSlot))
      pure (map snd (Map.toAscList mapSlots))

normalizeBindingsSparse :: String -> [(Word32, a)] -> SlopResult [(Int, a)]
normalizeBindingsSparse label bindings =
  case bindings of
    [] -> Right []
    _ -> do
      let pairs = map (\(slot, value) -> (fromIntegral slot :: Int, value)) bindings
      let mapSlots = Map.fromList pairs
      when (Map.size mapSlots /= length pairs) $
        Left (bindingSlotsError label "duplicate binding slot")
      let slots = Map.keys mapSlots
      pure (map (\slot -> (slot, mapSlots Map.! slot)) slots)

normalizeBindingsIO :: String -> [(Word32, a)] -> IO [a]
normalizeBindingsIO label bindings =
  either throwIO pure (normalizeBindings label bindings)

normalizeBindingsSparseIO :: String -> [(Word32, a)] -> IO [(Int, a)]
normalizeBindingsSparseIO label bindings =
  either throwIO pure (normalizeBindingsSparse label bindings)

normalizeUniforms :: String -> [UniformBinding] -> SlopResult [UniformBinding]
normalizeUniforms label bindings =
  case bindings of
    [] -> Right []
    _ -> do
      let pairs = map (\(UniformBinding slot bytes) -> (slot, bytes)) bindings
      let mapSlots = Map.fromList pairs
      when (Map.size mapSlots /= length pairs) $
        Left (bindingSlotsError label "duplicate binding slot")
      pure (map (uncurry UniformBinding) (Map.toAscList mapSlots))

normalizeUniformsIO :: String -> [UniformBinding] -> IO [UniformBinding]
normalizeUniformsIO label bindings =
  either throwIO pure (normalizeUniforms label bindings)

bindingSlotsError :: String -> String -> SlopError
bindingSlotsError label detail =
  SlopShaderFailure "normalize bindings" "unnamed" (Just (T.pack label)) (T.pack detail)

resolveNamedUniforms :: ShaderBindings -> [NamedUniform] -> IO [ShaderUniform]
resolveNamedUniforms bindings =
  fmap reverse . foldM (step bindings) []
  where
    step table acc entry =
      case entry of
        NamedUniform name value -> do
          slot <- lookupUniformSlot table name
          pure (ShaderUniform slot value : acc)
        NamedUniformBytes name bytes -> do
          slot <- lookupUniformSlot table name
          pure (ShaderUniformBytes slot bytes : acc)
        NamedSampler name tex -> do
          slot <- lookupSamplerSlot table name
          pure (ShaderSampler slot tex : acc)
        NamedSamplerWith name tex sampler -> do
          slot <- lookupSamplerSlot table name
          pure (ShaderSamplerWith slot tex sampler : acc)
        NamedStorageTexture name tex -> do
          slot <- lookupStorageTextureSlot table name
          pure (ShaderStorageTexture slot tex : acc)

resolveReflectedUniforms :: ReflectedShaderLayout -> [NamedUniform] -> SlopResult [ShaderUniform]
resolveReflectedUniforms layout values = do
  (resolved, supplied) <- foldM resolveOne ([], Map.empty) values
  let missing =
        [ binding.reflectedName
        | binding <- Map.elems layout.reflectedShaderBindings
        , not (implicitBinding binding)
        , Map.notMember binding.reflectedName supplied
        ]
  case missing of
    [] -> Right (reverse resolved)
    name : _ -> Left (reflectionError layout.reflectedShaderName (Just name) "required binding was not supplied")
  where
    resolveOne (resolved, supplied) value = do
      let name = namedUniformName value
      when (Map.member name supplied) $
        Left (reflectionError layout.reflectedShaderName (Just name) "binding was supplied more than once")
      binding <- case Map.lookup name layout.reflectedShaderBindings of
        Nothing -> Left (reflectionError layout.reflectedShaderName (Just name) "binding is not present in the reflected layout")
        Just found -> Right found
      result <- resolveValue binding value
      Right (result : resolved, Map.insert name () supplied)
    resolveValue binding value =
      case (binding.reflectedType, value) of
        (ReflectedUniform expectedBytes, NamedUniform _ uniformValue) ->
          if sizeOf uniformValue == expectedBytes
            then Right (ShaderUniform binding.reflectedSlot uniformValue)
            else Left (uniformBindingSizeError binding expectedBytes (sizeOf uniformValue))
        (ReflectedUniform expectedBytes, NamedUniformBytes _ bytes) ->
          if BS.length bytes == expectedBytes
            then Right (ShaderUniformBytes binding.reflectedSlot bytes)
            else Left (uniformBindingSizeError binding expectedBytes (BS.length bytes))
        (ReflectedSampledTexture, NamedSampler _ texture) ->
          Right (ShaderSampler binding.reflectedSlot texture)
        (ReflectedSampledTexture, NamedSamplerWith _ texture sampler) ->
          Right (ShaderSamplerWith binding.reflectedSlot texture sampler)
        (ReflectedStorageTexture {}, NamedStorageTexture _ texture) ->
          Right (ShaderStorageTexture binding.reflectedSlot texture)
        _ -> Left (reflectionError layout.reflectedShaderName (Just binding.reflectedName) ("expected " <> T.pack (show binding.reflectedType) <> ", got " <> namedUniformType value))
    implicitBinding binding =
      binding.reflectedSlot == 0
        && case binding.reflectedType of
          ReflectedUniform {} -> True
          ReflectedSampledTexture -> True
          _ -> False
    uniformBindingSizeError binding expectedBytes actualBytes =
      reflectionError layout.reflectedShaderName (Just binding.reflectedName)
        ("expected " <> showText expectedBytes <> " uniform bytes, got " <> showText actualBytes)

namedUniformName :: NamedUniform -> T.Text
namedUniformName value =
  case value of
    NamedUniform name _ -> T.pack name
    NamedUniformBytes name _ -> T.pack name
    NamedSampler name _ -> T.pack name
    NamedSamplerWith name _ _ -> T.pack name
    NamedStorageTexture name _ -> T.pack name

namedUniformType :: NamedUniform -> T.Text
namedUniformType value =
  case value of
    NamedUniform {} -> "uniform"
    NamedUniformBytes {} -> "uniform bytes"
    NamedSampler {} -> "sampled texture"
    NamedSamplerWith {} -> "sampled texture with sampler"
    NamedStorageTexture {} -> "storage texture"

lookupUniformSlot :: ShaderBindings -> String -> IO Word32
lookupUniformSlot table name =
  case Map.lookup name table.shaderUniformSlots of
    Just slot -> pure slot
    Nothing -> throwIO (SlopShaderFailure "bind uniform" "unnamed" (Just (T.pack name)) "binding name is not present in the shader layout")

lookupSamplerSlot :: ShaderBindings -> String -> IO Word32
lookupSamplerSlot table name =
  case Map.lookup name table.shaderSamplerSlots of
    Just slot -> pure slot
    Nothing -> throwIO (SlopShaderFailure "bind sampler" "unnamed" (Just (T.pack name)) "binding name is not present in the shader layout")

lookupStorageTextureSlot :: ShaderBindings -> String -> IO Word32
lookupStorageTextureSlot table name =
  case Map.lookup name table.shaderStorageTextureSlots of
    Just slot -> pure slot
    Nothing -> throwIO (SlopShaderFailure "bind storage texture" "unnamed" (Just (T.pack name)) "binding name is not present in the shader layout")
evictTextCacheForFontIO :: Window -> Font -> IO ()
evictTextCacheForFontIO window font = do
  let Font fontPtr = font
  stale <- atomicModifyIORef' (window.appRenderState) $ \st ->
    let (keep, dropMap) = Map.partitionWithKey (\(p, _) _ -> p /= castPtr fontPtr) (st.rsTextCache)
        st' = st { rsTextCache = keep }
    in (st', map (\ct -> ct.ctText) (Map.elems dropMap))
  mapM_ ttfDestroyText stale

withShaderBindings :: Shader -> [ShaderUniform] -> WindowM a -> WindowM a
withShaderBindings shader bindings action = do
  collected <- liftIO (collectShaderBindings bindings)
  withShaderBindingsInternalBlend BlendAlpha shader collected Nothing action

withShaderBindingsInternalBlend :: BlendMode -> Shader -> ([UniformBinding], [SamplerBindingSpec], [StorageBinding]) -> Maybe Camera2D -> WindowM a -> WindowM a
withShaderBindingsInternalBlend blend shader (uniforms, samplers, storage) camera action = do
  window <- ask
  merged <- liftIO (mergeUniformBindings window shader uniforms)
  let ctx = ShaderContext shader merged samplers storage blend camera
  liftIO (withShaderContext window ctx (runWindowM window action))

withShader :: Shader -> WindowM a -> WindowM a
withShader shader action = do
  window <- ask
  merged <- liftIO (mergeUniformBindings window shader [])
  let ctx = ShaderContext shader merged [] [] BlendAlpha Nothing
  liftIO (withShaderContext window ctx (runWindowM window action))

defaultVertexSpirv :: ByteString
defaultVertexSpirv = BS.pack
  [ 3, 2, 35, 7, 0, 6, 1, 0, 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0
  , 17, 0, 2, 0, 1, 0, 0, 0, 14, 0, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0
  , 15, 0, 11, 0, 0, 0, 0, 0, 17, 0, 0, 0, 109, 97, 105, 110, 0, 0, 0, 0
  , 6, 0, 0, 0, 7, 0, 0, 0, 9, 0, 0, 0, 11, 0, 0, 0, 13, 0, 0, 0
  , 14, 0, 0, 0, 5, 0, 4, 0, 1, 0, 0, 0, 86, 115, 79, 117, 116, 0, 0, 0
  , 6, 0, 6, 0, 1, 0, 0, 0, 0, 0, 0, 0, 112, 111, 115, 105, 116, 105, 111, 110
  , 0, 0, 0, 0, 6, 0, 4, 0, 1, 0, 0, 0, 1, 0, 0, 0, 117, 118, 0, 0
  , 6, 0, 5, 0, 1, 0, 0, 0, 2, 0, 0, 0, 99, 111, 108, 111, 114, 0, 0, 0
  , 5, 0, 4, 0, 6, 0, 0, 0, 105, 110, 95, 112, 111, 115, 0, 0, 5, 0, 4, 0
  , 7, 0, 0, 0, 105, 110, 95, 117, 118, 0, 0, 0, 5, 0, 5, 0, 9, 0, 0, 0
  , 105, 110, 95, 99, 111, 108, 111, 114, 0, 0, 0, 0, 5, 0, 6, 0, 11, 0, 0, 0
  , 86, 115, 79, 117, 116, 95, 112, 111, 115, 105, 116, 105, 111, 110, 0, 0, 5, 0, 5, 0
  , 13, 0, 0, 0, 86, 115, 79, 117, 116, 95, 117, 118, 0, 0, 0, 0, 5, 0, 5, 0
  , 14, 0, 0, 0, 86, 115, 79, 117, 116, 95, 99, 111, 108, 111, 114, 0, 5, 0, 4, 0
  , 17, 0, 0, 0, 109, 97, 105, 110, 0, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 1, 0, 0, 0, 35, 0, 0, 0, 16, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 2, 0, 0, 0, 35, 0, 0, 0, 32, 0, 0, 0, 71, 0, 4, 0, 6, 0, 0, 0
  , 30, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0, 7, 0, 0, 0, 30, 0, 0, 0
  , 1, 0, 0, 0, 71, 0, 4, 0, 9, 0, 0, 0, 30, 0, 0, 0, 2, 0, 0, 0
  , 71, 0, 4, 0, 11, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0
  , 13, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0, 14, 0, 0, 0
  , 30, 0, 0, 0, 1, 0, 0, 0, 22, 0, 3, 0, 2, 0, 0, 0, 32, 0, 0, 0
  , 23, 0, 4, 0, 3, 0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 23, 0, 4, 0
  , 4, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 30, 0, 5, 0, 1, 0, 0, 0
  , 3, 0, 0, 0, 4, 0, 0, 0, 3, 0, 0, 0, 32, 0, 4, 0, 5, 0, 0, 0
  , 1, 0, 0, 0, 4, 0, 0, 0, 32, 0, 4, 0, 8, 0, 0, 0, 1, 0, 0, 0
  , 3, 0, 0, 0, 32, 0, 4, 0, 10, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0
  , 32, 0, 4, 0, 12, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 19, 0, 2, 0
  , 15, 0, 0, 0, 33, 0, 3, 0, 16, 0, 0, 0, 15, 0, 0, 0, 32, 0, 4, 0
  , 26, 0, 0, 0, 7, 0, 0, 0, 3, 0, 0, 0, 43, 0, 4, 0, 2, 0, 0, 0
  , 23, 0, 0, 0, 0, 0, 0, 0, 43, 0, 4, 0, 2, 0, 0, 0, 24, 0, 0, 0
  , 0, 0, 128, 63, 59, 0, 4, 0, 5, 0, 0, 0, 6, 0, 0, 0, 1, 0, 0, 0
  , 59, 0, 4, 0, 5, 0, 0, 0, 7, 0, 0, 0, 1, 0, 0, 0, 59, 0, 4, 0
  , 8, 0, 0, 0, 9, 0, 0, 0, 1, 0, 0, 0, 59, 0, 4, 0, 10, 0, 0, 0
  , 11, 0, 0, 0, 3, 0, 0, 0, 59, 0, 4, 0, 12, 0, 0, 0, 13, 0, 0, 0
  , 3, 0, 0, 0, 59, 0, 4, 0, 10, 0, 0, 0, 14, 0, 0, 0, 3, 0, 0, 0
  , 54, 0, 5, 0, 15, 0, 0, 0, 17, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0
  , 248, 0, 2, 0, 18, 0, 0, 0, 59, 0, 4, 0, 26, 0, 0, 0, 27, 0, 0, 0
  , 7, 0, 0, 0, 61, 0, 4, 0, 4, 0, 0, 0, 19, 0, 0, 0, 6, 0, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 20, 0, 0, 0, 19, 0, 0, 0, 0, 0, 0, 0
  , 61, 0, 4, 0, 4, 0, 0, 0, 21, 0, 0, 0, 6, 0, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 22, 0, 0, 0, 21, 0, 0, 0, 1, 0, 0, 0, 80, 0, 7, 0
  , 3, 0, 0, 0, 25, 0, 0, 0, 20, 0, 0, 0, 22, 0, 0, 0, 23, 0, 0, 0
  , 24, 0, 0, 0, 62, 0, 3, 0, 27, 0, 0, 0, 25, 0, 0, 0, 61, 0, 4, 0
  , 3, 0, 0, 0, 28, 0, 0, 0, 27, 0, 0, 0, 61, 0, 4, 0, 4, 0, 0, 0
  , 29, 0, 0, 0, 7, 0, 0, 0, 61, 0, 4, 0, 3, 0, 0, 0, 30, 0, 0, 0
  , 9, 0, 0, 0, 80, 0, 6, 0, 1, 0, 0, 0, 31, 0, 0, 0, 28, 0, 0, 0
  , 29, 0, 0, 0, 30, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 32, 0, 0, 0
  , 31, 0, 0, 0, 0, 0, 0, 0, 62, 0, 3, 0, 11, 0, 0, 0, 32, 0, 0, 0
  , 81, 0, 5, 0, 4, 0, 0, 0, 33, 0, 0, 0, 31, 0, 0, 0, 1, 0, 0, 0
  , 62, 0, 3, 0, 13, 0, 0, 0, 33, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 34, 0, 0, 0, 31, 0, 0, 0, 2, 0, 0, 0, 62, 0, 3, 0, 14, 0, 0, 0
  , 34, 0, 0, 0, 253, 0, 1, 0, 56, 0, 1, 0
  ]

defaultVertex3DSpirv :: ByteString
defaultVertex3DSpirv = BS.pack
  [ 3, 2, 35, 7, 0, 6, 1, 0, 0, 0, 0, 0, 62, 0, 0, 0, 0, 0, 0, 0
  , 17, 0, 2, 0, 1, 0, 0, 0, 14, 0, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0
  , 15, 0, 12, 0, 0, 0, 0, 0, 21, 0, 0, 0, 109, 97, 105, 110, 0, 0, 0, 0
  , 8, 0, 0, 0, 10, 0, 0, 0, 12, 0, 0, 0, 13, 0, 0, 0, 15, 0, 0, 0
  , 17, 0, 0, 0, 18, 0, 0, 0, 5, 0, 4, 0, 1, 0, 0, 0, 86, 115, 79, 117, 116, 0, 0, 0
  , 6, 0, 6, 0, 1, 0, 0, 0, 0, 0, 0, 0, 112, 111, 115, 105, 116, 105, 111, 110
  , 0, 0, 0, 0, 6, 0, 4, 0, 1, 0, 0, 0, 1, 0, 0, 0, 117, 118, 0, 0
  , 6, 0, 5, 0, 1, 0, 0, 0, 2, 0, 0, 0, 99, 111, 108, 111, 114, 0, 0, 0
  , 5, 0, 3, 0, 2, 0, 0, 0, 77, 86, 80, 0, 6, 0, 4, 0, 2, 0, 0, 0
  , 0, 0, 0, 0, 109, 0, 0, 0, 5, 0, 4, 0, 8, 0, 0, 0, 117, 77, 86, 80, 0, 0, 0, 0
  , 5, 0, 4, 0, 10, 0, 0, 0, 105, 110, 95, 112, 111, 115, 0, 0, 5, 0, 4, 0
  , 12, 0, 0, 0, 105, 110, 95, 117, 118, 0, 0, 0, 5, 0, 5, 0, 13, 0, 0, 0
  , 105, 110, 95, 99, 111, 108, 111, 114, 0, 0, 0, 0, 5, 0, 6, 0, 15, 0, 0, 0
  , 86, 115, 79, 117, 116, 95, 112, 111, 115, 105, 116, 105, 111, 110, 0, 0
  , 5, 0, 5, 0, 17, 0, 0, 0, 86, 115, 79, 117, 116, 95, 117, 118, 0, 0, 0, 0
  , 5, 0, 5, 0, 18, 0, 0, 0, 86, 115, 79, 117, 116, 95, 99, 111, 108, 111, 114, 0
  , 5, 0, 4, 0, 21, 0, 0, 0, 109, 97, 105, 110, 0, 0, 0, 0, 72, 0, 5, 0
  , 1, 0, 0, 0, 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0, 72, 0, 5, 0
  , 1, 0, 0, 0, 1, 0, 0, 0, 35, 0, 0, 0, 16, 0, 0, 0, 72, 0, 5, 0
  , 1, 0, 0, 0, 2, 0, 0, 0, 35, 0, 0, 0, 32, 0, 0, 0, 72, 0, 5, 0
  , 2, 0, 0, 0, 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0, 71, 0, 3, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 71, 0, 4, 0, 8, 0, 0, 0, 34, 0, 0, 0
  , 0, 0, 0, 0, 71, 0, 4, 0, 8, 0, 0, 0, 33, 0, 0, 0, 0, 0, 0, 0
  , 71, 0, 4, 0, 10, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0
  , 12, 0, 0, 0, 30, 0, 0, 0, 1, 0, 0, 0, 71, 0, 4, 0, 13, 0, 0, 0
  , 30, 0, 0, 0, 2, 0, 0, 0, 71, 0, 4, 0, 15, 0, 0, 0, 11, 0, 0, 0
  , 0, 0, 0, 0, 71, 0, 4, 0, 17, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0
  , 71, 0, 4, 0, 18, 0, 0, 0, 30, 0, 0, 0, 1, 0, 0, 0, 22, 0, 3, 0
  , 3, 0, 0, 0, 32, 0, 0, 0, 23, 0, 4, 0, 4, 0, 0, 0, 3, 0, 0, 0
  , 4, 0, 0, 0, 23, 0, 4, 0, 5, 0, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0
  , 30, 0, 5, 0, 1, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0, 4, 0, 0, 0
  , 24, 0, 4, 0, 6, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 30, 0, 3, 0
  , 2, 0, 0, 0, 6, 0, 0, 0, 32, 0, 4, 0, 7, 0, 0, 0, 2, 0, 0, 0
  , 2, 0, 0, 0, 32, 0, 4, 0, 9, 0, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0
  , 32, 0, 4, 0, 11, 0, 0, 0, 1, 0, 0, 0, 5, 0, 0, 0, 32, 0, 4, 0
  , 14, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 32, 0, 4, 0, 16, 0, 0, 0
  , 3, 0, 0, 0, 5, 0, 0, 0, 19, 0, 2, 0, 19, 0, 0, 0, 33, 0, 3, 0
  , 20, 0, 0, 0, 19, 0, 0, 0, 21, 0, 4, 0, 24, 0, 0, 0, 32, 0, 0, 0
  , 0, 0, 0, 0, 32, 0, 4, 0, 25, 0, 0, 0, 2, 0, 0, 0, 6, 0, 0, 0
  , 21, 0, 4, 0, 28, 0, 0, 0, 32, 0, 0, 0, 1, 0, 0, 0, 32, 0, 4, 0
  , 29, 0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 32, 0, 4, 0, 53, 0, 0, 0
  , 7, 0, 0, 0, 4, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0, 23, 0, 0, 0
  , 0, 0, 0, 0, 43, 0, 4, 0, 28, 0, 0, 0, 27, 0, 0, 0, 0, 0, 0, 0
  , 43, 0, 4, 0, 28, 0, 0, 0, 35, 0, 0, 0, 1, 0, 0, 0, 43, 0, 4, 0
  , 28, 0, 0, 0, 41, 0, 0, 0, 2, 0, 0, 0, 43, 0, 4, 0, 28, 0, 0, 0
  , 47, 0, 0, 0, 3, 0, 0, 0, 59, 0, 4, 0, 7, 0, 0, 0, 8, 0, 0, 0
  , 2, 0, 0, 0, 59, 0, 4, 0, 9, 0, 0, 0, 10, 0, 0, 0, 1, 0, 0, 0
  , 59, 0, 4, 0, 11, 0, 0, 0, 12, 0, 0, 0, 1, 0, 0, 0, 59, 0, 4, 0
  , 9, 0, 0, 0, 13, 0, 0, 0, 1, 0, 0, 0, 59, 0, 4, 0, 14, 0, 0, 0
  , 15, 0, 0, 0, 3, 0, 0, 0, 59, 0, 4, 0, 16, 0, 0, 0, 17, 0, 0, 0
  , 3, 0, 0, 0, 59, 0, 4, 0, 14, 0, 0, 0, 18, 0, 0, 0, 3, 0, 0, 0
  , 54, 0, 5, 0, 19, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0
  , 248, 0, 2, 0, 22, 0, 0, 0, 59, 0, 4, 0, 53, 0, 0, 0, 54, 0, 0, 0
  , 7, 0, 0, 0, 65, 0, 5, 0, 25, 0, 0, 0, 26, 0, 0, 0, 8, 0, 0, 0
  , 23, 0, 0, 0, 65, 0, 5, 0, 29, 0, 0, 0, 30, 0, 0, 0, 26, 0, 0, 0
  , 27, 0, 0, 0, 61, 0, 4, 0, 4, 0, 0, 0, 31, 0, 0, 0, 30, 0, 0, 0
  , 61, 0, 4, 0, 4, 0, 0, 0, 32, 0, 0, 0, 10, 0, 0, 0, 148, 0, 5, 0
  , 3, 0, 0, 0, 33, 0, 0, 0, 31, 0, 0, 0, 32, 0, 0, 0, 65, 0, 5, 0
  , 25, 0, 0, 0, 34, 0, 0, 0, 8, 0, 0, 0, 23, 0, 0, 0, 65, 0, 5, 0
  , 29, 0, 0, 0, 36, 0, 0, 0, 34, 0, 0, 0, 35, 0, 0, 0, 61, 0, 4, 0
  , 4, 0, 0, 0, 37, 0, 0, 0, 36, 0, 0, 0, 61, 0, 4, 0, 4, 0, 0, 0
  , 38, 0, 0, 0, 10, 0, 0, 0, 148, 0, 5, 0, 3, 0, 0, 0, 39, 0, 0, 0
  , 37, 0, 0, 0, 38, 0, 0, 0, 65, 0, 5, 0, 25, 0, 0, 0, 40, 0, 0, 0
  , 8, 0, 0, 0, 23, 0, 0, 0, 65, 0, 5, 0, 29, 0, 0, 0, 42, 0, 0, 0
  , 40, 0, 0, 0, 41, 0, 0, 0, 61, 0, 4, 0, 4, 0, 0, 0, 43, 0, 0, 0
  , 42, 0, 0, 0, 61, 0, 4, 0, 4, 0, 0, 0, 44, 0, 0, 0, 10, 0, 0, 0
  , 148, 0, 5, 0, 3, 0, 0, 0, 45, 0, 0, 0, 43, 0, 0, 0, 44, 0, 0, 0
  , 65, 0, 5, 0, 25, 0, 0, 0, 46, 0, 0, 0, 8, 0, 0, 0, 23, 0, 0, 0
  , 65, 0, 5, 0, 29, 0, 0, 0, 48, 0, 0, 0, 46, 0, 0, 0, 47, 0, 0, 0
  , 61, 0, 4, 0, 4, 0, 0, 0, 49, 0, 0, 0, 48, 0, 0, 0, 61, 0, 4, 0
  , 4, 0, 0, 0, 50, 0, 0, 0, 10, 0, 0, 0, 148, 0, 5, 0, 3, 0, 0, 0
  , 51, 0, 0, 0, 49, 0, 0, 0, 50, 0, 0, 0, 80, 0, 7, 0, 4, 0, 0, 0
  , 52, 0, 0, 0, 33, 0, 0, 0, 39, 0, 0, 0, 45, 0, 0, 0, 51, 0, 0, 0
  , 62, 0, 3, 0, 54, 0, 0, 0, 52, 0, 0, 0, 61, 0, 4, 0, 4, 0, 0, 0
  , 55, 0, 0, 0, 54, 0, 0, 0, 61, 0, 4, 0, 5, 0, 0, 0, 56, 0, 0, 0
  , 12, 0, 0, 0, 61, 0, 4, 0, 4, 0, 0, 0, 57, 0, 0, 0, 13, 0, 0, 0
  , 80, 0, 6, 0, 1, 0, 0, 0, 58, 0, 0, 0, 55, 0, 0, 0, 56, 0, 0, 0
  , 57, 0, 0, 0, 81, 0, 5, 0, 4, 0, 0, 0, 59, 0, 0, 0, 58, 0, 0, 0
  , 0, 0, 0, 0, 62, 0, 3, 0, 15, 0, 0, 0, 59, 0, 0, 0, 81, 0, 5, 0
  , 5, 0, 0, 0, 60, 0, 0, 0, 58, 0, 0, 0, 1, 0, 0, 0, 62, 0, 3, 0
  , 17, 0, 0, 0, 60, 0, 0, 0, 81, 0, 5, 0, 4, 0, 0, 0, 61, 0, 0, 0
  , 58, 0, 0, 0, 2, 0, 0, 0, 62, 0, 3, 0, 18, 0, 0, 0, 61, 0, 0, 0
  , 253, 0, 1, 0, 56, 0, 1, 0
  ]

defaultFragmentSpirv :: ByteString
defaultFragmentSpirv = BS.pack
  [ 3, 2, 35, 7, 0, 6, 1, 0, 0, 0, 0, 0, 31, 0, 0, 0, 0, 0, 0, 0
  , 17, 0, 2, 0, 1, 0, 0, 0, 14, 0, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0
  , 15, 0, 10, 0, 4, 0, 0, 0, 18, 0, 0, 0, 109, 97, 105, 110, 0, 0, 0, 0
  , 4, 0, 0, 0, 7, 0, 0, 0, 10, 0, 0, 0, 13, 0, 0, 0, 15, 0, 0, 0
  , 16, 0, 3, 0, 18, 0, 0, 0, 7, 0, 0, 0, 5, 0, 5, 0, 4, 0, 0, 0
  , 115, 112, 114, 105, 116, 101, 84, 101, 120, 0, 0, 0, 5, 0, 5, 0, 7, 0, 0, 0
  , 115, 112, 114, 105, 116, 101, 83, 97, 109, 112, 0, 0, 5, 0, 3, 0, 10, 0, 0, 0
  , 117, 118, 0, 0, 5, 0, 4, 0, 13, 0, 0, 0, 99, 111, 108, 111, 114, 0, 0, 0
  , 5, 0, 5, 0, 15, 0, 0, 0, 102, 114, 97, 103, 95, 111, 117, 116, 112, 117, 116, 0
  , 5, 0, 4, 0, 18, 0, 0, 0, 109, 97, 105, 110, 0, 0, 0, 0, 71, 0, 4, 0
  , 4, 0, 0, 0, 34, 0, 0, 0, 2, 0, 0, 0, 71, 0, 4, 0, 4, 0, 0, 0
  , 33, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0, 7, 0, 0, 0, 34, 0, 0, 0
  , 2, 0, 0, 0, 71, 0, 4, 0, 7, 0, 0, 0, 33, 0, 0, 0, 1, 0, 0, 0
  , 71, 0, 4, 0, 10, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0
  , 13, 0, 0, 0, 30, 0, 0, 0, 1, 0, 0, 0, 71, 0, 4, 0, 15, 0, 0, 0
  , 30, 0, 0, 0, 0, 0, 0, 0, 22, 0, 3, 0, 1, 0, 0, 0, 32, 0, 0, 0
  , 25, 0, 9, 0, 2, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
  , 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 32, 0, 4, 0
  , 3, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 26, 0, 2, 0, 5, 0, 0, 0
  , 32, 0, 4, 0, 6, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 23, 0, 4, 0
  , 8, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 32, 0, 4, 0, 9, 0, 0, 0
  , 1, 0, 0, 0, 8, 0, 0, 0, 23, 0, 4, 0, 11, 0, 0, 0, 1, 0, 0, 0
  , 4, 0, 0, 0, 32, 0, 4, 0, 12, 0, 0, 0, 1, 0, 0, 0, 11, 0, 0, 0
  , 32, 0, 4, 0, 14, 0, 0, 0, 3, 0, 0, 0, 11, 0, 0, 0, 19, 0, 2, 0
  , 16, 0, 0, 0, 33, 0, 3, 0, 17, 0, 0, 0, 16, 0, 0, 0, 27, 0, 3, 0
  , 23, 0, 0, 0, 2, 0, 0, 0, 32, 0, 4, 0, 26, 0, 0, 0, 7, 0, 0, 0
  , 11, 0, 0, 0, 59, 0, 4, 0, 3, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0
  , 59, 0, 4, 0, 6, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 59, 0, 4, 0
  , 9, 0, 0, 0, 10, 0, 0, 0, 1, 0, 0, 0, 59, 0, 4, 0, 12, 0, 0, 0
  , 13, 0, 0, 0, 1, 0, 0, 0, 59, 0, 4, 0, 14, 0, 0, 0, 15, 0, 0, 0
  , 3, 0, 0, 0, 54, 0, 5, 0, 16, 0, 0, 0, 18, 0, 0, 0, 0, 0, 0, 0
  , 17, 0, 0, 0, 248, 0, 2, 0, 19, 0, 0, 0, 59, 0, 4, 0, 26, 0, 0, 0
  , 27, 0, 0, 0, 7, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 20, 0, 0, 0
  , 4, 0, 0, 0, 61, 0, 4, 0, 5, 0, 0, 0, 21, 0, 0, 0, 7, 0, 0, 0
  , 61, 0, 4, 0, 8, 0, 0, 0, 22, 0, 0, 0, 10, 0, 0, 0, 86, 0, 5, 0
  , 23, 0, 0, 0, 24, 0, 0, 0, 20, 0, 0, 0, 21, 0, 0, 0, 87, 0, 5, 0
  , 11, 0, 0, 0, 25, 0, 0, 0, 24, 0, 0, 0, 22, 0, 0, 0, 62, 0, 3, 0
  , 27, 0, 0, 0, 25, 0, 0, 0, 61, 0, 4, 0, 11, 0, 0, 0, 28, 0, 0, 0
  , 27, 0, 0, 0, 61, 0, 4, 0, 11, 0, 0, 0, 29, 0, 0, 0, 13, 0, 0, 0
  , 133, 0, 5, 0, 11, 0, 0, 0, 30, 0, 0, 0, 28, 0, 0, 0, 29, 0, 0, 0
  , 62, 0, 3, 0, 15, 0, 0, 0, 30, 0, 0, 0, 253, 0, 1, 0, 56, 0, 1, 0
  ]


noise2DComputeSpirv :: ByteString
noise2DComputeSpirv = BS.pack
    [ 3, 2, 35, 7, 0, 6, 1, 0, 0, 0, 0, 0, 215, 4, 0, 0, 0, 0, 0, 0
  , 17, 0, 2, 0, 1, 0, 0, 0, 11, 0, 6, 0, 137, 0, 0, 0, 71, 76, 83, 76
  , 46, 115, 116, 100, 46, 52, 53, 48, 0, 0, 0, 0, 14, 0, 3, 0, 0, 0, 0, 0
  , 1, 0, 0, 0, 15, 0, 8, 0, 5, 0, 0, 0, 52, 4, 0, 0, 109, 97, 105, 110
  , 0, 0, 0, 0, 5, 0, 0, 0, 8, 0, 0, 0, 12, 0, 0, 0, 16, 0, 6, 0
  , 52, 4, 0, 0, 17, 0, 0, 0, 8, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0
  , 5, 0, 4, 0, 1, 0, 0, 0, 80, 97, 114, 97, 109, 115, 0, 0, 6, 0, 5, 0
  , 1, 0, 0, 0, 0, 0, 0, 0, 100, 105, 109, 115, 0, 0, 0, 0, 6, 0, 5, 0
  , 1, 0, 0, 0, 1, 0, 0, 0, 115, 99, 97, 108, 101, 0, 0, 0, 6, 0, 5, 0
  , 1, 0, 0, 0, 2, 0, 0, 0, 101, 120, 116, 114, 97, 115, 0, 0, 6, 0, 5, 0
  , 1, 0, 0, 0, 3, 0, 0, 0, 112, 101, 114, 105, 111, 100, 0, 0, 5, 0, 4, 0
  , 5, 0, 0, 0, 112, 97, 114, 97, 109, 115, 0, 0, 5, 0, 4, 0, 8, 0, 0, 0
  , 111, 117, 116, 95, 116, 101, 120, 0, 5, 0, 3, 0, 12, 0, 0, 0, 103, 105, 100, 0
  , 5, 0, 4, 0, 14, 0, 0, 0, 109, 105, 120, 51, 50, 0, 0, 0, 5, 0, 4, 0
  , 16, 0, 0, 0, 104, 97, 115, 104, 50, 0, 0, 0, 5, 0, 6, 0, 18, 0, 0, 0
  , 115, 109, 111, 111, 116, 104, 115, 116, 101, 112, 48, 49, 0, 0, 0, 0, 5, 0, 4, 0
  , 20, 0, 0, 0, 108, 101, 114, 112, 0, 0, 0, 0, 5, 0, 4, 0, 21, 0, 0, 0
  , 99, 108, 97, 109, 112, 48, 49, 0, 5, 0, 5, 0, 23, 0, 0, 0, 119, 114, 97, 112
  , 73, 110, 100, 101, 120, 0, 0, 0, 5, 0, 5, 0, 26, 0, 0, 0, 119, 114, 97, 112
  , 73, 110, 100, 101, 120, 73, 0, 0, 5, 0, 5, 0, 28, 0, 0, 0, 119, 114, 97, 112
  , 68, 101, 108, 116, 97, 0, 0, 0, 5, 0, 5, 0, 30, 0, 0, 0, 118, 97, 108, 117
  , 101, 78, 111, 105, 115, 101, 50, 0, 5, 0, 4, 0, 33, 0, 0, 0, 103, 114, 97, 100
  , 50, 0, 0, 0, 5, 0, 4, 0, 34, 0, 0, 0, 112, 101, 114, 108, 105, 110, 50, 0
  , 5, 0, 5, 0, 35, 0, 0, 0, 115, 105, 109, 112, 108, 101, 120, 50, 0, 0, 0, 0
  , 5, 0, 5, 0, 36, 0, 0, 0, 115, 105, 109, 112, 108, 101, 120, 50, 98, 0, 0, 0
  , 5, 0, 5, 0, 38, 0, 0, 0, 99, 101, 108, 108, 80, 111, 105, 110, 116, 50, 0, 0
  , 5, 0, 5, 0, 40, 0, 0, 0, 118, 111, 114, 111, 110, 111, 105, 50, 0, 0, 0, 0
  , 5, 0, 4, 0, 42, 0, 0, 0, 110, 111, 105, 115, 101, 50, 0, 0, 5, 0, 5, 0
  , 44, 0, 0, 0, 102, 114, 97, 99, 116, 97, 108, 50, 0, 0, 0, 0, 5, 0, 4, 0
  , 52, 4, 0, 0, 109, 97, 105, 110, 0, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 1, 0, 0, 0, 35, 0, 0, 0, 16, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 2, 0, 0, 0, 35, 0, 0, 0, 32, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 3, 0, 0, 0, 35, 0, 0, 0, 48, 0, 0, 0, 71, 0, 3, 0, 1, 0, 0, 0
  , 2, 0, 0, 0, 71, 0, 4, 0, 5, 0, 0, 0, 34, 0, 0, 0, 2, 0, 0, 0
  , 71, 0, 4, 0, 5, 0, 0, 0, 33, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0
  , 8, 0, 0, 0, 34, 0, 0, 0, 1, 0, 0, 0, 71, 0, 4, 0, 8, 0, 0, 0
  , 33, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0, 12, 0, 0, 0, 11, 0, 0, 0
  , 28, 0, 0, 0, 22, 0, 3, 0, 2, 0, 0, 0, 32, 0, 0, 0, 23, 0, 4, 0
  , 3, 0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 30, 0, 6, 0, 1, 0, 0, 0
  , 3, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 32, 0, 4, 0
  , 4, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 25, 0, 9, 0, 6, 0, 0, 0
  , 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  , 2, 0, 0, 0, 4, 0, 0, 0, 32, 0, 4, 0, 7, 0, 0, 0, 0, 0, 0, 0
  , 6, 0, 0, 0, 21, 0, 4, 0, 9, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0
  , 23, 0, 4, 0, 10, 0, 0, 0, 9, 0, 0, 0, 3, 0, 0, 0, 32, 0, 4, 0
  , 11, 0, 0, 0, 1, 0, 0, 0, 10, 0, 0, 0, 33, 0, 4, 0, 13, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 33, 0, 6, 0, 15, 0, 0, 0, 2, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 33, 0, 4, 0, 17, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 33, 0, 6, 0, 19, 0, 0, 0, 2, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 33, 0, 5, 0, 22, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 21, 0, 4, 0, 24, 0, 0, 0
  , 32, 0, 0, 0, 1, 0, 0, 0, 33, 0, 5, 0, 25, 0, 0, 0, 24, 0, 0, 0
  , 24, 0, 0, 0, 24, 0, 0, 0, 33, 0, 5, 0, 27, 0, 0, 0, 2, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 33, 0, 8, 0, 29, 0, 0, 0, 2, 0, 0, 0
  , 9, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0
  , 23, 0, 4, 0, 31, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 33, 0, 8, 0
  , 32, 0, 0, 0, 31, 0, 0, 0, 9, 0, 0, 0, 24, 0, 0, 0, 24, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 33, 0, 9, 0, 37, 0, 0, 0, 31, 0, 0, 0
  , 9, 0, 0, 0, 2, 0, 0, 0, 24, 0, 0, 0, 24, 0, 0, 0, 9, 0, 0, 0
  , 9, 0, 0, 0, 33, 0, 9, 0, 39, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0
  , 33, 0, 10, 0, 41, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 2, 0, 0, 0
  , 33, 0, 14, 0, 43, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0, 2, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 32, 0, 4, 0
  , 47, 0, 0, 0, 7, 0, 0, 0, 9, 0, 0, 0, 32, 0, 4, 0, 106, 0, 0, 0
  , 7, 0, 0, 0, 2, 0, 0, 0, 20, 0, 2, 0, 147, 0, 0, 0, 32, 0, 4, 0
  , 158, 0, 0, 0, 7, 0, 0, 0, 24, 0, 0, 0, 32, 0, 4, 0, 123, 1, 0, 0
  , 7, 0, 0, 0, 31, 0, 0, 0, 19, 0, 2, 0, 50, 4, 0, 0, 33, 0, 3, 0
  , 51, 4, 0, 0, 50, 4, 0, 0, 23, 0, 4, 0, 209, 4, 0, 0, 24, 0, 0, 0
  , 2, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0, 51, 0, 0, 0, 16, 0, 0, 0
  , 43, 0, 4, 0, 24, 0, 0, 0, 57, 0, 0, 0, 45, 53, 235, 127, 43, 0, 4, 0
  , 24, 0, 0, 0, 62, 0, 0, 0, 15, 0, 0, 0, 43, 0, 4, 0, 9, 0, 0, 0
  , 67, 0, 0, 0, 139, 166, 108, 132, 43, 0, 4, 0, 24, 0, 0, 0, 82, 0, 0, 0
  , 177, 103, 86, 22, 43, 0, 4, 0, 24, 0, 0, 0, 86, 0, 0, 0, 47, 235, 212, 39
  , 43, 0, 4, 0, 24, 0, 0, 0, 91, 0, 0, 0, 129, 199, 253, 85, 43, 0, 4, 0
  , 24, 0, 0, 0, 98, 0, 0, 0, 255, 255, 0, 0, 43, 0, 4, 0, 2, 0, 0, 0
  , 102, 0, 0, 0, 0, 255, 127, 71, 43, 0, 4, 0, 2, 0, 0, 0, 111, 0, 0, 0
  , 0, 0, 64, 64, 43, 0, 4, 0, 2, 0, 0, 0, 112, 0, 0, 0, 0, 0, 0, 64
  , 43, 0, 4, 0, 2, 0, 0, 0, 135, 0, 0, 0, 0, 0, 0, 0, 43, 0, 4, 0
  , 2, 0, 0, 0, 136, 0, 0, 0, 0, 0, 128, 63, 43, 0, 4, 0, 24, 0, 0, 0
  , 145, 0, 0, 0, 0, 0, 0, 0, 43, 0, 4, 0, 2, 0, 0, 0, 205, 0, 0, 0
  , 0, 0, 0, 63, 43, 0, 4, 0, 24, 0, 0, 0, 229, 0, 0, 0, 1, 0, 0, 0
  , 43, 0, 4, 0, 2, 0, 0, 0, 72, 1, 0, 0, 219, 15, 201, 64, 43, 0, 4, 0
  , 2, 0, 0, 0, 238, 1, 0, 0, 175, 103, 187, 62, 43, 0, 4, 0, 2, 0, 0, 0
  , 240, 1, 0, 0, 140, 101, 88, 62, 43, 0, 4, 0, 2, 0, 0, 0, 187, 2, 0, 0
  , 0, 0, 140, 66, 43, 0, 4, 0, 2, 0, 0, 0, 205, 2, 0, 0, 243, 4, 53, 63
  , 43, 0, 4, 0, 24, 0, 0, 0, 220, 2, 0, 0, 17, 5, 0, 0, 43, 0, 4, 0
  , 24, 0, 0, 0, 4, 3, 0, 0, 17, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0
  , 8, 3, 0, 0, 31, 0, 0, 0, 43, 0, 4, 0, 2, 0, 0, 0, 45, 3, 0, 0
  , 40, 107, 110, 78, 43, 0, 4, 0, 2, 0, 0, 0, 122, 3, 0, 0, 243, 4, 181, 63
  , 43, 0, 4, 0, 24, 0, 0, 0, 154, 3, 0, 0, 2, 0, 0, 0, 43, 0, 4, 0
  , 24, 0, 0, 0, 167, 3, 0, 0, 3, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0
  , 181, 3, 0, 0, 4, 0, 0, 0, 43, 0, 4, 0, 2, 0, 0, 0, 81, 4, 0, 0
  , 23, 183, 209, 56, 59, 0, 4, 0, 4, 0, 0, 0, 5, 0, 0, 0, 2, 0, 0, 0
  , 59, 0, 4, 0, 7, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 59, 0, 4, 0
  , 11, 0, 0, 0, 12, 0, 0, 0, 1, 0, 0, 0, 54, 0, 5, 0, 9, 0, 0, 0
  , 14, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 46, 0, 0, 0, 248, 0, 2, 0, 45, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 48, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 55, 0, 0, 0
  , 7, 0, 0, 0, 62, 0, 3, 0, 48, 0, 0, 0, 46, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 49, 0, 0, 0, 48, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 50, 0, 0, 0, 48, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 52, 0, 0, 0
  , 51, 0, 0, 0, 194, 0, 5, 0, 9, 0, 0, 0, 53, 0, 0, 0, 50, 0, 0, 0
  , 52, 0, 0, 0, 198, 0, 5, 0, 9, 0, 0, 0, 54, 0, 0, 0, 49, 0, 0, 0
  , 53, 0, 0, 0, 62, 0, 3, 0, 55, 0, 0, 0, 54, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 56, 0, 0, 0, 55, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 58, 0, 0, 0, 57, 0, 0, 0, 132, 0, 5, 0, 9, 0, 0, 0, 59, 0, 0, 0
  , 56, 0, 0, 0, 58, 0, 0, 0, 62, 0, 3, 0, 55, 0, 0, 0, 59, 0, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 60, 0, 0, 0, 55, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 61, 0, 0, 0, 55, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 63, 0, 0, 0, 62, 0, 0, 0, 194, 0, 5, 0, 9, 0, 0, 0, 64, 0, 0, 0
  , 61, 0, 0, 0, 63, 0, 0, 0, 198, 0, 5, 0, 9, 0, 0, 0, 65, 0, 0, 0
  , 60, 0, 0, 0, 64, 0, 0, 0, 62, 0, 3, 0, 55, 0, 0, 0, 65, 0, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 66, 0, 0, 0, 55, 0, 0, 0, 132, 0, 5, 0
  , 9, 0, 0, 0, 68, 0, 0, 0, 66, 0, 0, 0, 67, 0, 0, 0, 62, 0, 3, 0
  , 55, 0, 0, 0, 68, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 69, 0, 0, 0
  , 55, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 70, 0, 0, 0, 55, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 71, 0, 0, 0, 51, 0, 0, 0, 194, 0, 5, 0
  , 9, 0, 0, 0, 72, 0, 0, 0, 70, 0, 0, 0, 71, 0, 0, 0, 198, 0, 5, 0
  , 9, 0, 0, 0, 73, 0, 0, 0, 69, 0, 0, 0, 72, 0, 0, 0, 254, 0, 2, 0
  , 73, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0, 16, 0, 0, 0
  , 0, 0, 0, 0, 15, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 75, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 77, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 79, 0, 0, 0, 248, 0, 2, 0, 74, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 76, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 78, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 80, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 96, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 76, 0, 0, 0, 75, 0, 0, 0, 62, 0, 3, 0, 78, 0, 0, 0, 77, 0, 0, 0
  , 62, 0, 3, 0, 80, 0, 0, 0, 79, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 81, 0, 0, 0, 78, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 83, 0, 0, 0
  , 82, 0, 0, 0, 132, 0, 5, 0, 9, 0, 0, 0, 84, 0, 0, 0, 81, 0, 0, 0
  , 83, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 85, 0, 0, 0, 80, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 87, 0, 0, 0, 86, 0, 0, 0, 132, 0, 5, 0
  , 9, 0, 0, 0, 88, 0, 0, 0, 85, 0, 0, 0, 87, 0, 0, 0, 128, 0, 5, 0
  , 9, 0, 0, 0, 89, 0, 0, 0, 84, 0, 0, 0, 88, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 90, 0, 0, 0, 76, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 92, 0, 0, 0, 91, 0, 0, 0, 132, 0, 5, 0, 9, 0, 0, 0, 93, 0, 0, 0
  , 90, 0, 0, 0, 92, 0, 0, 0, 128, 0, 5, 0, 9, 0, 0, 0, 94, 0, 0, 0
  , 89, 0, 0, 0, 93, 0, 0, 0, 57, 0, 5, 0, 9, 0, 0, 0, 95, 0, 0, 0
  , 14, 0, 0, 0, 94, 0, 0, 0, 62, 0, 3, 0, 96, 0, 0, 0, 95, 0, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 97, 0, 0, 0, 96, 0, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 99, 0, 0, 0, 98, 0, 0, 0, 199, 0, 5, 0, 9, 0, 0, 0
  , 100, 0, 0, 0, 97, 0, 0, 0, 99, 0, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0
  , 101, 0, 0, 0, 100, 0, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0, 103, 0, 0, 0
  , 101, 0, 0, 0, 102, 0, 0, 0, 254, 0, 2, 0, 103, 0, 0, 0, 56, 0, 1, 0
  , 54, 0, 5, 0, 2, 0, 0, 0, 18, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 105, 0, 0, 0, 248, 0, 2, 0, 104, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 107, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 107, 0, 0, 0, 105, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 108, 0, 0, 0
  , 107, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 109, 0, 0, 0, 107, 0, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 110, 0, 0, 0, 108, 0, 0, 0, 109, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 113, 0, 0, 0, 107, 0, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 114, 0, 0, 0, 112, 0, 0, 0, 113, 0, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 115, 0, 0, 0, 111, 0, 0, 0, 114, 0, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 116, 0, 0, 0, 110, 0, 0, 0, 115, 0, 0, 0, 254, 0, 2, 0
  , 116, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0, 20, 0, 0, 0
  , 0, 0, 0, 0, 19, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 118, 0, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 120, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 122, 0, 0, 0, 248, 0, 2, 0, 117, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 119, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 121, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 123, 0, 0, 0, 7, 0, 0, 0
  , 62, 0, 3, 0, 119, 0, 0, 0, 118, 0, 0, 0, 62, 0, 3, 0, 121, 0, 0, 0
  , 120, 0, 0, 0, 62, 0, 3, 0, 123, 0, 0, 0, 122, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 124, 0, 0, 0, 119, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 125, 0, 0, 0, 121, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 126, 0, 0, 0
  , 119, 0, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 127, 0, 0, 0, 125, 0, 0, 0
  , 126, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 128, 0, 0, 0, 123, 0, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 129, 0, 0, 0, 127, 0, 0, 0, 128, 0, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 130, 0, 0, 0, 124, 0, 0, 0, 129, 0, 0, 0
  , 254, 0, 2, 0, 130, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0
  , 21, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 132, 0, 0, 0, 248, 0, 2, 0, 131, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 133, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 133, 0, 0, 0, 132, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 134, 0, 0, 0, 133, 0, 0, 0, 12, 0, 8, 0
  , 2, 0, 0, 0, 138, 0, 0, 0, 137, 0, 0, 0, 43, 0, 0, 0, 134, 0, 0, 0
  , 135, 0, 0, 0, 136, 0, 0, 0, 254, 0, 2, 0, 138, 0, 0, 0, 56, 0, 1, 0
  , 54, 0, 5, 0, 9, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 140, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 142, 0, 0, 0, 248, 0, 2, 0, 139, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 141, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 143, 0, 0, 0
  , 7, 0, 0, 0, 62, 0, 3, 0, 141, 0, 0, 0, 140, 0, 0, 0, 62, 0, 3, 0
  , 143, 0, 0, 0, 142, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 144, 0, 0, 0
  , 143, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 146, 0, 0, 0, 145, 0, 0, 0
  , 170, 0, 5, 0, 147, 0, 0, 0, 148, 0, 0, 0, 144, 0, 0, 0, 146, 0, 0, 0
  , 247, 0, 3, 0, 151, 0, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 148, 0, 0, 0
  , 149, 0, 0, 0, 150, 0, 0, 0, 248, 0, 2, 0, 149, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 152, 0, 0, 0, 141, 0, 0, 0, 254, 0, 2, 0, 152, 0, 0, 0
  , 248, 0, 2, 0, 150, 0, 0, 0, 249, 0, 2, 0, 151, 0, 0, 0, 248, 0, 2, 0
  , 151, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 153, 0, 0, 0, 141, 0, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 154, 0, 0, 0, 143, 0, 0, 0, 137, 0, 5, 0
  , 9, 0, 0, 0, 155, 0, 0, 0, 153, 0, 0, 0, 154, 0, 0, 0, 254, 0, 2, 0
  , 155, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 24, 0, 0, 0, 26, 0, 0, 0
  , 0, 0, 0, 0, 25, 0, 0, 0, 55, 0, 3, 0, 24, 0, 0, 0, 157, 0, 0, 0
  , 55, 0, 3, 0, 24, 0, 0, 0, 160, 0, 0, 0, 248, 0, 2, 0, 156, 0, 0, 0
  , 59, 0, 4, 0, 158, 0, 0, 0, 159, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 158, 0, 0, 0, 161, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0
  , 171, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 159, 0, 0, 0, 157, 0, 0, 0
  , 62, 0, 3, 0, 161, 0, 0, 0, 160, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 162, 0, 0, 0, 161, 0, 0, 0, 179, 0, 5, 0, 147, 0, 0, 0, 163, 0, 0, 0
  , 162, 0, 0, 0, 145, 0, 0, 0, 247, 0, 3, 0, 166, 0, 0, 0, 0, 0, 0, 0
  , 250, 0, 4, 0, 163, 0, 0, 0, 164, 0, 0, 0, 165, 0, 0, 0, 248, 0, 2, 0
  , 164, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 167, 0, 0, 0, 159, 0, 0, 0
  , 254, 0, 2, 0, 167, 0, 0, 0, 248, 0, 2, 0, 165, 0, 0, 0, 249, 0, 2, 0
  , 166, 0, 0, 0, 248, 0, 2, 0, 166, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 168, 0, 0, 0, 159, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 169, 0, 0, 0
  , 161, 0, 0, 0, 138, 0, 5, 0, 24, 0, 0, 0, 170, 0, 0, 0, 168, 0, 0, 0
  , 169, 0, 0, 0, 62, 0, 3, 0, 171, 0, 0, 0, 170, 0, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 172, 0, 0, 0, 171, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 173, 0, 0, 0, 171, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 174, 0, 0, 0
  , 161, 0, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 175, 0, 0, 0, 173, 0, 0, 0
  , 174, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 176, 0, 0, 0, 171, 0, 0, 0
  , 177, 0, 5, 0, 147, 0, 0, 0, 177, 0, 0, 0, 176, 0, 0, 0, 145, 0, 0, 0
  , 169, 0, 6, 0, 24, 0, 0, 0, 178, 0, 0, 0, 177, 0, 0, 0, 175, 0, 0, 0
  , 172, 0, 0, 0, 254, 0, 2, 0, 178, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 28, 0, 0, 0, 0, 0, 0, 0, 27, 0, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 180, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 182, 0, 0, 0
  , 248, 0, 2, 0, 179, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 181, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 183, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 198, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 181, 0, 0, 0, 180, 0, 0, 0, 62, 0, 3, 0, 183, 0, 0, 0, 182, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 184, 0, 0, 0, 183, 0, 0, 0, 188, 0, 5, 0
  , 147, 0, 0, 0, 185, 0, 0, 0, 184, 0, 0, 0, 135, 0, 0, 0, 247, 0, 3, 0
  , 188, 0, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 185, 0, 0, 0, 186, 0, 0, 0
  , 187, 0, 0, 0, 248, 0, 2, 0, 186, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 189, 0, 0, 0, 181, 0, 0, 0, 254, 0, 2, 0, 189, 0, 0, 0, 248, 0, 2, 0
  , 187, 0, 0, 0, 249, 0, 2, 0, 188, 0, 0, 0, 248, 0, 2, 0, 188, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 190, 0, 0, 0, 181, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 191, 0, 0, 0, 183, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 192, 0, 0, 0, 181, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 193, 0, 0, 0
  , 183, 0, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0, 194, 0, 0, 0, 192, 0, 0, 0
  , 193, 0, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 195, 0, 0, 0, 137, 0, 0, 0
  , 8, 0, 0, 0, 194, 0, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 196, 0, 0, 0
  , 191, 0, 0, 0, 195, 0, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 197, 0, 0, 0
  , 190, 0, 0, 0, 196, 0, 0, 0, 62, 0, 3, 0, 198, 0, 0, 0, 197, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 199, 0, 0, 0, 198, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 200, 0, 0, 0, 198, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 201, 0, 0, 0, 183, 0, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 202, 0, 0, 0
  , 200, 0, 0, 0, 201, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 203, 0, 0, 0
  , 198, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 204, 0, 0, 0, 183, 0, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 206, 0, 0, 0, 204, 0, 0, 0, 205, 0, 0, 0
  , 186, 0, 5, 0, 147, 0, 0, 0, 207, 0, 0, 0, 203, 0, 0, 0, 206, 0, 0, 0
  , 169, 0, 6, 0, 2, 0, 0, 0, 208, 0, 0, 0, 207, 0, 0, 0, 202, 0, 0, 0
  , 199, 0, 0, 0, 254, 0, 2, 0, 208, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 29, 0, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 210, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 212, 0, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 214, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 216, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 218, 0, 0, 0, 248, 0, 2, 0
  , 209, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 211, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 213, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 215, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 217, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 219, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0, 223, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 158, 0, 0, 0, 227, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 158, 0, 0, 0, 231, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0
  , 234, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 240, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 246, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 1, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 12, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 23, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 34, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 39, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 44, 1, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 211, 0, 0, 0, 210, 0, 0, 0, 62, 0, 3, 0, 213, 0, 0, 0, 212, 0, 0, 0
  , 62, 0, 3, 0, 215, 0, 0, 0, 214, 0, 0, 0, 62, 0, 3, 0, 217, 0, 0, 0
  , 216, 0, 0, 0, 62, 0, 3, 0, 219, 0, 0, 0, 218, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 220, 0, 0, 0, 213, 0, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 221, 0, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0, 220, 0, 0, 0, 110, 0, 4, 0
  , 24, 0, 0, 0, 222, 0, 0, 0, 221, 0, 0, 0, 62, 0, 3, 0, 223, 0, 0, 0
  , 222, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 224, 0, 0, 0, 215, 0, 0, 0
  , 12, 0, 6, 0, 2, 0, 0, 0, 225, 0, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0
  , 224, 0, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0, 226, 0, 0, 0, 225, 0, 0, 0
  , 62, 0, 3, 0, 227, 0, 0, 0, 226, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 228, 0, 0, 0, 223, 0, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 230, 0, 0, 0
  , 228, 0, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0, 231, 0, 0, 0, 230, 0, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 232, 0, 0, 0, 227, 0, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 233, 0, 0, 0, 232, 0, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0
  , 234, 0, 0, 0, 233, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 235, 0, 0, 0
  , 213, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 236, 0, 0, 0, 223, 0, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 237, 0, 0, 0, 236, 0, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 238, 0, 0, 0, 235, 0, 0, 0, 237, 0, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 239, 0, 0, 0, 18, 0, 0, 0, 238, 0, 0, 0, 62, 0, 3, 0
  , 240, 0, 0, 0, 239, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 241, 0, 0, 0
  , 215, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 242, 0, 0, 0, 227, 0, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 243, 0, 0, 0, 242, 0, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 244, 0, 0, 0, 241, 0, 0, 0, 243, 0, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 245, 0, 0, 0, 18, 0, 0, 0, 244, 0, 0, 0, 62, 0, 3, 0
  , 246, 0, 0, 0, 245, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 247, 0, 0, 0
  , 211, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 248, 0, 0, 0, 223, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 249, 0, 0, 0, 248, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 250, 0, 0, 0, 217, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 251, 0, 0, 0, 23, 0, 0, 0, 249, 0, 0, 0, 250, 0, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 252, 0, 0, 0, 227, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 253, 0, 0, 0, 252, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 254, 0, 0, 0
  , 219, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 255, 0, 0, 0, 23, 0, 0, 0
  , 253, 0, 0, 0, 254, 0, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 0, 1, 0, 0
  , 16, 0, 0, 0, 247, 0, 0, 0, 251, 0, 0, 0, 255, 0, 0, 0, 62, 0, 3, 0
  , 1, 1, 0, 0, 0, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 2, 1, 0, 0
  , 211, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 3, 1, 0, 0, 231, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 4, 1, 0, 0, 3, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 5, 1, 0, 0, 217, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 6, 1, 0, 0, 23, 0, 0, 0, 4, 1, 0, 0, 5, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 7, 1, 0, 0, 227, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 8, 1, 0, 0, 7, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 9, 1, 0, 0
  , 219, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 10, 1, 0, 0, 23, 0, 0, 0
  , 8, 1, 0, 0, 9, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 11, 1, 0, 0
  , 16, 0, 0, 0, 2, 1, 0, 0, 6, 1, 0, 0, 10, 1, 0, 0, 62, 0, 3, 0
  , 12, 1, 0, 0, 11, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 13, 1, 0, 0
  , 211, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 14, 1, 0, 0, 223, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 15, 1, 0, 0, 14, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 16, 1, 0, 0, 217, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 17, 1, 0, 0, 23, 0, 0, 0, 15, 1, 0, 0, 16, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 18, 1, 0, 0, 234, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 19, 1, 0, 0, 18, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 20, 1, 0, 0
  , 219, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 21, 1, 0, 0, 23, 0, 0, 0
  , 19, 1, 0, 0, 20, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 22, 1, 0, 0
  , 16, 0, 0, 0, 13, 1, 0, 0, 17, 1, 0, 0, 21, 1, 0, 0, 62, 0, 3, 0
  , 23, 1, 0, 0, 22, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 24, 1, 0, 0
  , 211, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 25, 1, 0, 0, 231, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 26, 1, 0, 0, 25, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 27, 1, 0, 0, 217, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 28, 1, 0, 0, 23, 0, 0, 0, 26, 1, 0, 0, 27, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 29, 1, 0, 0, 234, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 30, 1, 0, 0, 29, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 31, 1, 0, 0
  , 219, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 32, 1, 0, 0, 23, 0, 0, 0
  , 30, 1, 0, 0, 31, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 33, 1, 0, 0
  , 16, 0, 0, 0, 24, 1, 0, 0, 28, 1, 0, 0, 32, 1, 0, 0, 62, 0, 3, 0
  , 34, 1, 0, 0, 33, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 35, 1, 0, 0
  , 1, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 36, 1, 0, 0, 12, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 37, 1, 0, 0, 240, 0, 0, 0, 57, 0, 7, 0
  , 2, 0, 0, 0, 38, 1, 0, 0, 20, 0, 0, 0, 35, 1, 0, 0, 36, 1, 0, 0
  , 37, 1, 0, 0, 62, 0, 3, 0, 39, 1, 0, 0, 38, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 40, 1, 0, 0, 23, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 41, 1, 0, 0, 34, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 42, 1, 0, 0
  , 240, 0, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 43, 1, 0, 0, 20, 0, 0, 0
  , 40, 1, 0, 0, 41, 1, 0, 0, 42, 1, 0, 0, 62, 0, 3, 0, 44, 1, 0, 0
  , 43, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 45, 1, 0, 0, 39, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 46, 1, 0, 0, 44, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 47, 1, 0, 0, 246, 0, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0
  , 48, 1, 0, 0, 20, 0, 0, 0, 45, 1, 0, 0, 46, 1, 0, 0, 47, 1, 0, 0
  , 254, 0, 2, 0, 48, 1, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 31, 0, 0, 0
  , 33, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 50, 1, 0, 0, 55, 0, 3, 0, 24, 0, 0, 0, 52, 1, 0, 0, 55, 0, 3, 0
  , 24, 0, 0, 0, 54, 1, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 56, 1, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 58, 1, 0, 0, 248, 0, 2, 0, 49, 1, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 51, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 158, 0, 0, 0, 53, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0
  , 55, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 57, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 59, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 70, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 74, 1, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 51, 1, 0, 0
  , 50, 1, 0, 0, 62, 0, 3, 0, 53, 1, 0, 0, 52, 1, 0, 0, 62, 0, 3, 0
  , 55, 1, 0, 0, 54, 1, 0, 0, 62, 0, 3, 0, 57, 1, 0, 0, 56, 1, 0, 0
  , 62, 0, 3, 0, 59, 1, 0, 0, 58, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 60, 1, 0, 0, 51, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 61, 1, 0, 0
  , 53, 1, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 62, 1, 0, 0, 61, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 63, 1, 0, 0, 57, 1, 0, 0, 57, 0, 6, 0
  , 9, 0, 0, 0, 64, 1, 0, 0, 23, 0, 0, 0, 62, 1, 0, 0, 63, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 65, 1, 0, 0, 55, 1, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 66, 1, 0, 0, 65, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 67, 1, 0, 0, 59, 1, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 68, 1, 0, 0
  , 23, 0, 0, 0, 66, 1, 0, 0, 67, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0
  , 69, 1, 0, 0, 16, 0, 0, 0, 60, 1, 0, 0, 64, 1, 0, 0, 68, 1, 0, 0
  , 62, 0, 3, 0, 70, 1, 0, 0, 69, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 71, 1, 0, 0, 70, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 73, 1, 0, 0
  , 71, 1, 0, 0, 72, 1, 0, 0, 62, 0, 3, 0, 74, 1, 0, 0, 73, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 75, 1, 0, 0, 74, 1, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 76, 1, 0, 0, 137, 0, 0, 0, 14, 0, 0, 0, 75, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 77, 1, 0, 0, 74, 1, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 78, 1, 0, 0, 137, 0, 0, 0, 13, 0, 0, 0, 77, 1, 0, 0
  , 80, 0, 5, 0, 31, 0, 0, 0, 79, 1, 0, 0, 76, 1, 0, 0, 78, 1, 0, 0
  , 254, 0, 2, 0, 79, 1, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0
  , 34, 0, 0, 0, 0, 0, 0, 0, 29, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 81, 1, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 83, 1, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 85, 1, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 87, 1, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 89, 1, 0, 0, 248, 0, 2, 0, 80, 1, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 82, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 84, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 86, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 88, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 90, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 158, 0, 0, 0, 94, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 158, 0, 0, 0, 98, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0
  , 101, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0, 104, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 110, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 116, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 123, 1, 0, 0, 124, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 123, 1, 0, 0
  , 131, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 123, 1, 0, 0, 138, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 123, 1, 0, 0, 145, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 161, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 177, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 193, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 209, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 214, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 219, 1, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 82, 1, 0, 0, 81, 1, 0, 0, 62, 0, 3, 0, 84, 1, 0, 0, 83, 1, 0, 0
  , 62, 0, 3, 0, 86, 1, 0, 0, 85, 1, 0, 0, 62, 0, 3, 0, 88, 1, 0, 0
  , 87, 1, 0, 0, 62, 0, 3, 0, 90, 1, 0, 0, 89, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 91, 1, 0, 0, 84, 1, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 92, 1, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0, 91, 1, 0, 0, 110, 0, 4, 0
  , 24, 0, 0, 0, 93, 1, 0, 0, 92, 1, 0, 0, 62, 0, 3, 0, 94, 1, 0, 0
  , 93, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 95, 1, 0, 0, 86, 1, 0, 0
  , 12, 0, 6, 0, 2, 0, 0, 0, 96, 1, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0
  , 95, 1, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0, 97, 1, 0, 0, 96, 1, 0, 0
  , 62, 0, 3, 0, 98, 1, 0, 0, 97, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 99, 1, 0, 0, 94, 1, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 100, 1, 0, 0
  , 99, 1, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0, 101, 1, 0, 0, 100, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 102, 1, 0, 0, 98, 1, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 103, 1, 0, 0, 102, 1, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0
  , 104, 1, 0, 0, 103, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 105, 1, 0, 0
  , 84, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 106, 1, 0, 0, 94, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 107, 1, 0, 0, 106, 1, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 108, 1, 0, 0, 105, 1, 0, 0, 107, 1, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 109, 1, 0, 0, 18, 0, 0, 0, 108, 1, 0, 0, 62, 0, 3, 0
  , 110, 1, 0, 0, 109, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 111, 1, 0, 0
  , 86, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 112, 1, 0, 0, 98, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 113, 1, 0, 0, 112, 1, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 114, 1, 0, 0, 111, 1, 0, 0, 113, 1, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 115, 1, 0, 0, 18, 0, 0, 0, 114, 1, 0, 0, 62, 0, 3, 0
  , 116, 1, 0, 0, 115, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 117, 1, 0, 0
  , 82, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 118, 1, 0, 0, 94, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 119, 1, 0, 0, 98, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 120, 1, 0, 0, 88, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 121, 1, 0, 0, 90, 1, 0, 0, 57, 0, 9, 0, 31, 0, 0, 0, 122, 1, 0, 0
  , 33, 0, 0, 0, 117, 1, 0, 0, 118, 1, 0, 0, 119, 1, 0, 0, 120, 1, 0, 0
  , 121, 1, 0, 0, 62, 0, 3, 0, 124, 1, 0, 0, 122, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 125, 1, 0, 0, 82, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 126, 1, 0, 0, 101, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 127, 1, 0, 0
  , 98, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 128, 1, 0, 0, 88, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 129, 1, 0, 0, 90, 1, 0, 0, 57, 0, 9, 0
  , 31, 0, 0, 0, 130, 1, 0, 0, 33, 0, 0, 0, 125, 1, 0, 0, 126, 1, 0, 0
  , 127, 1, 0, 0, 128, 1, 0, 0, 129, 1, 0, 0, 62, 0, 3, 0, 131, 1, 0, 0
  , 130, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 132, 1, 0, 0, 82, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 133, 1, 0, 0, 94, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 134, 1, 0, 0, 104, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 135, 1, 0, 0, 88, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 136, 1, 0, 0
  , 90, 1, 0, 0, 57, 0, 9, 0, 31, 0, 0, 0, 137, 1, 0, 0, 33, 0, 0, 0
  , 132, 1, 0, 0, 133, 1, 0, 0, 134, 1, 0, 0, 135, 1, 0, 0, 136, 1, 0, 0
  , 62, 0, 3, 0, 138, 1, 0, 0, 137, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 139, 1, 0, 0, 82, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 140, 1, 0, 0
  , 101, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 141, 1, 0, 0, 104, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 142, 1, 0, 0, 88, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 143, 1, 0, 0, 90, 1, 0, 0, 57, 0, 9, 0, 31, 0, 0, 0
  , 144, 1, 0, 0, 33, 0, 0, 0, 139, 1, 0, 0, 140, 1, 0, 0, 141, 1, 0, 0
  , 142, 1, 0, 0, 143, 1, 0, 0, 62, 0, 3, 0, 145, 1, 0, 0, 144, 1, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 146, 1, 0, 0, 124, 1, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 147, 1, 0, 0, 146, 1, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 148, 1, 0, 0, 84, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 149, 1, 0, 0, 94, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 150, 1, 0, 0
  , 149, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 151, 1, 0, 0, 148, 1, 0, 0
  , 150, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 152, 1, 0, 0, 147, 1, 0, 0
  , 151, 1, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 153, 1, 0, 0, 124, 1, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 154, 1, 0, 0, 153, 1, 0, 0, 1, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 155, 1, 0, 0, 86, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 156, 1, 0, 0, 98, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 157, 1, 0, 0, 156, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 158, 1, 0, 0
  , 155, 1, 0, 0, 157, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 159, 1, 0, 0
  , 154, 1, 0, 0, 158, 1, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 160, 1, 0, 0
  , 152, 1, 0, 0, 159, 1, 0, 0, 62, 0, 3, 0, 161, 1, 0, 0, 160, 1, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 162, 1, 0, 0, 131, 1, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 163, 1, 0, 0, 162, 1, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 164, 1, 0, 0, 84, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 165, 1, 0, 0, 101, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 166, 1, 0, 0
  , 165, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 167, 1, 0, 0, 164, 1, 0, 0
  , 166, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 168, 1, 0, 0, 163, 1, 0, 0
  , 167, 1, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 169, 1, 0, 0, 131, 1, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 170, 1, 0, 0, 169, 1, 0, 0, 1, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 171, 1, 0, 0, 86, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 172, 1, 0, 0, 98, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 173, 1, 0, 0, 172, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 174, 1, 0, 0
  , 171, 1, 0, 0, 173, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 175, 1, 0, 0
  , 170, 1, 0, 0, 174, 1, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 176, 1, 0, 0
  , 168, 1, 0, 0, 175, 1, 0, 0, 62, 0, 3, 0, 177, 1, 0, 0, 176, 1, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 178, 1, 0, 0, 138, 1, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 179, 1, 0, 0, 178, 1, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 180, 1, 0, 0, 84, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 181, 1, 0, 0, 94, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 182, 1, 0, 0
  , 181, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 183, 1, 0, 0, 180, 1, 0, 0
  , 182, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 184, 1, 0, 0, 179, 1, 0, 0
  , 183, 1, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 185, 1, 0, 0, 138, 1, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 186, 1, 0, 0, 185, 1, 0, 0, 1, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 187, 1, 0, 0, 86, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 188, 1, 0, 0, 104, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 189, 1, 0, 0, 188, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 190, 1, 0, 0
  , 187, 1, 0, 0, 189, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 191, 1, 0, 0
  , 186, 1, 0, 0, 190, 1, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 192, 1, 0, 0
  , 184, 1, 0, 0, 191, 1, 0, 0, 62, 0, 3, 0, 193, 1, 0, 0, 192, 1, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 194, 1, 0, 0, 145, 1, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 195, 1, 0, 0, 194, 1, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 196, 1, 0, 0, 84, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 197, 1, 0, 0, 101, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 198, 1, 0, 0
  , 197, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 199, 1, 0, 0, 196, 1, 0, 0
  , 198, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 200, 1, 0, 0, 195, 1, 0, 0
  , 199, 1, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 201, 1, 0, 0, 145, 1, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 202, 1, 0, 0, 201, 1, 0, 0, 1, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 203, 1, 0, 0, 86, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 204, 1, 0, 0, 104, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 205, 1, 0, 0, 204, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 206, 1, 0, 0
  , 203, 1, 0, 0, 205, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 207, 1, 0, 0
  , 202, 1, 0, 0, 206, 1, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 208, 1, 0, 0
  , 200, 1, 0, 0, 207, 1, 0, 0, 62, 0, 3, 0, 209, 1, 0, 0, 208, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 210, 1, 0, 0, 161, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 211, 1, 0, 0, 177, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 212, 1, 0, 0, 110, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 213, 1, 0, 0
  , 20, 0, 0, 0, 210, 1, 0, 0, 211, 1, 0, 0, 212, 1, 0, 0, 62, 0, 3, 0
  , 214, 1, 0, 0, 213, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 215, 1, 0, 0
  , 193, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 216, 1, 0, 0, 209, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 217, 1, 0, 0, 110, 1, 0, 0, 57, 0, 7, 0
  , 2, 0, 0, 0, 218, 1, 0, 0, 20, 0, 0, 0, 215, 1, 0, 0, 216, 1, 0, 0
  , 217, 1, 0, 0, 62, 0, 3, 0, 219, 1, 0, 0, 218, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 220, 1, 0, 0, 214, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 221, 1, 0, 0, 219, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 222, 1, 0, 0
  , 116, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 223, 1, 0, 0, 20, 0, 0, 0
  , 220, 1, 0, 0, 221, 1, 0, 0, 222, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 224, 1, 0, 0, 223, 1, 0, 0, 205, 0, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 225, 1, 0, 0, 224, 1, 0, 0, 205, 0, 0, 0, 57, 0, 5, 0, 2, 0, 0, 0
  , 226, 1, 0, 0, 21, 0, 0, 0, 225, 1, 0, 0, 254, 0, 2, 0, 226, 1, 0, 0
  , 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0
  , 29, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 228, 1, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 230, 1, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 232, 1, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 234, 1, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 236, 1, 0, 0, 248, 0, 2, 0, 227, 1, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 229, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 231, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 233, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 235, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 237, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 239, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 241, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 247, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 158, 0, 0, 0, 253, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 158, 0, 0, 0, 3, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 10, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 17, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 24, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 158, 0, 0, 0, 25, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 158, 0, 0, 0, 26, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 39, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 46, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 52, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 58, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 59, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 60, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 61, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 70, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 123, 1, 0, 0, 82, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 86, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 108, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 123, 1, 0, 0, 124, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 128, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 150, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 123, 1, 0, 0, 164, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 168, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 189, 2, 0, 0
  , 7, 0, 0, 0, 62, 0, 3, 0, 229, 1, 0, 0, 228, 1, 0, 0, 62, 0, 3, 0
  , 231, 1, 0, 0, 230, 1, 0, 0, 62, 0, 3, 0, 233, 1, 0, 0, 232, 1, 0, 0
  , 62, 0, 3, 0, 235, 1, 0, 0, 234, 1, 0, 0, 62, 0, 3, 0, 237, 1, 0, 0
  , 236, 1, 0, 0, 62, 0, 3, 0, 239, 1, 0, 0, 238, 1, 0, 0, 62, 0, 3, 0
  , 241, 1, 0, 0, 240, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 242, 1, 0, 0
  , 231, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 243, 1, 0, 0, 233, 1, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 244, 1, 0, 0, 242, 1, 0, 0, 243, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 245, 1, 0, 0, 239, 1, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 246, 1, 0, 0, 244, 1, 0, 0, 245, 1, 0, 0, 62, 0, 3, 0
  , 247, 1, 0, 0, 246, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 248, 1, 0, 0
  , 231, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 249, 1, 0, 0, 247, 1, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 250, 1, 0, 0, 248, 1, 0, 0, 249, 1, 0, 0
  , 12, 0, 6, 0, 2, 0, 0, 0, 251, 1, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0
  , 250, 1, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0, 252, 1, 0, 0, 251, 1, 0, 0
  , 62, 0, 3, 0, 253, 1, 0, 0, 252, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 254, 1, 0, 0, 233, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 255, 1, 0, 0
  , 247, 1, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 0, 2, 0, 0, 254, 1, 0, 0
  , 255, 1, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 1, 2, 0, 0, 137, 0, 0, 0
  , 8, 0, 0, 0, 0, 2, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0, 2, 2, 0, 0
  , 1, 2, 0, 0, 62, 0, 3, 0, 3, 2, 0, 0, 2, 2, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 4, 2, 0, 0, 253, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 5, 2, 0, 0, 3, 2, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 6, 2, 0, 0
  , 4, 2, 0, 0, 5, 2, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 7, 2, 0, 0
  , 6, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 8, 2, 0, 0, 241, 1, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 9, 2, 0, 0, 7, 2, 0, 0, 8, 2, 0, 0
  , 62, 0, 3, 0, 10, 2, 0, 0, 9, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 11, 2, 0, 0, 231, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 12, 2, 0, 0
  , 253, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 13, 2, 0, 0, 12, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 14, 2, 0, 0, 10, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 15, 2, 0, 0, 13, 2, 0, 0, 14, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 16, 2, 0, 0, 11, 2, 0, 0, 15, 2, 0, 0, 62, 0, 3, 0
  , 17, 2, 0, 0, 16, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 18, 2, 0, 0
  , 233, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 19, 2, 0, 0, 3, 2, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 20, 2, 0, 0, 19, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 21, 2, 0, 0, 10, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 22, 2, 0, 0, 20, 2, 0, 0, 21, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 23, 2, 0, 0, 18, 2, 0, 0, 22, 2, 0, 0, 62, 0, 3, 0, 24, 2, 0, 0
  , 23, 2, 0, 0, 62, 0, 3, 0, 25, 2, 0, 0, 145, 0, 0, 0, 62, 0, 3, 0
  , 26, 2, 0, 0, 229, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 27, 2, 0, 0
  , 17, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 28, 2, 0, 0, 24, 2, 0, 0
  , 186, 0, 5, 0, 147, 0, 0, 0, 29, 2, 0, 0, 27, 2, 0, 0, 28, 2, 0, 0
  , 247, 0, 3, 0, 32, 2, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 29, 2, 0, 0
  , 30, 2, 0, 0, 31, 2, 0, 0, 248, 0, 2, 0, 30, 2, 0, 0, 62, 0, 3, 0
  , 25, 2, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0, 26, 2, 0, 0, 145, 0, 0, 0
  , 249, 0, 2, 0, 32, 2, 0, 0, 248, 0, 2, 0, 31, 2, 0, 0, 249, 0, 2, 0
  , 32, 2, 0, 0, 248, 0, 2, 0, 32, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 33, 2, 0, 0, 17, 2, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 34, 2, 0, 0
  , 25, 2, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 35, 2, 0, 0, 34, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 36, 2, 0, 0, 33, 2, 0, 0, 35, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 37, 2, 0, 0, 241, 1, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 38, 2, 0, 0, 36, 2, 0, 0, 37, 2, 0, 0, 62, 0, 3, 0
  , 39, 2, 0, 0, 38, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 40, 2, 0, 0
  , 24, 2, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 41, 2, 0, 0, 26, 2, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 42, 2, 0, 0, 41, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 43, 2, 0, 0, 40, 2, 0, 0, 42, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 44, 2, 0, 0, 241, 1, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 45, 2, 0, 0, 43, 2, 0, 0, 44, 2, 0, 0, 62, 0, 3, 0, 46, 2, 0, 0
  , 45, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 47, 2, 0, 0, 17, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 48, 2, 0, 0, 47, 2, 0, 0, 136, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 49, 2, 0, 0, 241, 1, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 50, 2, 0, 0, 112, 0, 0, 0, 49, 2, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 51, 2, 0, 0, 48, 2, 0, 0, 50, 2, 0, 0, 62, 0, 3, 0
  , 52, 2, 0, 0, 51, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 53, 2, 0, 0
  , 24, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 54, 2, 0, 0, 53, 2, 0, 0
  , 136, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 55, 2, 0, 0, 241, 1, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 56, 2, 0, 0, 112, 0, 0, 0, 55, 2, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 57, 2, 0, 0, 54, 2, 0, 0, 56, 2, 0, 0
  , 62, 0, 3, 0, 58, 2, 0, 0, 57, 2, 0, 0, 62, 0, 3, 0, 59, 2, 0, 0
  , 135, 0, 0, 0, 62, 0, 3, 0, 60, 2, 0, 0, 135, 0, 0, 0, 62, 0, 3, 0
  , 61, 2, 0, 0, 135, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 62, 2, 0, 0
  , 17, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 63, 2, 0, 0, 17, 2, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 64, 2, 0, 0, 62, 2, 0, 0, 63, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 65, 2, 0, 0, 205, 0, 0, 0, 64, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 66, 2, 0, 0, 24, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 67, 2, 0, 0, 24, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 68, 2, 0, 0, 66, 2, 0, 0, 67, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 69, 2, 0, 0, 65, 2, 0, 0, 68, 2, 0, 0, 62, 0, 3, 0, 70, 2, 0, 0
  , 69, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 71, 2, 0, 0, 70, 2, 0, 0
  , 186, 0, 5, 0, 147, 0, 0, 0, 72, 2, 0, 0, 71, 2, 0, 0, 135, 0, 0, 0
  , 247, 0, 3, 0, 75, 2, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 72, 2, 0, 0
  , 73, 2, 0, 0, 74, 2, 0, 0, 248, 0, 2, 0, 73, 2, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 76, 2, 0, 0, 229, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 77, 2, 0, 0, 253, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 78, 2, 0, 0
  , 3, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 79, 2, 0, 0, 235, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 80, 2, 0, 0, 237, 1, 0, 0, 57, 0, 9, 0
  , 31, 0, 0, 0, 81, 2, 0, 0, 33, 0, 0, 0, 76, 2, 0, 0, 77, 2, 0, 0
  , 78, 2, 0, 0, 79, 2, 0, 0, 80, 2, 0, 0, 62, 0, 3, 0, 82, 2, 0, 0
  , 81, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 83, 2, 0, 0, 70, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 84, 2, 0, 0, 70, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 85, 2, 0, 0, 83, 2, 0, 0, 84, 2, 0, 0, 62, 0, 3, 0
  , 86, 2, 0, 0, 85, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 87, 2, 0, 0
  , 86, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 88, 2, 0, 0, 86, 2, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 89, 2, 0, 0, 87, 2, 0, 0, 88, 2, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 90, 2, 0, 0, 82, 2, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 91, 2, 0, 0, 90, 2, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 92, 2, 0, 0, 17, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 93, 2, 0, 0, 91, 2, 0, 0, 92, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 94, 2, 0, 0, 82, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 95, 2, 0, 0
  , 94, 2, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 96, 2, 0, 0
  , 24, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 97, 2, 0, 0, 95, 2, 0, 0
  , 96, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 98, 2, 0, 0, 93, 2, 0, 0
  , 97, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 99, 2, 0, 0, 89, 2, 0, 0
  , 98, 2, 0, 0, 62, 0, 3, 0, 59, 2, 0, 0, 99, 2, 0, 0, 249, 0, 2, 0
  , 75, 2, 0, 0, 248, 0, 2, 0, 74, 2, 0, 0, 249, 0, 2, 0, 75, 2, 0, 0
  , 248, 0, 2, 0, 75, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 100, 2, 0, 0
  , 39, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 101, 2, 0, 0, 39, 2, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 102, 2, 0, 0, 100, 2, 0, 0, 101, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 103, 2, 0, 0, 205, 0, 0, 0, 102, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 104, 2, 0, 0, 46, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 105, 2, 0, 0, 46, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 106, 2, 0, 0, 104, 2, 0, 0, 105, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 107, 2, 0, 0, 103, 2, 0, 0, 106, 2, 0, 0, 62, 0, 3, 0, 108, 2, 0, 0
  , 107, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 109, 2, 0, 0, 108, 2, 0, 0
  , 186, 0, 5, 0, 147, 0, 0, 0, 110, 2, 0, 0, 109, 2, 0, 0, 135, 0, 0, 0
  , 247, 0, 3, 0, 113, 2, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 110, 2, 0, 0
  , 111, 2, 0, 0, 112, 2, 0, 0, 248, 0, 2, 0, 111, 2, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 114, 2, 0, 0, 229, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 115, 2, 0, 0, 253, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 116, 2, 0, 0
  , 25, 2, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 117, 2, 0, 0, 115, 2, 0, 0
  , 116, 2, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 118, 2, 0, 0, 3, 2, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 119, 2, 0, 0, 26, 2, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 120, 2, 0, 0, 118, 2, 0, 0, 119, 2, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 121, 2, 0, 0, 235, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 122, 2, 0, 0, 237, 1, 0, 0, 57, 0, 9, 0, 31, 0, 0, 0, 123, 2, 0, 0
  , 33, 0, 0, 0, 114, 2, 0, 0, 117, 2, 0, 0, 120, 2, 0, 0, 121, 2, 0, 0
  , 122, 2, 0, 0, 62, 0, 3, 0, 124, 2, 0, 0, 123, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 125, 2, 0, 0, 108, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 126, 2, 0, 0, 108, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 127, 2, 0, 0
  , 125, 2, 0, 0, 126, 2, 0, 0, 62, 0, 3, 0, 128, 2, 0, 0, 127, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 129, 2, 0, 0, 128, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 130, 2, 0, 0, 128, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 131, 2, 0, 0, 129, 2, 0, 0, 130, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 132, 2, 0, 0, 124, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 133, 2, 0, 0
  , 132, 2, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 134, 2, 0, 0
  , 39, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 135, 2, 0, 0, 133, 2, 0, 0
  , 134, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 136, 2, 0, 0, 124, 2, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 137, 2, 0, 0, 136, 2, 0, 0, 1, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 138, 2, 0, 0, 46, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 139, 2, 0, 0, 137, 2, 0, 0, 138, 2, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 140, 2, 0, 0, 135, 2, 0, 0, 139, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 141, 2, 0, 0, 131, 2, 0, 0, 140, 2, 0, 0, 62, 0, 3, 0
  , 60, 2, 0, 0, 141, 2, 0, 0, 249, 0, 2, 0, 113, 2, 0, 0, 248, 0, 2, 0
  , 112, 2, 0, 0, 249, 0, 2, 0, 113, 2, 0, 0, 248, 0, 2, 0, 113, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 142, 2, 0, 0, 52, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 143, 2, 0, 0, 52, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 144, 2, 0, 0, 142, 2, 0, 0, 143, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 145, 2, 0, 0, 205, 0, 0, 0, 144, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 146, 2, 0, 0, 58, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 147, 2, 0, 0
  , 58, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 148, 2, 0, 0, 146, 2, 0, 0
  , 147, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 149, 2, 0, 0, 145, 2, 0, 0
  , 148, 2, 0, 0, 62, 0, 3, 0, 150, 2, 0, 0, 149, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 151, 2, 0, 0, 150, 2, 0, 0, 186, 0, 5, 0, 147, 0, 0, 0
  , 152, 2, 0, 0, 151, 2, 0, 0, 135, 0, 0, 0, 247, 0, 3, 0, 155, 2, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 152, 2, 0, 0, 153, 2, 0, 0, 154, 2, 0, 0
  , 248, 0, 2, 0, 153, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 156, 2, 0, 0
  , 229, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 157, 2, 0, 0, 253, 1, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 158, 2, 0, 0, 157, 2, 0, 0, 229, 0, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 159, 2, 0, 0, 3, 2, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 160, 2, 0, 0, 159, 2, 0, 0, 229, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 161, 2, 0, 0, 235, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 162, 2, 0, 0, 237, 1, 0, 0, 57, 0, 9, 0, 31, 0, 0, 0, 163, 2, 0, 0
  , 33, 0, 0, 0, 156, 2, 0, 0, 158, 2, 0, 0, 160, 2, 0, 0, 161, 2, 0, 0
  , 162, 2, 0, 0, 62, 0, 3, 0, 164, 2, 0, 0, 163, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 165, 2, 0, 0, 150, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 166, 2, 0, 0, 150, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 167, 2, 0, 0
  , 165, 2, 0, 0, 166, 2, 0, 0, 62, 0, 3, 0, 168, 2, 0, 0, 167, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 169, 2, 0, 0, 168, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 170, 2, 0, 0, 168, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 171, 2, 0, 0, 169, 2, 0, 0, 170, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 172, 2, 0, 0, 164, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 173, 2, 0, 0
  , 172, 2, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 174, 2, 0, 0
  , 52, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 175, 2, 0, 0, 173, 2, 0, 0
  , 174, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 176, 2, 0, 0, 164, 2, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 177, 2, 0, 0, 176, 2, 0, 0, 1, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 178, 2, 0, 0, 58, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 179, 2, 0, 0, 177, 2, 0, 0, 178, 2, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 180, 2, 0, 0, 175, 2, 0, 0, 179, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 181, 2, 0, 0, 171, 2, 0, 0, 180, 2, 0, 0, 62, 0, 3, 0
  , 61, 2, 0, 0, 181, 2, 0, 0, 249, 0, 2, 0, 155, 2, 0, 0, 248, 0, 2, 0
  , 154, 2, 0, 0, 249, 0, 2, 0, 155, 2, 0, 0, 248, 0, 2, 0, 155, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 182, 2, 0, 0, 59, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 183, 2, 0, 0, 60, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 184, 2, 0, 0, 182, 2, 0, 0, 183, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 185, 2, 0, 0, 61, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 186, 2, 0, 0
  , 184, 2, 0, 0, 185, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 188, 2, 0, 0
  , 186, 2, 0, 0, 187, 2, 0, 0, 62, 0, 3, 0, 189, 2, 0, 0, 188, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 190, 2, 0, 0, 189, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 191, 2, 0, 0, 190, 2, 0, 0, 205, 0, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 192, 2, 0, 0, 191, 2, 0, 0, 205, 0, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 193, 2, 0, 0, 21, 0, 0, 0, 192, 2, 0, 0, 254, 0, 2, 0
  , 193, 2, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0, 36, 0, 0, 0
  , 0, 0, 0, 0, 29, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 195, 2, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 197, 2, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 199, 2, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 201, 2, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 203, 2, 0, 0, 248, 0, 2, 0, 194, 2, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 196, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 198, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 200, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 202, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 204, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 206, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 212, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 218, 2, 0, 0
  , 7, 0, 0, 0, 62, 0, 3, 0, 196, 2, 0, 0, 195, 2, 0, 0, 62, 0, 3, 0
  , 198, 2, 0, 0, 197, 2, 0, 0, 62, 0, 3, 0, 200, 2, 0, 0, 199, 2, 0, 0
  , 62, 0, 3, 0, 202, 2, 0, 0, 201, 2, 0, 0, 62, 0, 3, 0, 204, 2, 0, 0
  , 203, 2, 0, 0, 62, 0, 3, 0, 206, 2, 0, 0, 205, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 207, 2, 0, 0, 198, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 208, 2, 0, 0, 200, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 209, 2, 0, 0
  , 207, 2, 0, 0, 208, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 210, 2, 0, 0
  , 206, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 211, 2, 0, 0, 209, 2, 0, 0
  , 210, 2, 0, 0, 62, 0, 3, 0, 212, 2, 0, 0, 211, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 213, 2, 0, 0, 200, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 214, 2, 0, 0, 198, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 215, 2, 0, 0
  , 213, 2, 0, 0, 214, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 216, 2, 0, 0
  , 206, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 217, 2, 0, 0, 215, 2, 0, 0
  , 216, 2, 0, 0, 62, 0, 3, 0, 218, 2, 0, 0, 217, 2, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 219, 2, 0, 0, 196, 2, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 221, 2, 0, 0, 220, 2, 0, 0, 128, 0, 5, 0, 9, 0, 0, 0, 222, 2, 0, 0
  , 219, 2, 0, 0, 221, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 223, 2, 0, 0
  , 212, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 224, 2, 0, 0, 218, 2, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 225, 2, 0, 0, 202, 2, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 226, 2, 0, 0, 204, 2, 0, 0, 57, 0, 9, 0, 2, 0, 0, 0
  , 227, 2, 0, 0, 35, 0, 0, 0, 222, 2, 0, 0, 223, 2, 0, 0, 224, 2, 0, 0
  , 225, 2, 0, 0, 226, 2, 0, 0, 254, 0, 2, 0, 227, 2, 0, 0, 56, 0, 1, 0
  , 54, 0, 5, 0, 31, 0, 0, 0, 38, 0, 0, 0, 0, 0, 0, 0, 37, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 229, 2, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 231, 2, 0, 0, 55, 0, 3, 0, 24, 0, 0, 0, 233, 2, 0, 0, 55, 0, 3, 0
  , 24, 0, 0, 0, 235, 2, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 237, 2, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 239, 2, 0, 0, 248, 0, 2, 0, 228, 2, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 230, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 232, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0
  , 234, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0, 236, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 238, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 240, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 158, 0, 0, 0, 245, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0
  , 250, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 1, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 12, 3, 0, 0, 7, 0, 0, 0
  , 62, 0, 3, 0, 230, 2, 0, 0, 229, 2, 0, 0, 62, 0, 3, 0, 232, 2, 0, 0
  , 231, 2, 0, 0, 62, 0, 3, 0, 234, 2, 0, 0, 233, 2, 0, 0, 62, 0, 3, 0
  , 236, 2, 0, 0, 235, 2, 0, 0, 62, 0, 3, 0, 238, 2, 0, 0, 237, 2, 0, 0
  , 62, 0, 3, 0, 240, 2, 0, 0, 239, 2, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 241, 2, 0, 0, 234, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 242, 2, 0, 0
  , 238, 2, 0, 0, 124, 0, 4, 0, 24, 0, 0, 0, 243, 2, 0, 0, 242, 2, 0, 0
  , 57, 0, 6, 0, 24, 0, 0, 0, 244, 2, 0, 0, 26, 0, 0, 0, 241, 2, 0, 0
  , 243, 2, 0, 0, 62, 0, 3, 0, 245, 2, 0, 0, 244, 2, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 246, 2, 0, 0, 236, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 247, 2, 0, 0, 240, 2, 0, 0, 124, 0, 4, 0, 24, 0, 0, 0, 248, 2, 0, 0
  , 247, 2, 0, 0, 57, 0, 6, 0, 24, 0, 0, 0, 249, 2, 0, 0, 26, 0, 0, 0
  , 246, 2, 0, 0, 248, 2, 0, 0, 62, 0, 3, 0, 250, 2, 0, 0, 249, 2, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 251, 2, 0, 0, 230, 2, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 252, 2, 0, 0, 245, 2, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 253, 2, 0, 0, 252, 2, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 254, 2, 0, 0
  , 250, 2, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 255, 2, 0, 0, 254, 2, 0, 0
  , 57, 0, 7, 0, 2, 0, 0, 0, 0, 3, 0, 0, 16, 0, 0, 0, 251, 2, 0, 0
  , 253, 2, 0, 0, 255, 2, 0, 0, 62, 0, 3, 0, 1, 3, 0, 0, 0, 3, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 2, 3, 0, 0, 230, 2, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 3, 3, 0, 0, 245, 2, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0
  , 5, 3, 0, 0, 3, 3, 0, 0, 4, 3, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 6, 3, 0, 0, 5, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 7, 3, 0, 0
  , 250, 2, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 9, 3, 0, 0, 7, 3, 0, 0
  , 8, 3, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 10, 3, 0, 0, 9, 3, 0, 0
  , 57, 0, 7, 0, 2, 0, 0, 0, 11, 3, 0, 0, 16, 0, 0, 0, 2, 3, 0, 0
  , 6, 3, 0, 0, 10, 3, 0, 0, 62, 0, 3, 0, 12, 3, 0, 0, 11, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 13, 3, 0, 0, 1, 3, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 14, 3, 0, 0, 13, 3, 0, 0, 205, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 15, 3, 0, 0, 232, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 16, 3, 0, 0, 14, 3, 0, 0, 15, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 17, 3, 0, 0, 16, 3, 0, 0, 205, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 18, 3, 0, 0, 12, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 19, 3, 0, 0
  , 18, 3, 0, 0, 205, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 20, 3, 0, 0
  , 232, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 21, 3, 0, 0, 19, 3, 0, 0
  , 20, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 22, 3, 0, 0, 21, 3, 0, 0
  , 205, 0, 0, 0, 80, 0, 5, 0, 31, 0, 0, 0, 23, 3, 0, 0, 17, 3, 0, 0
  , 22, 3, 0, 0, 254, 0, 2, 0, 23, 3, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 40, 0, 0, 0, 0, 0, 0, 0, 39, 0, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 25, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 27, 3, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 29, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 31, 3, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 33, 3, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 35, 3, 0, 0, 248, 0, 2, 0, 24, 3, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 26, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 28, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 30, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 32, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 34, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 36, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0
  , 40, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0, 44, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 46, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 158, 0, 0, 0, 48, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 158, 0, 0, 0, 56, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0
  , 66, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 158, 0, 0, 0, 70, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 123, 1, 0, 0, 78, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 84, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 90, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 97, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 104, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 112, 3, 0, 0, 7, 0, 0, 0
  , 62, 0, 3, 0, 26, 3, 0, 0, 25, 3, 0, 0, 62, 0, 3, 0, 28, 3, 0, 0
  , 27, 3, 0, 0, 62, 0, 3, 0, 30, 3, 0, 0, 29, 3, 0, 0, 62, 0, 3, 0
  , 32, 3, 0, 0, 31, 3, 0, 0, 62, 0, 3, 0, 34, 3, 0, 0, 33, 3, 0, 0
  , 62, 0, 3, 0, 36, 3, 0, 0, 35, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 37, 3, 0, 0, 30, 3, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 38, 3, 0, 0
  , 137, 0, 0, 0, 8, 0, 0, 0, 37, 3, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0
  , 39, 3, 0, 0, 38, 3, 0, 0, 62, 0, 3, 0, 40, 3, 0, 0, 39, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 41, 3, 0, 0, 32, 3, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 42, 3, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0, 41, 3, 0, 0
  , 110, 0, 4, 0, 24, 0, 0, 0, 43, 3, 0, 0, 42, 3, 0, 0, 62, 0, 3, 0
  , 44, 3, 0, 0, 43, 3, 0, 0, 62, 0, 3, 0, 46, 3, 0, 0, 45, 3, 0, 0
  , 126, 0, 4, 0, 24, 0, 0, 0, 47, 3, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0
  , 48, 3, 0, 0, 47, 3, 0, 0, 249, 0, 2, 0, 49, 3, 0, 0, 248, 0, 2, 0
  , 49, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 53, 3, 0, 0, 48, 3, 0, 0
  , 179, 0, 5, 0, 147, 0, 0, 0, 54, 3, 0, 0, 53, 3, 0, 0, 229, 0, 0, 0
  , 246, 0, 4, 0, 52, 3, 0, 0, 51, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0
  , 54, 3, 0, 0, 50, 3, 0, 0, 52, 3, 0, 0, 248, 0, 2, 0, 50, 3, 0, 0
  , 126, 0, 4, 0, 24, 0, 0, 0, 55, 3, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0
  , 56, 3, 0, 0, 55, 3, 0, 0, 249, 0, 2, 0, 57, 3, 0, 0, 248, 0, 2, 0
  , 57, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 61, 3, 0, 0, 56, 3, 0, 0
  , 179, 0, 5, 0, 147, 0, 0, 0, 62, 3, 0, 0, 61, 3, 0, 0, 229, 0, 0, 0
  , 246, 0, 4, 0, 60, 3, 0, 0, 59, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0
  , 62, 3, 0, 0, 58, 3, 0, 0, 60, 3, 0, 0, 248, 0, 2, 0, 58, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 63, 3, 0, 0, 40, 3, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 64, 3, 0, 0, 48, 3, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0
  , 65, 3, 0, 0, 63, 3, 0, 0, 64, 3, 0, 0, 62, 0, 3, 0, 66, 3, 0, 0
  , 65, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 67, 3, 0, 0, 44, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 68, 3, 0, 0, 56, 3, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 69, 3, 0, 0, 67, 3, 0, 0, 68, 3, 0, 0, 62, 0, 3, 0
  , 70, 3, 0, 0, 69, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 71, 3, 0, 0
  , 26, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 72, 3, 0, 0, 28, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 73, 3, 0, 0, 66, 3, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 74, 3, 0, 0, 70, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 75, 3, 0, 0, 34, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 76, 3, 0, 0
  , 36, 3, 0, 0, 57, 0, 10, 0, 31, 0, 0, 0, 77, 3, 0, 0, 38, 0, 0, 0
  , 71, 3, 0, 0, 72, 3, 0, 0, 73, 3, 0, 0, 74, 3, 0, 0, 75, 3, 0, 0
  , 76, 3, 0, 0, 62, 0, 3, 0, 78, 3, 0, 0, 77, 3, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 79, 3, 0, 0, 66, 3, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 80, 3, 0, 0, 79, 3, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 81, 3, 0, 0
  , 78, 3, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 82, 3, 0, 0, 81, 3, 0, 0
  , 0, 0, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 83, 3, 0, 0, 80, 3, 0, 0
  , 82, 3, 0, 0, 62, 0, 3, 0, 84, 3, 0, 0, 83, 3, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 85, 3, 0, 0, 70, 3, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 86, 3, 0, 0, 85, 3, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 87, 3, 0, 0
  , 78, 3, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 88, 3, 0, 0, 87, 3, 0, 0
  , 1, 0, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 89, 3, 0, 0, 86, 3, 0, 0
  , 88, 3, 0, 0, 62, 0, 3, 0, 90, 3, 0, 0, 89, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 91, 3, 0, 0, 84, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 92, 3, 0, 0, 30, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 93, 3, 0, 0
  , 91, 3, 0, 0, 92, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 94, 3, 0, 0
  , 34, 3, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0, 95, 3, 0, 0, 94, 3, 0, 0
  , 57, 0, 6, 0, 2, 0, 0, 0, 96, 3, 0, 0, 28, 0, 0, 0, 93, 3, 0, 0
  , 95, 3, 0, 0, 62, 0, 3, 0, 97, 3, 0, 0, 96, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 98, 3, 0, 0, 90, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 99, 3, 0, 0, 32, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 100, 3, 0, 0
  , 98, 3, 0, 0, 99, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 101, 3, 0, 0
  , 36, 3, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0, 102, 3, 0, 0, 101, 3, 0, 0
  , 57, 0, 6, 0, 2, 0, 0, 0, 103, 3, 0, 0, 28, 0, 0, 0, 100, 3, 0, 0
  , 102, 3, 0, 0, 62, 0, 3, 0, 104, 3, 0, 0, 103, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 105, 3, 0, 0, 97, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 106, 3, 0, 0, 97, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 107, 3, 0, 0
  , 105, 3, 0, 0, 106, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 108, 3, 0, 0
  , 104, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 109, 3, 0, 0, 104, 3, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 110, 3, 0, 0, 108, 3, 0, 0, 109, 3, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 111, 3, 0, 0, 107, 3, 0, 0, 110, 3, 0, 0
  , 62, 0, 3, 0, 112, 3, 0, 0, 111, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 113, 3, 0, 0, 46, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 114, 3, 0, 0
  , 112, 3, 0, 0, 12, 0, 7, 0, 2, 0, 0, 0, 115, 3, 0, 0, 137, 0, 0, 0
  , 37, 0, 0, 0, 113, 3, 0, 0, 114, 3, 0, 0, 62, 0, 3, 0, 46, 3, 0, 0
  , 115, 3, 0, 0, 249, 0, 2, 0, 59, 3, 0, 0, 248, 0, 2, 0, 59, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 116, 3, 0, 0, 56, 3, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 117, 3, 0, 0, 116, 3, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0
  , 56, 3, 0, 0, 117, 3, 0, 0, 249, 0, 2, 0, 57, 3, 0, 0, 248, 0, 2, 0
  , 60, 3, 0, 0, 249, 0, 2, 0, 51, 3, 0, 0, 248, 0, 2, 0, 51, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 118, 3, 0, 0, 48, 3, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 119, 3, 0, 0, 118, 3, 0, 0, 229, 0, 0, 0, 62, 0, 3, 0
  , 48, 3, 0, 0, 119, 3, 0, 0, 249, 0, 2, 0, 49, 3, 0, 0, 248, 0, 2, 0
  , 52, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 120, 3, 0, 0, 46, 3, 0, 0
  , 12, 0, 6, 0, 2, 0, 0, 0, 121, 3, 0, 0, 137, 0, 0, 0, 31, 0, 0, 0
  , 120, 3, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0, 123, 3, 0, 0, 121, 3, 0, 0
  , 122, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 124, 3, 0, 0, 136, 0, 0, 0
  , 123, 3, 0, 0, 57, 0, 5, 0, 2, 0, 0, 0, 125, 3, 0, 0, 21, 0, 0, 0
  , 124, 3, 0, 0, 254, 0, 2, 0, 125, 3, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 42, 0, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 127, 3, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 129, 3, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 131, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 133, 3, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 135, 3, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 137, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 139, 3, 0, 0
  , 248, 0, 2, 0, 126, 3, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 128, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 130, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 132, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 134, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 136, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 138, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 140, 3, 0, 0, 7, 0, 0, 0
  , 62, 0, 3, 0, 128, 3, 0, 0, 127, 3, 0, 0, 62, 0, 3, 0, 130, 3, 0, 0
  , 129, 3, 0, 0, 62, 0, 3, 0, 132, 3, 0, 0, 131, 3, 0, 0, 62, 0, 3, 0
  , 134, 3, 0, 0, 133, 3, 0, 0, 62, 0, 3, 0, 136, 3, 0, 0, 135, 3, 0, 0
  , 62, 0, 3, 0, 138, 3, 0, 0, 137, 3, 0, 0, 62, 0, 3, 0, 140, 3, 0, 0
  , 139, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 141, 3, 0, 0, 128, 3, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 142, 3, 0, 0, 229, 0, 0, 0, 170, 0, 5, 0
  , 147, 0, 0, 0, 143, 3, 0, 0, 141, 3, 0, 0, 142, 3, 0, 0, 247, 0, 3, 0
  , 146, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 143, 3, 0, 0, 144, 3, 0, 0
  , 145, 3, 0, 0, 248, 0, 2, 0, 144, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 147, 3, 0, 0, 130, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 148, 3, 0, 0
  , 132, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 149, 3, 0, 0, 134, 3, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 150, 3, 0, 0, 136, 3, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 151, 3, 0, 0, 138, 3, 0, 0, 57, 0, 9, 0, 2, 0, 0, 0
  , 152, 3, 0, 0, 30, 0, 0, 0, 147, 3, 0, 0, 148, 3, 0, 0, 149, 3, 0, 0
  , 150, 3, 0, 0, 151, 3, 0, 0, 254, 0, 2, 0, 152, 3, 0, 0, 248, 0, 2, 0
  , 145, 3, 0, 0, 249, 0, 2, 0, 146, 3, 0, 0, 248, 0, 2, 0, 146, 3, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 153, 3, 0, 0, 128, 3, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 155, 3, 0, 0, 154, 3, 0, 0, 170, 0, 5, 0, 147, 0, 0, 0
  , 156, 3, 0, 0, 153, 3, 0, 0, 155, 3, 0, 0, 247, 0, 3, 0, 159, 3, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 156, 3, 0, 0, 157, 3, 0, 0, 158, 3, 0, 0
  , 248, 0, 2, 0, 157, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 160, 3, 0, 0
  , 130, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 161, 3, 0, 0, 132, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 162, 3, 0, 0, 134, 3, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 163, 3, 0, 0, 136, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 164, 3, 0, 0, 138, 3, 0, 0, 57, 0, 9, 0, 2, 0, 0, 0, 165, 3, 0, 0
  , 34, 0, 0, 0, 160, 3, 0, 0, 161, 3, 0, 0, 162, 3, 0, 0, 163, 3, 0, 0
  , 164, 3, 0, 0, 254, 0, 2, 0, 165, 3, 0, 0, 248, 0, 2, 0, 158, 3, 0, 0
  , 249, 0, 2, 0, 159, 3, 0, 0, 248, 0, 2, 0, 159, 3, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 166, 3, 0, 0, 128, 3, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 168, 3, 0, 0, 167, 3, 0, 0, 170, 0, 5, 0, 147, 0, 0, 0, 169, 3, 0, 0
  , 166, 3, 0, 0, 168, 3, 0, 0, 247, 0, 3, 0, 172, 3, 0, 0, 0, 0, 0, 0
  , 250, 0, 4, 0, 169, 3, 0, 0, 170, 3, 0, 0, 171, 3, 0, 0, 248, 0, 2, 0
  , 170, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 173, 3, 0, 0, 130, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 174, 3, 0, 0, 140, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 175, 3, 0, 0, 132, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 176, 3, 0, 0, 134, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 177, 3, 0, 0
  , 136, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 178, 3, 0, 0, 138, 3, 0, 0
  , 57, 0, 10, 0, 2, 0, 0, 0, 179, 3, 0, 0, 40, 0, 0, 0, 173, 3, 0, 0
  , 174, 3, 0, 0, 175, 3, 0, 0, 176, 3, 0, 0, 177, 3, 0, 0, 178, 3, 0, 0
  , 254, 0, 2, 0, 179, 3, 0, 0, 248, 0, 2, 0, 171, 3, 0, 0, 249, 0, 2, 0
  , 172, 3, 0, 0, 248, 0, 2, 0, 172, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 180, 3, 0, 0, 128, 3, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 182, 3, 0, 0
  , 181, 3, 0, 0, 170, 0, 5, 0, 147, 0, 0, 0, 183, 3, 0, 0, 180, 3, 0, 0
  , 182, 3, 0, 0, 247, 0, 3, 0, 186, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0
  , 183, 3, 0, 0, 184, 3, 0, 0, 185, 3, 0, 0, 248, 0, 2, 0, 184, 3, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 187, 3, 0, 0, 130, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 188, 3, 0, 0, 132, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 189, 3, 0, 0, 134, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 190, 3, 0, 0
  , 136, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 191, 3, 0, 0, 138, 3, 0, 0
  , 57, 0, 9, 0, 2, 0, 0, 0, 192, 3, 0, 0, 35, 0, 0, 0, 187, 3, 0, 0
  , 188, 3, 0, 0, 189, 3, 0, 0, 190, 3, 0, 0, 191, 3, 0, 0, 254, 0, 2, 0
  , 192, 3, 0, 0, 248, 0, 2, 0, 185, 3, 0, 0, 249, 0, 2, 0, 186, 3, 0, 0
  , 248, 0, 2, 0, 186, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 193, 3, 0, 0
  , 130, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 194, 3, 0, 0, 132, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 195, 3, 0, 0, 134, 3, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 196, 3, 0, 0, 136, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 197, 3, 0, 0, 138, 3, 0, 0, 57, 0, 9, 0, 2, 0, 0, 0, 198, 3, 0, 0
  , 36, 0, 0, 0, 193, 3, 0, 0, 194, 3, 0, 0, 195, 3, 0, 0, 196, 3, 0, 0
  , 197, 3, 0, 0, 254, 0, 2, 0, 198, 3, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 44, 0, 0, 0, 0, 0, 0, 0, 43, 0, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 200, 3, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 202, 3, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 204, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 206, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 208, 3, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 210, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 212, 3, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 214, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 216, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 218, 3, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 220, 3, 0, 0, 248, 0, 2, 0, 199, 3, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 201, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 203, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 205, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 207, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 209, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 211, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 213, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 215, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 217, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 219, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 221, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 222, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 223, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 224, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 225, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 227, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 249, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 5, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 11, 4, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 17, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 26, 4, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 201, 3, 0, 0
  , 200, 3, 0, 0, 62, 0, 3, 0, 203, 3, 0, 0, 202, 3, 0, 0, 62, 0, 3, 0
  , 205, 3, 0, 0, 204, 3, 0, 0, 62, 0, 3, 0, 207, 3, 0, 0, 206, 3, 0, 0
  , 62, 0, 3, 0, 209, 3, 0, 0, 208, 3, 0, 0, 62, 0, 3, 0, 211, 3, 0, 0
  , 210, 3, 0, 0, 62, 0, 3, 0, 213, 3, 0, 0, 212, 3, 0, 0, 62, 0, 3, 0
  , 215, 3, 0, 0, 214, 3, 0, 0, 62, 0, 3, 0, 217, 3, 0, 0, 216, 3, 0, 0
  , 62, 0, 3, 0, 219, 3, 0, 0, 218, 3, 0, 0, 62, 0, 3, 0, 221, 3, 0, 0
  , 220, 3, 0, 0, 62, 0, 3, 0, 222, 3, 0, 0, 136, 0, 0, 0, 62, 0, 3, 0
  , 223, 3, 0, 0, 136, 0, 0, 0, 62, 0, 3, 0, 224, 3, 0, 0, 135, 0, 0, 0
  , 62, 0, 3, 0, 225, 3, 0, 0, 135, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 226, 3, 0, 0, 145, 0, 0, 0, 62, 0, 3, 0, 227, 3, 0, 0, 226, 3, 0, 0
  , 249, 0, 2, 0, 228, 3, 0, 0, 248, 0, 2, 0, 228, 3, 0, 0, 246, 0, 4, 0
  , 231, 3, 0, 0, 230, 3, 0, 0, 0, 0, 0, 0, 249, 0, 2, 0, 229, 3, 0, 0
  , 248, 0, 2, 0, 229, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 232, 3, 0, 0
  , 227, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 233, 3, 0, 0, 211, 3, 0, 0
  , 174, 0, 5, 0, 147, 0, 0, 0, 234, 3, 0, 0, 232, 3, 0, 0, 233, 3, 0, 0
  , 247, 0, 3, 0, 237, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 234, 3, 0, 0
  , 235, 3, 0, 0, 236, 3, 0, 0, 248, 0, 2, 0, 235, 3, 0, 0, 249, 0, 2, 0
  , 231, 3, 0, 0, 248, 0, 2, 0, 236, 3, 0, 0, 249, 0, 2, 0, 237, 3, 0, 0
  , 248, 0, 2, 0, 237, 3, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 238, 3, 0, 0
  , 145, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 239, 3, 0, 0, 217, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 240, 3, 0, 0, 223, 3, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 241, 3, 0, 0, 239, 3, 0, 0, 240, 3, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 242, 3, 0, 0, 241, 3, 0, 0, 205, 0, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 243, 3, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0, 242, 3, 0, 0
  , 12, 0, 7, 0, 2, 0, 0, 0, 244, 3, 0, 0, 137, 0, 0, 0, 40, 0, 0, 0
  , 136, 0, 0, 0, 243, 3, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0, 245, 3, 0, 0
  , 244, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 246, 3, 0, 0, 217, 3, 0, 0
  , 186, 0, 5, 0, 147, 0, 0, 0, 247, 3, 0, 0, 246, 3, 0, 0, 135, 0, 0, 0
  , 169, 0, 6, 0, 9, 0, 0, 0, 248, 3, 0, 0, 247, 3, 0, 0, 245, 3, 0, 0
  , 238, 3, 0, 0, 62, 0, 3, 0, 249, 3, 0, 0, 248, 3, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 250, 3, 0, 0, 145, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 251, 3, 0, 0, 219, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 252, 3, 0, 0
  , 223, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 253, 3, 0, 0, 251, 3, 0, 0
  , 252, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 254, 3, 0, 0, 253, 3, 0, 0
  , 205, 0, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 255, 3, 0, 0, 137, 0, 0, 0
  , 8, 0, 0, 0, 254, 3, 0, 0, 12, 0, 7, 0, 2, 0, 0, 0, 0, 4, 0, 0
  , 137, 0, 0, 0, 40, 0, 0, 0, 136, 0, 0, 0, 255, 3, 0, 0, 109, 0, 4, 0
  , 9, 0, 0, 0, 1, 4, 0, 0, 0, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 2, 4, 0, 0, 219, 3, 0, 0, 186, 0, 5, 0, 147, 0, 0, 0, 3, 4, 0, 0
  , 2, 4, 0, 0, 135, 0, 0, 0, 169, 0, 6, 0, 9, 0, 0, 0, 4, 4, 0, 0
  , 3, 4, 0, 0, 1, 4, 0, 0, 250, 3, 0, 0, 62, 0, 3, 0, 5, 4, 0, 0
  , 4, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 6, 4, 0, 0, 205, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 7, 4, 0, 0, 209, 3, 0, 0, 136, 0, 5, 0
  , 2, 0, 0, 0, 8, 4, 0, 0, 6, 4, 0, 0, 7, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 9, 4, 0, 0, 223, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 10, 4, 0, 0, 8, 4, 0, 0, 9, 4, 0, 0, 62, 0, 3, 0, 11, 4, 0, 0
  , 10, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 12, 4, 0, 0, 207, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 13, 4, 0, 0, 209, 3, 0, 0, 136, 0, 5, 0
  , 2, 0, 0, 0, 14, 4, 0, 0, 12, 4, 0, 0, 13, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 15, 4, 0, 0, 223, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 16, 4, 0, 0, 14, 4, 0, 0, 15, 4, 0, 0, 62, 0, 3, 0, 17, 4, 0, 0
  , 16, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 18, 4, 0, 0, 201, 3, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 19, 4, 0, 0, 203, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 20, 4, 0, 0, 11, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 21, 4, 0, 0, 17, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 22, 4, 0, 0
  , 249, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 23, 4, 0, 0, 5, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 24, 4, 0, 0, 221, 3, 0, 0, 57, 0, 11, 0
  , 2, 0, 0, 0, 25, 4, 0, 0, 42, 0, 0, 0, 18, 4, 0, 0, 19, 4, 0, 0
  , 20, 4, 0, 0, 21, 4, 0, 0, 22, 4, 0, 0, 23, 4, 0, 0, 24, 4, 0, 0
  , 62, 0, 3, 0, 26, 4, 0, 0, 25, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 27, 4, 0, 0, 224, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 28, 4, 0, 0
  , 26, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 29, 4, 0, 0, 222, 3, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 30, 4, 0, 0, 28, 4, 0, 0, 29, 4, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 31, 4, 0, 0, 27, 4, 0, 0, 30, 4, 0, 0
  , 62, 0, 3, 0, 224, 3, 0, 0, 31, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 32, 4, 0, 0, 225, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 33, 4, 0, 0
  , 222, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 34, 4, 0, 0, 32, 4, 0, 0
  , 33, 4, 0, 0, 62, 0, 3, 0, 225, 3, 0, 0, 34, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 35, 4, 0, 0, 222, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 36, 4, 0, 0, 215, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 37, 4, 0, 0
  , 35, 4, 0, 0, 36, 4, 0, 0, 62, 0, 3, 0, 222, 3, 0, 0, 37, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 38, 4, 0, 0, 223, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 39, 4, 0, 0, 213, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 40, 4, 0, 0, 38, 4, 0, 0, 39, 4, 0, 0, 62, 0, 3, 0, 223, 3, 0, 0
  , 40, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 41, 4, 0, 0, 227, 3, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 42, 4, 0, 0, 229, 0, 0, 0, 128, 0, 5, 0
  , 9, 0, 0, 0, 43, 4, 0, 0, 41, 4, 0, 0, 42, 4, 0, 0, 62, 0, 3, 0
  , 227, 3, 0, 0, 43, 4, 0, 0, 249, 0, 2, 0, 230, 3, 0, 0, 248, 0, 2, 0
  , 230, 3, 0, 0, 249, 0, 2, 0, 228, 3, 0, 0, 248, 0, 2, 0, 231, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 44, 4, 0, 0, 224, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 45, 4, 0, 0, 225, 3, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0
  , 46, 4, 0, 0, 44, 4, 0, 0, 45, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 47, 4, 0, 0, 225, 3, 0, 0, 186, 0, 5, 0, 147, 0, 0, 0, 48, 4, 0, 0
  , 47, 4, 0, 0, 135, 0, 0, 0, 169, 0, 6, 0, 2, 0, 0, 0, 49, 4, 0, 0
  , 48, 4, 0, 0, 46, 4, 0, 0, 135, 0, 0, 0, 254, 0, 2, 0, 49, 4, 0, 0
  , 56, 0, 1, 0, 54, 0, 5, 0, 50, 4, 0, 0, 52, 4, 0, 0, 0, 0, 0, 0
  , 51, 4, 0, 0, 248, 0, 2, 0, 53, 4, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 58, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 63, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 80, 4, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 86, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 94, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 98, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 102, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 107, 4, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 111, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 115, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 119, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 123, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 127, 4, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 106, 0, 0, 0, 145, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 106, 0, 0, 0, 163, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0
  , 164, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 198, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 106, 0, 0, 0, 201, 4, 0, 0, 7, 0, 0, 0
  , 61, 0, 4, 0, 1, 0, 0, 0, 54, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0
  , 3, 0, 0, 0, 55, 4, 0, 0, 54, 4, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 56, 4, 0, 0, 55, 4, 0, 0, 0, 0, 0, 0, 109, 0, 4, 0
  , 9, 0, 0, 0, 57, 4, 0, 0, 56, 4, 0, 0, 62, 0, 3, 0, 58, 4, 0, 0
  , 57, 4, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 59, 4, 0, 0, 5, 0, 0, 0
  , 81, 0, 5, 0, 3, 0, 0, 0, 60, 4, 0, 0, 59, 4, 0, 0, 0, 0, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 61, 4, 0, 0, 60, 4, 0, 0, 1, 0, 0, 0
  , 109, 0, 4, 0, 9, 0, 0, 0, 62, 4, 0, 0, 61, 4, 0, 0, 62, 0, 3, 0
  , 63, 4, 0, 0, 62, 4, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0, 64, 4, 0, 0
  , 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 65, 4, 0, 0, 64, 4, 0, 0
  , 0, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 66, 4, 0, 0, 58, 4, 0, 0
  , 174, 0, 5, 0, 147, 0, 0, 0, 67, 4, 0, 0, 65, 4, 0, 0, 66, 4, 0, 0
  , 61, 0, 4, 0, 10, 0, 0, 0, 68, 4, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0
  , 9, 0, 0, 0, 69, 4, 0, 0, 68, 4, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 70, 4, 0, 0, 63, 4, 0, 0, 174, 0, 5, 0, 147, 0, 0, 0
  , 71, 4, 0, 0, 69, 4, 0, 0, 70, 4, 0, 0, 166, 0, 5, 0, 147, 0, 0, 0
  , 72, 4, 0, 0, 67, 4, 0, 0, 71, 4, 0, 0, 247, 0, 3, 0, 75, 4, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 72, 4, 0, 0, 73, 4, 0, 0, 74, 4, 0, 0
  , 248, 0, 2, 0, 73, 4, 0, 0, 248, 0, 2, 0, 74, 4, 0, 0, 249, 0, 2, 0
  , 75, 4, 0, 0, 248, 0, 2, 0, 75, 4, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0
  , 76, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 77, 4, 0, 0
  , 76, 4, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 78, 4, 0, 0
  , 77, 4, 0, 0, 3, 0, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0, 79, 4, 0, 0
  , 78, 4, 0, 0, 62, 0, 3, 0, 80, 4, 0, 0, 79, 4, 0, 0, 61, 0, 4, 0
  , 1, 0, 0, 0, 82, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 83, 4, 0, 0, 82, 4, 0, 0, 1, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 84, 4, 0, 0, 83, 4, 0, 0, 0, 0, 0, 0, 12, 0, 7, 0, 2, 0, 0, 0
  , 85, 4, 0, 0, 137, 0, 0, 0, 40, 0, 0, 0, 81, 4, 0, 0, 84, 4, 0, 0
  , 62, 0, 3, 0, 86, 4, 0, 0, 85, 4, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 87, 4, 0, 0, 229, 0, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 88, 4, 0, 0
  , 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 89, 4, 0, 0, 88, 4, 0, 0
  , 1, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 90, 4, 0, 0, 89, 4, 0, 0
  , 1, 0, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0, 91, 4, 0, 0, 90, 4, 0, 0
  , 172, 0, 5, 0, 147, 0, 0, 0, 92, 4, 0, 0, 87, 4, 0, 0, 91, 4, 0, 0
  , 169, 0, 6, 0, 9, 0, 0, 0, 93, 4, 0, 0, 92, 4, 0, 0, 87, 4, 0, 0
  , 91, 4, 0, 0, 62, 0, 3, 0, 94, 4, 0, 0, 93, 4, 0, 0, 61, 0, 4, 0
  , 1, 0, 0, 0, 95, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 96, 4, 0, 0, 95, 4, 0, 0, 1, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 97, 4, 0, 0, 96, 4, 0, 0, 2, 0, 0, 0, 62, 0, 3, 0, 98, 4, 0, 0
  , 97, 4, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 99, 4, 0, 0, 5, 0, 0, 0
  , 81, 0, 5, 0, 3, 0, 0, 0, 100, 4, 0, 0, 99, 4, 0, 0, 1, 0, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 101, 4, 0, 0, 100, 4, 0, 0, 3, 0, 0, 0
  , 62, 0, 3, 0, 102, 4, 0, 0, 101, 4, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0
  , 103, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 104, 4, 0, 0
  , 103, 4, 0, 0, 2, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 105, 4, 0, 0
  , 104, 4, 0, 0, 0, 0, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0, 106, 4, 0, 0
  , 105, 4, 0, 0, 62, 0, 3, 0, 107, 4, 0, 0, 106, 4, 0, 0, 61, 0, 4, 0
  , 1, 0, 0, 0, 108, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 109, 4, 0, 0, 108, 4, 0, 0, 2, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 110, 4, 0, 0, 109, 4, 0, 0, 1, 0, 0, 0, 62, 0, 3, 0, 111, 4, 0, 0
  , 110, 4, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 112, 4, 0, 0, 5, 0, 0, 0
  , 81, 0, 5, 0, 3, 0, 0, 0, 113, 4, 0, 0, 112, 4, 0, 0, 2, 0, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 114, 4, 0, 0, 113, 4, 0, 0, 2, 0, 0, 0
  , 62, 0, 3, 0, 115, 4, 0, 0, 114, 4, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0
  , 116, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 117, 4, 0, 0
  , 116, 4, 0, 0, 2, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 118, 4, 0, 0
  , 117, 4, 0, 0, 3, 0, 0, 0, 62, 0, 3, 0, 119, 4, 0, 0, 118, 4, 0, 0
  , 61, 0, 4, 0, 1, 0, 0, 0, 120, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0
  , 3, 0, 0, 0, 121, 4, 0, 0, 120, 4, 0, 0, 3, 0, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 122, 4, 0, 0, 121, 4, 0, 0, 0, 0, 0, 0, 62, 0, 3, 0
  , 123, 4, 0, 0, 122, 4, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 124, 4, 0, 0
  , 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 125, 4, 0, 0, 124, 4, 0, 0
  , 3, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 126, 4, 0, 0, 125, 4, 0, 0
  , 1, 0, 0, 0, 62, 0, 3, 0, 127, 4, 0, 0, 126, 4, 0, 0, 61, 0, 4, 0
  , 10, 0, 0, 0, 128, 4, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0
  , 129, 4, 0, 0, 128, 4, 0, 0, 0, 0, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0
  , 130, 4, 0, 0, 129, 4, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0, 131, 4, 0, 0
  , 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 132, 4, 0, 0, 131, 4, 0, 0
  , 0, 0, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0, 133, 4, 0, 0, 132, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 134, 4, 0, 0, 123, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 135, 4, 0, 0, 86, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 136, 4, 0, 0, 134, 4, 0, 0, 135, 4, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0
  , 137, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 138, 4, 0, 0
  , 137, 4, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 139, 4, 0, 0
  , 138, 4, 0, 0, 0, 0, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0, 140, 4, 0, 0
  , 136, 4, 0, 0, 139, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 141, 4, 0, 0
  , 133, 4, 0, 0, 140, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 142, 4, 0, 0
  , 123, 4, 0, 0, 186, 0, 5, 0, 147, 0, 0, 0, 143, 4, 0, 0, 142, 4, 0, 0
  , 135, 0, 0, 0, 169, 0, 6, 0, 2, 0, 0, 0, 144, 4, 0, 0, 143, 4, 0, 0
  , 141, 4, 0, 0, 130, 4, 0, 0, 62, 0, 3, 0, 145, 4, 0, 0, 144, 4, 0, 0
  , 61, 0, 4, 0, 10, 0, 0, 0, 146, 4, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0
  , 9, 0, 0, 0, 147, 4, 0, 0, 146, 4, 0, 0, 1, 0, 0, 0, 112, 0, 4, 0
  , 2, 0, 0, 0, 148, 4, 0, 0, 147, 4, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0
  , 149, 4, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 150, 4, 0, 0
  , 149, 4, 0, 0, 1, 0, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0, 151, 4, 0, 0
  , 150, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 152, 4, 0, 0, 127, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 153, 4, 0, 0, 86, 4, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 154, 4, 0, 0, 152, 4, 0, 0, 153, 4, 0, 0, 61, 0, 4, 0
  , 1, 0, 0, 0, 155, 4, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 156, 4, 0, 0, 155, 4, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 157, 4, 0, 0, 156, 4, 0, 0, 1, 0, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0
  , 158, 4, 0, 0, 154, 4, 0, 0, 157, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 159, 4, 0, 0, 151, 4, 0, 0, 158, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 160, 4, 0, 0, 127, 4, 0, 0, 186, 0, 5, 0, 147, 0, 0, 0, 161, 4, 0, 0
  , 160, 4, 0, 0, 135, 0, 0, 0, 169, 0, 6, 0, 2, 0, 0, 0, 162, 4, 0, 0
  , 161, 4, 0, 0, 159, 4, 0, 0, 148, 4, 0, 0, 62, 0, 3, 0, 163, 4, 0, 0
  , 162, 4, 0, 0, 62, 0, 3, 0, 164, 4, 0, 0, 135, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 165, 4, 0, 0, 80, 4, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 166, 4, 0, 0, 145, 0, 0, 0, 170, 0, 5, 0, 147, 0, 0, 0, 167, 4, 0, 0
  , 165, 4, 0, 0, 166, 4, 0, 0, 247, 0, 3, 0, 170, 4, 0, 0, 0, 0, 0, 0
  , 250, 0, 4, 0, 167, 4, 0, 0, 168, 4, 0, 0, 169, 4, 0, 0, 248, 0, 2, 0
  , 168, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 171, 4, 0, 0, 107, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 172, 4, 0, 0, 145, 4, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 173, 4, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0, 172, 4, 0, 0
  , 109, 0, 4, 0, 9, 0, 0, 0, 174, 4, 0, 0, 173, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 175, 4, 0, 0, 163, 4, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 176, 4, 0, 0, 137, 0, 0, 0, 8, 0, 0, 0, 175, 4, 0, 0, 109, 0, 4, 0
  , 9, 0, 0, 0, 177, 4, 0, 0, 176, 4, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0
  , 178, 4, 0, 0, 16, 0, 0, 0, 171, 4, 0, 0, 174, 4, 0, 0, 177, 4, 0, 0
  , 62, 0, 3, 0, 164, 4, 0, 0, 178, 4, 0, 0, 249, 0, 2, 0, 170, 4, 0, 0
  , 248, 0, 2, 0, 169, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 179, 4, 0, 0
  , 80, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 180, 4, 0, 0, 107, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 181, 4, 0, 0, 145, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 182, 4, 0, 0, 163, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 183, 4, 0, 0, 86, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 184, 4, 0, 0
  , 94, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 185, 4, 0, 0, 98, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 186, 4, 0, 0, 102, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 187, 4, 0, 0, 123, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 188, 4, 0, 0, 127, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 189, 4, 0, 0
  , 111, 4, 0, 0, 57, 0, 15, 0, 2, 0, 0, 0, 190, 4, 0, 0, 44, 0, 0, 0
  , 179, 4, 0, 0, 180, 4, 0, 0, 181, 4, 0, 0, 182, 4, 0, 0, 183, 4, 0, 0
  , 184, 4, 0, 0, 185, 4, 0, 0, 186, 4, 0, 0, 187, 4, 0, 0, 188, 4, 0, 0
  , 189, 4, 0, 0, 62, 0, 3, 0, 164, 4, 0, 0, 190, 4, 0, 0, 249, 0, 2, 0
  , 170, 4, 0, 0, 248, 0, 2, 0, 170, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 191, 4, 0, 0, 164, 4, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 192, 4, 0, 0
  , 191, 4, 0, 0, 205, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 193, 4, 0, 0
  , 115, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 194, 4, 0, 0, 192, 4, 0, 0
  , 193, 4, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 195, 4, 0, 0, 194, 4, 0, 0
  , 205, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 196, 4, 0, 0, 119, 4, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 197, 4, 0, 0, 195, 4, 0, 0, 196, 4, 0, 0
  , 62, 0, 3, 0, 198, 4, 0, 0, 197, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 199, 4, 0, 0, 198, 4, 0, 0, 57, 0, 5, 0, 2, 0, 0, 0, 200, 4, 0, 0
  , 21, 0, 0, 0, 199, 4, 0, 0, 62, 0, 3, 0, 201, 4, 0, 0, 200, 4, 0, 0
  , 61, 0, 4, 0, 6, 0, 0, 0, 202, 4, 0, 0, 8, 0, 0, 0, 61, 0, 4, 0
  , 10, 0, 0, 0, 203, 4, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0
  , 204, 4, 0, 0, 203, 4, 0, 0, 0, 0, 0, 0, 124, 0, 4, 0, 24, 0, 0, 0
  , 205, 4, 0, 0, 204, 4, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0, 206, 4, 0, 0
  , 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 207, 4, 0, 0, 206, 4, 0, 0
  , 1, 0, 0, 0, 124, 0, 4, 0, 24, 0, 0, 0, 208, 4, 0, 0, 207, 4, 0, 0
  , 80, 0, 5, 0, 209, 4, 0, 0, 210, 4, 0, 0, 205, 4, 0, 0, 208, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 211, 4, 0, 0, 201, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 212, 4, 0, 0, 201, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 213, 4, 0, 0, 201, 4, 0, 0, 80, 0, 7, 0, 3, 0, 0, 0, 214, 4, 0, 0
  , 211, 4, 0, 0, 212, 4, 0, 0, 213, 4, 0, 0, 136, 0, 0, 0, 99, 0, 4, 0
  , 202, 4, 0, 0, 210, 4, 0, 0, 214, 4, 0, 0, 253, 0, 1, 0, 56, 0, 1, 0
  ]

noise3DComputeSpirv :: ByteString
noise3DComputeSpirv = BS.pack
    [ 3, 2, 35, 7, 0, 6, 1, 0, 0, 0, 0, 0, 139, 7, 0, 0, 0, 0, 0, 0
  , 17, 0, 2, 0, 1, 0, 0, 0, 11, 0, 6, 0, 142, 0, 0, 0, 71, 76, 83, 76
  , 46, 115, 116, 100, 46, 52, 53, 48, 0, 0, 0, 0, 14, 0, 3, 0, 0, 0, 0, 0
  , 1, 0, 0, 0, 15, 0, 8, 0, 5, 0, 0, 0, 192, 6, 0, 0, 109, 97, 105, 110
  , 0, 0, 0, 0, 5, 0, 0, 0, 8, 0, 0, 0, 12, 0, 0, 0, 16, 0, 6, 0
  , 192, 6, 0, 0, 17, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0
  , 5, 0, 4, 0, 1, 0, 0, 0, 80, 97, 114, 97, 109, 115, 0, 0, 6, 0, 5, 0
  , 1, 0, 0, 0, 0, 0, 0, 0, 100, 105, 109, 115, 0, 0, 0, 0, 6, 0, 5, 0
  , 1, 0, 0, 0, 1, 0, 0, 0, 115, 99, 97, 108, 101, 0, 0, 0, 6, 0, 5, 0
  , 1, 0, 0, 0, 2, 0, 0, 0, 101, 120, 116, 114, 97, 115, 0, 0, 6, 0, 5, 0
  , 1, 0, 0, 0, 3, 0, 0, 0, 112, 101, 114, 105, 111, 100, 0, 0, 5, 0, 4, 0
  , 5, 0, 0, 0, 112, 97, 114, 97, 109, 115, 0, 0, 5, 0, 4, 0, 8, 0, 0, 0
  , 111, 117, 116, 95, 116, 101, 120, 0, 5, 0, 3, 0, 12, 0, 0, 0, 103, 105, 100, 0
  , 5, 0, 4, 0, 14, 0, 0, 0, 109, 105, 120, 51, 50, 0, 0, 0, 5, 0, 4, 0
  , 16, 0, 0, 0, 104, 97, 115, 104, 51, 0, 0, 0, 5, 0, 6, 0, 18, 0, 0, 0
  , 115, 109, 111, 111, 116, 104, 115, 116, 101, 112, 48, 49, 0, 0, 0, 0, 5, 0, 4, 0
  , 20, 0, 0, 0, 108, 101, 114, 112, 0, 0, 0, 0, 5, 0, 4, 0, 21, 0, 0, 0
  , 99, 108, 97, 109, 112, 48, 49, 0, 5, 0, 5, 0, 23, 0, 0, 0, 119, 114, 97, 112
  , 73, 110, 100, 101, 120, 0, 0, 0, 5, 0, 5, 0, 26, 0, 0, 0, 119, 114, 97, 112
  , 73, 110, 100, 101, 120, 73, 0, 0, 5, 0, 5, 0, 28, 0, 0, 0, 119, 114, 97, 112
  , 68, 101, 108, 116, 97, 0, 0, 0, 5, 0, 5, 0, 30, 0, 0, 0, 118, 97, 108, 117
  , 101, 78, 111, 105, 115, 101, 51, 0, 5, 0, 4, 0, 33, 0, 0, 0, 103, 114, 97, 100
  , 51, 0, 0, 0, 5, 0, 4, 0, 34, 0, 0, 0, 112, 101, 114, 108, 105, 110, 51, 0
  , 5, 0, 5, 0, 35, 0, 0, 0, 115, 105, 109, 112, 108, 101, 120, 51, 0, 0, 0, 0
  , 5, 0, 5, 0, 36, 0, 0, 0, 115, 105, 109, 112, 108, 101, 120, 51, 98, 0, 0, 0
  , 5, 0, 5, 0, 38, 0, 0, 0, 99, 101, 108, 108, 80, 111, 105, 110, 116, 51, 0, 0
  , 5, 0, 5, 0, 40, 0, 0, 0, 118, 111, 114, 111, 110, 111, 105, 51, 0, 0, 0, 0
  , 5, 0, 4, 0, 42, 0, 0, 0, 110, 111, 105, 115, 101, 51, 0, 0, 5, 0, 5, 0
  , 44, 0, 0, 0, 102, 114, 97, 99, 116, 97, 108, 51, 0, 0, 0, 0, 5, 0, 4, 0
  , 192, 6, 0, 0, 109, 97, 105, 110, 0, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 1, 0, 0, 0, 35, 0, 0, 0, 16, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 2, 0, 0, 0, 35, 0, 0, 0, 32, 0, 0, 0, 72, 0, 5, 0, 1, 0, 0, 0
  , 3, 0, 0, 0, 35, 0, 0, 0, 48, 0, 0, 0, 71, 0, 3, 0, 1, 0, 0, 0
  , 2, 0, 0, 0, 71, 0, 4, 0, 5, 0, 0, 0, 34, 0, 0, 0, 2, 0, 0, 0
  , 71, 0, 4, 0, 5, 0, 0, 0, 33, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0
  , 8, 0, 0, 0, 34, 0, 0, 0, 1, 0, 0, 0, 71, 0, 4, 0, 8, 0, 0, 0
  , 33, 0, 0, 0, 0, 0, 0, 0, 71, 0, 4, 0, 12, 0, 0, 0, 11, 0, 0, 0
  , 28, 0, 0, 0, 22, 0, 3, 0, 2, 0, 0, 0, 32, 0, 0, 0, 23, 0, 4, 0
  , 3, 0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 30, 0, 6, 0, 1, 0, 0, 0
  , 3, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 32, 0, 4, 0
  , 4, 0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 25, 0, 9, 0, 6, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  , 2, 0, 0, 0, 4, 0, 0, 0, 32, 0, 4, 0, 7, 0, 0, 0, 0, 0, 0, 0
  , 6, 0, 0, 0, 21, 0, 4, 0, 9, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0
  , 23, 0, 4, 0, 10, 0, 0, 0, 9, 0, 0, 0, 3, 0, 0, 0, 32, 0, 4, 0
  , 11, 0, 0, 0, 1, 0, 0, 0, 10, 0, 0, 0, 33, 0, 4, 0, 13, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 33, 0, 7, 0, 15, 0, 0, 0, 2, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 33, 0, 4, 0
  , 17, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 33, 0, 6, 0, 19, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 33, 0, 5, 0
  , 22, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 21, 0, 4, 0
  , 24, 0, 0, 0, 32, 0, 0, 0, 1, 0, 0, 0, 33, 0, 5, 0, 25, 0, 0, 0
  , 24, 0, 0, 0, 24, 0, 0, 0, 24, 0, 0, 0, 33, 0, 5, 0, 27, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 33, 0, 10, 0, 29, 0, 0, 0
  , 2, 0, 0, 0, 9, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 23, 0, 4, 0, 31, 0, 0, 0
  , 2, 0, 0, 0, 3, 0, 0, 0, 33, 0, 10, 0, 32, 0, 0, 0, 31, 0, 0, 0
  , 9, 0, 0, 0, 24, 0, 0, 0, 24, 0, 0, 0, 24, 0, 0, 0, 9, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 33, 0, 11, 0, 37, 0, 0, 0, 31, 0, 0, 0
  , 9, 0, 0, 0, 2, 0, 0, 0, 24, 0, 0, 0, 24, 0, 0, 0, 24, 0, 0, 0
  , 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 33, 0, 11, 0, 39, 0, 0, 0
  , 2, 0, 0, 0, 9, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0
  , 2, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 33, 0, 12, 0
  , 41, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 2, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0, 9, 0, 0, 0
  , 2, 0, 0, 0, 33, 0, 16, 0, 43, 0, 0, 0, 2, 0, 0, 0, 9, 0, 0, 0
  , 9, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0
  , 9, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0
  , 2, 0, 0, 0, 2, 0, 0, 0, 32, 0, 4, 0, 47, 0, 0, 0, 7, 0, 0, 0
  , 9, 0, 0, 0, 32, 0, 4, 0, 111, 0, 0, 0, 7, 0, 0, 0, 2, 0, 0, 0
  , 20, 0, 2, 0, 152, 0, 0, 0, 32, 0, 4, 0, 163, 0, 0, 0, 7, 0, 0, 0
  , 24, 0, 0, 0, 32, 0, 4, 0, 28, 2, 0, 0, 7, 0, 0, 0, 31, 0, 0, 0
  , 19, 0, 2, 0, 190, 6, 0, 0, 33, 0, 3, 0, 191, 6, 0, 0, 190, 6, 0, 0
  , 23, 0, 4, 0, 133, 7, 0, 0, 24, 0, 0, 0, 3, 0, 0, 0, 43, 0, 4, 0
  , 24, 0, 0, 0, 51, 0, 0, 0, 16, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0
  , 57, 0, 0, 0, 45, 53, 235, 127, 43, 0, 4, 0, 24, 0, 0, 0, 62, 0, 0, 0
  , 15, 0, 0, 0, 43, 0, 4, 0, 9, 0, 0, 0, 67, 0, 0, 0, 139, 166, 108, 132
  , 43, 0, 4, 0, 24, 0, 0, 0, 84, 0, 0, 0, 177, 103, 86, 22, 43, 0, 4, 0
  , 24, 0, 0, 0, 88, 0, 0, 0, 47, 235, 212, 39, 43, 0, 4, 0, 9, 0, 0, 0
  , 93, 0, 0, 0, 119, 202, 235, 133, 43, 0, 4, 0, 9, 0, 0, 0, 97, 0, 0, 0
  , 61, 174, 178, 194, 43, 0, 4, 0, 24, 0, 0, 0, 103, 0, 0, 0, 255, 255, 0, 0
  , 43, 0, 4, 0, 2, 0, 0, 0, 107, 0, 0, 0, 0, 255, 127, 71, 43, 0, 4, 0
  , 2, 0, 0, 0, 116, 0, 0, 0, 0, 0, 64, 64, 43, 0, 4, 0, 2, 0, 0, 0
  , 117, 0, 0, 0, 0, 0, 0, 64, 43, 0, 4, 0, 2, 0, 0, 0, 140, 0, 0, 0
  , 0, 0, 0, 0, 43, 0, 4, 0, 2, 0, 0, 0, 141, 0, 0, 0, 0, 0, 128, 63
  , 43, 0, 4, 0, 24, 0, 0, 0, 150, 0, 0, 0, 0, 0, 0, 0, 43, 0, 4, 0
  , 2, 0, 0, 0, 210, 0, 0, 0, 0, 0, 0, 63, 43, 0, 4, 0, 24, 0, 0, 0
  , 242, 0, 0, 0, 1, 0, 0, 0, 43, 0, 4, 0, 2, 0, 0, 0, 198, 1, 0, 0
  , 219, 15, 201, 64, 43, 0, 4, 0, 2, 0, 0, 0, 81, 3, 0, 0, 171, 170, 170, 62
  , 43, 0, 4, 0, 2, 0, 0, 0, 83, 3, 0, 0, 171, 170, 42, 62, 43, 0, 4, 0
  , 2, 0, 0, 0, 244, 3, 0, 0, 154, 153, 25, 63, 43, 0, 4, 0, 2, 0, 0, 0
  , 207, 4, 0, 0, 0, 0, 0, 66, 43, 0, 4, 0, 2, 0, 0, 0, 229, 4, 0, 0
  , 243, 4, 53, 63, 43, 0, 4, 0, 24, 0, 0, 0, 244, 4, 0, 0, 17, 5, 0, 0
  , 43, 0, 4, 0, 24, 0, 0, 0, 41, 5, 0, 0, 17, 0, 0, 0, 43, 0, 4, 0
  , 24, 0, 0, 0, 45, 5, 0, 0, 31, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0
  , 49, 5, 0, 0, 57, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0, 56, 5, 0, 0
  , 29, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0, 60, 5, 0, 0, 71, 0, 0, 0
  , 43, 0, 4, 0, 24, 0, 0, 0, 64, 5, 0, 0, 19, 0, 0, 0, 43, 0, 4, 0
  , 2, 0, 0, 0, 114, 5, 0, 0, 40, 107, 110, 78, 43, 0, 4, 0, 2, 0, 0, 0
  , 224, 5, 0, 0, 215, 179, 221, 63, 43, 0, 4, 0, 24, 0, 0, 0, 6, 6, 0, 0
  , 2, 0, 0, 0, 43, 0, 4, 0, 24, 0, 0, 0, 21, 6, 0, 0, 3, 0, 0, 0
  , 43, 0, 4, 0, 24, 0, 0, 0, 37, 6, 0, 0, 4, 0, 0, 0, 43, 0, 4, 0
  , 2, 0, 0, 0, 231, 6, 0, 0, 23, 183, 209, 56, 59, 0, 4, 0, 4, 0, 0, 0
  , 5, 0, 0, 0, 2, 0, 0, 0, 59, 0, 4, 0, 7, 0, 0, 0, 8, 0, 0, 0
  , 0, 0, 0, 0, 59, 0, 4, 0, 11, 0, 0, 0, 12, 0, 0, 0, 1, 0, 0, 0
  , 54, 0, 5, 0, 9, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 46, 0, 0, 0, 248, 0, 2, 0, 45, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 48, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 55, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 48, 0, 0, 0
  , 46, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 49, 0, 0, 0, 48, 0, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 50, 0, 0, 0, 48, 0, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 52, 0, 0, 0, 51, 0, 0, 0, 194, 0, 5, 0, 9, 0, 0, 0
  , 53, 0, 0, 0, 50, 0, 0, 0, 52, 0, 0, 0, 198, 0, 5, 0, 9, 0, 0, 0
  , 54, 0, 0, 0, 49, 0, 0, 0, 53, 0, 0, 0, 62, 0, 3, 0, 55, 0, 0, 0
  , 54, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 56, 0, 0, 0, 55, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 58, 0, 0, 0, 57, 0, 0, 0, 132, 0, 5, 0
  , 9, 0, 0, 0, 59, 0, 0, 0, 56, 0, 0, 0, 58, 0, 0, 0, 62, 0, 3, 0
  , 55, 0, 0, 0, 59, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 60, 0, 0, 0
  , 55, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 61, 0, 0, 0, 55, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 63, 0, 0, 0, 62, 0, 0, 0, 194, 0, 5, 0
  , 9, 0, 0, 0, 64, 0, 0, 0, 61, 0, 0, 0, 63, 0, 0, 0, 198, 0, 5, 0
  , 9, 0, 0, 0, 65, 0, 0, 0, 60, 0, 0, 0, 64, 0, 0, 0, 62, 0, 3, 0
  , 55, 0, 0, 0, 65, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 66, 0, 0, 0
  , 55, 0, 0, 0, 132, 0, 5, 0, 9, 0, 0, 0, 68, 0, 0, 0, 66, 0, 0, 0
  , 67, 0, 0, 0, 62, 0, 3, 0, 55, 0, 0, 0, 68, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 69, 0, 0, 0, 55, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 70, 0, 0, 0, 55, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 71, 0, 0, 0
  , 51, 0, 0, 0, 194, 0, 5, 0, 9, 0, 0, 0, 72, 0, 0, 0, 70, 0, 0, 0
  , 71, 0, 0, 0, 198, 0, 5, 0, 9, 0, 0, 0, 73, 0, 0, 0, 69, 0, 0, 0
  , 72, 0, 0, 0, 254, 0, 2, 0, 73, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 75, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 77, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 79, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 81, 0, 0, 0, 248, 0, 2, 0, 74, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 76, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 78, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 80, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 82, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 101, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 76, 0, 0, 0
  , 75, 0, 0, 0, 62, 0, 3, 0, 78, 0, 0, 0, 77, 0, 0, 0, 62, 0, 3, 0
  , 80, 0, 0, 0, 79, 0, 0, 0, 62, 0, 3, 0, 82, 0, 0, 0, 81, 0, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 83, 0, 0, 0, 78, 0, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 85, 0, 0, 0, 84, 0, 0, 0, 132, 0, 5, 0, 9, 0, 0, 0
  , 86, 0, 0, 0, 83, 0, 0, 0, 85, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 87, 0, 0, 0, 80, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 89, 0, 0, 0
  , 88, 0, 0, 0, 132, 0, 5, 0, 9, 0, 0, 0, 90, 0, 0, 0, 87, 0, 0, 0
  , 89, 0, 0, 0, 128, 0, 5, 0, 9, 0, 0, 0, 91, 0, 0, 0, 86, 0, 0, 0
  , 90, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 92, 0, 0, 0, 82, 0, 0, 0
  , 132, 0, 5, 0, 9, 0, 0, 0, 94, 0, 0, 0, 92, 0, 0, 0, 93, 0, 0, 0
  , 128, 0, 5, 0, 9, 0, 0, 0, 95, 0, 0, 0, 91, 0, 0, 0, 94, 0, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 96, 0, 0, 0, 76, 0, 0, 0, 132, 0, 5, 0
  , 9, 0, 0, 0, 98, 0, 0, 0, 96, 0, 0, 0, 97, 0, 0, 0, 128, 0, 5, 0
  , 9, 0, 0, 0, 99, 0, 0, 0, 95, 0, 0, 0, 98, 0, 0, 0, 57, 0, 5, 0
  , 9, 0, 0, 0, 100, 0, 0, 0, 14, 0, 0, 0, 99, 0, 0, 0, 62, 0, 3, 0
  , 101, 0, 0, 0, 100, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 102, 0, 0, 0
  , 101, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 104, 0, 0, 0, 103, 0, 0, 0
  , 199, 0, 5, 0, 9, 0, 0, 0, 105, 0, 0, 0, 102, 0, 0, 0, 104, 0, 0, 0
  , 112, 0, 4, 0, 2, 0, 0, 0, 106, 0, 0, 0, 105, 0, 0, 0, 136, 0, 5, 0
  , 2, 0, 0, 0, 108, 0, 0, 0, 106, 0, 0, 0, 107, 0, 0, 0, 254, 0, 2, 0
  , 108, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0, 18, 0, 0, 0
  , 0, 0, 0, 0, 17, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 110, 0, 0, 0
  , 248, 0, 2, 0, 109, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 112, 0, 0, 0
  , 7, 0, 0, 0, 62, 0, 3, 0, 112, 0, 0, 0, 110, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 113, 0, 0, 0, 112, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 114, 0, 0, 0, 112, 0, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 115, 0, 0, 0
  , 113, 0, 0, 0, 114, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 118, 0, 0, 0
  , 112, 0, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 119, 0, 0, 0, 117, 0, 0, 0
  , 118, 0, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 120, 0, 0, 0, 116, 0, 0, 0
  , 119, 0, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 121, 0, 0, 0, 115, 0, 0, 0
  , 120, 0, 0, 0, 254, 0, 2, 0, 121, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 19, 0, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 123, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 125, 0, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 127, 0, 0, 0, 248, 0, 2, 0, 122, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 124, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 126, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 128, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 124, 0, 0, 0, 123, 0, 0, 0
  , 62, 0, 3, 0, 126, 0, 0, 0, 125, 0, 0, 0, 62, 0, 3, 0, 128, 0, 0, 0
  , 127, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 129, 0, 0, 0, 124, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 130, 0, 0, 0, 126, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 131, 0, 0, 0, 124, 0, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 132, 0, 0, 0, 130, 0, 0, 0, 131, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 133, 0, 0, 0, 128, 0, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 134, 0, 0, 0
  , 132, 0, 0, 0, 133, 0, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 135, 0, 0, 0
  , 129, 0, 0, 0, 134, 0, 0, 0, 254, 0, 2, 0, 135, 0, 0, 0, 56, 0, 1, 0
  , 54, 0, 5, 0, 2, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 137, 0, 0, 0, 248, 0, 2, 0, 136, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 138, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 138, 0, 0, 0, 137, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 139, 0, 0, 0
  , 138, 0, 0, 0, 12, 0, 8, 0, 2, 0, 0, 0, 143, 0, 0, 0, 142, 0, 0, 0
  , 43, 0, 0, 0, 139, 0, 0, 0, 140, 0, 0, 0, 141, 0, 0, 0, 254, 0, 2, 0
  , 143, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 9, 0, 0, 0, 23, 0, 0, 0
  , 0, 0, 0, 0, 22, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 145, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 147, 0, 0, 0, 248, 0, 2, 0, 144, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 146, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 148, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 146, 0, 0, 0
  , 145, 0, 0, 0, 62, 0, 3, 0, 148, 0, 0, 0, 147, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 149, 0, 0, 0, 148, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 151, 0, 0, 0, 150, 0, 0, 0, 170, 0, 5, 0, 152, 0, 0, 0, 153, 0, 0, 0
  , 149, 0, 0, 0, 151, 0, 0, 0, 247, 0, 3, 0, 156, 0, 0, 0, 0, 0, 0, 0
  , 250, 0, 4, 0, 153, 0, 0, 0, 154, 0, 0, 0, 155, 0, 0, 0, 248, 0, 2, 0
  , 154, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 157, 0, 0, 0, 146, 0, 0, 0
  , 254, 0, 2, 0, 157, 0, 0, 0, 248, 0, 2, 0, 155, 0, 0, 0, 249, 0, 2, 0
  , 156, 0, 0, 0, 248, 0, 2, 0, 156, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 158, 0, 0, 0, 146, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 159, 0, 0, 0
  , 148, 0, 0, 0, 137, 0, 5, 0, 9, 0, 0, 0, 160, 0, 0, 0, 158, 0, 0, 0
  , 159, 0, 0, 0, 254, 0, 2, 0, 160, 0, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 24, 0, 0, 0, 26, 0, 0, 0, 0, 0, 0, 0, 25, 0, 0, 0, 55, 0, 3, 0
  , 24, 0, 0, 0, 162, 0, 0, 0, 55, 0, 3, 0, 24, 0, 0, 0, 165, 0, 0, 0
  , 248, 0, 2, 0, 161, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 164, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 166, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 163, 0, 0, 0, 176, 0, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 164, 0, 0, 0, 162, 0, 0, 0, 62, 0, 3, 0, 166, 0, 0, 0, 165, 0, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 167, 0, 0, 0, 166, 0, 0, 0, 179, 0, 5, 0
  , 152, 0, 0, 0, 168, 0, 0, 0, 167, 0, 0, 0, 150, 0, 0, 0, 247, 0, 3, 0
  , 171, 0, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 168, 0, 0, 0, 169, 0, 0, 0
  , 170, 0, 0, 0, 248, 0, 2, 0, 169, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 172, 0, 0, 0, 164, 0, 0, 0, 254, 0, 2, 0, 172, 0, 0, 0, 248, 0, 2, 0
  , 170, 0, 0, 0, 249, 0, 2, 0, 171, 0, 0, 0, 248, 0, 2, 0, 171, 0, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 173, 0, 0, 0, 164, 0, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 174, 0, 0, 0, 166, 0, 0, 0, 138, 0, 5, 0, 24, 0, 0, 0
  , 175, 0, 0, 0, 173, 0, 0, 0, 174, 0, 0, 0, 62, 0, 3, 0, 176, 0, 0, 0
  , 175, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 177, 0, 0, 0, 176, 0, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 178, 0, 0, 0, 176, 0, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 179, 0, 0, 0, 166, 0, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0
  , 180, 0, 0, 0, 178, 0, 0, 0, 179, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 181, 0, 0, 0, 176, 0, 0, 0, 177, 0, 5, 0, 152, 0, 0, 0, 182, 0, 0, 0
  , 181, 0, 0, 0, 150, 0, 0, 0, 169, 0, 6, 0, 24, 0, 0, 0, 183, 0, 0, 0
  , 182, 0, 0, 0, 180, 0, 0, 0, 177, 0, 0, 0, 254, 0, 2, 0, 183, 0, 0, 0
  , 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0, 28, 0, 0, 0, 0, 0, 0, 0
  , 27, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 185, 0, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 187, 0, 0, 0, 248, 0, 2, 0, 184, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 186, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 188, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 203, 0, 0, 0
  , 7, 0, 0, 0, 62, 0, 3, 0, 186, 0, 0, 0, 185, 0, 0, 0, 62, 0, 3, 0
  , 188, 0, 0, 0, 187, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 189, 0, 0, 0
  , 188, 0, 0, 0, 188, 0, 5, 0, 152, 0, 0, 0, 190, 0, 0, 0, 189, 0, 0, 0
  , 140, 0, 0, 0, 247, 0, 3, 0, 193, 0, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0
  , 190, 0, 0, 0, 191, 0, 0, 0, 192, 0, 0, 0, 248, 0, 2, 0, 191, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 194, 0, 0, 0, 186, 0, 0, 0, 254, 0, 2, 0
  , 194, 0, 0, 0, 248, 0, 2, 0, 192, 0, 0, 0, 249, 0, 2, 0, 193, 0, 0, 0
  , 248, 0, 2, 0, 193, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 195, 0, 0, 0
  , 186, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 196, 0, 0, 0, 188, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 197, 0, 0, 0, 186, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 198, 0, 0, 0, 188, 0, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0
  , 199, 0, 0, 0, 197, 0, 0, 0, 198, 0, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 200, 0, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 199, 0, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 201, 0, 0, 0, 196, 0, 0, 0, 200, 0, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 202, 0, 0, 0, 195, 0, 0, 0, 201, 0, 0, 0, 62, 0, 3, 0
  , 203, 0, 0, 0, 202, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 204, 0, 0, 0
  , 203, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 205, 0, 0, 0, 203, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 206, 0, 0, 0, 188, 0, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 207, 0, 0, 0, 205, 0, 0, 0, 206, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 208, 0, 0, 0, 203, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 209, 0, 0, 0, 188, 0, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 211, 0, 0, 0
  , 209, 0, 0, 0, 210, 0, 0, 0, 186, 0, 5, 0, 152, 0, 0, 0, 212, 0, 0, 0
  , 208, 0, 0, 0, 211, 0, 0, 0, 169, 0, 6, 0, 2, 0, 0, 0, 213, 0, 0, 0
  , 212, 0, 0, 0, 207, 0, 0, 0, 204, 0, 0, 0, 254, 0, 2, 0, 213, 0, 0, 0
  , 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0
  , 29, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 215, 0, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 217, 0, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 219, 0, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 221, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 223, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 225, 0, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 227, 0, 0, 0, 248, 0, 2, 0, 214, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 216, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 218, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 220, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 222, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 224, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 226, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 228, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 232, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 236, 0, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 163, 0, 0, 0, 240, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 163, 0, 0, 0, 244, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 247, 0, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 250, 0, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 0, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 6, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 12, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 27, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 42, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 57, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 72, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 87, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 102, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 117, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 132, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 137, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 142, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 147, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 152, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 157, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 162, 1, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 216, 0, 0, 0, 215, 0, 0, 0, 62, 0, 3, 0, 218, 0, 0, 0, 217, 0, 0, 0
  , 62, 0, 3, 0, 220, 0, 0, 0, 219, 0, 0, 0, 62, 0, 3, 0, 222, 0, 0, 0
  , 221, 0, 0, 0, 62, 0, 3, 0, 224, 0, 0, 0, 223, 0, 0, 0, 62, 0, 3, 0
  , 226, 0, 0, 0, 225, 0, 0, 0, 62, 0, 3, 0, 228, 0, 0, 0, 227, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 229, 0, 0, 0, 218, 0, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 230, 0, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 229, 0, 0, 0
  , 110, 0, 4, 0, 24, 0, 0, 0, 231, 0, 0, 0, 230, 0, 0, 0, 62, 0, 3, 0
  , 232, 0, 0, 0, 231, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 233, 0, 0, 0
  , 220, 0, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 234, 0, 0, 0, 142, 0, 0, 0
  , 8, 0, 0, 0, 233, 0, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0, 235, 0, 0, 0
  , 234, 0, 0, 0, 62, 0, 3, 0, 236, 0, 0, 0, 235, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 237, 0, 0, 0, 222, 0, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 238, 0, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 237, 0, 0, 0, 110, 0, 4, 0
  , 24, 0, 0, 0, 239, 0, 0, 0, 238, 0, 0, 0, 62, 0, 3, 0, 240, 0, 0, 0
  , 239, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 241, 0, 0, 0, 232, 0, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 243, 0, 0, 0, 241, 0, 0, 0, 242, 0, 0, 0
  , 62, 0, 3, 0, 244, 0, 0, 0, 243, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 245, 0, 0, 0, 236, 0, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 246, 0, 0, 0
  , 245, 0, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 247, 0, 0, 0, 246, 0, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 248, 0, 0, 0, 240, 0, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 249, 0, 0, 0, 248, 0, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0
  , 250, 0, 0, 0, 249, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 251, 0, 0, 0
  , 218, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 252, 0, 0, 0, 232, 0, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 253, 0, 0, 0, 252, 0, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 254, 0, 0, 0, 251, 0, 0, 0, 253, 0, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 255, 0, 0, 0, 18, 0, 0, 0, 254, 0, 0, 0, 62, 0, 3, 0
  , 0, 1, 0, 0, 255, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 1, 1, 0, 0
  , 220, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 2, 1, 0, 0, 236, 0, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 3, 1, 0, 0, 2, 1, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 4, 1, 0, 0, 1, 1, 0, 0, 3, 1, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 5, 1, 0, 0, 18, 0, 0, 0, 4, 1, 0, 0, 62, 0, 3, 0
  , 6, 1, 0, 0, 5, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 7, 1, 0, 0
  , 222, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 8, 1, 0, 0, 240, 0, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 9, 1, 0, 0, 8, 1, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 10, 1, 0, 0, 7, 1, 0, 0, 9, 1, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 11, 1, 0, 0, 18, 0, 0, 0, 10, 1, 0, 0, 62, 0, 3, 0
  , 12, 1, 0, 0, 11, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 13, 1, 0, 0
  , 216, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 14, 1, 0, 0, 232, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 15, 1, 0, 0, 14, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 16, 1, 0, 0, 224, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 17, 1, 0, 0, 23, 0, 0, 0, 15, 1, 0, 0, 16, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 18, 1, 0, 0, 236, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 19, 1, 0, 0, 18, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 20, 1, 0, 0
  , 226, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 21, 1, 0, 0, 23, 0, 0, 0
  , 19, 1, 0, 0, 20, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 22, 1, 0, 0
  , 240, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 23, 1, 0, 0, 22, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 24, 1, 0, 0, 228, 0, 0, 0, 57, 0, 6, 0
  , 9, 0, 0, 0, 25, 1, 0, 0, 23, 0, 0, 0, 23, 1, 0, 0, 24, 1, 0, 0
  , 57, 0, 8, 0, 2, 0, 0, 0, 26, 1, 0, 0, 16, 0, 0, 0, 13, 1, 0, 0
  , 17, 1, 0, 0, 21, 1, 0, 0, 25, 1, 0, 0, 62, 0, 3, 0, 27, 1, 0, 0
  , 26, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 28, 1, 0, 0, 216, 0, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 29, 1, 0, 0, 244, 0, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 30, 1, 0, 0, 29, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 31, 1, 0, 0, 224, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 32, 1, 0, 0
  , 23, 0, 0, 0, 30, 1, 0, 0, 31, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 33, 1, 0, 0, 236, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 34, 1, 0, 0
  , 33, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 35, 1, 0, 0, 226, 0, 0, 0
  , 57, 0, 6, 0, 9, 0, 0, 0, 36, 1, 0, 0, 23, 0, 0, 0, 34, 1, 0, 0
  , 35, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 37, 1, 0, 0, 240, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 38, 1, 0, 0, 37, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 39, 1, 0, 0, 228, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 40, 1, 0, 0, 23, 0, 0, 0, 38, 1, 0, 0, 39, 1, 0, 0, 57, 0, 8, 0
  , 2, 0, 0, 0, 41, 1, 0, 0, 16, 0, 0, 0, 28, 1, 0, 0, 32, 1, 0, 0
  , 36, 1, 0, 0, 40, 1, 0, 0, 62, 0, 3, 0, 42, 1, 0, 0, 41, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 43, 1, 0, 0, 216, 0, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 44, 1, 0, 0, 232, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 45, 1, 0, 0, 44, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 46, 1, 0, 0
  , 224, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 47, 1, 0, 0, 23, 0, 0, 0
  , 45, 1, 0, 0, 46, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 48, 1, 0, 0
  , 247, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 49, 1, 0, 0, 48, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 50, 1, 0, 0, 226, 0, 0, 0, 57, 0, 6, 0
  , 9, 0, 0, 0, 51, 1, 0, 0, 23, 0, 0, 0, 49, 1, 0, 0, 50, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 52, 1, 0, 0, 240, 0, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 53, 1, 0, 0, 52, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 54, 1, 0, 0, 228, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 55, 1, 0, 0
  , 23, 0, 0, 0, 53, 1, 0, 0, 54, 1, 0, 0, 57, 0, 8, 0, 2, 0, 0, 0
  , 56, 1, 0, 0, 16, 0, 0, 0, 43, 1, 0, 0, 47, 1, 0, 0, 51, 1, 0, 0
  , 55, 1, 0, 0, 62, 0, 3, 0, 57, 1, 0, 0, 56, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 58, 1, 0, 0, 216, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 59, 1, 0, 0, 244, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 60, 1, 0, 0
  , 59, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 61, 1, 0, 0, 224, 0, 0, 0
  , 57, 0, 6, 0, 9, 0, 0, 0, 62, 1, 0, 0, 23, 0, 0, 0, 60, 1, 0, 0
  , 61, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 63, 1, 0, 0, 247, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 64, 1, 0, 0, 63, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 65, 1, 0, 0, 226, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 66, 1, 0, 0, 23, 0, 0, 0, 64, 1, 0, 0, 65, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 67, 1, 0, 0, 240, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 68, 1, 0, 0, 67, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 69, 1, 0, 0
  , 228, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 70, 1, 0, 0, 23, 0, 0, 0
  , 68, 1, 0, 0, 69, 1, 0, 0, 57, 0, 8, 0, 2, 0, 0, 0, 71, 1, 0, 0
  , 16, 0, 0, 0, 58, 1, 0, 0, 62, 1, 0, 0, 66, 1, 0, 0, 70, 1, 0, 0
  , 62, 0, 3, 0, 72, 1, 0, 0, 71, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 73, 1, 0, 0, 216, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 74, 1, 0, 0
  , 232, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 75, 1, 0, 0, 74, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 76, 1, 0, 0, 224, 0, 0, 0, 57, 0, 6, 0
  , 9, 0, 0, 0, 77, 1, 0, 0, 23, 0, 0, 0, 75, 1, 0, 0, 76, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 78, 1, 0, 0, 236, 0, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 79, 1, 0, 0, 78, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 80, 1, 0, 0, 226, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 81, 1, 0, 0
  , 23, 0, 0, 0, 79, 1, 0, 0, 80, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 82, 1, 0, 0, 250, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 83, 1, 0, 0
  , 82, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 84, 1, 0, 0, 228, 0, 0, 0
  , 57, 0, 6, 0, 9, 0, 0, 0, 85, 1, 0, 0, 23, 0, 0, 0, 83, 1, 0, 0
  , 84, 1, 0, 0, 57, 0, 8, 0, 2, 0, 0, 0, 86, 1, 0, 0, 16, 0, 0, 0
  , 73, 1, 0, 0, 77, 1, 0, 0, 81, 1, 0, 0, 85, 1, 0, 0, 62, 0, 3, 0
  , 87, 1, 0, 0, 86, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 88, 1, 0, 0
  , 216, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 89, 1, 0, 0, 244, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 90, 1, 0, 0, 89, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 91, 1, 0, 0, 224, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 92, 1, 0, 0, 23, 0, 0, 0, 90, 1, 0, 0, 91, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 93, 1, 0, 0, 236, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 94, 1, 0, 0, 93, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 95, 1, 0, 0
  , 226, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 96, 1, 0, 0, 23, 0, 0, 0
  , 94, 1, 0, 0, 95, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 97, 1, 0, 0
  , 250, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 98, 1, 0, 0, 97, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 99, 1, 0, 0, 228, 0, 0, 0, 57, 0, 6, 0
  , 9, 0, 0, 0, 100, 1, 0, 0, 23, 0, 0, 0, 98, 1, 0, 0, 99, 1, 0, 0
  , 57, 0, 8, 0, 2, 0, 0, 0, 101, 1, 0, 0, 16, 0, 0, 0, 88, 1, 0, 0
  , 92, 1, 0, 0, 96, 1, 0, 0, 100, 1, 0, 0, 62, 0, 3, 0, 102, 1, 0, 0
  , 101, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 103, 1, 0, 0, 216, 0, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 104, 1, 0, 0, 232, 0, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 105, 1, 0, 0, 104, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 106, 1, 0, 0, 224, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 107, 1, 0, 0
  , 23, 0, 0, 0, 105, 1, 0, 0, 106, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 108, 1, 0, 0, 247, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 109, 1, 0, 0
  , 108, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 110, 1, 0, 0, 226, 0, 0, 0
  , 57, 0, 6, 0, 9, 0, 0, 0, 111, 1, 0, 0, 23, 0, 0, 0, 109, 1, 0, 0
  , 110, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 112, 1, 0, 0, 250, 0, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 113, 1, 0, 0, 112, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 114, 1, 0, 0, 228, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 115, 1, 0, 0, 23, 0, 0, 0, 113, 1, 0, 0, 114, 1, 0, 0, 57, 0, 8, 0
  , 2, 0, 0, 0, 116, 1, 0, 0, 16, 0, 0, 0, 103, 1, 0, 0, 107, 1, 0, 0
  , 111, 1, 0, 0, 115, 1, 0, 0, 62, 0, 3, 0, 117, 1, 0, 0, 116, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 118, 1, 0, 0, 216, 0, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 119, 1, 0, 0, 244, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 120, 1, 0, 0, 119, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 121, 1, 0, 0
  , 224, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 122, 1, 0, 0, 23, 0, 0, 0
  , 120, 1, 0, 0, 121, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 123, 1, 0, 0
  , 247, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 124, 1, 0, 0, 123, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 125, 1, 0, 0, 226, 0, 0, 0, 57, 0, 6, 0
  , 9, 0, 0, 0, 126, 1, 0, 0, 23, 0, 0, 0, 124, 1, 0, 0, 125, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 127, 1, 0, 0, 250, 0, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 128, 1, 0, 0, 127, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 129, 1, 0, 0, 228, 0, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 130, 1, 0, 0
  , 23, 0, 0, 0, 128, 1, 0, 0, 129, 1, 0, 0, 57, 0, 8, 0, 2, 0, 0, 0
  , 131, 1, 0, 0, 16, 0, 0, 0, 118, 1, 0, 0, 122, 1, 0, 0, 126, 1, 0, 0
  , 130, 1, 0, 0, 62, 0, 3, 0, 132, 1, 0, 0, 131, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 133, 1, 0, 0, 27, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 134, 1, 0, 0, 42, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 135, 1, 0, 0
  , 0, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 136, 1, 0, 0, 20, 0, 0, 0
  , 133, 1, 0, 0, 134, 1, 0, 0, 135, 1, 0, 0, 62, 0, 3, 0, 137, 1, 0, 0
  , 136, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 138, 1, 0, 0, 57, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 139, 1, 0, 0, 72, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 140, 1, 0, 0, 0, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0
  , 141, 1, 0, 0, 20, 0, 0, 0, 138, 1, 0, 0, 139, 1, 0, 0, 140, 1, 0, 0
  , 62, 0, 3, 0, 142, 1, 0, 0, 141, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 143, 1, 0, 0, 87, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 144, 1, 0, 0
  , 102, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 145, 1, 0, 0, 0, 1, 0, 0
  , 57, 0, 7, 0, 2, 0, 0, 0, 146, 1, 0, 0, 20, 0, 0, 0, 143, 1, 0, 0
  , 144, 1, 0, 0, 145, 1, 0, 0, 62, 0, 3, 0, 147, 1, 0, 0, 146, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 148, 1, 0, 0, 117, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 149, 1, 0, 0, 132, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 150, 1, 0, 0, 0, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 151, 1, 0, 0
  , 20, 0, 0, 0, 148, 1, 0, 0, 149, 1, 0, 0, 150, 1, 0, 0, 62, 0, 3, 0
  , 152, 1, 0, 0, 151, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 153, 1, 0, 0
  , 137, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 154, 1, 0, 0, 142, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 155, 1, 0, 0, 6, 1, 0, 0, 57, 0, 7, 0
  , 2, 0, 0, 0, 156, 1, 0, 0, 20, 0, 0, 0, 153, 1, 0, 0, 154, 1, 0, 0
  , 155, 1, 0, 0, 62, 0, 3, 0, 157, 1, 0, 0, 156, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 158, 1, 0, 0, 147, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 159, 1, 0, 0, 152, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 160, 1, 0, 0
  , 6, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 161, 1, 0, 0, 20, 0, 0, 0
  , 158, 1, 0, 0, 159, 1, 0, 0, 160, 1, 0, 0, 62, 0, 3, 0, 162, 1, 0, 0
  , 161, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 163, 1, 0, 0, 157, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 164, 1, 0, 0, 162, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 165, 1, 0, 0, 12, 1, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0
  , 166, 1, 0, 0, 20, 0, 0, 0, 163, 1, 0, 0, 164, 1, 0, 0, 165, 1, 0, 0
  , 254, 0, 2, 0, 166, 1, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 31, 0, 0, 0
  , 33, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 168, 1, 0, 0, 55, 0, 3, 0, 24, 0, 0, 0, 170, 1, 0, 0, 55, 0, 3, 0
  , 24, 0, 0, 0, 172, 1, 0, 0, 55, 0, 3, 0, 24, 0, 0, 0, 174, 1, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 176, 1, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 178, 1, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 180, 1, 0, 0, 248, 0, 2, 0
  , 167, 1, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 169, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 163, 0, 0, 0, 171, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 163, 0, 0, 0, 173, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 175, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 177, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 179, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 181, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 196, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 200, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 204, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 211, 1, 0, 0, 7, 0, 0, 0
  , 62, 0, 3, 0, 169, 1, 0, 0, 168, 1, 0, 0, 62, 0, 3, 0, 171, 1, 0, 0
  , 170, 1, 0, 0, 62, 0, 3, 0, 173, 1, 0, 0, 172, 1, 0, 0, 62, 0, 3, 0
  , 175, 1, 0, 0, 174, 1, 0, 0, 62, 0, 3, 0, 177, 1, 0, 0, 176, 1, 0, 0
  , 62, 0, 3, 0, 179, 1, 0, 0, 178, 1, 0, 0, 62, 0, 3, 0, 181, 1, 0, 0
  , 180, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 182, 1, 0, 0, 169, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 183, 1, 0, 0, 171, 1, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 184, 1, 0, 0, 183, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 185, 1, 0, 0, 177, 1, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0, 186, 1, 0, 0
  , 23, 0, 0, 0, 184, 1, 0, 0, 185, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 187, 1, 0, 0, 173, 1, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 188, 1, 0, 0
  , 187, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 189, 1, 0, 0, 179, 1, 0, 0
  , 57, 0, 6, 0, 9, 0, 0, 0, 190, 1, 0, 0, 23, 0, 0, 0, 188, 1, 0, 0
  , 189, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 191, 1, 0, 0, 175, 1, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 192, 1, 0, 0, 191, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 193, 1, 0, 0, 181, 1, 0, 0, 57, 0, 6, 0, 9, 0, 0, 0
  , 194, 1, 0, 0, 23, 0, 0, 0, 192, 1, 0, 0, 193, 1, 0, 0, 57, 0, 8, 0
  , 2, 0, 0, 0, 195, 1, 0, 0, 16, 0, 0, 0, 182, 1, 0, 0, 186, 1, 0, 0
  , 190, 1, 0, 0, 194, 1, 0, 0, 62, 0, 3, 0, 196, 1, 0, 0, 195, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 197, 1, 0, 0, 196, 1, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 199, 1, 0, 0, 197, 1, 0, 0, 198, 1, 0, 0, 62, 0, 3, 0
  , 200, 1, 0, 0, 199, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 201, 1, 0, 0
  , 196, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 202, 1, 0, 0, 201, 1, 0, 0
  , 117, 0, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 203, 1, 0, 0, 202, 1, 0, 0
  , 141, 0, 0, 0, 62, 0, 3, 0, 204, 1, 0, 0, 203, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 205, 1, 0, 0, 204, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 206, 1, 0, 0, 204, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 207, 1, 0, 0
  , 205, 1, 0, 0, 206, 1, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 208, 1, 0, 0
  , 141, 0, 0, 0, 207, 1, 0, 0, 12, 0, 7, 0, 2, 0, 0, 0, 209, 1, 0, 0
  , 142, 0, 0, 0, 40, 0, 0, 0, 140, 0, 0, 0, 208, 1, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 210, 1, 0, 0, 142, 0, 0, 0, 31, 0, 0, 0, 209, 1, 0, 0
  , 62, 0, 3, 0, 211, 1, 0, 0, 210, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 212, 1, 0, 0, 211, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 213, 1, 0, 0
  , 200, 1, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 214, 1, 0, 0, 142, 0, 0, 0
  , 14, 0, 0, 0, 213, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 215, 1, 0, 0
  , 212, 1, 0, 0, 214, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 216, 1, 0, 0
  , 211, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 217, 1, 0, 0, 200, 1, 0, 0
  , 12, 0, 6, 0, 2, 0, 0, 0, 218, 1, 0, 0, 142, 0, 0, 0, 13, 0, 0, 0
  , 217, 1, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 219, 1, 0, 0, 216, 1, 0, 0
  , 218, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 220, 1, 0, 0, 204, 1, 0, 0
  , 80, 0, 6, 0, 31, 0, 0, 0, 221, 1, 0, 0, 215, 1, 0, 0, 219, 1, 0, 0
  , 220, 1, 0, 0, 254, 0, 2, 0, 221, 1, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 34, 0, 0, 0, 0, 0, 0, 0, 29, 0, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 223, 1, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 225, 1, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 227, 1, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 229, 1, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 231, 1, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 233, 1, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 235, 1, 0, 0
  , 248, 0, 2, 0, 222, 1, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 224, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 226, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 228, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 230, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 232, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 234, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 236, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 163, 0, 0, 0, 240, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 163, 0, 0, 0, 244, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 248, 1, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 251, 1, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 254, 1, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 163, 0, 0, 0, 1, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 7, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 13, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 19, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 28, 2, 0, 0, 29, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 28, 2, 0, 0, 38, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 28, 2, 0, 0, 47, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 28, 2, 0, 0
  , 56, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 28, 2, 0, 0, 65, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 28, 2, 0, 0, 74, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 28, 2, 0, 0, 83, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 28, 2, 0, 0, 92, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 116, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 140, 2, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 164, 2, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 188, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 212, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 236, 2, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 4, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 28, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 33, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 38, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 43, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 48, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 53, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 58, 3, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 224, 1, 0, 0, 223, 1, 0, 0, 62, 0, 3, 0, 226, 1, 0, 0, 225, 1, 0, 0
  , 62, 0, 3, 0, 228, 1, 0, 0, 227, 1, 0, 0, 62, 0, 3, 0, 230, 1, 0, 0
  , 229, 1, 0, 0, 62, 0, 3, 0, 232, 1, 0, 0, 231, 1, 0, 0, 62, 0, 3, 0
  , 234, 1, 0, 0, 233, 1, 0, 0, 62, 0, 3, 0, 236, 1, 0, 0, 235, 1, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 237, 1, 0, 0, 226, 1, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 238, 1, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 237, 1, 0, 0
  , 110, 0, 4, 0, 24, 0, 0, 0, 239, 1, 0, 0, 238, 1, 0, 0, 62, 0, 3, 0
  , 240, 1, 0, 0, 239, 1, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 241, 1, 0, 0
  , 228, 1, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 242, 1, 0, 0, 142, 0, 0, 0
  , 8, 0, 0, 0, 241, 1, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0, 243, 1, 0, 0
  , 242, 1, 0, 0, 62, 0, 3, 0, 244, 1, 0, 0, 243, 1, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 245, 1, 0, 0, 230, 1, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 246, 1, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 245, 1, 0, 0, 110, 0, 4, 0
  , 24, 0, 0, 0, 247, 1, 0, 0, 246, 1, 0, 0, 62, 0, 3, 0, 248, 1, 0, 0
  , 247, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 249, 1, 0, 0, 240, 1, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 250, 1, 0, 0, 249, 1, 0, 0, 242, 0, 0, 0
  , 62, 0, 3, 0, 251, 1, 0, 0, 250, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 252, 1, 0, 0, 244, 1, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 253, 1, 0, 0
  , 252, 1, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 254, 1, 0, 0, 253, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 255, 1, 0, 0, 248, 1, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 0, 2, 0, 0, 255, 1, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0
  , 1, 2, 0, 0, 0, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 2, 2, 0, 0
  , 226, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 3, 2, 0, 0, 240, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 4, 2, 0, 0, 3, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 5, 2, 0, 0, 2, 2, 0, 0, 4, 2, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 6, 2, 0, 0, 18, 0, 0, 0, 5, 2, 0, 0, 62, 0, 3, 0
  , 7, 2, 0, 0, 6, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 8, 2, 0, 0
  , 228, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 9, 2, 0, 0, 244, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 10, 2, 0, 0, 9, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 11, 2, 0, 0, 8, 2, 0, 0, 10, 2, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 12, 2, 0, 0, 18, 0, 0, 0, 11, 2, 0, 0, 62, 0, 3, 0
  , 13, 2, 0, 0, 12, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 14, 2, 0, 0
  , 230, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 15, 2, 0, 0, 248, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 16, 2, 0, 0, 15, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 17, 2, 0, 0, 14, 2, 0, 0, 16, 2, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 18, 2, 0, 0, 18, 0, 0, 0, 17, 2, 0, 0, 62, 0, 3, 0
  , 19, 2, 0, 0, 18, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 20, 2, 0, 0
  , 224, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 21, 2, 0, 0, 240, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 22, 2, 0, 0, 244, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 23, 2, 0, 0, 248, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 24, 2, 0, 0, 232, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 25, 2, 0, 0
  , 234, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 26, 2, 0, 0, 236, 1, 0, 0
  , 57, 0, 11, 0, 31, 0, 0, 0, 27, 2, 0, 0, 33, 0, 0, 0, 20, 2, 0, 0
  , 21, 2, 0, 0, 22, 2, 0, 0, 23, 2, 0, 0, 24, 2, 0, 0, 25, 2, 0, 0
  , 26, 2, 0, 0, 62, 0, 3, 0, 29, 2, 0, 0, 27, 2, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 30, 2, 0, 0, 224, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 31, 2, 0, 0, 251, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 32, 2, 0, 0
  , 244, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 33, 2, 0, 0, 248, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 34, 2, 0, 0, 232, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 35, 2, 0, 0, 234, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 36, 2, 0, 0, 236, 1, 0, 0, 57, 0, 11, 0, 31, 0, 0, 0, 37, 2, 0, 0
  , 33, 0, 0, 0, 30, 2, 0, 0, 31, 2, 0, 0, 32, 2, 0, 0, 33, 2, 0, 0
  , 34, 2, 0, 0, 35, 2, 0, 0, 36, 2, 0, 0, 62, 0, 3, 0, 38, 2, 0, 0
  , 37, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 39, 2, 0, 0, 224, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 40, 2, 0, 0, 240, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 41, 2, 0, 0, 254, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 42, 2, 0, 0, 248, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 43, 2, 0, 0
  , 232, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 44, 2, 0, 0, 234, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 45, 2, 0, 0, 236, 1, 0, 0, 57, 0, 11, 0
  , 31, 0, 0, 0, 46, 2, 0, 0, 33, 0, 0, 0, 39, 2, 0, 0, 40, 2, 0, 0
  , 41, 2, 0, 0, 42, 2, 0, 0, 43, 2, 0, 0, 44, 2, 0, 0, 45, 2, 0, 0
  , 62, 0, 3, 0, 47, 2, 0, 0, 46, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 48, 2, 0, 0, 224, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 49, 2, 0, 0
  , 251, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 50, 2, 0, 0, 254, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 51, 2, 0, 0, 248, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 52, 2, 0, 0, 232, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 53, 2, 0, 0, 234, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 54, 2, 0, 0
  , 236, 1, 0, 0, 57, 0, 11, 0, 31, 0, 0, 0, 55, 2, 0, 0, 33, 0, 0, 0
  , 48, 2, 0, 0, 49, 2, 0, 0, 50, 2, 0, 0, 51, 2, 0, 0, 52, 2, 0, 0
  , 53, 2, 0, 0, 54, 2, 0, 0, 62, 0, 3, 0, 56, 2, 0, 0, 55, 2, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 57, 2, 0, 0, 224, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 58, 2, 0, 0, 240, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 59, 2, 0, 0, 244, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 60, 2, 0, 0
  , 1, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 61, 2, 0, 0, 232, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 62, 2, 0, 0, 234, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 63, 2, 0, 0, 236, 1, 0, 0, 57, 0, 11, 0, 31, 0, 0, 0
  , 64, 2, 0, 0, 33, 0, 0, 0, 57, 2, 0, 0, 58, 2, 0, 0, 59, 2, 0, 0
  , 60, 2, 0, 0, 61, 2, 0, 0, 62, 2, 0, 0, 63, 2, 0, 0, 62, 0, 3, 0
  , 65, 2, 0, 0, 64, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 66, 2, 0, 0
  , 224, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 67, 2, 0, 0, 251, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 68, 2, 0, 0, 244, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 69, 2, 0, 0, 1, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 70, 2, 0, 0, 232, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 71, 2, 0, 0
  , 234, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 72, 2, 0, 0, 236, 1, 0, 0
  , 57, 0, 11, 0, 31, 0, 0, 0, 73, 2, 0, 0, 33, 0, 0, 0, 66, 2, 0, 0
  , 67, 2, 0, 0, 68, 2, 0, 0, 69, 2, 0, 0, 70, 2, 0, 0, 71, 2, 0, 0
  , 72, 2, 0, 0, 62, 0, 3, 0, 74, 2, 0, 0, 73, 2, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 75, 2, 0, 0, 224, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 76, 2, 0, 0, 240, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 77, 2, 0, 0
  , 254, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 78, 2, 0, 0, 1, 2, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 79, 2, 0, 0, 232, 1, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 80, 2, 0, 0, 234, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 81, 2, 0, 0, 236, 1, 0, 0, 57, 0, 11, 0, 31, 0, 0, 0, 82, 2, 0, 0
  , 33, 0, 0, 0, 75, 2, 0, 0, 76, 2, 0, 0, 77, 2, 0, 0, 78, 2, 0, 0
  , 79, 2, 0, 0, 80, 2, 0, 0, 81, 2, 0, 0, 62, 0, 3, 0, 83, 2, 0, 0
  , 82, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 84, 2, 0, 0, 224, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 85, 2, 0, 0, 251, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 86, 2, 0, 0, 254, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 87, 2, 0, 0, 1, 2, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 88, 2, 0, 0
  , 232, 1, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 89, 2, 0, 0, 234, 1, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 90, 2, 0, 0, 236, 1, 0, 0, 57, 0, 11, 0
  , 31, 0, 0, 0, 91, 2, 0, 0, 33, 0, 0, 0, 84, 2, 0, 0, 85, 2, 0, 0
  , 86, 2, 0, 0, 87, 2, 0, 0, 88, 2, 0, 0, 89, 2, 0, 0, 90, 2, 0, 0
  , 62, 0, 3, 0, 92, 2, 0, 0, 91, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 93, 2, 0, 0, 29, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 94, 2, 0, 0
  , 93, 2, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 95, 2, 0, 0
  , 226, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 96, 2, 0, 0, 240, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 97, 2, 0, 0, 96, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 98, 2, 0, 0, 95, 2, 0, 0, 97, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 99, 2, 0, 0, 94, 2, 0, 0, 98, 2, 0, 0, 61, 0, 4, 0
  , 31, 0, 0, 0, 100, 2, 0, 0, 29, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 101, 2, 0, 0, 100, 2, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 102, 2, 0, 0, 228, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 103, 2, 0, 0
  , 244, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 104, 2, 0, 0, 103, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 105, 2, 0, 0, 102, 2, 0, 0, 104, 2, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 106, 2, 0, 0, 101, 2, 0, 0, 105, 2, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 107, 2, 0, 0, 99, 2, 0, 0, 106, 2, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 108, 2, 0, 0, 29, 2, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 109, 2, 0, 0, 108, 2, 0, 0, 2, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 110, 2, 0, 0, 230, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 111, 2, 0, 0, 248, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 112, 2, 0, 0
  , 111, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 113, 2, 0, 0, 110, 2, 0, 0
  , 112, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 114, 2, 0, 0, 109, 2, 0, 0
  , 113, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 115, 2, 0, 0, 107, 2, 0, 0
  , 114, 2, 0, 0, 62, 0, 3, 0, 116, 2, 0, 0, 115, 2, 0, 0, 61, 0, 4, 0
  , 31, 0, 0, 0, 117, 2, 0, 0, 38, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 118, 2, 0, 0, 117, 2, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 119, 2, 0, 0, 226, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 120, 2, 0, 0
  , 251, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 121, 2, 0, 0, 120, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 122, 2, 0, 0, 119, 2, 0, 0, 121, 2, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 123, 2, 0, 0, 118, 2, 0, 0, 122, 2, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 124, 2, 0, 0, 38, 2, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 125, 2, 0, 0, 124, 2, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 126, 2, 0, 0, 228, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 127, 2, 0, 0, 244, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 128, 2, 0, 0
  , 127, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 129, 2, 0, 0, 126, 2, 0, 0
  , 128, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 130, 2, 0, 0, 125, 2, 0, 0
  , 129, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 131, 2, 0, 0, 123, 2, 0, 0
  , 130, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 132, 2, 0, 0, 38, 2, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 133, 2, 0, 0, 132, 2, 0, 0, 2, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 134, 2, 0, 0, 230, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 135, 2, 0, 0, 248, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 136, 2, 0, 0, 135, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 137, 2, 0, 0
  , 134, 2, 0, 0, 136, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 138, 2, 0, 0
  , 133, 2, 0, 0, 137, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 139, 2, 0, 0
  , 131, 2, 0, 0, 138, 2, 0, 0, 62, 0, 3, 0, 140, 2, 0, 0, 139, 2, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 141, 2, 0, 0, 47, 2, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 142, 2, 0, 0, 141, 2, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 143, 2, 0, 0, 226, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 144, 2, 0, 0, 240, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 145, 2, 0, 0
  , 144, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 146, 2, 0, 0, 143, 2, 0, 0
  , 145, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 147, 2, 0, 0, 142, 2, 0, 0
  , 146, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 148, 2, 0, 0, 47, 2, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 149, 2, 0, 0, 148, 2, 0, 0, 1, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 150, 2, 0, 0, 228, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 151, 2, 0, 0, 254, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 152, 2, 0, 0, 151, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 153, 2, 0, 0
  , 150, 2, 0, 0, 152, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 154, 2, 0, 0
  , 149, 2, 0, 0, 153, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 155, 2, 0, 0
  , 147, 2, 0, 0, 154, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 156, 2, 0, 0
  , 47, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 157, 2, 0, 0, 156, 2, 0, 0
  , 2, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 158, 2, 0, 0, 230, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 159, 2, 0, 0, 248, 1, 0, 0, 111, 0, 4, 0
  , 2, 0, 0, 0, 160, 2, 0, 0, 159, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 161, 2, 0, 0, 158, 2, 0, 0, 160, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 162, 2, 0, 0, 157, 2, 0, 0, 161, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 163, 2, 0, 0, 155, 2, 0, 0, 162, 2, 0, 0, 62, 0, 3, 0, 164, 2, 0, 0
  , 163, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 165, 2, 0, 0, 56, 2, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 166, 2, 0, 0, 165, 2, 0, 0, 0, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 167, 2, 0, 0, 226, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 168, 2, 0, 0, 251, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 169, 2, 0, 0, 168, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 170, 2, 0, 0
  , 167, 2, 0, 0, 169, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 171, 2, 0, 0
  , 166, 2, 0, 0, 170, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 172, 2, 0, 0
  , 56, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 173, 2, 0, 0, 172, 2, 0, 0
  , 1, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 174, 2, 0, 0, 228, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 175, 2, 0, 0, 254, 1, 0, 0, 111, 0, 4, 0
  , 2, 0, 0, 0, 176, 2, 0, 0, 175, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 177, 2, 0, 0, 174, 2, 0, 0, 176, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 178, 2, 0, 0, 173, 2, 0, 0, 177, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 179, 2, 0, 0, 171, 2, 0, 0, 178, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 180, 2, 0, 0, 56, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 181, 2, 0, 0
  , 180, 2, 0, 0, 2, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 182, 2, 0, 0
  , 230, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 183, 2, 0, 0, 248, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 184, 2, 0, 0, 183, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 185, 2, 0, 0, 182, 2, 0, 0, 184, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 186, 2, 0, 0, 181, 2, 0, 0, 185, 2, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 187, 2, 0, 0, 179, 2, 0, 0, 186, 2, 0, 0, 62, 0, 3, 0
  , 188, 2, 0, 0, 187, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 189, 2, 0, 0
  , 65, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 190, 2, 0, 0, 189, 2, 0, 0
  , 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 191, 2, 0, 0, 226, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 192, 2, 0, 0, 240, 1, 0, 0, 111, 0, 4, 0
  , 2, 0, 0, 0, 193, 2, 0, 0, 192, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 194, 2, 0, 0, 191, 2, 0, 0, 193, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 195, 2, 0, 0, 190, 2, 0, 0, 194, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 196, 2, 0, 0, 65, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 197, 2, 0, 0
  , 196, 2, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 198, 2, 0, 0
  , 228, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 199, 2, 0, 0, 244, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 200, 2, 0, 0, 199, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 201, 2, 0, 0, 198, 2, 0, 0, 200, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 202, 2, 0, 0, 197, 2, 0, 0, 201, 2, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 203, 2, 0, 0, 195, 2, 0, 0, 202, 2, 0, 0, 61, 0, 4, 0
  , 31, 0, 0, 0, 204, 2, 0, 0, 65, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 205, 2, 0, 0, 204, 2, 0, 0, 2, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 206, 2, 0, 0, 230, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 207, 2, 0, 0
  , 1, 2, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 208, 2, 0, 0, 207, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 209, 2, 0, 0, 206, 2, 0, 0, 208, 2, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 210, 2, 0, 0, 205, 2, 0, 0, 209, 2, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 211, 2, 0, 0, 203, 2, 0, 0, 210, 2, 0, 0
  , 62, 0, 3, 0, 212, 2, 0, 0, 211, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 213, 2, 0, 0, 74, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 214, 2, 0, 0
  , 213, 2, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 215, 2, 0, 0
  , 226, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 216, 2, 0, 0, 251, 1, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 217, 2, 0, 0, 216, 2, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 218, 2, 0, 0, 215, 2, 0, 0, 217, 2, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 219, 2, 0, 0, 214, 2, 0, 0, 218, 2, 0, 0, 61, 0, 4, 0
  , 31, 0, 0, 0, 220, 2, 0, 0, 74, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 221, 2, 0, 0, 220, 2, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 222, 2, 0, 0, 228, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 223, 2, 0, 0
  , 244, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 224, 2, 0, 0, 223, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 225, 2, 0, 0, 222, 2, 0, 0, 224, 2, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 226, 2, 0, 0, 221, 2, 0, 0, 225, 2, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 227, 2, 0, 0, 219, 2, 0, 0, 226, 2, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 228, 2, 0, 0, 74, 2, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 229, 2, 0, 0, 228, 2, 0, 0, 2, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 230, 2, 0, 0, 230, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 231, 2, 0, 0, 1, 2, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 232, 2, 0, 0
  , 231, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 233, 2, 0, 0, 230, 2, 0, 0
  , 232, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 234, 2, 0, 0, 229, 2, 0, 0
  , 233, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 235, 2, 0, 0, 227, 2, 0, 0
  , 234, 2, 0, 0, 62, 0, 3, 0, 236, 2, 0, 0, 235, 2, 0, 0, 61, 0, 4, 0
  , 31, 0, 0, 0, 237, 2, 0, 0, 83, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 238, 2, 0, 0, 237, 2, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 239, 2, 0, 0, 226, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 240, 2, 0, 0
  , 240, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 241, 2, 0, 0, 240, 2, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 242, 2, 0, 0, 239, 2, 0, 0, 241, 2, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 243, 2, 0, 0, 238, 2, 0, 0, 242, 2, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 244, 2, 0, 0, 83, 2, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 245, 2, 0, 0, 244, 2, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 246, 2, 0, 0, 228, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 247, 2, 0, 0, 254, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 248, 2, 0, 0
  , 247, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 249, 2, 0, 0, 246, 2, 0, 0
  , 248, 2, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 250, 2, 0, 0, 245, 2, 0, 0
  , 249, 2, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 251, 2, 0, 0, 243, 2, 0, 0
  , 250, 2, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 252, 2, 0, 0, 83, 2, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 253, 2, 0, 0, 252, 2, 0, 0, 2, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 254, 2, 0, 0, 230, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 255, 2, 0, 0, 1, 2, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 0, 3, 0, 0, 255, 2, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 1, 3, 0, 0
  , 254, 2, 0, 0, 0, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 2, 3, 0, 0
  , 253, 2, 0, 0, 1, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 3, 3, 0, 0
  , 251, 2, 0, 0, 2, 3, 0, 0, 62, 0, 3, 0, 4, 3, 0, 0, 3, 3, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 5, 3, 0, 0, 92, 2, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 6, 3, 0, 0, 5, 3, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 7, 3, 0, 0, 226, 1, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 8, 3, 0, 0, 251, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 9, 3, 0, 0
  , 8, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 10, 3, 0, 0, 7, 3, 0, 0
  , 9, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 11, 3, 0, 0, 6, 3, 0, 0
  , 10, 3, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 12, 3, 0, 0, 92, 2, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 13, 3, 0, 0, 12, 3, 0, 0, 1, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 14, 3, 0, 0, 228, 1, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 15, 3, 0, 0, 254, 1, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 16, 3, 0, 0, 15, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 17, 3, 0, 0
  , 14, 3, 0, 0, 16, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 18, 3, 0, 0
  , 13, 3, 0, 0, 17, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 19, 3, 0, 0
  , 11, 3, 0, 0, 18, 3, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 20, 3, 0, 0
  , 92, 2, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 21, 3, 0, 0, 20, 3, 0, 0
  , 2, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 22, 3, 0, 0, 230, 1, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 23, 3, 0, 0, 1, 2, 0, 0, 111, 0, 4, 0
  , 2, 0, 0, 0, 24, 3, 0, 0, 23, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 25, 3, 0, 0, 22, 3, 0, 0, 24, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 26, 3, 0, 0, 21, 3, 0, 0, 25, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 27, 3, 0, 0, 19, 3, 0, 0, 26, 3, 0, 0, 62, 0, 3, 0, 28, 3, 0, 0
  , 27, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 29, 3, 0, 0, 116, 2, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 30, 3, 0, 0, 140, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 31, 3, 0, 0, 7, 2, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0
  , 32, 3, 0, 0, 20, 0, 0, 0, 29, 3, 0, 0, 30, 3, 0, 0, 31, 3, 0, 0
  , 62, 0, 3, 0, 33, 3, 0, 0, 32, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 34, 3, 0, 0, 164, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 35, 3, 0, 0
  , 188, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 36, 3, 0, 0, 7, 2, 0, 0
  , 57, 0, 7, 0, 2, 0, 0, 0, 37, 3, 0, 0, 20, 0, 0, 0, 34, 3, 0, 0
  , 35, 3, 0, 0, 36, 3, 0, 0, 62, 0, 3, 0, 38, 3, 0, 0, 37, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 39, 3, 0, 0, 212, 2, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 40, 3, 0, 0, 236, 2, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 41, 3, 0, 0, 7, 2, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 42, 3, 0, 0
  , 20, 0, 0, 0, 39, 3, 0, 0, 40, 3, 0, 0, 41, 3, 0, 0, 62, 0, 3, 0
  , 43, 3, 0, 0, 42, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 44, 3, 0, 0
  , 4, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 45, 3, 0, 0, 28, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 46, 3, 0, 0, 7, 2, 0, 0, 57, 0, 7, 0
  , 2, 0, 0, 0, 47, 3, 0, 0, 20, 0, 0, 0, 44, 3, 0, 0, 45, 3, 0, 0
  , 46, 3, 0, 0, 62, 0, 3, 0, 48, 3, 0, 0, 47, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 49, 3, 0, 0, 33, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 50, 3, 0, 0, 38, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 51, 3, 0, 0
  , 13, 2, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0, 52, 3, 0, 0, 20, 0, 0, 0
  , 49, 3, 0, 0, 50, 3, 0, 0, 51, 3, 0, 0, 62, 0, 3, 0, 53, 3, 0, 0
  , 52, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 54, 3, 0, 0, 43, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 55, 3, 0, 0, 48, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 56, 3, 0, 0, 13, 2, 0, 0, 57, 0, 7, 0, 2, 0, 0, 0
  , 57, 3, 0, 0, 20, 0, 0, 0, 54, 3, 0, 0, 55, 3, 0, 0, 56, 3, 0, 0
  , 62, 0, 3, 0, 58, 3, 0, 0, 57, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 59, 3, 0, 0, 53, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 60, 3, 0, 0
  , 58, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 61, 3, 0, 0, 19, 2, 0, 0
  , 57, 0, 7, 0, 2, 0, 0, 0, 62, 3, 0, 0, 20, 0, 0, 0, 59, 3, 0, 0
  , 60, 3, 0, 0, 61, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 63, 3, 0, 0
  , 62, 3, 0, 0, 210, 0, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 64, 3, 0, 0
  , 63, 3, 0, 0, 210, 0, 0, 0, 57, 0, 5, 0, 2, 0, 0, 0, 65, 3, 0, 0
  , 21, 0, 0, 0, 64, 3, 0, 0, 254, 0, 2, 0, 65, 3, 0, 0, 56, 0, 1, 0
  , 54, 0, 5, 0, 2, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0, 29, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 67, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 69, 3, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 71, 3, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 73, 3, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 75, 3, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 77, 3, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 79, 3, 0, 0, 248, 0, 2, 0, 66, 3, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 68, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 70, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 72, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 74, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 76, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 78, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 80, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 82, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 84, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 92, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 98, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 104, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 110, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 119, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 126, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 133, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 140, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 141, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 163, 0, 0, 0, 142, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 163, 0, 0, 0, 143, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 144, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 145, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 146, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 183, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 190, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 197, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 205, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 213, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 221, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 227, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 233, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 239, 3, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 240, 3, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 241, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 242, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 243, 3, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 1, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 28, 2, 0, 0, 15, 4, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 19, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 50, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 28, 2, 0, 0
  , 70, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 74, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 105, 4, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 28, 2, 0, 0, 125, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 129, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 160, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 28, 2, 0, 0, 177, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 181, 4, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 209, 4, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 68, 3, 0, 0, 67, 3, 0, 0, 62, 0, 3, 0, 70, 3, 0, 0, 69, 3, 0, 0
  , 62, 0, 3, 0, 72, 3, 0, 0, 71, 3, 0, 0, 62, 0, 3, 0, 74, 3, 0, 0
  , 73, 3, 0, 0, 62, 0, 3, 0, 76, 3, 0, 0, 75, 3, 0, 0, 62, 0, 3, 0
  , 78, 3, 0, 0, 77, 3, 0, 0, 62, 0, 3, 0, 80, 3, 0, 0, 79, 3, 0, 0
  , 62, 0, 3, 0, 82, 3, 0, 0, 81, 3, 0, 0, 62, 0, 3, 0, 84, 3, 0, 0
  , 83, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 85, 3, 0, 0, 70, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 86, 3, 0, 0, 72, 3, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 87, 3, 0, 0, 85, 3, 0, 0, 86, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 88, 3, 0, 0, 74, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 89, 3, 0, 0, 87, 3, 0, 0, 88, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 90, 3, 0, 0, 82, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 91, 3, 0, 0
  , 89, 3, 0, 0, 90, 3, 0, 0, 62, 0, 3, 0, 92, 3, 0, 0, 91, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 93, 3, 0, 0, 70, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 94, 3, 0, 0, 92, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 95, 3, 0, 0, 93, 3, 0, 0, 94, 3, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 96, 3, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 95, 3, 0, 0, 110, 0, 4, 0
  , 24, 0, 0, 0, 97, 3, 0, 0, 96, 3, 0, 0, 62, 0, 3, 0, 98, 3, 0, 0
  , 97, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 99, 3, 0, 0, 72, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 100, 3, 0, 0, 92, 3, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 101, 3, 0, 0, 99, 3, 0, 0, 100, 3, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 102, 3, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 101, 3, 0, 0
  , 110, 0, 4, 0, 24, 0, 0, 0, 103, 3, 0, 0, 102, 3, 0, 0, 62, 0, 3, 0
  , 104, 3, 0, 0, 103, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 105, 3, 0, 0
  , 74, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 106, 3, 0, 0, 92, 3, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 107, 3, 0, 0, 105, 3, 0, 0, 106, 3, 0, 0
  , 12, 0, 6, 0, 2, 0, 0, 0, 108, 3, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0
  , 107, 3, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0, 109, 3, 0, 0, 108, 3, 0, 0
  , 62, 0, 3, 0, 110, 3, 0, 0, 109, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 111, 3, 0, 0, 98, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 112, 3, 0, 0
  , 104, 3, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 113, 3, 0, 0, 111, 3, 0, 0
  , 112, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 114, 3, 0, 0, 110, 3, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 115, 3, 0, 0, 113, 3, 0, 0, 114, 3, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 116, 3, 0, 0, 115, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 117, 3, 0, 0, 84, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 118, 3, 0, 0, 116, 3, 0, 0, 117, 3, 0, 0, 62, 0, 3, 0, 119, 3, 0, 0
  , 118, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 120, 3, 0, 0, 70, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 121, 3, 0, 0, 98, 3, 0, 0, 111, 0, 4, 0
  , 2, 0, 0, 0, 122, 3, 0, 0, 121, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 123, 3, 0, 0, 119, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 124, 3, 0, 0
  , 122, 3, 0, 0, 123, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 125, 3, 0, 0
  , 120, 3, 0, 0, 124, 3, 0, 0, 62, 0, 3, 0, 126, 3, 0, 0, 125, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 127, 3, 0, 0, 72, 3, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 128, 3, 0, 0, 104, 3, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 129, 3, 0, 0, 128, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 130, 3, 0, 0
  , 119, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 131, 3, 0, 0, 129, 3, 0, 0
  , 130, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 132, 3, 0, 0, 127, 3, 0, 0
  , 131, 3, 0, 0, 62, 0, 3, 0, 133, 3, 0, 0, 132, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 134, 3, 0, 0, 74, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 135, 3, 0, 0, 110, 3, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 136, 3, 0, 0
  , 135, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 137, 3, 0, 0, 119, 3, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 138, 3, 0, 0, 136, 3, 0, 0, 137, 3, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 139, 3, 0, 0, 134, 3, 0, 0, 138, 3, 0, 0
  , 62, 0, 3, 0, 140, 3, 0, 0, 139, 3, 0, 0, 62, 0, 3, 0, 141, 3, 0, 0
  , 150, 0, 0, 0, 62, 0, 3, 0, 142, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0
  , 143, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0, 144, 3, 0, 0, 150, 0, 0, 0
  , 62, 0, 3, 0, 145, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0, 146, 3, 0, 0
  , 150, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 147, 3, 0, 0, 126, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 148, 3, 0, 0, 133, 3, 0, 0, 190, 0, 5, 0
  , 152, 0, 0, 0, 149, 3, 0, 0, 147, 3, 0, 0, 148, 3, 0, 0, 247, 0, 3, 0
  , 152, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 149, 3, 0, 0, 150, 3, 0, 0
  , 151, 3, 0, 0, 248, 0, 2, 0, 150, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 153, 3, 0, 0, 133, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 154, 3, 0, 0
  , 140, 3, 0, 0, 190, 0, 5, 0, 152, 0, 0, 0, 155, 3, 0, 0, 153, 3, 0, 0
  , 154, 3, 0, 0, 247, 0, 3, 0, 158, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0
  , 155, 3, 0, 0, 156, 3, 0, 0, 157, 3, 0, 0, 248, 0, 2, 0, 156, 3, 0, 0
  , 62, 0, 3, 0, 141, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 142, 3, 0, 0
  , 150, 0, 0, 0, 62, 0, 3, 0, 143, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0
  , 144, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 145, 3, 0, 0, 242, 0, 0, 0
  , 62, 0, 3, 0, 146, 3, 0, 0, 150, 0, 0, 0, 249, 0, 2, 0, 158, 3, 0, 0
  , 248, 0, 2, 0, 157, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 159, 3, 0, 0
  , 126, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 160, 3, 0, 0, 140, 3, 0, 0
  , 190, 0, 5, 0, 152, 0, 0, 0, 161, 3, 0, 0, 159, 3, 0, 0, 160, 3, 0, 0
  , 247, 0, 3, 0, 164, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 161, 3, 0, 0
  , 162, 3, 0, 0, 163, 3, 0, 0, 248, 0, 2, 0, 162, 3, 0, 0, 62, 0, 3, 0
  , 141, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 142, 3, 0, 0, 150, 0, 0, 0
  , 62, 0, 3, 0, 143, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0, 144, 3, 0, 0
  , 242, 0, 0, 0, 62, 0, 3, 0, 145, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0
  , 146, 3, 0, 0, 242, 0, 0, 0, 249, 0, 2, 0, 164, 3, 0, 0, 248, 0, 2, 0
  , 163, 3, 0, 0, 62, 0, 3, 0, 141, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0
  , 142, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0, 143, 3, 0, 0, 242, 0, 0, 0
  , 62, 0, 3, 0, 144, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 145, 3, 0, 0
  , 150, 0, 0, 0, 62, 0, 3, 0, 146, 3, 0, 0, 242, 0, 0, 0, 249, 0, 2, 0
  , 164, 3, 0, 0, 248, 0, 2, 0, 164, 3, 0, 0, 249, 0, 2, 0, 158, 3, 0, 0
  , 248, 0, 2, 0, 158, 3, 0, 0, 249, 0, 2, 0, 152, 3, 0, 0, 248, 0, 2, 0
  , 151, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 165, 3, 0, 0, 133, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 166, 3, 0, 0, 140, 3, 0, 0, 184, 0, 5, 0
  , 152, 0, 0, 0, 167, 3, 0, 0, 165, 3, 0, 0, 166, 3, 0, 0, 247, 0, 3, 0
  , 170, 3, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 167, 3, 0, 0, 168, 3, 0, 0
  , 169, 3, 0, 0, 248, 0, 2, 0, 168, 3, 0, 0, 62, 0, 3, 0, 141, 3, 0, 0
  , 150, 0, 0, 0, 62, 0, 3, 0, 142, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0
  , 143, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 144, 3, 0, 0, 150, 0, 0, 0
  , 62, 0, 3, 0, 145, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 146, 3, 0, 0
  , 242, 0, 0, 0, 249, 0, 2, 0, 170, 3, 0, 0, 248, 0, 2, 0, 169, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 171, 3, 0, 0, 126, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 172, 3, 0, 0, 140, 3, 0, 0, 184, 0, 5, 0, 152, 0, 0, 0
  , 173, 3, 0, 0, 171, 3, 0, 0, 172, 3, 0, 0, 247, 0, 3, 0, 176, 3, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 173, 3, 0, 0, 174, 3, 0, 0, 175, 3, 0, 0
  , 248, 0, 2, 0, 174, 3, 0, 0, 62, 0, 3, 0, 141, 3, 0, 0, 150, 0, 0, 0
  , 62, 0, 3, 0, 142, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 143, 3, 0, 0
  , 150, 0, 0, 0, 62, 0, 3, 0, 144, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0
  , 145, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0, 146, 3, 0, 0, 242, 0, 0, 0
  , 249, 0, 2, 0, 176, 3, 0, 0, 248, 0, 2, 0, 175, 3, 0, 0, 62, 0, 3, 0
  , 141, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0, 142, 3, 0, 0, 242, 0, 0, 0
  , 62, 0, 3, 0, 143, 3, 0, 0, 150, 0, 0, 0, 62, 0, 3, 0, 144, 3, 0, 0
  , 242, 0, 0, 0, 62, 0, 3, 0, 145, 3, 0, 0, 242, 0, 0, 0, 62, 0, 3, 0
  , 146, 3, 0, 0, 150, 0, 0, 0, 249, 0, 2, 0, 176, 3, 0, 0, 248, 0, 2, 0
  , 176, 3, 0, 0, 249, 0, 2, 0, 170, 3, 0, 0, 248, 0, 2, 0, 170, 3, 0, 0
  , 249, 0, 2, 0, 152, 3, 0, 0, 248, 0, 2, 0, 152, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 177, 3, 0, 0, 126, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 178, 3, 0, 0, 141, 3, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 179, 3, 0, 0
  , 178, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 180, 3, 0, 0, 177, 3, 0, 0
  , 179, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 181, 3, 0, 0, 84, 3, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 182, 3, 0, 0, 180, 3, 0, 0, 181, 3, 0, 0
  , 62, 0, 3, 0, 183, 3, 0, 0, 182, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 184, 3, 0, 0, 133, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 185, 3, 0, 0
  , 142, 3, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 186, 3, 0, 0, 185, 3, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 187, 3, 0, 0, 184, 3, 0, 0, 186, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 188, 3, 0, 0, 84, 3, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 189, 3, 0, 0, 187, 3, 0, 0, 188, 3, 0, 0, 62, 0, 3, 0
  , 190, 3, 0, 0, 189, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 191, 3, 0, 0
  , 140, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 192, 3, 0, 0, 143, 3, 0, 0
  , 111, 0, 4, 0, 2, 0, 0, 0, 193, 3, 0, 0, 192, 3, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 194, 3, 0, 0, 191, 3, 0, 0, 193, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 195, 3, 0, 0, 84, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 196, 3, 0, 0, 194, 3, 0, 0, 195, 3, 0, 0, 62, 0, 3, 0, 197, 3, 0, 0
  , 196, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 198, 3, 0, 0, 126, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 199, 3, 0, 0, 144, 3, 0, 0, 111, 0, 4, 0
  , 2, 0, 0, 0, 200, 3, 0, 0, 199, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 201, 3, 0, 0, 198, 3, 0, 0, 200, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 202, 3, 0, 0, 84, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 203, 3, 0, 0
  , 117, 0, 0, 0, 202, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 204, 3, 0, 0
  , 201, 3, 0, 0, 203, 3, 0, 0, 62, 0, 3, 0, 205, 3, 0, 0, 204, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 206, 3, 0, 0, 133, 3, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 207, 3, 0, 0, 145, 3, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0
  , 208, 3, 0, 0, 207, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 209, 3, 0, 0
  , 206, 3, 0, 0, 208, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 210, 3, 0, 0
  , 84, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 211, 3, 0, 0, 117, 0, 0, 0
  , 210, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 212, 3, 0, 0, 209, 3, 0, 0
  , 211, 3, 0, 0, 62, 0, 3, 0, 213, 3, 0, 0, 212, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 214, 3, 0, 0, 140, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 215, 3, 0, 0, 146, 3, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 216, 3, 0, 0
  , 215, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 217, 3, 0, 0, 214, 3, 0, 0
  , 216, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 218, 3, 0, 0, 84, 3, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 219, 3, 0, 0, 117, 0, 0, 0, 218, 3, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 220, 3, 0, 0, 217, 3, 0, 0, 219, 3, 0, 0
  , 62, 0, 3, 0, 221, 3, 0, 0, 220, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 222, 3, 0, 0, 126, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 223, 3, 0, 0
  , 222, 3, 0, 0, 141, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 224, 3, 0, 0
  , 84, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 225, 3, 0, 0, 116, 0, 0, 0
  , 224, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 226, 3, 0, 0, 223, 3, 0, 0
  , 225, 3, 0, 0, 62, 0, 3, 0, 227, 3, 0, 0, 226, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 228, 3, 0, 0, 133, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 229, 3, 0, 0, 228, 3, 0, 0, 141, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 230, 3, 0, 0, 84, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 231, 3, 0, 0
  , 116, 0, 0, 0, 230, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 232, 3, 0, 0
  , 229, 3, 0, 0, 231, 3, 0, 0, 62, 0, 3, 0, 233, 3, 0, 0, 232, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 234, 3, 0, 0, 140, 3, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 235, 3, 0, 0, 234, 3, 0, 0, 141, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 236, 3, 0, 0, 84, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 237, 3, 0, 0, 116, 0, 0, 0, 236, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 238, 3, 0, 0, 235, 3, 0, 0, 237, 3, 0, 0, 62, 0, 3, 0, 239, 3, 0, 0
  , 238, 3, 0, 0, 62, 0, 3, 0, 240, 3, 0, 0, 140, 0, 0, 0, 62, 0, 3, 0
  , 241, 3, 0, 0, 140, 0, 0, 0, 62, 0, 3, 0, 242, 3, 0, 0, 140, 0, 0, 0
  , 62, 0, 3, 0, 243, 3, 0, 0, 140, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 245, 3, 0, 0, 126, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 246, 3, 0, 0
  , 126, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 247, 3, 0, 0, 245, 3, 0, 0
  , 246, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 248, 3, 0, 0, 244, 3, 0, 0
  , 247, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 249, 3, 0, 0, 133, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 250, 3, 0, 0, 133, 3, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 251, 3, 0, 0, 249, 3, 0, 0, 250, 3, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 252, 3, 0, 0, 248, 3, 0, 0, 251, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 253, 3, 0, 0, 140, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 254, 3, 0, 0, 140, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 255, 3, 0, 0
  , 253, 3, 0, 0, 254, 3, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 0, 4, 0, 0
  , 252, 3, 0, 0, 255, 3, 0, 0, 62, 0, 3, 0, 1, 4, 0, 0, 0, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 2, 4, 0, 0, 1, 4, 0, 0, 186, 0, 5, 0
  , 152, 0, 0, 0, 3, 4, 0, 0, 2, 4, 0, 0, 140, 0, 0, 0, 247, 0, 3, 0
  , 6, 4, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 3, 4, 0, 0, 4, 4, 0, 0
  , 5, 4, 0, 0, 248, 0, 2, 0, 4, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 7, 4, 0, 0, 68, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 8, 4, 0, 0
  , 98, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 9, 4, 0, 0, 104, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 10, 4, 0, 0, 110, 3, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 11, 4, 0, 0, 76, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 12, 4, 0, 0, 78, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 13, 4, 0, 0
  , 80, 3, 0, 0, 57, 0, 11, 0, 31, 0, 0, 0, 14, 4, 0, 0, 33, 0, 0, 0
  , 7, 4, 0, 0, 8, 4, 0, 0, 9, 4, 0, 0, 10, 4, 0, 0, 11, 4, 0, 0
  , 12, 4, 0, 0, 13, 4, 0, 0, 62, 0, 3, 0, 15, 4, 0, 0, 14, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 16, 4, 0, 0, 1, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 17, 4, 0, 0, 1, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 18, 4, 0, 0, 16, 4, 0, 0, 17, 4, 0, 0, 62, 0, 3, 0, 19, 4, 0, 0
  , 18, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 20, 4, 0, 0, 19, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 21, 4, 0, 0, 19, 4, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 22, 4, 0, 0, 20, 4, 0, 0, 21, 4, 0, 0, 61, 0, 4, 0
  , 31, 0, 0, 0, 23, 4, 0, 0, 15, 4, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 24, 4, 0, 0, 23, 4, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 25, 4, 0, 0, 126, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 26, 4, 0, 0
  , 24, 4, 0, 0, 25, 4, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 27, 4, 0, 0
  , 15, 4, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 28, 4, 0, 0, 27, 4, 0, 0
  , 1, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 29, 4, 0, 0, 133, 3, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 30, 4, 0, 0, 28, 4, 0, 0, 29, 4, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 31, 4, 0, 0, 26, 4, 0, 0, 30, 4, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 32, 4, 0, 0, 15, 4, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 33, 4, 0, 0, 32, 4, 0, 0, 2, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 34, 4, 0, 0, 140, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 35, 4, 0, 0, 33, 4, 0, 0, 34, 4, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 36, 4, 0, 0, 31, 4, 0, 0, 35, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 37, 4, 0, 0, 22, 4, 0, 0, 36, 4, 0, 0, 62, 0, 3, 0, 240, 3, 0, 0
  , 37, 4, 0, 0, 249, 0, 2, 0, 6, 4, 0, 0, 248, 0, 2, 0, 5, 4, 0, 0
  , 249, 0, 2, 0, 6, 4, 0, 0, 248, 0, 2, 0, 6, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 38, 4, 0, 0, 183, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 39, 4, 0, 0, 183, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 40, 4, 0, 0
  , 38, 4, 0, 0, 39, 4, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 41, 4, 0, 0
  , 244, 3, 0, 0, 40, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 42, 4, 0, 0
  , 190, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 43, 4, 0, 0, 190, 3, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 44, 4, 0, 0, 42, 4, 0, 0, 43, 4, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 45, 4, 0, 0, 41, 4, 0, 0, 44, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 46, 4, 0, 0, 197, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 47, 4, 0, 0, 197, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 48, 4, 0, 0, 46, 4, 0, 0, 47, 4, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 49, 4, 0, 0, 45, 4, 0, 0, 48, 4, 0, 0, 62, 0, 3, 0, 50, 4, 0, 0
  , 49, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 51, 4, 0, 0, 50, 4, 0, 0
  , 186, 0, 5, 0, 152, 0, 0, 0, 52, 4, 0, 0, 51, 4, 0, 0, 140, 0, 0, 0
  , 247, 0, 3, 0, 55, 4, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 52, 4, 0, 0
  , 53, 4, 0, 0, 54, 4, 0, 0, 248, 0, 2, 0, 53, 4, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 56, 4, 0, 0, 68, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 57, 4, 0, 0, 98, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 58, 4, 0, 0
  , 141, 3, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 59, 4, 0, 0, 57, 4, 0, 0
  , 58, 4, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 60, 4, 0, 0, 104, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 61, 4, 0, 0, 142, 3, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 62, 4, 0, 0, 60, 4, 0, 0, 61, 4, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 63, 4, 0, 0, 110, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 64, 4, 0, 0, 143, 3, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 65, 4, 0, 0
  , 63, 4, 0, 0, 64, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 66, 4, 0, 0
  , 76, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 67, 4, 0, 0, 78, 3, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 68, 4, 0, 0, 80, 3, 0, 0, 57, 0, 11, 0
  , 31, 0, 0, 0, 69, 4, 0, 0, 33, 0, 0, 0, 56, 4, 0, 0, 59, 4, 0, 0
  , 62, 4, 0, 0, 65, 4, 0, 0, 66, 4, 0, 0, 67, 4, 0, 0, 68, 4, 0, 0
  , 62, 0, 3, 0, 70, 4, 0, 0, 69, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 71, 4, 0, 0, 50, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 72, 4, 0, 0
  , 50, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 73, 4, 0, 0, 71, 4, 0, 0
  , 72, 4, 0, 0, 62, 0, 3, 0, 74, 4, 0, 0, 73, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 75, 4, 0, 0, 74, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 76, 4, 0, 0, 74, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 77, 4, 0, 0
  , 75, 4, 0, 0, 76, 4, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 78, 4, 0, 0
  , 70, 4, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 79, 4, 0, 0, 78, 4, 0, 0
  , 0, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 80, 4, 0, 0, 183, 3, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 81, 4, 0, 0, 79, 4, 0, 0, 80, 4, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 82, 4, 0, 0, 70, 4, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 83, 4, 0, 0, 82, 4, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 84, 4, 0, 0, 190, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 85, 4, 0, 0, 83, 4, 0, 0, 84, 4, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 86, 4, 0, 0, 81, 4, 0, 0, 85, 4, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 87, 4, 0, 0, 70, 4, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 88, 4, 0, 0
  , 87, 4, 0, 0, 2, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 89, 4, 0, 0
  , 197, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 90, 4, 0, 0, 88, 4, 0, 0
  , 89, 4, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 91, 4, 0, 0, 86, 4, 0, 0
  , 90, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 92, 4, 0, 0, 77, 4, 0, 0
  , 91, 4, 0, 0, 62, 0, 3, 0, 241, 3, 0, 0, 92, 4, 0, 0, 249, 0, 2, 0
  , 55, 4, 0, 0, 248, 0, 2, 0, 54, 4, 0, 0, 249, 0, 2, 0, 55, 4, 0, 0
  , 248, 0, 2, 0, 55, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 93, 4, 0, 0
  , 205, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 94, 4, 0, 0, 205, 3, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 95, 4, 0, 0, 93, 4, 0, 0, 94, 4, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 96, 4, 0, 0, 244, 3, 0, 0, 95, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 97, 4, 0, 0, 213, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 98, 4, 0, 0, 213, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 99, 4, 0, 0, 97, 4, 0, 0, 98, 4, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 100, 4, 0, 0, 96, 4, 0, 0, 99, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 101, 4, 0, 0, 221, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 102, 4, 0, 0
  , 221, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 103, 4, 0, 0, 101, 4, 0, 0
  , 102, 4, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 104, 4, 0, 0, 100, 4, 0, 0
  , 103, 4, 0, 0, 62, 0, 3, 0, 105, 4, 0, 0, 104, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 106, 4, 0, 0, 105, 4, 0, 0, 186, 0, 5, 0, 152, 0, 0, 0
  , 107, 4, 0, 0, 106, 4, 0, 0, 140, 0, 0, 0, 247, 0, 3, 0, 110, 4, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 107, 4, 0, 0, 108, 4, 0, 0, 109, 4, 0, 0
  , 248, 0, 2, 0, 108, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 111, 4, 0, 0
  , 68, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 112, 4, 0, 0, 98, 3, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 113, 4, 0, 0, 144, 3, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 114, 4, 0, 0, 112, 4, 0, 0, 113, 4, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 115, 4, 0, 0, 104, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 116, 4, 0, 0, 145, 3, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 117, 4, 0, 0
  , 115, 4, 0, 0, 116, 4, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 118, 4, 0, 0
  , 110, 3, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 119, 4, 0, 0, 146, 3, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 120, 4, 0, 0, 118, 4, 0, 0, 119, 4, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 121, 4, 0, 0, 76, 3, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 122, 4, 0, 0, 78, 3, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 123, 4, 0, 0, 80, 3, 0, 0, 57, 0, 11, 0, 31, 0, 0, 0, 124, 4, 0, 0
  , 33, 0, 0, 0, 111, 4, 0, 0, 114, 4, 0, 0, 117, 4, 0, 0, 120, 4, 0, 0
  , 121, 4, 0, 0, 122, 4, 0, 0, 123, 4, 0, 0, 62, 0, 3, 0, 125, 4, 0, 0
  , 124, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 126, 4, 0, 0, 105, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 127, 4, 0, 0, 105, 4, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 128, 4, 0, 0, 126, 4, 0, 0, 127, 4, 0, 0, 62, 0, 3, 0
  , 129, 4, 0, 0, 128, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 130, 4, 0, 0
  , 129, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 131, 4, 0, 0, 129, 4, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 132, 4, 0, 0, 130, 4, 0, 0, 131, 4, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 133, 4, 0, 0, 125, 4, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 134, 4, 0, 0, 133, 4, 0, 0, 0, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 135, 4, 0, 0, 205, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 136, 4, 0, 0, 134, 4, 0, 0, 135, 4, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0
  , 137, 4, 0, 0, 125, 4, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 138, 4, 0, 0
  , 137, 4, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 139, 4, 0, 0
  , 213, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 140, 4, 0, 0, 138, 4, 0, 0
  , 139, 4, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 141, 4, 0, 0, 136, 4, 0, 0
  , 140, 4, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 142, 4, 0, 0, 125, 4, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 143, 4, 0, 0, 142, 4, 0, 0, 2, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 144, 4, 0, 0, 221, 3, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 145, 4, 0, 0, 143, 4, 0, 0, 144, 4, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 146, 4, 0, 0, 141, 4, 0, 0, 145, 4, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 147, 4, 0, 0, 132, 4, 0, 0, 146, 4, 0, 0, 62, 0, 3, 0
  , 242, 3, 0, 0, 147, 4, 0, 0, 249, 0, 2, 0, 110, 4, 0, 0, 248, 0, 2, 0
  , 109, 4, 0, 0, 249, 0, 2, 0, 110, 4, 0, 0, 248, 0, 2, 0, 110, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 148, 4, 0, 0, 227, 3, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 149, 4, 0, 0, 227, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 150, 4, 0, 0, 148, 4, 0, 0, 149, 4, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 151, 4, 0, 0, 244, 3, 0, 0, 150, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 152, 4, 0, 0, 233, 3, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 153, 4, 0, 0
  , 233, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 154, 4, 0, 0, 152, 4, 0, 0
  , 153, 4, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 155, 4, 0, 0, 151, 4, 0, 0
  , 154, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 156, 4, 0, 0, 239, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 157, 4, 0, 0, 239, 3, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 158, 4, 0, 0, 156, 4, 0, 0, 157, 4, 0, 0, 131, 0, 5, 0
  , 2, 0, 0, 0, 159, 4, 0, 0, 155, 4, 0, 0, 158, 4, 0, 0, 62, 0, 3, 0
  , 160, 4, 0, 0, 159, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 161, 4, 0, 0
  , 160, 4, 0, 0, 186, 0, 5, 0, 152, 0, 0, 0, 162, 4, 0, 0, 161, 4, 0, 0
  , 140, 0, 0, 0, 247, 0, 3, 0, 165, 4, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0
  , 162, 4, 0, 0, 163, 4, 0, 0, 164, 4, 0, 0, 248, 0, 2, 0, 163, 4, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 166, 4, 0, 0, 68, 3, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 167, 4, 0, 0, 98, 3, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0
  , 168, 4, 0, 0, 167, 4, 0, 0, 242, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 169, 4, 0, 0, 104, 3, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 170, 4, 0, 0
  , 169, 4, 0, 0, 242, 0, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 171, 4, 0, 0
  , 110, 3, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 172, 4, 0, 0, 171, 4, 0, 0
  , 242, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 173, 4, 0, 0, 76, 3, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 174, 4, 0, 0, 78, 3, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 175, 4, 0, 0, 80, 3, 0, 0, 57, 0, 11, 0, 31, 0, 0, 0
  , 176, 4, 0, 0, 33, 0, 0, 0, 166, 4, 0, 0, 168, 4, 0, 0, 170, 4, 0, 0
  , 172, 4, 0, 0, 173, 4, 0, 0, 174, 4, 0, 0, 175, 4, 0, 0, 62, 0, 3, 0
  , 177, 4, 0, 0, 176, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 178, 4, 0, 0
  , 160, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 179, 4, 0, 0, 160, 4, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 180, 4, 0, 0, 178, 4, 0, 0, 179, 4, 0, 0
  , 62, 0, 3, 0, 181, 4, 0, 0, 180, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 182, 4, 0, 0, 181, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 183, 4, 0, 0
  , 181, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 184, 4, 0, 0, 182, 4, 0, 0
  , 183, 4, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 185, 4, 0, 0, 177, 4, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 186, 4, 0, 0, 185, 4, 0, 0, 0, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 187, 4, 0, 0, 227, 3, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 188, 4, 0, 0, 186, 4, 0, 0, 187, 4, 0, 0, 61, 0, 4, 0
  , 31, 0, 0, 0, 189, 4, 0, 0, 177, 4, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 190, 4, 0, 0, 189, 4, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 191, 4, 0, 0, 233, 3, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 192, 4, 0, 0
  , 190, 4, 0, 0, 191, 4, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 193, 4, 0, 0
  , 188, 4, 0, 0, 192, 4, 0, 0, 61, 0, 4, 0, 31, 0, 0, 0, 194, 4, 0, 0
  , 177, 4, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 195, 4, 0, 0, 194, 4, 0, 0
  , 2, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 196, 4, 0, 0, 239, 3, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 197, 4, 0, 0, 195, 4, 0, 0, 196, 4, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 198, 4, 0, 0, 193, 4, 0, 0, 197, 4, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 199, 4, 0, 0, 184, 4, 0, 0, 198, 4, 0, 0
  , 62, 0, 3, 0, 243, 3, 0, 0, 199, 4, 0, 0, 249, 0, 2, 0, 165, 4, 0, 0
  , 248, 0, 2, 0, 164, 4, 0, 0, 249, 0, 2, 0, 165, 4, 0, 0, 248, 0, 2, 0
  , 165, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 200, 4, 0, 0, 240, 3, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 201, 4, 0, 0, 241, 3, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 202, 4, 0, 0, 200, 4, 0, 0, 201, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 203, 4, 0, 0, 242, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 204, 4, 0, 0, 202, 4, 0, 0, 203, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 205, 4, 0, 0, 243, 3, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 206, 4, 0, 0
  , 204, 4, 0, 0, 205, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 208, 4, 0, 0
  , 206, 4, 0, 0, 207, 4, 0, 0, 62, 0, 3, 0, 209, 4, 0, 0, 208, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 210, 4, 0, 0, 209, 4, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 211, 4, 0, 0, 210, 4, 0, 0, 210, 0, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 212, 4, 0, 0, 211, 4, 0, 0, 210, 0, 0, 0, 57, 0, 5, 0
  , 2, 0, 0, 0, 213, 4, 0, 0, 21, 0, 0, 0, 212, 4, 0, 0, 254, 0, 2, 0
  , 213, 4, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 2, 0, 0, 0, 36, 0, 0, 0
  , 0, 0, 0, 0, 29, 0, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 215, 4, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 217, 4, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 219, 4, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 221, 4, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 223, 4, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 225, 4, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 227, 4, 0, 0, 248, 0, 2, 0, 214, 4, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 216, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 218, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 220, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 222, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 224, 4, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 226, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 228, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 230, 4, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 236, 4, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 242, 4, 0, 0, 7, 0, 0, 0
  , 62, 0, 3, 0, 216, 4, 0, 0, 215, 4, 0, 0, 62, 0, 3, 0, 218, 4, 0, 0
  , 217, 4, 0, 0, 62, 0, 3, 0, 220, 4, 0, 0, 219, 4, 0, 0, 62, 0, 3, 0
  , 222, 4, 0, 0, 221, 4, 0, 0, 62, 0, 3, 0, 224, 4, 0, 0, 223, 4, 0, 0
  , 62, 0, 3, 0, 226, 4, 0, 0, 225, 4, 0, 0, 62, 0, 3, 0, 228, 4, 0, 0
  , 227, 4, 0, 0, 62, 0, 3, 0, 230, 4, 0, 0, 229, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 231, 4, 0, 0, 218, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 232, 4, 0, 0, 220, 4, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 233, 4, 0, 0
  , 231, 4, 0, 0, 232, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 234, 4, 0, 0
  , 230, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 235, 4, 0, 0, 233, 4, 0, 0
  , 234, 4, 0, 0, 62, 0, 3, 0, 236, 4, 0, 0, 235, 4, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 237, 4, 0, 0, 220, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 238, 4, 0, 0, 218, 4, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 239, 4, 0, 0
  , 237, 4, 0, 0, 238, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 240, 4, 0, 0
  , 230, 4, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 241, 4, 0, 0, 239, 4, 0, 0
  , 240, 4, 0, 0, 62, 0, 3, 0, 242, 4, 0, 0, 241, 4, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 243, 4, 0, 0, 216, 4, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 245, 4, 0, 0, 244, 4, 0, 0, 128, 0, 5, 0, 9, 0, 0, 0, 246, 4, 0, 0
  , 243, 4, 0, 0, 245, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 247, 4, 0, 0
  , 236, 4, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 248, 4, 0, 0, 242, 4, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 249, 4, 0, 0, 222, 4, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 250, 4, 0, 0, 224, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 251, 4, 0, 0, 226, 4, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 252, 4, 0, 0
  , 228, 4, 0, 0, 57, 0, 11, 0, 2, 0, 0, 0, 253, 4, 0, 0, 35, 0, 0, 0
  , 246, 4, 0, 0, 247, 4, 0, 0, 248, 4, 0, 0, 249, 4, 0, 0, 250, 4, 0, 0
  , 251, 4, 0, 0, 252, 4, 0, 0, 254, 0, 2, 0, 253, 4, 0, 0, 56, 0, 1, 0
  , 54, 0, 5, 0, 31, 0, 0, 0, 38, 0, 0, 0, 0, 0, 0, 0, 37, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 255, 4, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 1, 5, 0, 0, 55, 0, 3, 0, 24, 0, 0, 0, 3, 5, 0, 0, 55, 0, 3, 0
  , 24, 0, 0, 0, 5, 5, 0, 0, 55, 0, 3, 0, 24, 0, 0, 0, 7, 5, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 9, 5, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 11, 5, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 13, 5, 0, 0, 248, 0, 2, 0
  , 254, 4, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 0, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 2, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 163, 0, 0, 0, 4, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 6, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 8, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 10, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 12, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 14, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 19, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 24, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 29, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 38, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 53, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 68, 5, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0, 0, 5, 0, 0, 255, 4, 0, 0
  , 62, 0, 3, 0, 2, 5, 0, 0, 1, 5, 0, 0, 62, 0, 3, 0, 4, 5, 0, 0
  , 3, 5, 0, 0, 62, 0, 3, 0, 6, 5, 0, 0, 5, 5, 0, 0, 62, 0, 3, 0
  , 8, 5, 0, 0, 7, 5, 0, 0, 62, 0, 3, 0, 10, 5, 0, 0, 9, 5, 0, 0
  , 62, 0, 3, 0, 12, 5, 0, 0, 11, 5, 0, 0, 62, 0, 3, 0, 14, 5, 0, 0
  , 13, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 15, 5, 0, 0, 4, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 16, 5, 0, 0, 10, 5, 0, 0, 124, 0, 4, 0
  , 24, 0, 0, 0, 17, 5, 0, 0, 16, 5, 0, 0, 57, 0, 6, 0, 24, 0, 0, 0
  , 18, 5, 0, 0, 26, 0, 0, 0, 15, 5, 0, 0, 17, 5, 0, 0, 62, 0, 3, 0
  , 19, 5, 0, 0, 18, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 20, 5, 0, 0
  , 6, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 21, 5, 0, 0, 12, 5, 0, 0
  , 124, 0, 4, 0, 24, 0, 0, 0, 22, 5, 0, 0, 21, 5, 0, 0, 57, 0, 6, 0
  , 24, 0, 0, 0, 23, 5, 0, 0, 26, 0, 0, 0, 20, 5, 0, 0, 22, 5, 0, 0
  , 62, 0, 3, 0, 24, 5, 0, 0, 23, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 25, 5, 0, 0, 8, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 26, 5, 0, 0
  , 14, 5, 0, 0, 124, 0, 4, 0, 24, 0, 0, 0, 27, 5, 0, 0, 26, 5, 0, 0
  , 57, 0, 6, 0, 24, 0, 0, 0, 28, 5, 0, 0, 26, 0, 0, 0, 25, 5, 0, 0
  , 27, 5, 0, 0, 62, 0, 3, 0, 29, 5, 0, 0, 28, 5, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 30, 5, 0, 0, 0, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 31, 5, 0, 0, 19, 5, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 32, 5, 0, 0
  , 31, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 33, 5, 0, 0, 24, 5, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 34, 5, 0, 0, 33, 5, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 35, 5, 0, 0, 29, 5, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 36, 5, 0, 0, 35, 5, 0, 0, 57, 0, 8, 0, 2, 0, 0, 0, 37, 5, 0, 0
  , 16, 0, 0, 0, 30, 5, 0, 0, 32, 5, 0, 0, 34, 5, 0, 0, 36, 5, 0, 0
  , 62, 0, 3, 0, 38, 5, 0, 0, 37, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 39, 5, 0, 0, 0, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 40, 5, 0, 0
  , 19, 5, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 42, 5, 0, 0, 40, 5, 0, 0
  , 41, 5, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 43, 5, 0, 0, 42, 5, 0, 0
  , 61, 0, 4, 0, 24, 0, 0, 0, 44, 5, 0, 0, 24, 5, 0, 0, 128, 0, 5, 0
  , 24, 0, 0, 0, 46, 5, 0, 0, 44, 5, 0, 0, 45, 5, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 47, 5, 0, 0, 46, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 48, 5, 0, 0, 29, 5, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 50, 5, 0, 0
  , 48, 5, 0, 0, 49, 5, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 51, 5, 0, 0
  , 50, 5, 0, 0, 57, 0, 8, 0, 2, 0, 0, 0, 52, 5, 0, 0, 16, 0, 0, 0
  , 39, 5, 0, 0, 43, 5, 0, 0, 47, 5, 0, 0, 51, 5, 0, 0, 62, 0, 3, 0
  , 53, 5, 0, 0, 52, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 54, 5, 0, 0
  , 0, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 55, 5, 0, 0, 19, 5, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 57, 5, 0, 0, 55, 5, 0, 0, 56, 5, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 58, 5, 0, 0, 57, 5, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 59, 5, 0, 0, 24, 5, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0
  , 61, 5, 0, 0, 59, 5, 0, 0, 60, 5, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 62, 5, 0, 0, 61, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 63, 5, 0, 0
  , 29, 5, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 65, 5, 0, 0, 63, 5, 0, 0
  , 64, 5, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 66, 5, 0, 0, 65, 5, 0, 0
  , 57, 0, 8, 0, 2, 0, 0, 0, 67, 5, 0, 0, 16, 0, 0, 0, 54, 5, 0, 0
  , 58, 5, 0, 0, 62, 5, 0, 0, 66, 5, 0, 0, 62, 0, 3, 0, 68, 5, 0, 0
  , 67, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 69, 5, 0, 0, 38, 5, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 70, 5, 0, 0, 69, 5, 0, 0, 210, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 71, 5, 0, 0, 2, 5, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 72, 5, 0, 0, 70, 5, 0, 0, 71, 5, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 73, 5, 0, 0, 72, 5, 0, 0, 210, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 74, 5, 0, 0, 53, 5, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0
  , 75, 5, 0, 0, 74, 5, 0, 0, 210, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 76, 5, 0, 0, 2, 5, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 77, 5, 0, 0
  , 75, 5, 0, 0, 76, 5, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 78, 5, 0, 0
  , 77, 5, 0, 0, 210, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 79, 5, 0, 0
  , 68, 5, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 80, 5, 0, 0, 79, 5, 0, 0
  , 210, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 81, 5, 0, 0, 2, 5, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 82, 5, 0, 0, 80, 5, 0, 0, 81, 5, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 83, 5, 0, 0, 82, 5, 0, 0, 210, 0, 0, 0
  , 80, 0, 6, 0, 31, 0, 0, 0, 84, 5, 0, 0, 73, 5, 0, 0, 78, 5, 0, 0
  , 83, 5, 0, 0, 254, 0, 2, 0, 84, 5, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0
  , 2, 0, 0, 0, 40, 0, 0, 0, 0, 0, 0, 0, 39, 0, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 86, 5, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 88, 5, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 90, 5, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 92, 5, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 94, 5, 0, 0, 55, 0, 3, 0
  , 9, 0, 0, 0, 96, 5, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 98, 5, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 100, 5, 0, 0, 248, 0, 2, 0, 85, 5, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 87, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 89, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 91, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 93, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 95, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 97, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 99, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 101, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 105, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 109, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 163, 0, 0, 0, 113, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 115, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 117, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 125, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0, 133, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 163, 0, 0, 0, 143, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 163, 0, 0, 0, 147, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 163, 0, 0, 0
  , 151, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 28, 2, 0, 0, 161, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 167, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 173, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 179, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 186, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 193, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 200, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 212, 5, 0, 0, 7, 0, 0, 0, 62, 0, 3, 0
  , 87, 5, 0, 0, 86, 5, 0, 0, 62, 0, 3, 0, 89, 5, 0, 0, 88, 5, 0, 0
  , 62, 0, 3, 0, 91, 5, 0, 0, 90, 5, 0, 0, 62, 0, 3, 0, 93, 5, 0, 0
  , 92, 5, 0, 0, 62, 0, 3, 0, 95, 5, 0, 0, 94, 5, 0, 0, 62, 0, 3, 0
  , 97, 5, 0, 0, 96, 5, 0, 0, 62, 0, 3, 0, 99, 5, 0, 0, 98, 5, 0, 0
  , 62, 0, 3, 0, 101, 5, 0, 0, 100, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 102, 5, 0, 0, 91, 5, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 103, 5, 0, 0
  , 142, 0, 0, 0, 8, 0, 0, 0, 102, 5, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0
  , 104, 5, 0, 0, 103, 5, 0, 0, 62, 0, 3, 0, 105, 5, 0, 0, 104, 5, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 106, 5, 0, 0, 93, 5, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 107, 5, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 106, 5, 0, 0
  , 110, 0, 4, 0, 24, 0, 0, 0, 108, 5, 0, 0, 107, 5, 0, 0, 62, 0, 3, 0
  , 109, 5, 0, 0, 108, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 110, 5, 0, 0
  , 95, 5, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 111, 5, 0, 0, 142, 0, 0, 0
  , 8, 0, 0, 0, 110, 5, 0, 0, 110, 0, 4, 0, 24, 0, 0, 0, 112, 5, 0, 0
  , 111, 5, 0, 0, 62, 0, 3, 0, 113, 5, 0, 0, 112, 5, 0, 0, 62, 0, 3, 0
  , 115, 5, 0, 0, 114, 5, 0, 0, 126, 0, 4, 0, 24, 0, 0, 0, 116, 5, 0, 0
  , 242, 0, 0, 0, 62, 0, 3, 0, 117, 5, 0, 0, 116, 5, 0, 0, 249, 0, 2, 0
  , 118, 5, 0, 0, 248, 0, 2, 0, 118, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 122, 5, 0, 0, 117, 5, 0, 0, 179, 0, 5, 0, 152, 0, 0, 0, 123, 5, 0, 0
  , 122, 5, 0, 0, 242, 0, 0, 0, 246, 0, 4, 0, 121, 5, 0, 0, 120, 5, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 123, 5, 0, 0, 119, 5, 0, 0, 121, 5, 0, 0
  , 248, 0, 2, 0, 119, 5, 0, 0, 126, 0, 4, 0, 24, 0, 0, 0, 124, 5, 0, 0
  , 242, 0, 0, 0, 62, 0, 3, 0, 125, 5, 0, 0, 124, 5, 0, 0, 249, 0, 2, 0
  , 126, 5, 0, 0, 248, 0, 2, 0, 126, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 130, 5, 0, 0, 125, 5, 0, 0, 179, 0, 5, 0, 152, 0, 0, 0, 131, 5, 0, 0
  , 130, 5, 0, 0, 242, 0, 0, 0, 246, 0, 4, 0, 129, 5, 0, 0, 128, 5, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 131, 5, 0, 0, 127, 5, 0, 0, 129, 5, 0, 0
  , 248, 0, 2, 0, 127, 5, 0, 0, 126, 0, 4, 0, 24, 0, 0, 0, 132, 5, 0, 0
  , 242, 0, 0, 0, 62, 0, 3, 0, 133, 5, 0, 0, 132, 5, 0, 0, 249, 0, 2, 0
  , 134, 5, 0, 0, 248, 0, 2, 0, 134, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 138, 5, 0, 0, 133, 5, 0, 0, 179, 0, 5, 0, 152, 0, 0, 0, 139, 5, 0, 0
  , 138, 5, 0, 0, 242, 0, 0, 0, 246, 0, 4, 0, 137, 5, 0, 0, 136, 5, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 139, 5, 0, 0, 135, 5, 0, 0, 137, 5, 0, 0
  , 248, 0, 2, 0, 135, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 140, 5, 0, 0
  , 105, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 141, 5, 0, 0, 117, 5, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 142, 5, 0, 0, 140, 5, 0, 0, 141, 5, 0, 0
  , 62, 0, 3, 0, 143, 5, 0, 0, 142, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 144, 5, 0, 0, 109, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 145, 5, 0, 0
  , 125, 5, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 146, 5, 0, 0, 144, 5, 0, 0
  , 145, 5, 0, 0, 62, 0, 3, 0, 147, 5, 0, 0, 146, 5, 0, 0, 61, 0, 4, 0
  , 24, 0, 0, 0, 148, 5, 0, 0, 113, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 149, 5, 0, 0, 133, 5, 0, 0, 128, 0, 5, 0, 24, 0, 0, 0, 150, 5, 0, 0
  , 148, 5, 0, 0, 149, 5, 0, 0, 62, 0, 3, 0, 151, 5, 0, 0, 150, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 152, 5, 0, 0, 87, 5, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 153, 5, 0, 0, 89, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0
  , 154, 5, 0, 0, 143, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 155, 5, 0, 0
  , 147, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 156, 5, 0, 0, 151, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 157, 5, 0, 0, 97, 5, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 158, 5, 0, 0, 99, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 159, 5, 0, 0, 101, 5, 0, 0, 57, 0, 12, 0, 31, 0, 0, 0, 160, 5, 0, 0
  , 38, 0, 0, 0, 152, 5, 0, 0, 153, 5, 0, 0, 154, 5, 0, 0, 155, 5, 0, 0
  , 156, 5, 0, 0, 157, 5, 0, 0, 158, 5, 0, 0, 159, 5, 0, 0, 62, 0, 3, 0
  , 161, 5, 0, 0, 160, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 162, 5, 0, 0
  , 143, 5, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 163, 5, 0, 0, 162, 5, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 164, 5, 0, 0, 161, 5, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 165, 5, 0, 0, 164, 5, 0, 0, 0, 0, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 166, 5, 0, 0, 163, 5, 0, 0, 165, 5, 0, 0, 62, 0, 3, 0
  , 167, 5, 0, 0, 166, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 168, 5, 0, 0
  , 147, 5, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 169, 5, 0, 0, 168, 5, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 170, 5, 0, 0, 161, 5, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 171, 5, 0, 0, 170, 5, 0, 0, 1, 0, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 172, 5, 0, 0, 169, 5, 0, 0, 171, 5, 0, 0, 62, 0, 3, 0
  , 173, 5, 0, 0, 172, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 174, 5, 0, 0
  , 151, 5, 0, 0, 111, 0, 4, 0, 2, 0, 0, 0, 175, 5, 0, 0, 174, 5, 0, 0
  , 61, 0, 4, 0, 31, 0, 0, 0, 176, 5, 0, 0, 161, 5, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 177, 5, 0, 0, 176, 5, 0, 0, 2, 0, 0, 0, 129, 0, 5, 0
  , 2, 0, 0, 0, 178, 5, 0, 0, 175, 5, 0, 0, 177, 5, 0, 0, 62, 0, 3, 0
  , 179, 5, 0, 0, 178, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 180, 5, 0, 0
  , 167, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 181, 5, 0, 0, 91, 5, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 182, 5, 0, 0, 180, 5, 0, 0, 181, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 183, 5, 0, 0, 97, 5, 0, 0, 112, 0, 4, 0
  , 2, 0, 0, 0, 184, 5, 0, 0, 183, 5, 0, 0, 57, 0, 6, 0, 2, 0, 0, 0
  , 185, 5, 0, 0, 28, 0, 0, 0, 182, 5, 0, 0, 184, 5, 0, 0, 62, 0, 3, 0
  , 186, 5, 0, 0, 185, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 187, 5, 0, 0
  , 173, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 188, 5, 0, 0, 93, 5, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 189, 5, 0, 0, 187, 5, 0, 0, 188, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 190, 5, 0, 0, 99, 5, 0, 0, 112, 0, 4, 0
  , 2, 0, 0, 0, 191, 5, 0, 0, 190, 5, 0, 0, 57, 0, 6, 0, 2, 0, 0, 0
  , 192, 5, 0, 0, 28, 0, 0, 0, 189, 5, 0, 0, 191, 5, 0, 0, 62, 0, 3, 0
  , 193, 5, 0, 0, 192, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 194, 5, 0, 0
  , 179, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 195, 5, 0, 0, 95, 5, 0, 0
  , 131, 0, 5, 0, 2, 0, 0, 0, 196, 5, 0, 0, 194, 5, 0, 0, 195, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 197, 5, 0, 0, 101, 5, 0, 0, 112, 0, 4, 0
  , 2, 0, 0, 0, 198, 5, 0, 0, 197, 5, 0, 0, 57, 0, 6, 0, 2, 0, 0, 0
  , 199, 5, 0, 0, 28, 0, 0, 0, 196, 5, 0, 0, 198, 5, 0, 0, 62, 0, 3, 0
  , 200, 5, 0, 0, 199, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 201, 5, 0, 0
  , 186, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 202, 5, 0, 0, 186, 5, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 203, 5, 0, 0, 201, 5, 0, 0, 202, 5, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 204, 5, 0, 0, 193, 5, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 205, 5, 0, 0, 193, 5, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 206, 5, 0, 0, 204, 5, 0, 0, 205, 5, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 207, 5, 0, 0, 203, 5, 0, 0, 206, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 208, 5, 0, 0, 200, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 209, 5, 0, 0
  , 200, 5, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 210, 5, 0, 0, 208, 5, 0, 0
  , 209, 5, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 211, 5, 0, 0, 207, 5, 0, 0
  , 210, 5, 0, 0, 62, 0, 3, 0, 212, 5, 0, 0, 211, 5, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 213, 5, 0, 0, 115, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 214, 5, 0, 0, 212, 5, 0, 0, 12, 0, 7, 0, 2, 0, 0, 0, 215, 5, 0, 0
  , 142, 0, 0, 0, 37, 0, 0, 0, 213, 5, 0, 0, 214, 5, 0, 0, 62, 0, 3, 0
  , 115, 5, 0, 0, 215, 5, 0, 0, 249, 0, 2, 0, 136, 5, 0, 0, 248, 0, 2, 0
  , 136, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 216, 5, 0, 0, 133, 5, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 217, 5, 0, 0, 216, 5, 0, 0, 242, 0, 0, 0
  , 62, 0, 3, 0, 133, 5, 0, 0, 217, 5, 0, 0, 249, 0, 2, 0, 134, 5, 0, 0
  , 248, 0, 2, 0, 137, 5, 0, 0, 249, 0, 2, 0, 128, 5, 0, 0, 248, 0, 2, 0
  , 128, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 218, 5, 0, 0, 125, 5, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 219, 5, 0, 0, 218, 5, 0, 0, 242, 0, 0, 0
  , 62, 0, 3, 0, 125, 5, 0, 0, 219, 5, 0, 0, 249, 0, 2, 0, 126, 5, 0, 0
  , 248, 0, 2, 0, 129, 5, 0, 0, 249, 0, 2, 0, 120, 5, 0, 0, 248, 0, 2, 0
  , 120, 5, 0, 0, 61, 0, 4, 0, 24, 0, 0, 0, 220, 5, 0, 0, 117, 5, 0, 0
  , 128, 0, 5, 0, 24, 0, 0, 0, 221, 5, 0, 0, 220, 5, 0, 0, 242, 0, 0, 0
  , 62, 0, 3, 0, 117, 5, 0, 0, 221, 5, 0, 0, 249, 0, 2, 0, 118, 5, 0, 0
  , 248, 0, 2, 0, 121, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 222, 5, 0, 0
  , 115, 5, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 223, 5, 0, 0, 142, 0, 0, 0
  , 31, 0, 0, 0, 222, 5, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0, 225, 5, 0, 0
  , 223, 5, 0, 0, 224, 5, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 226, 5, 0, 0
  , 141, 0, 0, 0, 225, 5, 0, 0, 57, 0, 5, 0, 2, 0, 0, 0, 227, 5, 0, 0
  , 21, 0, 0, 0, 226, 5, 0, 0, 254, 0, 2, 0, 227, 5, 0, 0, 56, 0, 1, 0
  , 54, 0, 5, 0, 2, 0, 0, 0, 42, 0, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 229, 5, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 231, 5, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 233, 5, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 235, 5, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 237, 5, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 239, 5, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 241, 5, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0, 243, 5, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 245, 5, 0, 0, 248, 0, 2, 0, 228, 5, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 230, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 232, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 234, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 236, 5, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 238, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 240, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 242, 5, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 244, 5, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 246, 5, 0, 0, 7, 0, 0, 0
  , 62, 0, 3, 0, 230, 5, 0, 0, 229, 5, 0, 0, 62, 0, 3, 0, 232, 5, 0, 0
  , 231, 5, 0, 0, 62, 0, 3, 0, 234, 5, 0, 0, 233, 5, 0, 0, 62, 0, 3, 0
  , 236, 5, 0, 0, 235, 5, 0, 0, 62, 0, 3, 0, 238, 5, 0, 0, 237, 5, 0, 0
  , 62, 0, 3, 0, 240, 5, 0, 0, 239, 5, 0, 0, 62, 0, 3, 0, 242, 5, 0, 0
  , 241, 5, 0, 0, 62, 0, 3, 0, 244, 5, 0, 0, 243, 5, 0, 0, 62, 0, 3, 0
  , 246, 5, 0, 0, 245, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 247, 5, 0, 0
  , 230, 5, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 248, 5, 0, 0, 242, 0, 0, 0
  , 170, 0, 5, 0, 152, 0, 0, 0, 249, 5, 0, 0, 247, 5, 0, 0, 248, 5, 0, 0
  , 247, 0, 3, 0, 252, 5, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 249, 5, 0, 0
  , 250, 5, 0, 0, 251, 5, 0, 0, 248, 0, 2, 0, 250, 5, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 253, 5, 0, 0, 232, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 254, 5, 0, 0, 234, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 255, 5, 0, 0
  , 236, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 0, 6, 0, 0, 238, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 1, 6, 0, 0, 240, 5, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 2, 6, 0, 0, 242, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 3, 6, 0, 0, 244, 5, 0, 0, 57, 0, 11, 0, 2, 0, 0, 0, 4, 6, 0, 0
  , 30, 0, 0, 0, 253, 5, 0, 0, 254, 5, 0, 0, 255, 5, 0, 0, 0, 6, 0, 0
  , 1, 6, 0, 0, 2, 6, 0, 0, 3, 6, 0, 0, 254, 0, 2, 0, 4, 6, 0, 0
  , 248, 0, 2, 0, 251, 5, 0, 0, 249, 0, 2, 0, 252, 5, 0, 0, 248, 0, 2, 0
  , 252, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 5, 6, 0, 0, 230, 5, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 7, 6, 0, 0, 6, 6, 0, 0, 170, 0, 5, 0
  , 152, 0, 0, 0, 8, 6, 0, 0, 5, 6, 0, 0, 7, 6, 0, 0, 247, 0, 3, 0
  , 11, 6, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 8, 6, 0, 0, 9, 6, 0, 0
  , 10, 6, 0, 0, 248, 0, 2, 0, 9, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 12, 6, 0, 0, 232, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 13, 6, 0, 0
  , 234, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 14, 6, 0, 0, 236, 5, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 15, 6, 0, 0, 238, 5, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 16, 6, 0, 0, 240, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 17, 6, 0, 0, 242, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 18, 6, 0, 0
  , 244, 5, 0, 0, 57, 0, 11, 0, 2, 0, 0, 0, 19, 6, 0, 0, 34, 0, 0, 0
  , 12, 6, 0, 0, 13, 6, 0, 0, 14, 6, 0, 0, 15, 6, 0, 0, 16, 6, 0, 0
  , 17, 6, 0, 0, 18, 6, 0, 0, 254, 0, 2, 0, 19, 6, 0, 0, 248, 0, 2, 0
  , 10, 6, 0, 0, 249, 0, 2, 0, 11, 6, 0, 0, 248, 0, 2, 0, 11, 6, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 20, 6, 0, 0, 230, 5, 0, 0, 124, 0, 4, 0
  , 9, 0, 0, 0, 22, 6, 0, 0, 21, 6, 0, 0, 170, 0, 5, 0, 152, 0, 0, 0
  , 23, 6, 0, 0, 20, 6, 0, 0, 22, 6, 0, 0, 247, 0, 3, 0, 26, 6, 0, 0
  , 0, 0, 0, 0, 250, 0, 4, 0, 23, 6, 0, 0, 24, 6, 0, 0, 25, 6, 0, 0
  , 248, 0, 2, 0, 24, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 27, 6, 0, 0
  , 232, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 28, 6, 0, 0, 246, 5, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 29, 6, 0, 0, 234, 5, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 30, 6, 0, 0, 236, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 31, 6, 0, 0, 238, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 32, 6, 0, 0
  , 240, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 33, 6, 0, 0, 242, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 34, 6, 0, 0, 244, 5, 0, 0, 57, 0, 12, 0
  , 2, 0, 0, 0, 35, 6, 0, 0, 40, 0, 0, 0, 27, 6, 0, 0, 28, 6, 0, 0
  , 29, 6, 0, 0, 30, 6, 0, 0, 31, 6, 0, 0, 32, 6, 0, 0, 33, 6, 0, 0
  , 34, 6, 0, 0, 254, 0, 2, 0, 35, 6, 0, 0, 248, 0, 2, 0, 25, 6, 0, 0
  , 249, 0, 2, 0, 26, 6, 0, 0, 248, 0, 2, 0, 26, 6, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 36, 6, 0, 0, 230, 5, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 38, 6, 0, 0, 37, 6, 0, 0, 170, 0, 5, 0, 152, 0, 0, 0, 39, 6, 0, 0
  , 36, 6, 0, 0, 38, 6, 0, 0, 247, 0, 3, 0, 42, 6, 0, 0, 0, 0, 0, 0
  , 250, 0, 4, 0, 39, 6, 0, 0, 40, 6, 0, 0, 41, 6, 0, 0, 248, 0, 2, 0
  , 40, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 43, 6, 0, 0, 232, 5, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 44, 6, 0, 0, 234, 5, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 45, 6, 0, 0, 236, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 46, 6, 0, 0, 238, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 47, 6, 0, 0
  , 240, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 48, 6, 0, 0, 242, 5, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 49, 6, 0, 0, 244, 5, 0, 0, 57, 0, 11, 0
  , 2, 0, 0, 0, 50, 6, 0, 0, 35, 0, 0, 0, 43, 6, 0, 0, 44, 6, 0, 0
  , 45, 6, 0, 0, 46, 6, 0, 0, 47, 6, 0, 0, 48, 6, 0, 0, 49, 6, 0, 0
  , 254, 0, 2, 0, 50, 6, 0, 0, 248, 0, 2, 0, 41, 6, 0, 0, 249, 0, 2, 0
  , 42, 6, 0, 0, 248, 0, 2, 0, 42, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 51, 6, 0, 0, 232, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 52, 6, 0, 0
  , 234, 5, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 53, 6, 0, 0, 236, 5, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 54, 6, 0, 0, 238, 5, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 55, 6, 0, 0, 240, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 56, 6, 0, 0, 242, 5, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 57, 6, 0, 0
  , 244, 5, 0, 0, 57, 0, 11, 0, 2, 0, 0, 0, 58, 6, 0, 0, 36, 0, 0, 0
  , 51, 6, 0, 0, 52, 6, 0, 0, 53, 6, 0, 0, 54, 6, 0, 0, 55, 6, 0, 0
  , 56, 6, 0, 0, 57, 6, 0, 0, 254, 0, 2, 0, 58, 6, 0, 0, 56, 0, 1, 0
  , 54, 0, 5, 0, 2, 0, 0, 0, 44, 0, 0, 0, 0, 0, 0, 0, 43, 0, 0, 0
  , 55, 0, 3, 0, 9, 0, 0, 0, 60, 6, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 62, 6, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 64, 6, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 66, 6, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 68, 6, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 70, 6, 0, 0, 55, 0, 3, 0, 9, 0, 0, 0
  , 72, 6, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 74, 6, 0, 0, 55, 0, 3, 0
  , 2, 0, 0, 0, 76, 6, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 78, 6, 0, 0
  , 55, 0, 3, 0, 2, 0, 0, 0, 80, 6, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0
  , 82, 6, 0, 0, 55, 0, 3, 0, 2, 0, 0, 0, 84, 6, 0, 0, 248, 0, 2, 0
  , 59, 6, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 61, 6, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 63, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 65, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 67, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 69, 6, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 71, 6, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 47, 0, 0, 0, 73, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 75, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 77, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 79, 6, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 81, 6, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 83, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 85, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 86, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 87, 6, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 88, 6, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 89, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 91, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 113, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 125, 6, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 137, 6, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 143, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 149, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 155, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 166, 6, 0, 0
  , 7, 0, 0, 0, 62, 0, 3, 0, 61, 6, 0, 0, 60, 6, 0, 0, 62, 0, 3, 0
  , 63, 6, 0, 0, 62, 6, 0, 0, 62, 0, 3, 0, 65, 6, 0, 0, 64, 6, 0, 0
  , 62, 0, 3, 0, 67, 6, 0, 0, 66, 6, 0, 0, 62, 0, 3, 0, 69, 6, 0, 0
  , 68, 6, 0, 0, 62, 0, 3, 0, 71, 6, 0, 0, 70, 6, 0, 0, 62, 0, 3, 0
  , 73, 6, 0, 0, 72, 6, 0, 0, 62, 0, 3, 0, 75, 6, 0, 0, 74, 6, 0, 0
  , 62, 0, 3, 0, 77, 6, 0, 0, 76, 6, 0, 0, 62, 0, 3, 0, 79, 6, 0, 0
  , 78, 6, 0, 0, 62, 0, 3, 0, 81, 6, 0, 0, 80, 6, 0, 0, 62, 0, 3, 0
  , 83, 6, 0, 0, 82, 6, 0, 0, 62, 0, 3, 0, 85, 6, 0, 0, 84, 6, 0, 0
  , 62, 0, 3, 0, 86, 6, 0, 0, 141, 0, 0, 0, 62, 0, 3, 0, 87, 6, 0, 0
  , 141, 0, 0, 0, 62, 0, 3, 0, 88, 6, 0, 0, 140, 0, 0, 0, 62, 0, 3, 0
  , 89, 6, 0, 0, 140, 0, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 90, 6, 0, 0
  , 150, 0, 0, 0, 62, 0, 3, 0, 91, 6, 0, 0, 90, 6, 0, 0, 249, 0, 2, 0
  , 92, 6, 0, 0, 248, 0, 2, 0, 92, 6, 0, 0, 246, 0, 4, 0, 95, 6, 0, 0
  , 94, 6, 0, 0, 0, 0, 0, 0, 249, 0, 2, 0, 93, 6, 0, 0, 248, 0, 2, 0
  , 93, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 96, 6, 0, 0, 91, 6, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 97, 6, 0, 0, 73, 6, 0, 0, 174, 0, 5, 0
  , 152, 0, 0, 0, 98, 6, 0, 0, 96, 6, 0, 0, 97, 6, 0, 0, 247, 0, 3, 0
  , 101, 6, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 98, 6, 0, 0, 99, 6, 0, 0
  , 100, 6, 0, 0, 248, 0, 2, 0, 99, 6, 0, 0, 249, 0, 2, 0, 95, 6, 0, 0
  , 248, 0, 2, 0, 100, 6, 0, 0, 249, 0, 2, 0, 101, 6, 0, 0, 248, 0, 2, 0
  , 101, 6, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 102, 6, 0, 0, 150, 0, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 103, 6, 0, 0, 79, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 104, 6, 0, 0, 87, 6, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 105, 6, 0, 0, 103, 6, 0, 0, 104, 6, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0
  , 106, 6, 0, 0, 105, 6, 0, 0, 210, 0, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 107, 6, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 106, 6, 0, 0, 12, 0, 7, 0
  , 2, 0, 0, 0, 108, 6, 0, 0, 142, 0, 0, 0, 40, 0, 0, 0, 141, 0, 0, 0
  , 107, 6, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0, 109, 6, 0, 0, 108, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 110, 6, 0, 0, 79, 6, 0, 0, 186, 0, 5, 0
  , 152, 0, 0, 0, 111, 6, 0, 0, 110, 6, 0, 0, 140, 0, 0, 0, 169, 0, 6, 0
  , 9, 0, 0, 0, 112, 6, 0, 0, 111, 6, 0, 0, 109, 6, 0, 0, 102, 6, 0, 0
  , 62, 0, 3, 0, 113, 6, 0, 0, 112, 6, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 114, 6, 0, 0, 150, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 115, 6, 0, 0
  , 81, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 116, 6, 0, 0, 87, 6, 0, 0
  , 133, 0, 5, 0, 2, 0, 0, 0, 117, 6, 0, 0, 115, 6, 0, 0, 116, 6, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 118, 6, 0, 0, 117, 6, 0, 0, 210, 0, 0, 0
  , 12, 0, 6, 0, 2, 0, 0, 0, 119, 6, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0
  , 118, 6, 0, 0, 12, 0, 7, 0, 2, 0, 0, 0, 120, 6, 0, 0, 142, 0, 0, 0
  , 40, 0, 0, 0, 141, 0, 0, 0, 119, 6, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0
  , 121, 6, 0, 0, 120, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 122, 6, 0, 0
  , 81, 6, 0, 0, 186, 0, 5, 0, 152, 0, 0, 0, 123, 6, 0, 0, 122, 6, 0, 0
  , 140, 0, 0, 0, 169, 0, 6, 0, 9, 0, 0, 0, 124, 6, 0, 0, 123, 6, 0, 0
  , 121, 6, 0, 0, 114, 6, 0, 0, 62, 0, 3, 0, 125, 6, 0, 0, 124, 6, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 126, 6, 0, 0, 150, 0, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 127, 6, 0, 0, 83, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 128, 6, 0, 0, 87, 6, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 129, 6, 0, 0
  , 127, 6, 0, 0, 128, 6, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 130, 6, 0, 0
  , 129, 6, 0, 0, 210, 0, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 131, 6, 0, 0
  , 142, 0, 0, 0, 8, 0, 0, 0, 130, 6, 0, 0, 12, 0, 7, 0, 2, 0, 0, 0
  , 132, 6, 0, 0, 142, 0, 0, 0, 40, 0, 0, 0, 141, 0, 0, 0, 131, 6, 0, 0
  , 109, 0, 4, 0, 9, 0, 0, 0, 133, 6, 0, 0, 132, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 134, 6, 0, 0, 83, 6, 0, 0, 186, 0, 5, 0, 152, 0, 0, 0
  , 135, 6, 0, 0, 134, 6, 0, 0, 140, 0, 0, 0, 169, 0, 6, 0, 9, 0, 0, 0
  , 136, 6, 0, 0, 135, 6, 0, 0, 133, 6, 0, 0, 126, 6, 0, 0, 62, 0, 3, 0
  , 137, 6, 0, 0, 136, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 138, 6, 0, 0
  , 65, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 139, 6, 0, 0, 71, 6, 0, 0
  , 136, 0, 5, 0, 2, 0, 0, 0, 140, 6, 0, 0, 138, 6, 0, 0, 139, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 141, 6, 0, 0, 87, 6, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 142, 6, 0, 0, 140, 6, 0, 0, 141, 6, 0, 0, 62, 0, 3, 0
  , 143, 6, 0, 0, 142, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 144, 6, 0, 0
  , 67, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 145, 6, 0, 0, 71, 6, 0, 0
  , 136, 0, 5, 0, 2, 0, 0, 0, 146, 6, 0, 0, 144, 6, 0, 0, 145, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 147, 6, 0, 0, 87, 6, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 148, 6, 0, 0, 146, 6, 0, 0, 147, 6, 0, 0, 62, 0, 3, 0
  , 149, 6, 0, 0, 148, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 150, 6, 0, 0
  , 69, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 151, 6, 0, 0, 71, 6, 0, 0
  , 136, 0, 5, 0, 2, 0, 0, 0, 152, 6, 0, 0, 150, 6, 0, 0, 151, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 153, 6, 0, 0, 87, 6, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 154, 6, 0, 0, 152, 6, 0, 0, 153, 6, 0, 0, 62, 0, 3, 0
  , 155, 6, 0, 0, 154, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 156, 6, 0, 0
  , 61, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 157, 6, 0, 0, 63, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 158, 6, 0, 0, 143, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 159, 6, 0, 0, 149, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 160, 6, 0, 0, 155, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 161, 6, 0, 0
  , 113, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 162, 6, 0, 0, 125, 6, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 163, 6, 0, 0, 137, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 164, 6, 0, 0, 85, 6, 0, 0, 57, 0, 13, 0, 2, 0, 0, 0
  , 165, 6, 0, 0, 42, 0, 0, 0, 156, 6, 0, 0, 157, 6, 0, 0, 158, 6, 0, 0
  , 159, 6, 0, 0, 160, 6, 0, 0, 161, 6, 0, 0, 162, 6, 0, 0, 163, 6, 0, 0
  , 164, 6, 0, 0, 62, 0, 3, 0, 166, 6, 0, 0, 165, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 167, 6, 0, 0, 88, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 168, 6, 0, 0, 166, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 169, 6, 0, 0
  , 86, 6, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 170, 6, 0, 0, 168, 6, 0, 0
  , 169, 6, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 171, 6, 0, 0, 167, 6, 0, 0
  , 170, 6, 0, 0, 62, 0, 3, 0, 88, 6, 0, 0, 171, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 172, 6, 0, 0, 89, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 173, 6, 0, 0, 86, 6, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 174, 6, 0, 0
  , 172, 6, 0, 0, 173, 6, 0, 0, 62, 0, 3, 0, 89, 6, 0, 0, 174, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 175, 6, 0, 0, 86, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 176, 6, 0, 0, 77, 6, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 177, 6, 0, 0, 175, 6, 0, 0, 176, 6, 0, 0, 62, 0, 3, 0, 86, 6, 0, 0
  , 177, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 178, 6, 0, 0, 87, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 179, 6, 0, 0, 75, 6, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 180, 6, 0, 0, 178, 6, 0, 0, 179, 6, 0, 0, 62, 0, 3, 0
  , 87, 6, 0, 0, 180, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 181, 6, 0, 0
  , 91, 6, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0, 182, 6, 0, 0, 242, 0, 0, 0
  , 128, 0, 5, 0, 9, 0, 0, 0, 183, 6, 0, 0, 181, 6, 0, 0, 182, 6, 0, 0
  , 62, 0, 3, 0, 91, 6, 0, 0, 183, 6, 0, 0, 249, 0, 2, 0, 94, 6, 0, 0
  , 248, 0, 2, 0, 94, 6, 0, 0, 249, 0, 2, 0, 92, 6, 0, 0, 248, 0, 2, 0
  , 95, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 184, 6, 0, 0, 88, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 185, 6, 0, 0, 89, 6, 0, 0, 136, 0, 5, 0
  , 2, 0, 0, 0, 186, 6, 0, 0, 184, 6, 0, 0, 185, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 187, 6, 0, 0, 89, 6, 0, 0, 186, 0, 5, 0, 152, 0, 0, 0
  , 188, 6, 0, 0, 187, 6, 0, 0, 140, 0, 0, 0, 169, 0, 6, 0, 2, 0, 0, 0
  , 189, 6, 0, 0, 188, 6, 0, 0, 186, 6, 0, 0, 140, 0, 0, 0, 254, 0, 2, 0
  , 189, 6, 0, 0, 56, 0, 1, 0, 54, 0, 5, 0, 190, 6, 0, 0, 192, 6, 0, 0
  , 0, 0, 0, 0, 191, 6, 0, 0, 248, 0, 2, 0, 193, 6, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 198, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0
  , 203, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 208, 6, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 230, 6, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 236, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 47, 0, 0, 0, 244, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 248, 6, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 252, 6, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 47, 0, 0, 0, 1, 7, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 5, 7, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 9, 7, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 13, 7, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 17, 7, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 21, 7, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 25, 7, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 43, 7, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0
  , 61, 7, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 79, 7, 0, 0
  , 7, 0, 0, 0, 59, 0, 4, 0, 111, 0, 0, 0, 80, 7, 0, 0, 7, 0, 0, 0
  , 59, 0, 4, 0, 111, 0, 0, 0, 119, 7, 0, 0, 7, 0, 0, 0, 59, 0, 4, 0
  , 111, 0, 0, 0, 122, 7, 0, 0, 7, 0, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0
  , 194, 6, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 195, 6, 0, 0
  , 194, 6, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 196, 6, 0, 0
  , 195, 6, 0, 0, 0, 0, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0, 197, 6, 0, 0
  , 196, 6, 0, 0, 62, 0, 3, 0, 198, 6, 0, 0, 197, 6, 0, 0, 61, 0, 4, 0
  , 1, 0, 0, 0, 199, 6, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 200, 6, 0, 0, 199, 6, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 201, 6, 0, 0, 200, 6, 0, 0, 1, 0, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0
  , 202, 6, 0, 0, 201, 6, 0, 0, 62, 0, 3, 0, 203, 6, 0, 0, 202, 6, 0, 0
  , 61, 0, 4, 0, 1, 0, 0, 0, 204, 6, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0
  , 3, 0, 0, 0, 205, 6, 0, 0, 204, 6, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 206, 6, 0, 0, 205, 6, 0, 0, 2, 0, 0, 0, 109, 0, 4, 0
  , 9, 0, 0, 0, 207, 6, 0, 0, 206, 6, 0, 0, 62, 0, 3, 0, 208, 6, 0, 0
  , 207, 6, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0, 209, 6, 0, 0, 12, 0, 0, 0
  , 81, 0, 5, 0, 9, 0, 0, 0, 210, 6, 0, 0, 209, 6, 0, 0, 0, 0, 0, 0
  , 61, 0, 4, 0, 9, 0, 0, 0, 211, 6, 0, 0, 198, 6, 0, 0, 174, 0, 5, 0
  , 152, 0, 0, 0, 212, 6, 0, 0, 210, 6, 0, 0, 211, 6, 0, 0, 61, 0, 4, 0
  , 10, 0, 0, 0, 213, 6, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0
  , 214, 6, 0, 0, 213, 6, 0, 0, 1, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0
  , 215, 6, 0, 0, 203, 6, 0, 0, 174, 0, 5, 0, 152, 0, 0, 0, 216, 6, 0, 0
  , 214, 6, 0, 0, 215, 6, 0, 0, 166, 0, 5, 0, 152, 0, 0, 0, 217, 6, 0, 0
  , 212, 6, 0, 0, 216, 6, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0, 218, 6, 0, 0
  , 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 219, 6, 0, 0, 218, 6, 0, 0
  , 2, 0, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 220, 6, 0, 0, 208, 6, 0, 0
  , 174, 0, 5, 0, 152, 0, 0, 0, 221, 6, 0, 0, 219, 6, 0, 0, 220, 6, 0, 0
  , 166, 0, 5, 0, 152, 0, 0, 0, 222, 6, 0, 0, 217, 6, 0, 0, 221, 6, 0, 0
  , 247, 0, 3, 0, 225, 6, 0, 0, 0, 0, 0, 0, 250, 0, 4, 0, 222, 6, 0, 0
  , 223, 6, 0, 0, 224, 6, 0, 0, 248, 0, 2, 0, 223, 6, 0, 0, 248, 0, 2, 0
  , 224, 6, 0, 0, 249, 0, 2, 0, 225, 6, 0, 0, 248, 0, 2, 0, 225, 6, 0, 0
  , 61, 0, 4, 0, 1, 0, 0, 0, 226, 6, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0
  , 3, 0, 0, 0, 227, 6, 0, 0, 226, 6, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 228, 6, 0, 0, 227, 6, 0, 0, 3, 0, 0, 0, 109, 0, 4, 0
  , 9, 0, 0, 0, 229, 6, 0, 0, 228, 6, 0, 0, 62, 0, 3, 0, 230, 6, 0, 0
  , 229, 6, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 232, 6, 0, 0, 5, 0, 0, 0
  , 81, 0, 5, 0, 3, 0, 0, 0, 233, 6, 0, 0, 232, 6, 0, 0, 1, 0, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 234, 6, 0, 0, 233, 6, 0, 0, 0, 0, 0, 0
  , 12, 0, 7, 0, 2, 0, 0, 0, 235, 6, 0, 0, 142, 0, 0, 0, 40, 0, 0, 0
  , 231, 6, 0, 0, 234, 6, 0, 0, 62, 0, 3, 0, 236, 6, 0, 0, 235, 6, 0, 0
  , 124, 0, 4, 0, 9, 0, 0, 0, 237, 6, 0, 0, 242, 0, 0, 0, 61, 0, 4, 0
  , 1, 0, 0, 0, 238, 6, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 239, 6, 0, 0, 238, 6, 0, 0, 1, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 240, 6, 0, 0, 239, 6, 0, 0, 1, 0, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0
  , 241, 6, 0, 0, 240, 6, 0, 0, 172, 0, 5, 0, 152, 0, 0, 0, 242, 6, 0, 0
  , 237, 6, 0, 0, 241, 6, 0, 0, 169, 0, 6, 0, 9, 0, 0, 0, 243, 6, 0, 0
  , 242, 6, 0, 0, 237, 6, 0, 0, 241, 6, 0, 0, 62, 0, 3, 0, 244, 6, 0, 0
  , 243, 6, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 245, 6, 0, 0, 5, 0, 0, 0
  , 81, 0, 5, 0, 3, 0, 0, 0, 246, 6, 0, 0, 245, 6, 0, 0, 1, 0, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 247, 6, 0, 0, 246, 6, 0, 0, 2, 0, 0, 0
  , 62, 0, 3, 0, 248, 6, 0, 0, 247, 6, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0
  , 249, 6, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 250, 6, 0, 0
  , 249, 6, 0, 0, 1, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 251, 6, 0, 0
  , 250, 6, 0, 0, 3, 0, 0, 0, 62, 0, 3, 0, 252, 6, 0, 0, 251, 6, 0, 0
  , 61, 0, 4, 0, 1, 0, 0, 0, 253, 6, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0
  , 3, 0, 0, 0, 254, 6, 0, 0, 253, 6, 0, 0, 2, 0, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 255, 6, 0, 0, 254, 6, 0, 0, 0, 0, 0, 0, 109, 0, 4, 0
  , 9, 0, 0, 0, 0, 7, 0, 0, 255, 6, 0, 0, 62, 0, 3, 0, 1, 7, 0, 0
  , 0, 7, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 2, 7, 0, 0, 5, 0, 0, 0
  , 81, 0, 5, 0, 3, 0, 0, 0, 3, 7, 0, 0, 2, 7, 0, 0, 2, 0, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 4, 7, 0, 0, 3, 7, 0, 0, 1, 0, 0, 0
  , 62, 0, 3, 0, 5, 7, 0, 0, 4, 7, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0
  , 6, 7, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 7, 7, 0, 0
  , 6, 7, 0, 0, 2, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 8, 7, 0, 0
  , 7, 7, 0, 0, 2, 0, 0, 0, 62, 0, 3, 0, 9, 7, 0, 0, 8, 7, 0, 0
  , 61, 0, 4, 0, 1, 0, 0, 0, 10, 7, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0
  , 3, 0, 0, 0, 11, 7, 0, 0, 10, 7, 0, 0, 2, 0, 0, 0, 81, 0, 5, 0
  , 2, 0, 0, 0, 12, 7, 0, 0, 11, 7, 0, 0, 3, 0, 0, 0, 62, 0, 3, 0
  , 13, 7, 0, 0, 12, 7, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 14, 7, 0, 0
  , 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 15, 7, 0, 0, 14, 7, 0, 0
  , 3, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 16, 7, 0, 0, 15, 7, 0, 0
  , 0, 0, 0, 0, 62, 0, 3, 0, 17, 7, 0, 0, 16, 7, 0, 0, 61, 0, 4, 0
  , 1, 0, 0, 0, 18, 7, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 19, 7, 0, 0, 18, 7, 0, 0, 3, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 20, 7, 0, 0, 19, 7, 0, 0, 1, 0, 0, 0, 62, 0, 3, 0, 21, 7, 0, 0
  , 20, 7, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 22, 7, 0, 0, 5, 0, 0, 0
  , 81, 0, 5, 0, 3, 0, 0, 0, 23, 7, 0, 0, 22, 7, 0, 0, 3, 0, 0, 0
  , 81, 0, 5, 0, 2, 0, 0, 0, 24, 7, 0, 0, 23, 7, 0, 0, 2, 0, 0, 0
  , 62, 0, 3, 0, 25, 7, 0, 0, 24, 7, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0
  , 26, 7, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 27, 7, 0, 0
  , 26, 7, 0, 0, 0, 0, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0, 28, 7, 0, 0
  , 27, 7, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0, 29, 7, 0, 0, 12, 0, 0, 0
  , 81, 0, 5, 0, 9, 0, 0, 0, 30, 7, 0, 0, 29, 7, 0, 0, 0, 0, 0, 0
  , 112, 0, 4, 0, 2, 0, 0, 0, 31, 7, 0, 0, 30, 7, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 32, 7, 0, 0, 17, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 33, 7, 0, 0, 236, 6, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 34, 7, 0, 0
  , 32, 7, 0, 0, 33, 7, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0, 35, 7, 0, 0
  , 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 36, 7, 0, 0, 35, 7, 0, 0
  , 0, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 37, 7, 0, 0, 36, 7, 0, 0
  , 0, 0, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0, 38, 7, 0, 0, 34, 7, 0, 0
  , 37, 7, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 39, 7, 0, 0, 31, 7, 0, 0
  , 38, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 40, 7, 0, 0, 17, 7, 0, 0
  , 186, 0, 5, 0, 152, 0, 0, 0, 41, 7, 0, 0, 40, 7, 0, 0, 140, 0, 0, 0
  , 169, 0, 6, 0, 2, 0, 0, 0, 42, 7, 0, 0, 41, 7, 0, 0, 39, 7, 0, 0
  , 28, 7, 0, 0, 62, 0, 3, 0, 43, 7, 0, 0, 42, 7, 0, 0, 61, 0, 4, 0
  , 10, 0, 0, 0, 44, 7, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0
  , 45, 7, 0, 0, 44, 7, 0, 0, 1, 0, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0
  , 46, 7, 0, 0, 45, 7, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0, 47, 7, 0, 0
  , 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 48, 7, 0, 0, 47, 7, 0, 0
  , 1, 0, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0, 49, 7, 0, 0, 48, 7, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 50, 7, 0, 0, 21, 7, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 51, 7, 0, 0, 236, 6, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 52, 7, 0, 0, 50, 7, 0, 0, 51, 7, 0, 0, 61, 0, 4, 0, 1, 0, 0, 0
  , 53, 7, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0, 54, 7, 0, 0
  , 53, 7, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0, 55, 7, 0, 0
  , 54, 7, 0, 0, 1, 0, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0, 56, 7, 0, 0
  , 52, 7, 0, 0, 55, 7, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 57, 7, 0, 0
  , 49, 7, 0, 0, 56, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 58, 7, 0, 0
  , 21, 7, 0, 0, 186, 0, 5, 0, 152, 0, 0, 0, 59, 7, 0, 0, 58, 7, 0, 0
  , 140, 0, 0, 0, 169, 0, 6, 0, 2, 0, 0, 0, 60, 7, 0, 0, 59, 7, 0, 0
  , 57, 7, 0, 0, 46, 7, 0, 0, 62, 0, 3, 0, 61, 7, 0, 0, 60, 7, 0, 0
  , 61, 0, 4, 0, 10, 0, 0, 0, 62, 7, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0
  , 9, 0, 0, 0, 63, 7, 0, 0, 62, 7, 0, 0, 2, 0, 0, 0, 112, 0, 4, 0
  , 2, 0, 0, 0, 64, 7, 0, 0, 63, 7, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0
  , 65, 7, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 66, 7, 0, 0
  , 65, 7, 0, 0, 2, 0, 0, 0, 112, 0, 4, 0, 2, 0, 0, 0, 67, 7, 0, 0
  , 66, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 68, 7, 0, 0, 25, 7, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 69, 7, 0, 0, 236, 6, 0, 0, 133, 0, 5, 0
  , 2, 0, 0, 0, 70, 7, 0, 0, 68, 7, 0, 0, 69, 7, 0, 0, 61, 0, 4, 0
  , 1, 0, 0, 0, 71, 7, 0, 0, 5, 0, 0, 0, 81, 0, 5, 0, 3, 0, 0, 0
  , 72, 7, 0, 0, 71, 7, 0, 0, 0, 0, 0, 0, 81, 0, 5, 0, 2, 0, 0, 0
  , 73, 7, 0, 0, 72, 7, 0, 0, 2, 0, 0, 0, 136, 0, 5, 0, 2, 0, 0, 0
  , 74, 7, 0, 0, 70, 7, 0, 0, 73, 7, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0
  , 75, 7, 0, 0, 67, 7, 0, 0, 74, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 76, 7, 0, 0, 25, 7, 0, 0, 186, 0, 5, 0, 152, 0, 0, 0, 77, 7, 0, 0
  , 76, 7, 0, 0, 140, 0, 0, 0, 169, 0, 6, 0, 2, 0, 0, 0, 78, 7, 0, 0
  , 77, 7, 0, 0, 75, 7, 0, 0, 64, 7, 0, 0, 62, 0, 3, 0, 79, 7, 0, 0
  , 78, 7, 0, 0, 62, 0, 3, 0, 80, 7, 0, 0, 140, 0, 0, 0, 61, 0, 4, 0
  , 9, 0, 0, 0, 81, 7, 0, 0, 230, 6, 0, 0, 124, 0, 4, 0, 9, 0, 0, 0
  , 82, 7, 0, 0, 150, 0, 0, 0, 170, 0, 5, 0, 152, 0, 0, 0, 83, 7, 0, 0
  , 81, 7, 0, 0, 82, 7, 0, 0, 247, 0, 3, 0, 86, 7, 0, 0, 0, 0, 0, 0
  , 250, 0, 4, 0, 83, 7, 0, 0, 84, 7, 0, 0, 85, 7, 0, 0, 248, 0, 2, 0
  , 84, 7, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 87, 7, 0, 0, 1, 7, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 88, 7, 0, 0, 43, 7, 0, 0, 12, 0, 6, 0
  , 2, 0, 0, 0, 89, 7, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 88, 7, 0, 0
  , 109, 0, 4, 0, 9, 0, 0, 0, 90, 7, 0, 0, 89, 7, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 91, 7, 0, 0, 61, 7, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0
  , 92, 7, 0, 0, 142, 0, 0, 0, 8, 0, 0, 0, 91, 7, 0, 0, 109, 0, 4, 0
  , 9, 0, 0, 0, 93, 7, 0, 0, 92, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 94, 7, 0, 0, 79, 7, 0, 0, 12, 0, 6, 0, 2, 0, 0, 0, 95, 7, 0, 0
  , 142, 0, 0, 0, 8, 0, 0, 0, 94, 7, 0, 0, 109, 0, 4, 0, 9, 0, 0, 0
  , 96, 7, 0, 0, 95, 7, 0, 0, 57, 0, 8, 0, 2, 0, 0, 0, 97, 7, 0, 0
  , 16, 0, 0, 0, 87, 7, 0, 0, 90, 7, 0, 0, 93, 7, 0, 0, 96, 7, 0, 0
  , 62, 0, 3, 0, 80, 7, 0, 0, 97, 7, 0, 0, 249, 0, 2, 0, 86, 7, 0, 0
  , 248, 0, 2, 0, 85, 7, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 98, 7, 0, 0
  , 230, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 99, 7, 0, 0, 1, 7, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 100, 7, 0, 0, 43, 7, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 101, 7, 0, 0, 61, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 102, 7, 0, 0, 79, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 103, 7, 0, 0
  , 236, 6, 0, 0, 61, 0, 4, 0, 9, 0, 0, 0, 104, 7, 0, 0, 244, 6, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 105, 7, 0, 0, 248, 6, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 106, 7, 0, 0, 252, 6, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 107, 7, 0, 0, 17, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 108, 7, 0, 0
  , 21, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 109, 7, 0, 0, 25, 7, 0, 0
  , 61, 0, 4, 0, 2, 0, 0, 0, 110, 7, 0, 0, 5, 7, 0, 0, 57, 0, 17, 0
  , 2, 0, 0, 0, 111, 7, 0, 0, 44, 0, 0, 0, 98, 7, 0, 0, 99, 7, 0, 0
  , 100, 7, 0, 0, 101, 7, 0, 0, 102, 7, 0, 0, 103, 7, 0, 0, 104, 7, 0, 0
  , 105, 7, 0, 0, 106, 7, 0, 0, 107, 7, 0, 0, 108, 7, 0, 0, 109, 7, 0, 0
  , 110, 7, 0, 0, 62, 0, 3, 0, 80, 7, 0, 0, 111, 7, 0, 0, 249, 0, 2, 0
  , 86, 7, 0, 0, 248, 0, 2, 0, 86, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 112, 7, 0, 0, 80, 7, 0, 0, 131, 0, 5, 0, 2, 0, 0, 0, 113, 7, 0, 0
  , 112, 7, 0, 0, 210, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 114, 7, 0, 0
  , 9, 7, 0, 0, 133, 0, 5, 0, 2, 0, 0, 0, 115, 7, 0, 0, 113, 7, 0, 0
  , 114, 7, 0, 0, 129, 0, 5, 0, 2, 0, 0, 0, 116, 7, 0, 0, 115, 7, 0, 0
  , 210, 0, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 117, 7, 0, 0, 13, 7, 0, 0
  , 129, 0, 5, 0, 2, 0, 0, 0, 118, 7, 0, 0, 116, 7, 0, 0, 117, 7, 0, 0
  , 62, 0, 3, 0, 119, 7, 0, 0, 118, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 120, 7, 0, 0, 119, 7, 0, 0, 57, 0, 5, 0, 2, 0, 0, 0, 121, 7, 0, 0
  , 21, 0, 0, 0, 120, 7, 0, 0, 62, 0, 3, 0, 122, 7, 0, 0, 121, 7, 0, 0
  , 61, 0, 4, 0, 6, 0, 0, 0, 123, 7, 0, 0, 8, 0, 0, 0, 61, 0, 4, 0
  , 10, 0, 0, 0, 124, 7, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0
  , 125, 7, 0, 0, 124, 7, 0, 0, 0, 0, 0, 0, 124, 0, 4, 0, 24, 0, 0, 0
  , 126, 7, 0, 0, 125, 7, 0, 0, 61, 0, 4, 0, 10, 0, 0, 0, 127, 7, 0, 0
  , 12, 0, 0, 0, 81, 0, 5, 0, 9, 0, 0, 0, 128, 7, 0, 0, 127, 7, 0, 0
  , 1, 0, 0, 0, 124, 0, 4, 0, 24, 0, 0, 0, 129, 7, 0, 0, 128, 7, 0, 0
  , 61, 0, 4, 0, 10, 0, 0, 0, 130, 7, 0, 0, 12, 0, 0, 0, 81, 0, 5, 0
  , 9, 0, 0, 0, 131, 7, 0, 0, 130, 7, 0, 0, 2, 0, 0, 0, 124, 0, 4, 0
  , 24, 0, 0, 0, 132, 7, 0, 0, 131, 7, 0, 0, 80, 0, 6, 0, 133, 7, 0, 0
  , 134, 7, 0, 0, 126, 7, 0, 0, 129, 7, 0, 0, 132, 7, 0, 0, 61, 0, 4, 0
  , 2, 0, 0, 0, 135, 7, 0, 0, 122, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0
  , 136, 7, 0, 0, 122, 7, 0, 0, 61, 0, 4, 0, 2, 0, 0, 0, 137, 7, 0, 0
  , 122, 7, 0, 0, 80, 0, 7, 0, 3, 0, 0, 0, 138, 7, 0, 0, 135, 7, 0, 0
  , 136, 7, 0, 0, 137, 7, 0, 0, 141, 0, 0, 0, 99, 0, 4, 0, 123, 7, 0, 0
  , 134, 7, 0, 0, 138, 7, 0, 0, 253, 0, 1, 0, 56, 0, 1, 0
  ]
