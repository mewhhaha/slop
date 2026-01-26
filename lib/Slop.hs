{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

module Slop
  ( Config(..)
  , defaultConfig
  , ConfigPatch(..)
  , applyConfigPatch
  , WindowM
  , Window(..)
  , Loop
  , runWindowM
  , runWindow
  , runWindowIO
  , askWindow
  , liftWindow
  , runLoop
  , liftLoop
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
  , createTexture2D
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
  , ShaderCounts(..)
  , TargetFormat(..)
  , BlendMode(..)
  , DepthMode(..)
  , GraphicsDesc(..)
  , defaultGraphics
  , graphicsPipeline
  , defaultCompute
  , computePipeline
  , Binding(..)
  , ComputePipeline(..)
  , ComputeDesc(..)
  , ComputeBinding(..)
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
  , createComputePipeline
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
  , withRenderTarget
  , destroyTarget
  , render
  , drawRender
  , output
  , postProcess
  , TargetRef(..)
  , RenderPlan
  , PlanM
  , PassM
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
  , drawTextCached
  , Frame(..)
  , LoopControl(..)
  , LoopExit(..)
  , InputState(..)
  , InputFrame(..)
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
  , Vec2(..)
  , Vec3(..)
  , Vec4(..)
  , Mat4(..)
  , mat4Identity
  , mat4Mul
  , mat4Perspective
  , mat4Ortho
  , mat4LookAt
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
  , point
  , rgb
  , rgba
  , Texture(..)
  , Font (..)
  , Track(..)
  , ShaderAsset(..)
  , VertexShaderAsset(..)
  , ComputePipelineAsset(..)
  , PipelineAsset(..)
  , SamplerAsset(..)
  , SdfFontAsset(..)
  , setFontSDF
  , getFontSDF
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
  , shaderUniformChecked
  , shaderUniformSized
  , shaderUniformBytesChecked
  , shaderUniformBytesSized
  , ShaderStage(..)
  , ShaderBinding(..)
  , NamedShaderBinding(..)
  , ShaderBindings(..)
  , NamedUniform(..)
  , emptyShaderBindings
  , setShaderBindings
  , getShaderBindings
  , resolveNamedUniforms
  , withShaderBindingsStage
  , withShaderBindingsNamed
  , AssetId(..)
  , AnyAssetId(..)
  , AssetStatus(..)
  , AssetUpdate
  , AssetLoader(..)
  , AssetThread(..)
  , TextureAsset(..)
  , TextureDescAsset(..)
  , FontAsset(..)
  , TextAsset(..)
  , MusicAsset(..)
  , ChunkAsset(..)
  , loadAsset
  , loadAssetAsync
  , processMainAssets
  , awaitAsset
  , getAsset
  , getAssetStatus
  , removeAsset
  , removeAssets
  , removeAssets_
  , removeAllAssets
  , enableHotReload
  , disableHotReload
  , reloadAssetAsync
  , awaitAssetUpdate
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
  , BlendPool
  , createBlendPool
  , crossfadeTo
  , crossfadeToLoop
  , updateBlend
  , createTrack
  , destroyTrack
  , playOn
  , playOnLoop
  , stopTrack
  , clearIO
  , presentIO
  , setDrawColorIO
  , drawLineIO
  , drawRectIO
  , fillRectIO
  , drawTextureIO
  , loadTextureIO
  , destroyTextureIO
  , loadFontIO
  , loadFontSDFIO
  , closeFontIO
  , createTextIO
  , destroyTextIO
  , drawTextIO
  , createShaderFromSpirvIO
  , createShaderFromSpirvWithIO
  , destroyShaderIO
  , withShaderIO
  , setShaderUniformIO
  , setShaderUniformBytesIO
  , createShaderFromSpirv
  , createShaderFromSpirvWith
  , destroyShader
  , withShaderBindings
  , withShader
  , setShaderUniformCached
  , setShaderUniformBytesCached
  , withShaderUniform
  ) where

import Control.Exception (SomeException, bracket, bracket_, finally, try)
import Control.Monad (foldM, forM, forM_, replicateM, unless, void, when)
import Control.Concurrent (ThreadId, forkIO, threadDelay)
import Control.Concurrent.STM
  ( TMVar
  , TQueue
  , TVar
  , atomically
  , newEmptyTMVar
  , newTQueueIO
  , newTVarIO
  , modifyTVar'
  , putTMVar
  , readTMVar
  , tryReadTMVar
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
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Internal as BSI
import Data.Dynamic (Dynamic, fromDynamic, toDyn)
import Data.IntSet (IntSet)
import qualified Data.IntSet as IntSet
import Data.IORef (IORef, atomicModifyIORef', modifyIORef', newIORef, readIORef, writeIORef)
import Data.Maybe (catMaybes, fromMaybe)
import Data.Monoid (Last (..))
import qualified Data.Map.Strict as Map
import Data.Proxy (Proxy (..))
import Data.Time.Clock (UTCTime)
import Data.Typeable (TypeRep, Typeable, typeOf, typeRep)
import Data.Word (Word8, Word32, Word64)
import GHC.Conc (getNumCapabilities)
import Foreign (Ptr, Storable (..), alloca, castPtr, nullPtr, peek, poke, pokeByteOff)
import Foreign.C.String (withCString)
import Foreign.C.Types (CFloat (..))
import Foreign.Marshal.Array (peekArray, withArray, withArrayLen)
import Foreign.Marshal.Utils (copyBytes)
import System.Directory (getModificationTime)

import Slop.Internal.DList (DList, singleton, toList)
import qualified Slop.SDL.Raw as SDL
import Slop.SDL.Raw
  ( FPoint (..)
  , FRect (..)
  , FColor (..)
  , Font (..)
  , Mixer (..)
  , Audio (..)
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
  , mixLoadAudio
  , mixDestroyAudio
  , mixSetTrackAudio
  , mixPlayTrack
  , mixSetTrackLoops
  , mixSetTrackGain
  , mixPlayAudio
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
  , sdlGetMouseState
  , sdlPollEvent
  , sdlPumpEvents
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
  , ttfGetFontSDF
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
  }
  deriving (Eq, Show)

data ConfigPatch = ConfigPatch
  { patchWindowTitle :: Last String
  , patchWindowWidth :: Last Int
  , patchWindowHeight :: Last Int
  , patchWindowResizable :: Last Bool
  , patchTextAtlasSize :: Last (Maybe Int)
  , patchAssetWorkers :: Last Int
  }
  deriving (Eq, Show)

instance Semigroup ConfigPatch where
  ConfigPatch a b c d e f <> ConfigPatch a' b' c' d' e' f' =
    ConfigPatch (a <> a') (b <> b') (c <> c') (d <> d') (e <> e') (f <> f')

instance Monoid ConfigPatch where
  mempty = ConfigPatch mempty mempty mempty mempty mempty mempty

applyConfigPatch :: Config -> ConfigPatch -> Config
applyConfigPatch cfg patch =
  cfg
    { windowTitle = pick cfg.windowTitle patch.patchWindowTitle
    , windowWidth = pick cfg.windowWidth patch.patchWindowWidth
    , windowHeight = pick cfg.windowHeight patch.patchWindowHeight
    , windowResizable = pick cfg.windowResizable patch.patchWindowResizable
    , textAtlasSize = pick cfg.textAtlasSize patch.patchTextAtlasSize
    , assetWorkers = pick cfg.assetWorkers patch.patchAssetWorkers
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
  , appPipelineTargets :: IORef (Map.Map Int (RenderTarget, (Int, Int)))
  , appDepthFormat :: SDL_GPUTextureFormat
  , appDepthTarget :: IORef (Maybe DepthTarget)
  , appDepthTargets :: IORef (Map.Map (Ptr ()) DepthTarget)
  , appRenderState :: IORef RenderState
  , appHotReload :: IORef HotReloadConfig
  , appFrameContext :: RecordingContext
  , appRecording :: IORef (Maybe Recording)
  , appWindowSize :: IORef (Int, Int)
  , appWhiteTexture :: Texture
  , appVertexShader :: GPUShader
  , appVertexShader3D :: GPUShader
  , appDefaultShader :: Shader
  , appPipelines :: IORef (Map.Map PipelineKey GPUGraphicsPipeline)
  , appDrawColor :: IORef Color
  }

newtype WindowM a = WindowM (ReaderT Window IO a)
  deriving (Functor, Applicative, Monad, MonadIO, MonadReader Window)

newtype Loop a = Loop (WindowM a)
  deriving (Functor, Applicative, Monad, MonadIO)

instance MonadReader Window Loop where
  ask = Loop ask
  local f (Loop action) = Loop (local f action)

data RenderState = RenderState
  { rsTextCache :: !(Map.Map TextCacheKey CachedText)
  , rsFrameId :: !Word64
  }

type TextCacheKey = (Ptr (), String)

data CachedText = CachedText
  { ctText :: !Text
  , ctLastUsed :: !Word64
  }

data RecordingContext = RecordingContext
  { rcCommands :: IORef [RecordedOp]
  , rcShaderStack :: IORef [ShaderContext]
  }

newtype Recording = Recording RecordingContext

data Transform2D
  = TransformMatrix Mat4
  | TransformCamera Camera2D
  deriving (Eq, Show)

data ShaderContext = ShaderContext
  { ctxShader :: Shader
  , ctxUniforms :: [UniformBinding]
  , ctxSamplers :: [SamplerBindingSpec]
  , ctxStorage :: [StorageBinding]
  , ctxBlend :: BlendMode
  , ctxTransform :: Maybe Transform2D
  }

data DrawShape
  = ShapeLine Color FPoint FPoint
  | ShapeRectOutline Color FRect
  | ShapeRectFill Color FRect
  | ShapeSprite Texture (Maybe FRect) FRect
  | ShapeText Text Float Float

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
  , mesh3DModel :: Mat4
  , mesh3DBindings :: [Binding]
  }

data VertexShader = VertexShader
  { vertexShaderHandle :: GPUShader
  , vertexShaderDevice :: GPUDevice
  }
  deriving (Eq, Show)

type FragmentShader = Shader

data ShaderCounts = ShaderCounts
  { shaderSamplers :: Word32
  , shaderStorageTextures :: Word32
  , shaderStorageBuffers :: Word32
  , shaderUniformBuffers :: Word32
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
  , computeThreads :: (Word32, Word32, Word32)
  }
  deriving (Eq, Show)

data ComputeBinding
  = ComputeUniform Word32 BindingValue
  | ComputeSampler Word32 Texture (Maybe Sampler)
  | ComputeStorageTexture Word32 Texture
  | ComputeStorageTextureRW Word32 Texture

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
  { vertexX :: CFloat
  , vertexY :: CFloat
  , vertexU :: CFloat
  , vertexV :: CFloat
  , vertexR :: CFloat
  , vertexG :: CFloat
  , vertexB :: CFloat
  , vertexA :: CFloat
  }
  deriving (Eq, Show)

data Vertex3D = Vertex3D
  { vertex3DX :: CFloat
  , vertex3DY :: CFloat
  , vertex3DZ :: CFloat
  , vertex3DW :: CFloat
  , vertex3DU :: CFloat
  , vertex3DV :: CFloat
  , vertex3DR :: CFloat
  , vertex3DG :: CFloat
  , vertex3DB :: CFloat
  , vertex3DA :: CFloat
  }
  deriving (Eq, Show)

runWindowM :: Window -> WindowM a -> IO a
runWindowM window (WindowM action) =
  runReaderT action window

runLoop :: Loop a -> WindowM a
runLoop (Loop action) = action

runWindow :: Config -> WindowM a -> IO a
runWindow cfg action = runWindowIO cfg (\window -> runWindowM window action)

askWindow :: WindowM Window
askWindow = ask

liftWindow :: (Window -> IO a) -> WindowM a
liftWindow f = do
  window <- ask
  liftIO (f window)

liftLoop :: WindowM a -> Loop a
liftLoop = Loop

withWindowLoop :: (Window -> IO a) -> Loop a
withWindowLoop f = Loop (liftWindow f)

-- Asset manager

newtype AssetId a = AssetId { unAssetId :: Int }
  deriving (Eq, Ord, Show)

data AnyAssetId where
  AnyAssetId :: AssetId a -> AnyAssetId

data AssetStatus a
  = AssetLoading
  | AssetReady a
  | AssetFailed String
  deriving (Eq, Show)

newtype AssetUpdate = AssetUpdate (TMVar (Either String ()))

data AssetThread
  = AssetAny
  | AssetMain
  deriving (Eq, Show)

class (Typeable spec, Typeable (AssetType spec)) => AssetLoader spec where
  type AssetType spec
  loadAssetIO :: Window -> spec -> IO (Either String (AssetType spec))
  unloadAssetIO :: Window -> spec -> AssetType spec -> IO ()
  assetLabel :: spec -> String
  assetFiles :: spec -> [FilePath]
  assetFiles _ = []
  assetThread :: spec -> AssetThread
  assetThread _ = AssetAny

data TextureAsset = TextureAsset FilePath
  deriving (Eq, Show)

data TextureDescAsset = TextureDescAsset TextureDesc
  deriving (Eq, Show)

data FontAsset = FontAsset FilePath Float
  deriving (Eq, Show)

data TextAsset = TextAsset Font String
  deriving (Eq, Show)

data MusicAsset = MusicAsset FilePath
  deriving (Eq, Show)

data ChunkAsset = ChunkAsset FilePath
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
  deriving (Eq, Show)

data VertexShaderAsset = VertexShaderAsset
  { vertexShaderSpirvBytes :: !ByteString
  , vertexShaderCounts :: !ShaderCounts
  }
  deriving (Eq, Show)

data ComputePipelineAsset = ComputePipelineAsset
  { computePipelineDesc :: !ComputeDesc
  }
  deriving (Eq, Show)

data PipelineAsset = PipelineAsset
  { pipelineDesc :: !GraphicsDesc
  }

data SamplerAsset = SamplerAsset
  { samplerDesc :: !SamplerDesc
  }
  deriving (Eq, Show)

instance AssetLoader TextureAsset where
  type AssetType TextureAsset = Texture
  loadAssetIO app (TextureAsset path) = do
    result <- try (loadTextureIO app path)
    case result of
      Right tex -> pure (Right tex)
      Left (err :: SomeException) -> pure (Left (show err))
  unloadAssetIO _ _ = destroyTextureIO
  assetLabel (TextureAsset path) = path
  assetFiles (TextureAsset path) = [path]
  assetThread _ = AssetMain

instance AssetLoader TextureDescAsset where
  type AssetType TextureDescAsset = Texture
  loadAssetIO app (TextureDescAsset desc) = Right <$> createTexture2DIO app desc
  unloadAssetIO _ _ = destroyTextureIO
  assetLabel _ = "texture-desc"
  assetThread _ = AssetMain

instance AssetLoader FontAsset where
  type AssetType FontAsset = Font
  loadAssetIO _ (FontAsset path size) = do
    result <- ttfOpenFont path size
    case result of
      Nothing -> Left <$> sdlGetError
      Just font -> pure (Right font)
  unloadAssetIO _ _ = ttfCloseFont
  assetLabel (FontAsset path _) = path
  assetFiles (FontAsset path _) = [path]

instance AssetLoader TextAsset where
  type AssetType TextAsset = Text
  loadAssetIO app (TextAsset font str) = do
    result <- ttfCreateText (app.appTextEngine) font str
    case result of
      Nothing -> Left <$> sdlGetError
      Just textObj -> pure (Right textObj)
  unloadAssetIO _ _ = ttfDestroyText
  assetLabel (TextAsset _ str) = str
  assetThread _ = AssetMain

instance AssetLoader MusicAsset where
  type AssetType MusicAsset = Audio
  loadAssetIO app (MusicAsset path) = do
    result <- mixLoadAudio app.appMixer path False
    case result of
      Nothing -> Left <$> sdlGetError
      Just audio -> pure (Right audio)
  unloadAssetIO _ _ = mixDestroyAudio
  assetLabel (MusicAsset path) = path
  assetFiles (MusicAsset path) = [path]

instance AssetLoader ChunkAsset where
  type AssetType ChunkAsset = Audio
  loadAssetIO app (ChunkAsset path) = do
    result <- mixLoadAudio app.appMixer path True
    case result of
      Nothing -> Left <$> sdlGetError
      Just audio -> pure (Right audio)
  unloadAssetIO _ _ = mixDestroyAudio
  assetLabel (ChunkAsset path) = path
  assetFiles (ChunkAsset path) = [path]

instance AssetLoader SdfFontAsset where
  type AssetType SdfFontAsset = Font
  loadAssetIO _ (SdfFontAsset path size) = do
    result <- ttfOpenFont path size
    case result of
      Nothing -> Left <$> sdlGetError
      Just font -> do
        ok <- ttfSetFontSDF font True
        if ok
          then pure (Right font)
          else do
            ttfCloseFont font
            Left <$> sdlGetError
  unloadAssetIO _ _ = ttfCloseFont
  assetLabel (SdfFontAsset path _) = path
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
  , amThreads :: ![ThreadId]
  }

data ManagerState = ManagerState
  { msNextId :: !Int
  , msAssets :: !(Map.Map Int AssetSlot)
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
  = SlotLoading !(TMVar (Either String ()))
  | SlotReady !Dynamic !(IO ())
  | SlotFailed !String

data RequestMode = RequestLoad | RequestReload

data AssetCommand where
  AssetCommand :: AssetLoader spec => Int -> spec -> RequestMode -> Maybe (TMVar (Either String ())) -> AssetCommand
  StopCommand :: TMVar () -> AssetCommand

initAssetManager :: Window -> Int -> IO AssetManager
initAssetManager app workerCount = do
  stateVar <- newTVarIO ManagerState { msNextId = 0, msAssets = Map.empty }
  queue <- newTQueueIO
  let count = max 1 workerCount
  tids <- replicateM count (forkIO (assetWorker app stateVar queue))
  pure AssetManager
    { amState = stateVar
    , amQueue = queue
    , amThreads = tids
    }

shutdownAssetManager :: Window -> AssetManager -> IO ()
shutdownAssetManager app mgr = do
  let workerCount = length mgr.amThreads
  stopVars <- replicateM workerCount (atomically newEmptyTMVar)
  atomically $ forM_ stopVars (\var -> writeTQueue (mgr.amQueue) (StopCommand var))
  mapM_ (atomically . readTMVar) stopVars
  cleanupAssets app mgr

cleanupAssets :: Window -> AssetManager -> IO ()
cleanupAssets app mgr = removeAllAssetsIO app mgr

removeAllAssetsIO :: Window -> AssetManager -> IO ()
removeAllAssetsIO app mgr = do
  entries <- atomically $ do
    st <- readTVar (mgr.amState)
    writeTVar (mgr.amState) st { msAssets = Map.empty }
    pure (Map.elems (st.msAssets))
  mapM_ (finalizeEntry app) entries
  where
    finalizeEntry _ (AssetSlot _ (SlotFailed _) _) = pure ()
    finalizeEntry _ (AssetSlot _ (SlotLoading var) _) =
      void (atomically (tryPutTMVar var (Left "asset removed")))
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
    StopCommand done -> do
      atomically (putTMVar done ())
      pure False
    AssetCommand assetId spec mode notify -> do
      result <- try @SomeException (loadAssetIO app spec)
      let resolved = case result of
            Left ex -> Left (show ex)
            Right ok -> ok
      case mode of
        RequestLoad -> finishLoad app stateVar assetId spec resolved notify
        RequestReload -> finishReload app stateVar assetId spec resolved notify
      pure True

finishLoad :: forall spec. AssetLoader spec => Window -> TVar ManagerState -> Int -> spec -> Either String (AssetType spec) -> Maybe (TMVar (Either String ())) -> IO ()
finishLoad app stateVar assetId spec result _ = case result of
  Left err -> do
    atomically $ do
      st <- readTVar stateVar
      case Map.lookup assetId (st.msAssets) of
        Just slot@AssetSlot { slotState = SlotLoading var } -> do
          let slot' = slot { slotState = SlotFailed err }
          writeTVar stateVar st { msAssets = Map.insert assetId slot' (st.msAssets) }
          void (tryPutTMVar var (Left err))
        _ -> pure ()
  Right asset -> do
    let dyn = toDyn asset
    let finalizer = unloadAssetIO app spec asset
    let typ = typeOf asset
    cancelled <- atomically $ do
      st <- readTVar stateVar
      case Map.lookup assetId (st.msAssets) of
        Just slot@AssetSlot { slotState = SlotLoading var } -> do
          let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
          writeTVar stateVar st { msAssets = Map.insert assetId slot' (st.msAssets) }
          void (tryPutTMVar var (Right ()))
          pure False
        Nothing -> pure True
        _ -> pure False
    if cancelled then finalizer else pure ()

finishReload :: forall spec. AssetLoader spec => Window -> TVar ManagerState -> Int -> spec -> Either String (AssetType spec) -> Maybe (TMVar (Either String ())) -> IO ()
finishReload app stateVar assetId spec result notify = case result of
  Left err -> do
    atomically $ do
      case notify of
        Nothing -> pure ()
        Just var -> void (tryPutTMVar var (Left err))
  Right asset -> do
    let dyn = toDyn asset
    let finalizer = unloadAssetIO app spec asset
    let typ = typeOf asset
    (_replaced, oldFinalizer, missing) <- atomically $ do
      st <- readTVar stateVar
      case Map.lookup assetId (st.msAssets) of
        Nothing -> pure (False, Nothing, True)
        Just slot@AssetSlot { slotState = SlotReady _ oldFin } -> do
          let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
          writeTVar stateVar st { msAssets = Map.insert assetId slot' (st.msAssets) }
          pure (True, Just oldFin, False)
        Just slot@AssetSlot { slotState = SlotFailed _ } -> do
          let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
          writeTVar stateVar st { msAssets = Map.insert assetId slot' (st.msAssets) }
          pure (True, Nothing, False)
        Just slot@AssetSlot { slotState = SlotLoading _ } -> do
          let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
          writeTVar stateVar st { msAssets = Map.insert assetId slot' (st.msAssets) }
          pure (True, Nothing, False)
    if missing
      then do
        finalizer
        atomically $ case notify of
          Nothing -> pure ()
          Just var -> void (tryPutTMVar var (Left "asset not found"))
      else do
        maybe (pure ()) id oldFinalizer
        atomically $ case notify of
          Nothing -> pure ()
          Just var -> void (tryPutTMVar var (Right ()))

registerLoading :: forall a. Typeable a => AssetManager -> IO (AssetId a, TMVar (Either String ()))
registerLoading mgr = atomically $ do
  st <- readTVar (mgr.amState)
  var <- newEmptyTMVar
  let newId = st.msNextId
  let slot = AssetSlot (typeRep (Proxy :: Proxy a)) (SlotLoading var) Nothing
  writeTVar (mgr.amState) st { msNextId = newId + 1, msAssets = Map.insert newId slot (st.msAssets) }
  pure (AssetId newId, var)

loadAsset :: forall spec. AssetLoader spec => spec -> WindowM (Either String (AssetId (AssetType spec)))
loadAsset spec = do
  app <- ask
  let mgr = app.appAssets
  (assetId, _) <- liftIO (registerLoading @(AssetType spec) mgr)
  liftIO (installHotReloadInfo app assetId spec)
  result <- liftIO (try @SomeException (loadAssetIO app spec))
  let resolved = case result of
        Left ex -> Left (show ex)
        Right ok -> ok
  liftIO $ case resolved of
    Left err -> do
      atomically $ do
        st <- readTVar (mgr.amState)
        case Map.lookup (assetId.unAssetId) (st.msAssets) of
          Just slot@AssetSlot { slotState = SlotLoading var } -> do
            let slot' = slot { slotState = SlotFailed err }
            writeTVar (mgr.amState) st { msAssets = Map.insert (assetId.unAssetId) slot' (st.msAssets) }
            void (tryPutTMVar var (Left err))
          _ -> pure ()
    Right asset -> do
      let dyn = toDyn asset
      let finalizer = unloadAssetIO app spec asset
      let typ = typeOf asset
      cancelled <- atomically $ do
        st <- readTVar (mgr.amState)
        case Map.lookup (assetId.unAssetId) (st.msAssets) of
          Just slot@AssetSlot { slotState = SlotLoading var } -> do
            let slot' = slot { slotType = typ, slotState = SlotReady dyn finalizer }
            writeTVar (mgr.amState) st { msAssets = Map.insert (assetId.unAssetId) slot' (st.msAssets) }
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
            StopCommand _ -> pure ()
            _ -> void (handleAssetCommand app stateVar cmd)
          drain app stateVar queue

reloadAssetAsync :: forall spec. AssetLoader spec => AssetId (AssetType spec) -> spec -> WindowM AssetUpdate
reloadAssetAsync assetId spec = do
  app <- ask
  let mgr = app.appAssets
  notify <- liftIO (atomically newEmptyTMVar)
  exists <- liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    pure (Map.member (assetId.unAssetId) (st.msAssets))
  if exists
    then do
      liftIO (installHotReloadInfo app assetId spec)
      liftIO $ atomically $
        case assetThread spec of
          AssetMain -> writeTQueue (app.appMainAssetQueue) (AssetCommand (assetId.unAssetId) spec RequestReload (Just notify))
          AssetAny -> writeTQueue (mgr.amQueue) (AssetCommand (assetId.unAssetId) spec RequestReload (Just notify))
      pure (AssetUpdate notify)
    else do
      liftIO $ atomically (putTMVar notify (Left "asset not found"))
      pure (AssetUpdate notify)

awaitAssetUpdate :: AssetUpdate -> WindowM (Either String ())
awaitAssetUpdate (AssetUpdate var) = do
  let step = do
        mValue <- liftIO (atomically (tryReadTMVar var))
        case mValue of
          Just value -> pure value
          Nothing -> do
            processMainAssets
            liftIO (threadDelay 1000)
            step
  step

awaitAsset :: forall a. Typeable a => AssetId a -> WindowM (Either String a)
awaitAsset assetId = do
  app <- ask
  let mgr = app.appAssets
  mWait <- liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    case Map.lookup (assetId.unAssetId) (st.msAssets) of
      Just (AssetSlot _ (SlotLoading var) _) -> pure (Just var)
      _ -> pure Nothing
  case mWait of
    Just var -> do
      let step = do
            mValue <- liftIO (atomically (tryReadTMVar var))
            case mValue of
              Just _ -> getAfterWait
              Nothing -> do
                processMainAssets
                liftIO (threadDelay 1000)
                step
      step
    Nothing -> getAfterWait
  where
    getAfterWait = do
      status <- getAssetStatus assetId
      case status of
        Nothing -> pure (Left "asset not found")
        Just AssetLoading -> pure (Left "asset still loading")
        Just (AssetFailed err) -> pure (Left err)
        Just (AssetReady value) -> pure (Right value)

getAsset :: forall a. Typeable a => AssetId a -> WindowM (Maybe a)
getAsset assetId = do
  status <- getAssetStatus assetId
  case status of
    Just (AssetReady value) -> pure (Just value)
    _ -> pure Nothing

getAssetStatus :: forall a. Typeable a => AssetId a -> WindowM (Maybe (AssetStatus a))
getAssetStatus assetId = do
  app <- ask
  let mgr = app.appAssets
  liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    pure $ do
      slot <- Map.lookup (assetId.unAssetId) (st.msAssets)
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
    case Map.lookup (assetId.unAssetId) (st.msAssets) of
      Nothing -> pure (Left False)
      Just slot -> do
        writeTVar (mgr.amState) st { msAssets = Map.delete (assetId.unAssetId) (st.msAssets) }
        case slot.slotState of
          SlotLoading var -> do
            void (tryPutTMVar var (Left "asset removed"))
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
    st { msAssets = Map.adjust (\slot -> slot { slotHotReload = info }) (assetId.unAssetId) (st.msAssets) }

loadHotReloadTimes :: [FilePath] -> IO (Map.Map FilePath (Maybe UTCTime))
loadHotReloadTimes files = do
  pairs <- mapM (\path -> do time <- safeGetModTime path; pure (path, time)) files
  pure (Map.fromList pairs)

safeGetModTime :: FilePath -> IO (Maybe UTCTime)
safeGetModTime path = do
  result <- try @SomeException (getModificationTime path)
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
    pure (Map.toList (st.msAssets))
  updates <- liftIO $ mapM checkEntry entries
  let updates' = catMaybes updates
  liftIO $ atomically $ modifyTVar' (mgr.amState) $ \st ->
    let assets' = foldl'
          (\assets (assetId, info) -> Map.adjust (\slot -> slot { slotHotReload = Just info }) assetId assets)
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
  { delta :: Float
  , time :: Float
  , ticks :: Word64
  , quitRequested :: Bool
  , size :: (Int, Int)
  , input :: InputFrame
  }
  deriving (Eq, Show)

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
  , inputMousePos :: !Vec2
  }
  deriving (Eq, Show)

data InputFrame = InputFrame
  { inputPrev :: !InputState
  , inputNow :: !InputState
  }
  deriving (Eq, Show)

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


data Color = Color
  { colorR :: Float
  , colorG :: Float
  , colorB :: Float
  , colorA :: Float
  }
  deriving (Eq, Show)

data Texture = Texture
  { textureHandle :: GPUTexture
  , textureDevice :: GPUDevice
  , textureWidth :: Int
  , textureHeight :: Int
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

textureDesc :: Int -> Int -> TextureDesc
textureDesc width height =
  TextureDesc
    { texWidth = width
    , texHeight = height
    , texFormat = sdlGPUTextureFormatRGBA8
    , texUsage = [TextureSampled]
    }

rgb :: Float -> Float -> Float -> Color
rgb r g b = Color r g b 1

rgba :: Float -> Float -> Float -> Float -> Color
rgba = Color


data Vec2 = Vec2 !Float !Float deriving (Eq, Show)

data Vec3 = Vec3 !Float !Float !Float deriving (Eq, Show)

data Vec4 = Vec4 !Float !Float !Float !Float deriving (Eq, Show)

data Mat4
  = Mat4 !Float !Float !Float !Float
         !Float !Float !Float !Float
         !Float !Float !Float !Float
         !Float !Float !Float !Float
  deriving (Eq, Show)

mat4Identity :: Mat4
mat4Identity =
  Mat4 1 0 0 0
       0 1 0 0
       0 0 1 0
       0 0 0 1

mat4Mul :: Mat4 -> Mat4 -> Mat4
mat4Mul (Mat4 a00 a01 a02 a03
               a10 a11 a12 a13
               a20 a21 a22 a23
               a30 a31 a32 a33)
        (Mat4 b00 b01 b02 b03
               b10 b11 b12 b13
               b20 b21 b22 b23
               b30 b31 b32 b33) =
  Mat4
    (a00*b00 + a01*b10 + a02*b20 + a03*b30)
    (a00*b01 + a01*b11 + a02*b21 + a03*b31)
    (a00*b02 + a01*b12 + a02*b22 + a03*b32)
    (a00*b03 + a01*b13 + a02*b23 + a03*b33)
    (a10*b00 + a11*b10 + a12*b20 + a13*b30)
    (a10*b01 + a11*b11 + a12*b21 + a13*b31)
    (a10*b02 + a11*b12 + a12*b22 + a13*b32)
    (a10*b03 + a11*b13 + a12*b23 + a13*b33)
    (a20*b00 + a21*b10 + a22*b20 + a23*b30)
    (a20*b01 + a21*b11 + a22*b21 + a23*b31)
    (a20*b02 + a21*b12 + a22*b22 + a23*b32)
    (a20*b03 + a21*b13 + a22*b23 + a23*b33)
    (a30*b00 + a31*b10 + a32*b20 + a33*b30)
    (a30*b01 + a31*b11 + a32*b21 + a33*b31)
    (a30*b02 + a31*b12 + a32*b22 + a33*b32)
    (a30*b03 + a31*b13 + a32*b23 + a33*b33)

mat4MulVec4 :: Mat4 -> Vec4 -> Vec4
mat4MulVec4 (Mat4 m00 m01 m02 m03
                   m10 m11 m12 m13
                   m20 m21 m22 m23
                   m30 m31 m32 m33)
            (Vec4 x y z w) =
  Vec4
    (m00*x + m01*y + m02*z + m03*w)
    (m10*x + m11*y + m12*z + m13*w)
    (m20*x + m21*y + m22*z + m23*w)
    (m30*x + m31*y + m32*z + m33*w)

mat4Ortho :: Float -> Float -> Float -> Float -> Float -> Float -> Mat4
mat4Ortho l r b t n f =
  let rl = r - l
      tb = t - b
      fn = f - n
  in Mat4
      (2 / rl) 0 0 (-(r + l) / rl)
      0 (2 / tb) 0 (-(t + b) / tb)
      0 0 (1 / fn) (-n / fn)
      0 0 0 1

mat4Perspective :: Float -> Float -> Float -> Float -> Mat4
mat4Perspective fovY aspect n f =
  let t = 1 / tan (fovY / 2)
      fn = f - n
  in Mat4
      (t / aspect) 0 0 0
      0 t 0 0
      0 0 (f / fn) 1
      0 0 ((-n * f) / fn) 0

vec3Sub :: Vec3 -> Vec3 -> Vec3
vec3Sub (Vec3 ax ay az) (Vec3 bx by bz) = Vec3 (ax - bx) (ay - by) (az - bz)

vec3Dot :: Vec3 -> Vec3 -> Float
vec3Dot (Vec3 ax ay az) (Vec3 bx by bz) = ax*bx + ay*by + az*bz

vec3Cross :: Vec3 -> Vec3 -> Vec3
vec3Cross (Vec3 ax ay az) (Vec3 bx by bz) =
  Vec3 (ay*bz - az*by) (az*bx - ax*bz) (ax*by - ay*bx)

vec3Length :: Vec3 -> Float
vec3Length v = sqrt (vec3Dot v v)

vec3Normalize :: Vec3 -> Vec3
vec3Normalize v@(Vec3 x y z) =
  let len = vec3Length v
      inv = if len == 0 then 1 else 1 / len
  in Vec3 (x*inv) (y*inv) (z*inv)

mat4LookAt :: Vec3 -> Vec3 -> Vec3 -> Mat4
mat4LookAt eye target up =
  let f = vec3Normalize (vec3Sub target eye)
      s = vec3Normalize (vec3Cross f up)
      u = vec3Cross s f
      Vec3 sx sy sz = s
      Vec3 ux uy uz = u
      Vec3 fx fy fz = f
  in Mat4
      sx ux (-fx) 0
      sy uy (-fy) 0
      sz uz (-fz) 0
      (-vec3Dot s eye) (-vec3Dot u eye) (vec3Dot f eye) 1

data Camera2D = Camera2D
  { camera2DPosition :: Vec2
  , camera2DZoom :: Float
  , camera2DRotation :: Float
  , camera2DViewport :: Maybe (Float, Float)
  }
  deriving (Eq, Show)

camera2D :: Vec2 -> Float -> (Float, Float) -> Camera2D
camera2D pos zoom viewport =
  Camera2D
    { camera2DPosition = pos
    , camera2DZoom = zoom
    , camera2DRotation = 0
    , camera2DViewport = Just viewport
    }

camera2DWindow :: Vec2 -> Float -> Camera2D
camera2DWindow pos zoom =
  Camera2D
    { camera2DPosition = pos
    , camera2DZoom = zoom
    , camera2DRotation = 0
    , camera2DViewport = Nothing
    }

camera2DScreen :: (Float, Float) -> Camera2D
camera2DScreen (vw, vh) =
  camera2D (Vec2 (vw / 2) (vh / 2)) 1 (vw, vh)

camera2DMatrix :: (Int, Int) -> Camera2D -> Mat4
camera2DMatrix size cam =
  let Vec2 px py = cam.camera2DPosition
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
      proj = mat4Ortho left right bottom top 0 1
      c = cos (-rot)
      s = sin (-rot)
      rotZ =
        Mat4 c (-s) 0 0
             s c 0 0
             0 0 1 0
             0 0 0 1
      view =
        Mat4 1 0 0 (-px)
             0 1 0 (-py)
             0 0 1 0
             0 0 0 1
      scale =
        Mat4 zoom 0 0 0
             0 zoom 0 0
             0 0 1 0
             0 0 0 1
  in proj `mat4Mul` (rotZ `mat4Mul` (scale `mat4Mul` view))

data Camera3D = Camera3D
  { camera3DEye :: Vec3
  , camera3DTarget :: Vec3
  , camera3DUp :: Vec3
  , camera3DFovY :: Float
  , camera3DAspect :: Float
  , camera3DNear :: Float
  , camera3DFar :: Float
  }
  deriving (Eq, Show)

camera3D :: Vec3 -> Vec3 -> Vec3 -> Float -> Float -> Float -> Float -> Camera3D
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

camera3DView :: Camera3D -> Mat4
camera3DView cam =
  mat4LookAt cam.camera3DEye cam.camera3DTarget cam.camera3DUp

camera3DProj :: Camera3D -> Mat4
camera3DProj cam =
  mat4Perspective cam.camera3DFovY cam.camera3DAspect cam.camera3DNear cam.camera3DFar

camera3DViewProj :: Camera3D -> Mat4
camera3DViewProj cam =
  mat4Mul (camera3DProj cam) (camera3DView cam)

camera3DMVP :: Camera3D -> Mat4 -> Mat4
camera3DMVP cam model =
  mat4Mul (camera3DViewProj cam) model

instance Storable Vec2 where
  sizeOf _ = 2 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    x <- peekByteOff ptr 0 :: IO CFloat
    y <- peekByteOff ptr (sizeOf (undefined :: CFloat)) :: IO CFloat
    pure (Vec2 (realToFrac x) (realToFrac y))
  poke ptr (Vec2 x y) = do
    pokeByteOff ptr 0 (realToFrac x :: CFloat)
    pokeByteOff ptr (sizeOf (undefined :: CFloat)) (realToFrac y :: CFloat)

instance Storable Vec4 where
  sizeOf _ = 4 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
    x <- peekByteOff ptr 0 :: IO CFloat
    y <- peekByteOff ptr step :: IO CFloat
    z <- peekByteOff ptr (2 * step) :: IO CFloat
    w <- peekByteOff ptr (3 * step) :: IO CFloat
    pure (Vec4 (realToFrac x) (realToFrac y) (realToFrac z) (realToFrac w))
  poke ptr (Vec4 x y z w) = do
    let step = sizeOf (undefined :: CFloat)
    pokeByteOff ptr 0 (realToFrac x :: CFloat)
    pokeByteOff ptr step (realToFrac y :: CFloat)
    pokeByteOff ptr (2 * step) (realToFrac z :: CFloat)
    pokeByteOff ptr (3 * step) (realToFrac w :: CFloat)

instance Storable Mat4 where
  sizeOf _ = 16 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
        at n = realToFrac <$> (peekByteOff ptr (n * step) :: IO CFloat)
    Mat4
      <$> at 0 <*> at 1 <*> at 2 <*> at 3
      <*> at 4 <*> at 5 <*> at 6 <*> at 7
      <*> at 8 <*> at 9 <*> at 10 <*> at 11
      <*> at 12 <*> at 13 <*> at 14 <*> at 15
  poke ptr (Mat4 m00 m01 m02 m03 m10 m11 m12 m13 m20 m21 m22 m23 m30 m31 m32 m33) = do
    let step = sizeOf (undefined :: CFloat)
        pokeAt n value = pokeByteOff ptr (n * step) (realToFrac value :: CFloat)
    pokeAt 0 m00
    pokeAt 1 m01
    pokeAt 2 m02
    pokeAt 3 m03
    pokeAt 4 m10
    pokeAt 5 m11
    pokeAt 6 m12
    pokeAt 7 m13
    pokeAt 8 m20
    pokeAt 9 m21
    pokeAt 10 m22
    pokeAt 11 m23
    pokeAt 12 m30
    pokeAt 13 m31
    pokeAt 14 m32
    pokeAt 15 m33

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

point :: Float -> Float -> FPoint
point x y = FPoint (realToFrac x) (realToFrac y)

data As2D
  = As2DCamera Camera2D
  | AsUI
  | AsUIWith Shader [ShaderUniform]
  | AsUIView Mat4
  | AsUIWithView Shader [ShaderUniform] Mat4
  | AsUICamera Camera2D
  | AsUIWithCamera Shader [ShaderUniform] Camera2D
  | AsParticle
  | AsParticleWith Shader [ShaderUniform]
  | AsParticleView Mat4
  | AsParticleWithView Shader [ShaderUniform] Mat4
  | AsParticleCamera Camera2D
  | AsParticleWithCamera Shader [ShaderUniform] Camera2D
  | As3DCamera Camera3D

basic2D :: Camera2D -> As2D
basic2D = As2DCamera

basicUI :: As2D
basicUI = AsUI

basicUIWith :: Shader -> [ShaderUniform] -> As2D
basicUIWith = AsUIWith

basicUIWithCamera :: Camera2D -> As2D
basicUIWithCamera = AsUICamera

basicParticle :: As2D
basicParticle = AsParticle

basicParticleWith :: Shader -> [ShaderUniform] -> As2D
basicParticleWith = AsParticleWith

basicParticleWithCamera :: Camera2D -> As2D
basicParticleWithCamera = AsParticleCamera

basic3D :: Camera3D -> As2D
basic3D = As3DCamera

class Draw ctx a where
  draw :: ctx -> a -> Loop ()

data DrawItem where
  DrawItem :: Draw ctx a => ctx -> a -> DrawItem

data Line = Line Color FPoint FPoint
  deriving (Eq, Show)

data RectOutline = RectOutline Color FRect
  deriving (Eq, Show)

data RectFill = RectFill Color FRect
  deriving (Eq, Show)

data Sprite = Sprite Texture (Maybe FRect) FRect (Maybe SpriteEffect)

data SpriteEffect = SpriteEffect Shader [ShaderUniform]

spriteEffect :: Shader -> [ShaderUniform] -> SpriteEffect
spriteEffect = SpriteEffect

spriteEffectNamed :: Shader -> [NamedUniform] -> WindowM SpriteEffect
spriteEffectNamed shader named = do
  table <- getShaderBindings shader
  uniforms <- liftIO (resolveNamedUniforms table named)
  pure (SpriteEffect shader uniforms)

data Label = Label Text Float Float

data TextDraw = TextDraw Font String Float Float

text :: Font -> String -> Float -> Float -> TextDraw
text = TextDraw

data ShaderUniform where
  ShaderUniform :: Storable a => Word32 -> a -> ShaderUniform
  ShaderUniformBytes :: Word32 -> ByteString -> ShaderUniform
  ShaderSampler :: Word32 -> Texture -> ShaderUniform
  ShaderSamplerWith :: Word32 -> Texture -> Sampler -> ShaderUniform
  ShaderStorageTexture :: Word32 -> Texture -> ShaderUniform

shaderUniformChecked :: Storable a => Word32 -> Int -> a -> Either String ShaderUniform
shaderUniformChecked slot expectedBytes value =
  let actual = sizeOf value
  in if actual /= expectedBytes
      then Left ("uniform size mismatch at slot " <> show slot <> ": expected " <> show expectedBytes <> ", got " <> show actual)
      else Right (ShaderUniform slot value)

shaderUniformSized :: Storable a => Word32 -> Int -> a -> ShaderUniform
shaderUniformSized slot expectedBytes value =
  case shaderUniformChecked slot expectedBytes value of
    Left err -> error err
    Right uniform -> uniform

shaderUniformBytesChecked :: Word32 -> Int -> ByteString -> Either String ShaderUniform
shaderUniformBytesChecked slot expectedBytes bytes =
  let actual = BS.length bytes
  in if actual /= expectedBytes
      then Left ("uniform byte size mismatch at slot " <> show slot <> ": expected " <> show expectedBytes <> ", got " <> show actual)
      else Right (ShaderUniformBytes slot bytes)

shaderUniformBytesSized :: Word32 -> Int -> ByteString -> ShaderUniform
shaderUniformBytesSized slot expectedBytes bytes =
  case shaderUniformBytesChecked slot expectedBytes bytes of
    Left err -> error err
    Right uniform -> uniform

data ShaderStage
  = ShaderFragment
  | ShaderVertex
  | ShaderCompute
  deriving (Eq, Ord, Show)

data ShaderBinding where
  ShaderBindUniform :: Storable a => ShaderStage -> Word32 -> a -> ShaderBinding
  ShaderBindUniformBytes :: ShaderStage -> Word32 -> ByteString -> ShaderBinding
  ShaderBindSampler :: ShaderStage -> Word32 -> Texture -> ShaderBinding
  ShaderBindSamplerWith :: ShaderStage -> Word32 -> Texture -> Sampler -> ShaderBinding
  ShaderBindStorageTexture :: ShaderStage -> Word32 -> Texture -> ShaderBinding

data NamedShaderBinding where
  ShaderBindUniformNamed :: Storable a => ShaderStage -> String -> a -> NamedShaderBinding
  ShaderBindUniformBytesNamed :: ShaderStage -> String -> ByteString -> NamedShaderBinding
  ShaderBindSamplerNamed :: ShaderStage -> String -> Texture -> NamedShaderBinding
  ShaderBindSamplerWithNamed :: ShaderStage -> String -> Texture -> Sampler -> NamedShaderBinding
  ShaderBindStorageTextureNamed :: ShaderStage -> String -> Texture -> NamedShaderBinding

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
  deriving (Functor, Applicative, Monad)

newtype PlanM a = PlanM (Writer (DList Pass) a)
  deriving (Functor, Applicative, Monad)

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
    case effect of
      Nothing -> withAs2D ctx (drawTexture texture src dst)
      Just (SpriteEffect sh uniforms) ->
        withShaderBindings sh uniforms (drawTexture texture src dst)

instance Draw As2D Label where
  draw ctx (Label textObj x y) =
    withAs2D ctx (drawText textObj x y)

instance Draw As2D TextDraw where
  draw ctx (TextDraw font str x y) =
    withAs2D ctx (drawTextCached font str x y)

drawItem :: DrawItem -> Loop ()
drawItem (DrawItem ctx item) = draw ctx item

instance Draw ctx a => Draw ctx [a] where
  draw ctx = mapM_ (draw ctx)

withAs2D :: As2D -> Loop a -> Loop a
withAs2D ctx action =
  case ctx of
    As2DCamera cam -> withBlendTransform BlendAlpha (Just (TransformCamera cam)) action
    AsUI -> withBlendTransform BlendPremultiplied Nothing action
    AsUIWith shader uniforms -> withShaderBindingsBlendTransform BlendPremultiplied shader uniforms Nothing action
    AsUIView view -> withBlendTransform BlendPremultiplied (Just (TransformMatrix view)) action
    AsUIWithView shader uniforms view -> withShaderBindingsBlendTransform BlendPremultiplied shader uniforms (Just (TransformMatrix view)) action
    AsUICamera cam -> withBlendTransform BlendPremultiplied (Just (TransformCamera cam)) action
    AsUIWithCamera shader uniforms cam -> withShaderBindingsBlendTransform BlendPremultiplied shader uniforms (Just (TransformCamera cam)) action
    AsParticle -> withBlendTransform BlendAdditive Nothing action
    AsParticleWith shader uniforms -> withShaderBindingsBlendTransform BlendAdditive shader uniforms Nothing action
    AsParticleView view -> withBlendTransform BlendAdditive (Just (TransformMatrix view)) action
    AsParticleWithView shader uniforms view -> withShaderBindingsBlendTransform BlendAdditive shader uniforms (Just (TransformMatrix view)) action
    AsParticleCamera cam -> withBlendTransform BlendAdditive (Just (TransformCamera cam)) action
    AsParticleWithCamera shader uniforms cam -> withShaderBindingsBlendTransform BlendAdditive shader uniforms (Just (TransformCamera cam)) action
    As3DCamera _ -> action

withBlendTransform :: BlendMode -> Maybe Transform2D -> Loop a -> Loop a
withBlendTransform blend transform (Loop action) =
  Loop $ do
    window <- ask
    merged <- liftIO (mergeUniformBindings window.appDefaultShader [])
    let ctx = ShaderContext window.appDefaultShader merged [] [] blend transform
    liftIO (withShaderContext window ctx (runWindowM window action))

withShaderBindingsBlendTransform :: BlendMode -> Shader -> [ShaderUniform] -> Maybe Transform2D -> Loop a -> Loop a
withShaderBindingsBlendTransform blend shader bindings transform action =
  Loop $ do
    collected <- liftIO (collectShaderBindings bindings)
    runLoop (withShaderBindingsInternalBlend blend shader collected transform action)


runWindowIO :: Config -> (Window -> IO a) -> IO a
runWindowIO cfg action =
  bracket_ initSDL shutdownSDL $ do
    let title = cfg.windowTitle
    let width = cfg.windowWidth
    let height = cfg.windowHeight
    window <- require "SDL_CreateWindow" (sdlCreateWindow title width height 0)
    bracket (pure window) sdlDestroyWindow $ \win -> do
      void $ sdlSetWindowResizable win (cfg.windowResizable)
      okShow <- sdlShowWindow win
      unless okShow (die "SDL_ShowWindow")
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
                        pipelineTargets <- newIORef Map.empty
                        depthTarget <- newIORef Nothing
                        depthTargets <- newIORef Map.empty
                        renderState <- newIORef (RenderState Map.empty 0)
                        hotReload <- newIORef (HotReloadConfig True 0.5 0)
                        frameCommands <- newIORef []
                        frameShaders <- newIORef []
                        recording <- newIORef Nothing
                        winSize <- sdlGetWindowSize win
                        windowSize <- newIORef winSize
                        pipelines <- newIORef Map.empty
                        drawColor <- newIORef (rgba 1 1 1 1)
                        let frameContext = RecordingContext frameCommands frameShaders
                        let placeholderAssets = error "AssetManager not initialized"
                        let windowBase = Window
                              { appWindow = win
                              , appGPUDevice = dev
                              , appSwapchainFormat = swapFmt
                              , appDefaultSampler = defaultSampler
                              , appTextEngine = engine
                              , appMixer = mix
                              , appMusicTrack = musicTrackRef
                              , appBlendPools = blendPools
                              , appAssets = placeholderAssets
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
                              , appWhiteTexture = whiteTexture
                              , appVertexShader = vertShader
                              , appVertexShader3D = vertShader3D
                              , appDefaultShader = defShader
                              , appPipelines = pipelines
                              , appDrawColor = drawColor
                              }
                        workerCount <-
                          if cfg.assetWorkers <= 0
                            then max 1 <$> getNumCapabilities
                            else pure cfg.assetWorkers
                        bracket (initAssetManager windowBase workerCount) (shutdownAssetManager windowBase) $ \assets -> do
                          let windowHandle = windowBase { appAssets = assets }
                          action windowHandle `finally` (cleanupPipelines windowHandle >> cleanupRenderTargets windowHandle >> cleanupDepthTargets windowHandle)
  where
    initSDL = do
      ok <- sdlInit (sdlInitVideo .|. sdlInitAudio)
      unless ok $ die "SDL_Init"
      okMix <- mixInit
      unless okMix $ die "MIX_Init"
      okFont <- ttfInit
      unless okFont $ die "TTF_Init"
    shutdownSDL = do
      mixQuit
      ttfQuit
      sdlQuit
    die label = do
      err <- sdlGetError
      ioError (userError (label <> " failed: " <> err))


require :: String -> IO (Maybe a) -> IO a
require label action = do
  result <- action
  case result of
    Just value -> pure value
    Nothing -> do
      err <- sdlGetError
      ioError (userError (label <> " failed: " <> err))

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

registerDepthTarget :: Window -> Texture -> DepthTarget -> IO ()
registerDepthTarget window colorTex depth =
  atomicModifyIORef' (window.appDepthTargets) $ \targets ->
    (Map.insert (renderTargetKey colorTex) depth targets, ())

unregisterDepthTarget :: Window -> Texture -> IO ()
unregisterDepthTarget window colorTex =
  atomicModifyIORef' (window.appDepthTargets) $ \targets ->
    let key = renderTargetKey colorTex
    in (Map.delete key targets, ())

cleanupDepthTargets :: Window -> IO ()
cleanupDepthTargets window = do
  targets <- atomicModifyIORef' (window.appDepthTargets) $ \targets ->
    (Map.empty, Map.elems targets)
  mapM_ (\target -> destroyTextureIO target.depthTexture) targets

ensureSwapchainDepthTarget :: Window -> (Int, Int) -> IO DepthTarget
ensureSwapchainDepthTarget window size = do
  current <- readIORef window.appDepthTarget
  case current of
    Just target | target.depthSize == size -> pure target
    Just target -> do
      destroyTextureIO target.depthTexture
      newTarget <- createDepthTargetIO window (fst size) (snd size)
      writeIORef window.appDepthTarget (Just newTarget)
      pure newTarget
    Nothing -> do
      newTarget <- createDepthTargetIO window (fst size) (snd size)
      writeIORef window.appDepthTarget (Just newTarget)
      pure newTarget

ensureRenderTargetDepth :: Window -> Texture -> (Int, Int) -> IO DepthTarget
ensureRenderTargetDepth window colorTex size = do
  targets <- readIORef window.appDepthTargets
  case Map.lookup (renderTargetKey colorTex) targets of
    Just target | target.depthSize == size -> pure target
    _ -> do
      newTarget <- createDepthTargetIO window (fst size) (snd size)
      atomicModifyIORef' window.appDepthTargets $ \m ->
        (Map.insert (renderTargetKey colorTex) newTarget m, ())
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

readMouseState :: IO (Word32, Vec2)
readMouseState =
  alloca $ \xPtr ->
    alloca $ \yPtr -> do
      buttons <- sdlGetMouseState xPtr yPtr
      x <- peek xPtr
      y <- peek yPtr
      pure (buttons, Vec2 (realToFrac x) (realToFrac y))

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
loadTextureIO window path = do
  surface <- require "IMG_Load" (imgLoadSurface path)
  texture <- loadTextureFromSurface window surface
  sdlDestroySurface surface
  pure texture

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
        else do
          converted <- require "SDL_ConvertSurface" (sdlConvertSurface surface sdlPixelFormatRGBA8888)
          texture <- loadTextureFromSurface window converted
          sdlDestroySurface converted
          pure texture
    else do
      uploadSurface window surface gpuFormat

uploadSurface :: Window -> Surface -> SDL_GPUTextureFormat -> IO Texture
uploadSurface window surface gpuFormat = do
  surfaceInfo <- peekSurfaceInfo surface
  let width = fromIntegral surfaceInfo.surfaceInfoWidth
  let height = fromIntegral surfaceInfo.surfaceInfoHeight
  let texUsage = sdlGPUTextureUsageSampler
  tex <- createTexture window.appGPUDevice gpuFormat texUsage width height
  ok <- sdlLockSurface surface
  unless ok $ do
    err <- sdlGetError
    ioError (userError ("SDL_LockSurface failed: " <> err))
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
  ptr <- require "SDL_MapGPUTransferBuffer" (sdlMapGPUTransferBuffer window.appGPUDevice transfer False)
  copyBytes ptr surfaceInfo'.surfaceInfoPixels byteSize
  sdlUnmapGPUTransferBuffer window.appGPUDevice transfer
  sdlUnlockSurface surface
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
    ioError (userError ("SDL_SubmitGPUCommandBuffer failed: " <> err))
  sdlReleaseGPUTransferBuffer window.appGPUDevice transfer
  pure tex

createSolidTexture :: GPUDevice -> SDL_GPUTextureFormat -> Int -> Int -> Word8 -> Word8 -> Word8 -> Word8 -> IO Texture
createSolidTexture device fmt width height r g b a = do
  let texUsage = sdlGPUTextureUsageSampler
  tex <- createTexture device fmt texUsage width height
  let byteSize = width * height * 4
  transfer <- require "SDL_CreateGPUTransferBuffer"
    (sdlCreateGPUTransferBuffer device
      GPUTransferBufferCreateInfo
        { gpuTransferUsage = sdlGPUTransferBufferUsageUpload
        , gpuTransferSize = fromIntegral byteSize
        , gpuTransferProps = 0
        })
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
    ioError (userError ("SDL_SubmitGPUCommandBuffer failed: " <> err))
  sdlReleaseGPUTransferBuffer device transfer
  pure tex

createTexture :: GPUDevice -> SDL_GPUTextureFormat -> SDL_GPUTextureUsageFlags -> Int -> Int -> IO Texture
createTexture device fmt usage width height = do
  gpuTex <- require "SDL_CreateGPUTexture"
    (sdlCreateGPUTexture device
      GPUTextureCreateInfo
        { gpuTextureType = sdlGPUTextureType2D
        , gpuTextureFormat = fmt
        , gpuTextureUsage = usage
        , gpuTextureWidth = fromIntegral width
        , gpuTextureHeight = fromIntegral height
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
    }

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
  let go [] = ioError (userError "No supported depth format found")
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
    ioError (userError ("TTF_SetFontSDF failed: " <> err))

getFontSDF :: Font -> IO Bool
getFontSDF = ttfGetFontSDF

loadFontSDFIO :: FilePath -> Float -> IO Font
loadFontSDFIO path size = do
  font <- loadFontIO path size
  setFontSDF font True
  pure font

createTextIO :: Window -> Font -> String -> IO Text
createTextIO window font str = require "TTF_CreateText" (ttfCreateText (window.appTextEngine) font str)

destroyTextIO :: Text -> IO ()
destroyTextIO = ttfDestroyText

drawTextIO :: Window -> Text -> Float -> Float -> IO ()
drawTextIO window textObj x y =
  recordDraw window (ShapeText textObj x y)

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
    ioError (userError ("SDL_SubmitGPUCommandBuffer failed: " <> err))
  mapM_ (releasePrepared window) prepared

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
      BS.useAsCStringLen bytes $ \(ptr, len) ->
        sdlPushGPUVertexUniformData cmd' slot (castPtr ptr) (fromIntegral len)
    pushUniformFragment cmd' (UniformBinding slot bytes) =
      BS.useAsCStringLen bytes $ \(ptr, len) ->
        sdlPushGPUFragmentUniformData cmd' slot (castPtr ptr) (fromIntegral len)

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
prepareDraws window fmt size ops =
  fmap concat $
    forM ops $ \op ->
      case op of
        RecordedDraw cmd -> prepareDraw window fmt size cmd
        RecordedMesh pipeline mesh bindings -> prepareMeshDraw window fmt pipeline mesh bindings
        RecordedClear {} -> pure []

prepareDraw :: Window -> SDL_GPUTextureFormat -> (Int, Int) -> DrawCmd -> IO [PreparedDraw]
prepareDraw window fmt size (DrawCmd shape maybeCtx) = do
  ctx <- resolveShaderContext window maybeCtx
  resolved <- buildShapeDraws window size shape ctx
  fmap catMaybes $
    forM resolved $ \resolvedDraw -> do
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

prepareMeshDraw :: Window -> SDL_GPUTextureFormat -> Pipeline -> Mesh -> [Binding] -> IO [PreparedDraw]
prepareMeshDraw window fmt pipeline mesh bindings = do
  when (pipeline.pipelineTargetFormat /= fmt) $
    ioError (userError "pipeline target format does not match render target format")
  when (pipeline.pipelineLayout /= mesh.meshLayout) $
    ioError (userError "mesh layout does not match pipeline layout")
  resolved <- collectBindings bindings
  samplers <- buildSamplerBindingsExplicit window resolved.dbSamplers
  storage <- buildStorageBindingsExplicit resolved.dbStorageTextures
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
      defaults <- mergeUniformBindings window.appDefaultShader []
      pure ShaderContext
        { ctxShader = window.appDefaultShader
        , ctxUniforms = defaults
        , ctxSamplers = []
        , ctxStorage = []
        , ctxBlend = BlendAlpha
        , ctxTransform = Nothing
        }

buildShapeDraws :: Window -> (Int, Int) -> DrawShape -> ShaderContext -> IO [ResolvedDraw]
buildShapeDraws window size shape ctx =
  case shape of
    ShapeLine color p1 p2 ->
      pure [ResolvedDraw sdlGPUPrimitiveTypeLineList (lineVertices size ctx.ctxTransform color p1 p2) (window.appWhiteTexture.textureHandle) ctx]
    ShapeRectOutline color rectShape ->
      pure [ResolvedDraw sdlGPUPrimitiveTypeLineList (rectOutlineVertices size ctx.ctxTransform color rectShape) (window.appWhiteTexture.textureHandle) ctx]
    ShapeRectFill color rectShape ->
      pure [ResolvedDraw sdlGPUPrimitiveTypeTriangleList (rectFillVertices size ctx.ctxTransform color rectShape) (window.appWhiteTexture.textureHandle) ctx]
    ShapeSprite tex src dst ->
      pure [ResolvedDraw sdlGPUPrimitiveTypeTriangleList (spriteVertices size ctx.ctxTransform tex src dst) tex.textureHandle ctx]
    ShapeText textObj x y ->
      textVertices size textObj x y ctx

lineVertices :: (Int, Int) -> Maybe Transform2D -> Color -> FPoint -> FPoint -> [Vertex]
lineVertices size transform color p1 p2 =
  [ mkVertex size transform p1 (Vec2 0 0) color
  , mkVertex size transform p2 (Vec2 0 0) color
  ]

rectOutlineVertices :: (Int, Int) -> Maybe Transform2D -> Color -> FRect -> [Vertex]
rectOutlineVertices size transform color (FRect x y w h) =
  let p1 = FPoint x y
      p2 = FPoint (x + w) y
      p3 = FPoint (x + w) (y + h)
      p4 = FPoint x (y + h)
  in [ mkVertex size transform p1 (Vec2 0 0) color
     , mkVertex size transform p2 (Vec2 0 0) color
     , mkVertex size transform p2 (Vec2 0 0) color
     , mkVertex size transform p3 (Vec2 0 0) color
     , mkVertex size transform p3 (Vec2 0 0) color
     , mkVertex size transform p4 (Vec2 0 0) color
     , mkVertex size transform p4 (Vec2 0 0) color
     , mkVertex size transform p1 (Vec2 0 0) color
     ]

rectFillVertices :: (Int, Int) -> Maybe Transform2D -> Color -> FRect -> [Vertex]
rectFillVertices size transform color (FRect x y w h) =
  let p1 = FPoint x y
      p2 = FPoint (x + w) y
      p3 = FPoint (x + w) (y + h)
      p4 = FPoint x (y + h)
      uv1 = Vec2 0 0
      uv2 = Vec2 1 0
      uv3 = Vec2 1 1
      uv4 = Vec2 0 1
  in [ mkVertex size transform p1 uv1 color
     , mkVertex size transform p2 uv2 color
     , mkVertex size transform p4 uv4 color
     , mkVertex size transform p2 uv2 color
     , mkVertex size transform p3 uv3 color
     , mkVertex size transform p4 uv4 color
     ]

spriteVertices :: (Int, Int) -> Maybe Transform2D -> Texture -> Maybe FRect -> FRect -> [Vertex]
spriteVertices size transform tex src dst =
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
      uv1 = Vec2 u0 v0
      uv2 = Vec2 u1 v0
      uv3 = Vec2 u1 v1
      uv4 = Vec2 u0 v1
      white = rgba 1 1 1 1
  in [ mkVertex size transform p1 uv1 white
     , mkVertex size transform p2 uv2 white
     , mkVertex size transform p4 uv4 white
     , mkVertex size transform p2 uv2 white
     , mkVertex size transform p3 uv3 white
     , mkVertex size transform p4 uv4 white
     ]

textVertices :: (Int, Int) -> Text -> Float -> Float -> ShaderContext -> IO [ResolvedDraw]
textVertices size textObj x y ctx = do
  void (ttfSetTextPosition textObj (round x) (round y))
  seqPtr <- ttfGetGPUTextDrawData textObj
  go seqPtr []
  where
    go ptr acc
      | ptr == nullPtr = pure (reverse acc)
      | otherwise = do
          seqInfo <- peek ptr
          let numVerts = fromIntegral seqInfo.ttfAtlasNumVertices
          let numIdx = fromIntegral seqInfo.ttfAtlasNumIndices
          xy <- if seqInfo.ttfAtlasXY == nullPtr then pure [] else peekArray numVerts seqInfo.ttfAtlasXY
          uv <- if seqInfo.ttfAtlasUV == nullPtr then pure [] else peekArray numVerts seqInfo.ttfAtlasUV
          idx <- if seqInfo.ttfAtlasIndices == nullPtr then pure [] else peekArray numIdx seqInfo.ttfAtlasIndices
          let vertices = map (vertexFrom xy uv) idx
          let resolvedDraw = ResolvedDraw sdlGPUPrimitiveTypeTriangleList vertices seqInfo.ttfAtlasTexture ctx
          go seqInfo.ttfAtlasNext (resolvedDraw : acc)
    vertexFrom xy uv i =
      let idx = fromIntegral i
          FPoint px py = xy !! idx
          FPoint u v = uv !! idx
          uvVec = Vec2 (realToFrac u) (realToFrac v)
          white = rgba 1 1 1 1
      in mkVertex size ctx.ctxTransform (FPoint px py) uvVec white

mkVertex :: (Int, Int) -> Maybe Transform2D -> FPoint -> Vec2 -> Color -> Vertex
mkVertex (w, h) transform (FPoint x y) (Vec2 u v) (Color r g b a) =
  let (nx, ny) =
        case transform of
          Nothing ->
            let wf = max 1 (fromIntegral w :: Float)
                hf = max 1 (fromIntegral h :: Float)
            in ( (realToFrac x / wf) * 2 - 1
               , 1 - (realToFrac y / hf) * 2
               )
          Just (TransformMatrix mat) ->
            let Vec4 tx ty _ tw = mat4MulVec4 mat (Vec4 (realToFrac x) (realToFrac y) 0 1)
                invW = if tw == 0 then 1 else 1 / tw
            in (tx * invW, ty * invW)
          Just (TransformCamera cam) ->
            let mat = camera2DMatrix (w, h) cam
                Vec4 tx ty _ tw = mat4MulVec4 mat (Vec4 (realToFrac x) (realToFrac y) 0 1)
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
  transfer <- require "SDL_CreateGPUTransferBuffer"
    (sdlCreateGPUTransferBuffer window.appGPUDevice
      GPUTransferBufferCreateInfo
        { gpuTransferUsage = sdlGPUTransferBufferUsageUpload
        , gpuTransferSize = fromIntegral byteSize
        , gpuTransferProps = 0
        })
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
  transfer <- require "SDL_CreateGPUTransferBuffer"
    (sdlCreateGPUTransferBuffer window.appGPUDevice
      GPUTransferBufferCreateInfo
        { gpuTransferUsage = sdlGPUTransferBufferUsageUpload
        , gpuTransferSize = fromIntegral byteSize
        , gpuTransferProps = 0
        })
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
    ioError (userError ("SDL_SubmitGPUCommandBuffer failed: " <> err))
  sdlReleaseGPUTransferBuffer window.appGPUDevice transfer
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
createMesh layout vertices =
  liftWindow (\window -> createMeshIO window layout vertices)

createTransientMesh :: Storable a => VertexLayout -> [a] -> WindowM Mesh
createTransientMesh layout vertices =
  liftWindow (\window -> createTransientMeshIO window layout vertices)

createMesh3D :: [Vertex3D] -> WindowM Mesh
createMesh3D vertices =
  createMesh mesh3DLayout vertices

createTransientMesh3D :: [Vertex3D] -> WindowM Mesh
createTransientMesh3D vertices =
  createTransientMesh mesh3DLayout vertices

mesh3D :: Mesh -> Mat4 -> [Binding] -> Mesh3D
mesh3D = Mesh3D

destroyMesh :: Mesh -> WindowM ()
destroyMesh mesh = do
  window <- ask
  liftIO (sdlReleaseGPUBuffer window.appGPUDevice mesh.meshBuffer)

buildSamplerBindings :: Window -> ShaderContext -> GPUTexture -> IO [GPUTextureSamplerBinding]
buildSamplerBindings window ctx baseTexture = do
  extras <- normalizeBindings "sampler" (map (\(SamplerBindingSpec slot tex sampler) -> (slot, (tex, sampler))) ctx.ctxSamplers)
  let baseSampler = window.appDefaultSampler
  let baseBinding = GPUTextureSamplerBinding baseTexture (unwrapSampler baseSampler)
  let extraBindings = map (\(tex, sampler) ->
        GPUTextureSamplerBinding tex.textureHandle (unwrapSampler (fromMaybe baseSampler sampler))) extras
  pure (baseBinding : extraBindings)
  where
    unwrapSampler (Sampler s) = s

buildSamplerBindingsExplicit :: Window -> [SamplerBindingSpec] -> IO [GPUTextureSamplerBinding]
buildSamplerBindingsExplicit window specs = do
  bindings <- normalizeBindings "sampler" (map (\(SamplerBindingSpec slot tex sampler) -> (slot, (tex, sampler))) specs)
  let baseSampler = window.appDefaultSampler
  pure (map (\(tex, sampler) ->
    GPUTextureSamplerBinding tex.textureHandle (unwrapSampler (fromMaybe baseSampler sampler))) bindings)
  where
    unwrapSampler (Sampler s) = s

buildStorageBindingsExplicit :: [StorageBinding] -> IO [GPUTexture]
buildStorageBindingsExplicit specs = do
  storage <- normalizeBindings "storage texture" (map (\(StorageBinding slot tex) -> (slot, tex)) specs)
  pure (map (\tex -> tex.textureHandle) storage)

buildStorageBindings :: ShaderContext -> IO [GPUTexture]
buildStorageBindings ctx = do
  storage <- normalizeBindings "storage texture" (map (\(StorageBinding slot tex) -> (slot, tex)) ctx.ctxStorage)
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
  pure Pipeline
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

destroyPipeline :: Pipeline -> WindowM ()
destroyPipeline pipeline = do
  window <- ask
  liftIO (sdlReleaseGPUGraphicsPipeline window.appGPUDevice pipeline.pipelineHandle)

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
  liftWindow (\window -> createTransientMeshIO window spriteLayout (spriteVertices size Nothing tex src dst))

-- WindowM wrappers

loop :: a -> (Frame -> a -> Loop (LoopControl a)) -> WindowM (LoopExit a)
loop initialState onFrame = do
  window <- ask
  start <- liftIO sdlGetTicks
  liftIO sdlPumpEvents
  initialInput <- liftIO readInputState
  let go previous frameId prevInput state = do
        liftIO sdlPumpEvents
        liftIO (resetRecording window.appFrameContext)
        quitRequested <- liftIO pollQuit
        now <- liftIO sdlGetTicks
        currentInput <- liftIO readInputState
        (winW, winH) <- liftIO (sdlGetWindowSize (window.appWindow))
        liftIO (writeIORef window.appWindowSize (winW, winH))
        let dt = fromIntegral (now - previous) / 1000
            t = fromIntegral (now - start) / 1000
            nextFrame = frameId + 1
        liftIO (setFrameId window nextFrame)
        let frame = Frame
              { delta = dt
              , time = t
              , ticks = now
              , quitRequested = quitRequested
              , size = (winW, winH)
              , input = InputFrame prevInput currentInput
              }
        autoUpdateBlendPools dt
        autoHotReload dt
        processMainAssets
        control <- runLoop (onFrame frame state)
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
    pollQuit = allocaEvent $ \eventPtr ->
      let step quitSeen = do
            has <- sdlPollEvent eventPtr
            if not has
              then pure quitSeen
              else do
                eventType <- peekEventType eventPtr
                let quitNow = quitSeen || eventType == sdlEventQuit
                step quitNow
      in step False

autoUpdateBlendPools :: Float -> WindowM ()
autoUpdateBlendPools delta = do
  window <- ask
  pools <- liftIO (readIORef window.appBlendPools)
  mapM_ (\pool -> runLoop (updateBlend pool delta)) pools

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

clear :: Color -> Loop ()
clear color = withWindowLoop (\window -> clearIO window color)

setDrawColor :: Color -> Loop ()
setDrawColor color = withWindowLoop (\window -> setDrawColorIO window color)

drawLine :: Color -> FPoint -> FPoint -> Loop ()
drawLine color p1 p2 = withWindowLoop (\window -> drawLineIO window color p1 p2)

drawRect :: Color -> FRect -> Loop ()
drawRect color rectShape = withWindowLoop (\window -> drawRectIO window color rectShape)

fillRect :: Color -> FRect -> Loop ()
fillRect color rectShape = withWindowLoop (\window -> fillRectIO window color rectShape)

drawTexture :: Texture -> Maybe FRect -> FRect -> Loop ()
drawTexture texture src dst = withWindowLoop (\window -> drawTextureIO window texture src dst)

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
    }

createTexture2D :: TextureDesc -> WindowM Texture
createTexture2D desc = do
  window <- ask
  liftIO (createTexture2DIO window desc)

drawMesh :: Pipeline -> Mesh -> [Binding] -> Loop ()
drawMesh pipeline mesh bindings =
  withWindowLoop (\window -> recordMesh window pipeline mesh bindings)

drawMesh3DWith :: Shader -> [Binding] -> Mesh -> Loop ()
drawMesh3DWith shader bindings mesh =
  withWindowLoop $ \window -> do
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

instance Draw As2D Mesh3D where
  draw ctx (Mesh3D mesh model bindings) =
    case ctx of
      As3DCamera cam ->
        Loop $ do
          window <- ask
          let mvp = camera3DMVP cam model
          let mergedBindings = bindMesh3DMVP mvp bindings
          runLoop (drawMesh3DWith window.appDefaultShader mergedBindings mesh)
      _ ->
        Loop (liftIO (ioError (userError "Mesh3D draw requires basic3D camera context")))

bindMesh3DMVP :: Mat4 -> [Binding] -> [Binding]
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
  tex <- liftIO (createRenderTargetTexture window width height)
  depth <- liftIO (createDepthTargetIO window width height)
  liftIO (registerRenderTarget window tex)
  liftIO (registerDepthTarget window tex depth)
  pure (RenderTarget tex)

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
  removed <- liftIO (unregisterRenderTarget window tex)
  if removed
    then do
      liftIO (unregisterDepthTarget window tex)
      liftIO (destroyTextureIO tex)
    else pure ()

render :: RenderTarget -> Loop () -> Loop ()
render target (Loop action) =
  Loop $ do
    window <- ask
    let runWithContext ctx = do
          result <- runWindowM window action
          ops <- liftIO (drainRecording ctx)
          liftIO (flushTarget window target ops)
          pure result
    liftIO (withRecording window target runWithContext)

drawRender :: RenderTarget -> Maybe FRect -> FRect -> Loop ()
drawRender (RenderTarget tex) src dst = do
  drawTexture tex src dst

output :: RenderTarget -> Maybe FRect -> FRect -> Loop ()
output = drawRender

postProcess :: RenderTarget -> RenderTarget -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> Loop ()
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

runPlan :: RenderPlan -> Loop ()
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
        OpBlit target src dst -> drawRender target src dst
        OpShader shader uniforms opsList ->
          withShaderBindings shader uniforms (runOps opsList)

loadTexture :: FilePath -> WindowM Texture
loadTexture path = liftWindow (\window -> loadTextureIO window path)

destroyTexture :: Texture -> WindowM ()
destroyTexture texture = liftIO (destroyTextureIO texture)

loadFont :: FilePath -> Float -> WindowM Font
loadFont path size = liftIO (loadFontIO path size)

loadFontSDF :: FilePath -> Float -> WindowM Font
loadFontSDF path size = liftIO (loadFontSDFIO path size)

closeFont :: Font -> WindowM ()
closeFont font = liftIO (closeFontIO font)

createText :: Font -> String -> WindowM Text
createText font str = do
  window <- ask
  liftIO (createTextIO window font str)

destroyText :: Text -> WindowM ()
destroyText textObj = liftIO (destroyTextIO textObj)

drawText :: Text -> Float -> Float -> Loop ()
drawText textObj x y = withWindowLoop (\window -> drawTextIO window textObj x y)

drawTextCached :: Font -> String -> Float -> Float -> Loop ()
drawTextCached font str x y =
  Loop $ do
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
    liftIO (recordDraw window (ShapeText textObj x y))

playMusic :: Audio -> Int -> WindowM Bool
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
            pure (Just track)
  case mTrack of
    Nothing -> pure False
    Just track -> do
      okSet <- liftIO (mixSetTrackAudio track audio)
      okPlay <- liftIO (mixPlayTrack track 0)
      okLoop <- liftIO (mixSetTrackLoops track loops)
      pure (okSet && okPlay && okLoop)

playMusicLoop :: Audio -> WindowM Bool
playMusicLoop audio = playMusic audio (-1)

playSound :: Audio -> Loop Bool
playSound audio =
  withWindowLoop (\window -> mixPlayAudio window.appMixer audio)

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
  let count' = if policy == PoolBlend then max 2 count else count
  tracks <- fmap catMaybes (replicateM count' createTrack)
  createTrackPoolFrom policy tracks

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

trackPlaying :: Track -> Loop Bool
trackPlaying track = Loop (liftIO (mixTrackPlaying track))

playPool :: TrackPool -> Audio -> Loop Bool
playPool pool audio = playPoolWith pool 0 Nothing audio

playPoolLoop :: TrackPool -> Audio -> Loop Bool
playPoolLoop pool audio = playPoolWith pool (-1) Nothing audio

playPoolPriority :: TrackPool -> Int -> Audio -> Loop Bool
playPoolPriority pool priority audio = playPoolWith pool 0 (Just priority) audio

playPoolPriorityLoop :: TrackPool -> Int -> Audio -> Loop Bool
playPoolPriorityLoop pool priority audio = playPoolWith pool (-1) (Just priority) audio

stopPool :: TrackPool -> Loop ()
stopPool pool = Loop $ do
  let tracks = pool.poolTracks
  mapM_ (\track -> liftIO (mixStopTrack track 0)) tracks

playPoolWith :: TrackPool -> Int -> Maybe Int -> Audio -> Loop Bool
playPoolWith pool loops mPriority audio = Loop $ do
  let tracks = pool.poolTracks
  case tracks of
    [] -> pure False
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
        Nothing -> pure False
        Just (idx, info) -> do
          when info.tiPlaying (void (liftIO (mixStopTrack info.tiTrack 0)))
          okSet <- liftIO (mixSetTrackAudio info.tiTrack audio)
          okPlay <- liftIO (mixPlayTrack info.tiTrack 0)
          okLoop <- liftIO (mixSetTrackLoops info.tiTrack loops)
          let priorityValue = fromMaybe (Map.findWithDefault 0 idx state.psPriorities) mPriority
          let state' = state
                { psNext = (idx + 1) `mod` length tracks
                , psLastUsed = Map.insert idx ticks state.psLastUsed
                , psPriorities = Map.insert idx priorityValue state.psPriorities
                }
          liftIO (writeIORef pool.poolState state')
          pure (okSet && okPlay && okLoop)
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
  , bsLoops :: !Int
  }

type BlendPool = TrackPool

createBlendPool :: WindowM BlendPool
createBlendPool = createTrackPool PoolBlend 2

crossfadeTo :: TrackPool -> Audio -> Float -> Loop Bool
crossfadeTo pool audio duration = crossfadeToWith pool audio duration 0

crossfadeToLoop :: TrackPool -> Audio -> Float -> Loop Bool
crossfadeToLoop pool audio duration = crossfadeToWith pool audio duration (-1)

updateBlend :: TrackPool -> Float -> Loop ()
updateBlend pool delta = Loop $ do
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
          _ <- liftIO (mixSetTrackGain blend.bsFrom (1 - t))
          _ <- liftIO (mixSetTrackGain blend.bsTo t)
          if elapsed' >= duration
            then do
              _ <- liftIO (mixStopTrack blend.bsFrom 0)
              _ <- liftIO (mixSetTrackGain blend.bsTo 1)
              let activeIdx = trackIndex pool blend.bsTo
              liftIO (writeIORef pool.poolState state { psBlend = Nothing, psActive = activeIdx })
            else
              liftIO (writeIORef pool.poolState state { psBlend = Just blend { bsElapsed = elapsed' } })

crossfadeToWith :: TrackPool -> Audio -> Float -> Int -> Loop Bool
crossfadeToWith pool audio duration loops =
  if pool.poolPolicy /= PoolBlend
    then playPoolWith pool loops Nothing audio
    else Loop $ do
      let tracks = pool.poolTracks
      case tracks of
        [] -> pure False
        [track] -> do
          _ <- liftIO (mixSetTrackAudio track audio)
          _ <- liftIO (mixPlayTrack track 0)
          _ <- liftIO (mixSetTrackLoops track loops)
          _ <- liftIO (mixSetTrackGain track 1)
          pure True
        (trackA : trackB : _) -> do
          state <- liftIO (readIORef pool.poolState)
          let activeIdx = state.psActive `mod` 2
          let fromTrack = if activeIdx == 0 then trackA else trackB
          let toTrack = if activeIdx == 0 then trackB else trackA
          case state.psBlend of
            Just blend -> do
              _ <- liftIO (mixStopTrack blend.bsFrom 0)
              _ <- liftIO (mixSetTrackGain blend.bsTo 1)
              liftIO (writeIORef pool.poolState state { psBlend = Nothing, psActive = trackIndex pool blend.bsTo })
            Nothing -> pure ()
          if duration <= 0 || fromTrack == toTrack
            then do
              _ <- liftIO (mixSetTrackAudio fromTrack audio)
              _ <- liftIO (mixPlayTrack fromTrack 0)
              _ <- liftIO (mixSetTrackLoops fromTrack loops)
              _ <- liftIO (mixSetTrackGain fromTrack 1)
              liftIO (writeIORef pool.poolState state { psActive = trackIndex pool fromTrack })
              pure True
            else do
              _ <- liftIO (mixSetTrackGain toTrack 0)
              okSet <- liftIO (mixSetTrackAudio toTrack audio)
              okPlay <- liftIO (mixPlayTrack toTrack 0)
              okLoop <- liftIO (mixSetTrackLoops toTrack loops)
              _ <- liftIO (mixSetTrackGain fromTrack 1)
              let blend = BlendState
                    { bsFrom = fromTrack
                    , bsTo = toTrack
                    , bsDuration = duration
                    , bsElapsed = 0
                    , bsLoops = loops
                    }
              liftIO (writeIORef pool.poolState state { psBlend = Just blend })
              pure (okSet && okPlay && okLoop)

trackIndex :: TrackPool -> Track -> Int
trackIndex pool track =
  case pool.poolTracks of
    (t1 : t2 : _) ->
      if track == t1 then 0 else if track == t2 then 1 else 0
    (t1 : _) ->
      if track == t1 then 0 else 0
    [] -> 0

createTrack :: WindowM (Maybe Track)
createTrack = do
  window <- ask
  liftIO (mixCreateTrack window.appMixer)

destroyTrack :: Track -> WindowM ()
destroyTrack = liftIO . mixDestroyTrack

playOn :: Track -> Audio -> Loop Bool
playOn track audio = Loop $ do
  okSet <- liftIO (mixSetTrackAudio track audio)
  okPlay <- liftIO (mixPlayTrack track 0)
  okLoop <- liftIO (mixSetTrackLoops track 0)
  pure (okSet && okPlay && okLoop)

playOnLoop :: Track -> Audio -> Loop Bool
playOnLoop track audio = Loop $ do
  okSet <- liftIO (mixSetTrackAudio track audio)
  okPlay <- liftIO (mixPlayTrack track 0)
  okLoop <- liftIO (mixSetTrackLoops track (-1))
  pure (okSet && okPlay && okLoop)

stopTrack :: Track -> Loop Bool
stopTrack track = Loop (liftIO (mixStopTrack track 0))

-- Shaders

data Shader = Shader
  { shaderHandle :: GPUShader
  , shaderDevice :: GPUDevice
  , shaderSamplerCount :: Word32
  , shaderStorageTextureCount :: Word32
  , shaderStorageBufferCount :: Word32
  , shaderUniformBufferCount :: Word32
  , shaderUniformDefaults :: IORef (Map.Map Word32 ByteString)
  , shaderBindingTable :: IORef ShaderBindings
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
  pure (Sampler sampler)

destroySampler :: Sampler -> WindowM ()
destroySampler (Sampler sampler) = do
  window <- ask
  liftIO (sdlReleaseGPUSampler window.appGPUDevice sampler)

setShaderBindings :: Shader -> ShaderBindings -> WindowM ()
setShaderBindings shader bindings =
  liftIO (writeIORef shader.shaderBindingTable bindings)

getShaderBindings :: Shader -> WindowM ShaderBindings
getShaderBindings shader =
  liftIO (readIORef shader.shaderBindingTable)

createShaderFromSpirvIO :: Window -> ByteString -> IO Shader
createShaderFromSpirvIO window spirv =
  createShaderFromSpirvWithIO window spirv 0 0 0 0

createShaderFromSpirvWithIO :: Window -> ByteString -> Word32 -> Word32 -> Word32 -> Word32 -> IO Shader
createShaderFromSpirvWithIO window spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers =
  createShaderFromSpirvWithDevice window.appGPUDevice spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers

createShaderFromSpirvWithDevice :: GPUDevice -> ByteString -> Word32 -> Word32 -> Word32 -> Word32 -> IO Shader
createShaderFromSpirvWithDevice device spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers = do
  shader <- require "SDL_CreateGPUShader" (createRawShader device spirv sdlGPUShaderStageFragment numSamplers numStorageTextures numStorageBuffers numUniformBuffers)
  defaults <- newIORef Map.empty
  bindingsRef <- newIORef emptyShaderBindings
  pure Shader
    { shaderHandle = shader
    , shaderDevice = device
    , shaderSamplerCount = numSamplers
    , shaderStorageTextureCount = numStorageTextures
    , shaderStorageBufferCount = numStorageBuffers
    , shaderUniformBufferCount = numUniformBuffers
    , shaderUniformDefaults = defaults
    , shaderBindingTable = bindingsRef
    }

createRawShader :: GPUDevice -> ByteString -> SDL_GPUShaderStage -> Word32 -> Word32 -> Word32 -> Word32 -> IO (Maybe GPUShader)
createRawShader device spirv stage numSamplers numStorageTextures numStorageBuffers numUniformBuffers =
  BS.useAsCStringLen spirv $ \(ptr, len) ->
    withCString "main" $ \entry -> do
      let createInfo = GPUShaderCreateInfo
            { gpuShaderCodeSize = fromIntegral len
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
createVertexShader spirv counts =
  liftWindow (\window -> createVertexShaderIO window spirv counts)

destroyVertexShader :: VertexShader -> WindowM ()
destroyVertexShader shader =
  liftWindow (\_ -> sdlReleaseGPUShader shader.vertexShaderDevice shader.vertexShaderHandle)

createFragmentShader :: ByteString -> ShaderCounts -> WindowM FragmentShader
createFragmentShader spirv counts =
  createShaderFromSpirvWith spirv counts.shaderSamplers counts.shaderStorageTextures counts.shaderStorageBuffers counts.shaderUniformBuffers

destroyFragmentShader :: FragmentShader -> WindowM ()
destroyFragmentShader = destroyShader

createComputePipelineIO :: Window -> ComputeDesc -> IO ComputePipeline
createComputePipelineIO window desc = do
  let device = window.appGPUDevice
  BS.useAsCStringLen desc.computeShaderCode $ \(ptr, len) ->
    withCString "main" $ \entry -> do
      let (threadsX, threadsY, threadsZ) = desc.computeThreads
      let createInfo =
            GPUComputePipelineCreateInfo
              { gpuComputeCodeSize = fromIntegral len
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

createComputePipeline :: ComputeDesc -> WindowM ComputePipeline
createComputePipeline desc =
  liftWindow (\window -> createComputePipelineIO window desc)

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
    , computeThreads = (1, 1, 1)
    }

computePipeline :: ComputeDesc -> WindowM ComputePipeline
computePipeline = createComputePipeline

destroyComputePipeline :: ComputePipeline -> WindowM ()
destroyComputePipeline pipeline =
  liftWindow (\_ -> sdlReleaseGPUComputePipeline pipeline.computeDevice pipeline.computeHandle)

dispatchCompute :: ComputePipeline -> [ComputeBinding] -> (Word32, Word32, Word32) -> WindowM ()
dispatchCompute pipeline bindings (groupX, groupY, groupZ) = do
  window <- ask
  resolved <- liftIO (collectComputeBindings bindings)
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
  cmd <- liftIO (require "SDL_AcquireGPUCommandBuffer" (sdlAcquireGPUCommandBuffer window.appGPUDevice))
  computePass <- liftIO (require "SDL_BeginGPUComputePass" (sdlBeginGPUComputePass cmd rwBindings []))
  liftIO (sdlBindGPUComputePipeline computePass pipeline.computeHandle)
  samplers <- liftIO (buildSamplerBindingsExplicit window resolved.cbSamplers)
  liftIO (sdlBindGPUComputeSamplers computePass 0 samplers)
  let readOnlyTextures = map (\tex -> tex.textureHandle) resolved.cbReadOnlyTextures
  liftIO (sdlBindGPUComputeStorageTextures computePass 0 readOnlyTextures)
  liftIO $ forM_ resolved.cbUniforms $ \(UniformBinding slot bytes) ->
    BS.useAsCStringLen bytes $ \(ptr, len) ->
      sdlPushGPUComputeUniformData cmd slot (castPtr ptr) (fromIntegral len)
  liftIO (sdlDispatchGPUCompute computePass groupX groupY groupZ)
  liftIO (sdlEndGPUComputePass computePass)
  ok <- liftIO (sdlSubmitGPUCommandBuffer cmd)
  unless ok $ do
    err <- liftIO sdlGetError
    liftIO (ioError (userError ("SDL_SubmitGPUCommandBuffer failed: " <> err)))

destroyShaderIO :: Shader -> IO ()
destroyShaderIO shader =
  sdlReleaseGPUShader (shader.shaderDevice) (shader.shaderHandle)

withShaderIO :: Window -> Shader -> IO a -> IO a
withShaderIO window shader action = do
  defaults <- readIORef shader.shaderUniformDefaults
  let uniforms = map (uncurry UniformBinding) (Map.toList defaults)
  let ctx = ShaderContext shader uniforms [] [] BlendAlpha Nothing
  withShaderContext window ctx action

setShaderUniformIO :: Storable a => Shader -> Word32 -> a -> IO ()
setShaderUniformIO shader slot value =
  toBytes value >>= setShaderUniformBytesIO shader slot

setShaderUniformBytesIO :: Shader -> Word32 -> ByteString -> IO ()
setShaderUniformBytesIO shader slot bytes =
  modifyIORef' shader.shaderUniformDefaults (Map.insert slot bytes)


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

collectStageBindings :: [ShaderBinding] -> IO ([UniformBinding], [SamplerBindingSpec], [StorageBinding])
collectStageBindings = foldM step ([], [], [])
  where
    step acc binding =
      case binding of
        ShaderBindUniform stage slot value -> do
          ensureFragmentStage stage
          bytes <- toBytes value
          let (uniforms, samplers, storage) = acc
          pure (UniformBinding slot bytes : uniforms, samplers, storage)
        ShaderBindUniformBytes stage slot bytes -> do
          ensureFragmentStage stage
          let (uniforms, samplers, storage) = acc
          pure (UniformBinding slot bytes : uniforms, samplers, storage)
        ShaderBindSampler stage slot tex -> do
          ensureFragmentStage stage
          let (uniforms, samplers, storage) = acc
          pure (uniforms, SamplerBindingSpec slot tex Nothing : samplers, storage)
        ShaderBindSamplerWith stage slot tex sampler -> do
          ensureFragmentStage stage
          let (uniforms, samplers, storage) = acc
          pure (uniforms, SamplerBindingSpec slot tex (Just sampler) : samplers, storage)
        ShaderBindStorageTexture stage slot tex -> do
          ensureFragmentStage stage
          let (uniforms, samplers, storage) = acc
          pure (uniforms, samplers, StorageBinding slot tex : storage)

collectBindings :: [Binding] -> IO DrawBindings
collectBindings bindings = do
  (vUniforms, fUniforms, samplers, storage) <- foldM step ([], [], [], []) bindings
  vUniforms' <- normalizeUniforms "vertex uniform" vUniforms
  fUniforms' <- normalizeUniforms "fragment uniform" fUniforms
  samplerValues <- normalizeBindings "sampler" (map (\(SamplerBindingSpec slot tex sampler) -> (slot, (tex, sampler))) samplers)
  storageValues <- normalizeBindings "storage texture" (map (\(StorageBinding slot tex) -> (slot, tex)) storage)
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
  uniforms' <- normalizeUniforms "compute uniform" uniforms
  samplerValues <- normalizeBindings "compute sampler" (map (\(SamplerBindingSpec slot tex sampler) -> (slot, (tex, sampler))) samplers)
  readOnlyValues <- normalizeBindings "compute storage texture" (map (\(slot, tex) -> (slot, tex)) readOnly)
  readWriteValues <- normalizeBindings "compute storage texture (rw)" (map (\(slot, tex) -> (slot, tex)) readWrite)
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

mergeUniformBindings :: Shader -> [UniformBinding] -> IO [UniformBinding]
mergeUniformBindings shader explicit = do
  defaults <- readIORef shader.shaderUniformDefaults
  let explicitMap = Map.fromList [ (slot, bytes) | UniformBinding slot bytes <- explicit ]
  let merged = Map.union explicitMap defaults
  pure (map (uncurry UniformBinding) (Map.toAscList merged))

ensureFragmentStage :: ShaderStage -> IO ()
ensureFragmentStage stage =
  case stage of
    ShaderFragment -> pure ()
    ShaderVertex ->
      ioError (userError "vertex-stage bindings are not supported by the Slop renderer")
    ShaderCompute ->
      ioError (userError "compute-stage bindings are not supported by the Slop renderer")

normalizeBindings :: String -> [(Word32, a)] -> IO [a]
normalizeBindings label bindings =
  either (ioError . userError) pure (normalizeBindingsEither label bindings)

normalizeBindingsEither :: String -> [(Word32, a)] -> Either String [a]
normalizeBindingsEither label bindings =
  case bindings of
    [] -> Right []
    _ -> do
      let pairs = map (\(slot, value) -> (fromIntegral slot :: Int, value)) bindings
      let mapSlots = Map.fromList pairs
      when (Map.size mapSlots /= length pairs) $
        Left ("duplicate " <> label <> " binding slot")
      let slots = Map.keys mapSlots
      let maxSlot = last slots
      let expected = [0 .. maxSlot]
      when (slots /= expected) $
        Left ("non-contiguous " <> label <> " binding slots; expected 0.." <> show maxSlot)
      pure (map snd (Map.toAscList mapSlots))

normalizeUniforms :: String -> [UniformBinding] -> IO [UniformBinding]
normalizeUniforms label bindings =
  either (ioError . userError) pure (normalizeUniformsEither label bindings)

normalizeUniformsEither :: String -> [UniformBinding] -> Either String [UniformBinding]
normalizeUniformsEither label bindings =
  case bindings of
    [] -> Right []
    _ -> do
      let pairs = map (\(UniformBinding slot bytes) -> (slot, bytes)) bindings
      let mapSlots = Map.fromList pairs
      when (Map.size mapSlots /= length pairs) $
        Left ("duplicate " <> label <> " binding slot")
      pure (map (uncurry UniformBinding) (Map.toAscList mapSlots))

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

resolveNamedBindings :: ShaderBindings -> [NamedShaderBinding] -> IO [ShaderBinding]
resolveNamedBindings bindings =
  fmap reverse . foldM (step bindings) []
  where
    step table acc entry =
      case entry of
        ShaderBindUniformNamed stage name value -> do
          slot <- lookupUniformSlot table name
          pure (ShaderBindUniform stage slot value : acc)
        ShaderBindUniformBytesNamed stage name bytes -> do
          slot <- lookupUniformSlot table name
          pure (ShaderBindUniformBytes stage slot bytes : acc)
        ShaderBindSamplerNamed stage name tex -> do
          slot <- lookupSamplerSlot table name
          pure (ShaderBindSampler stage slot tex : acc)
        ShaderBindSamplerWithNamed stage name tex sampler -> do
          slot <- lookupSamplerSlot table name
          pure (ShaderBindSamplerWith stage slot tex sampler : acc)
        ShaderBindStorageTextureNamed stage name tex -> do
          slot <- lookupStorageTextureSlot table name
          pure (ShaderBindStorageTexture stage slot tex : acc)

lookupUniformSlot :: ShaderBindings -> String -> IO Word32
lookupUniformSlot table name =
  case Map.lookup name table.shaderUniformSlots of
    Just slot -> pure slot
    Nothing -> ioError (userError ("unknown uniform binding: " <> name))

lookupSamplerSlot :: ShaderBindings -> String -> IO Word32
lookupSamplerSlot table name =
  case Map.lookup name table.shaderSamplerSlots of
    Just slot -> pure slot
    Nothing -> ioError (userError ("unknown sampler binding: " <> name))

lookupStorageTextureSlot :: ShaderBindings -> String -> IO Word32
lookupStorageTextureSlot table name =
  case Map.lookup name table.shaderStorageTextureSlots of
    Just slot -> pure slot
    Nothing -> ioError (userError ("unknown storage texture binding: " <> name))
setShaderUniformCached :: Storable a => Shader -> Word32 -> a -> Loop ()
setShaderUniformCached shader slot value =
  Loop (liftIO (setShaderUniformIO shader slot value))

setShaderUniformBytesCached :: Shader -> Word32 -> ByteString -> Loop ()
setShaderUniformBytesCached shader slot bytes =
  Loop (liftIO (setShaderUniformBytesIO shader slot bytes))

createShaderFromSpirv :: ByteString -> WindowM Shader
createShaderFromSpirv spirv = liftWindow (\window -> createShaderFromSpirvIO window spirv)

createShaderFromSpirvWith :: ByteString -> Word32 -> Word32 -> Word32 -> Word32 -> WindowM Shader
createShaderFromSpirvWith spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers =
  liftWindow (\window -> createShaderFromSpirvWithIO window spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers)

evictTextCacheForFontIO :: Window -> Font -> IO ()
evictTextCacheForFontIO window font = do
  let Font fontPtr = font
  stale <- atomicModifyIORef' (window.appRenderState) $ \st ->
    let (keep, dropMap) = Map.partitionWithKey (\(p, _) _ -> p /= castPtr fontPtr) (st.rsTextCache)
        st' = st { rsTextCache = keep }
    in (st', map (\ct -> ct.ctText) (Map.elems dropMap))
  mapM_ ttfDestroyText stale

destroyShader :: Shader -> WindowM ()
destroyShader shader =
  liftIO (destroyShaderIO shader)

withShaderBindings :: Shader -> [ShaderUniform] -> Loop a -> Loop a
withShaderBindings shader bindings action =
  Loop $ do
    collected <- liftIO (collectShaderBindings bindings)
    runLoop (withShaderBindingsInternalBlend BlendAlpha shader collected Nothing action)

withShaderBindingsStage :: Shader -> [ShaderBinding] -> Loop a -> Loop a
withShaderBindingsStage shader bindings action =
  Loop $ do
    collected <- liftIO (collectStageBindings bindings)
    runLoop (withShaderBindingsInternalBlend BlendAlpha shader collected Nothing action)

withShaderBindingsNamed :: Shader -> [NamedShaderBinding] -> Loop a -> Loop a
withShaderBindingsNamed shader bindings action =
  Loop $ do
    table <- liftIO (readIORef shader.shaderBindingTable)
    resolved <- liftIO (resolveNamedBindings table bindings)
    runLoop (withShaderBindingsStage shader resolved action)

withShaderBindingsInternalBlend :: BlendMode -> Shader -> ([UniformBinding], [SamplerBindingSpec], [StorageBinding]) -> Maybe Transform2D -> Loop a -> Loop a
withShaderBindingsInternalBlend blend shader (uniforms, samplers, storage) transform (Loop action) =
  Loop $ do
    window <- ask
    merged <- liftIO (mergeUniformBindings shader uniforms)
    let ctx = ShaderContext shader merged samplers storage blend transform
    liftIO (withShaderContext window ctx (runWindowM window action))

withShader :: Shader -> Loop a -> Loop a
withShader shader (Loop action) =
  Loop $ do
    window <- ask
    merged <- liftIO (mergeUniformBindings shader [])
    let ctx = ShaderContext shader merged [] [] BlendAlpha Nothing
    liftIO (withShaderContext window ctx (runWindowM window action))

withShaderUniform :: Storable a => Shader -> Word32 -> a -> Loop b -> Loop b
withShaderUniform shader slot value action = do
  setShaderUniformCached shader slot value
  withShader shader action

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
