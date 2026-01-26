{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module Slop.SDL.Raw
  ( SDL_InitFlags
  , SDL_WindowFlags
  , SDL_PixelFormat
  , SDL_TextureAccess
  , SDL_GPUShaderFormat
  , SDL_GPUShaderStage
  , SDL_GPUFilter
  , SDL_GPUSamplerMipmapMode
  , SDL_GPUSamplerAddressMode
  , SDL_GPUCompareOp
  , SDL_GPUTextureFormat
  , SDL_GPUTextureType
  , SDL_GPUTextureUsageFlags
  , SDL_GPUBufferUsageFlags
  , SDL_GPUTransferBufferUsage
  , SDL_GPUPrimitiveType
  , SDL_GPULoadOp
  , SDL_GPUStoreOp
  , SDL_GPUSampleCount
  , SDL_GPUVertexElementFormat
  , SDL_GPUVertexInputRate
  , SDL_GPUBlendOp
  , SDL_GPUBlendFactor
  , SDL_GPUColorComponentFlags
  , SDL_GPUFillMode
  , SDL_GPUCullMode
  , SDL_GPUFrontFace
  , SDL_GPUStencilOp
  , SDL_EventType
  , SDL_PropertiesID
  , SDL_Keycode
  , SDL_Keymod
  , Window(..)
  , Renderer(..)
  , Texture(..)
  , Surface(..)
  , SurfaceInfo(..)
  , Mixer(..)
  , Audio(..)
  , Track(..)
  , GPUDevice(..)
  , GPUCommandBuffer(..)
  , GPUComputePass(..)
  , GPUComputePipeline(..)
  , GPURenderPass(..)
  , GPUGraphicsPipeline(..)
  , GPUBuffer(..)
  , GPUTransferBuffer(..)
  , GPUCopyPass(..)
  , GPUTexture(..)
  , GPUShader(..)
  , GPURenderState(..)
  , GPUSampler(..)
  , TextEngine(..)
  , Font(..)
  , Text(..)
  , SDL_Event
  , FColor(..)
  , FRect(..)
  , FPoint(..)
  , GPUTextureSamplerBinding(..)
  , GPUStorageBufferReadWriteBinding(..)
  , GPUStorageTextureReadWriteBinding(..)
  , GPUBufferBinding(..)
  , GPUViewport(..)
  , GPUVertexBufferDescription(..)
  , GPUVertexAttribute(..)
  , GPUVertexInputState(..)
  , GPUColorTargetBlendState(..)
  , GPUColorTargetDescription(..)
  , GPUGraphicsPipelineTargetInfo(..)
  , GPURasterizerState(..)
  , GPUMultisampleState(..)
  , GPUDepthStencilState(..)
  , GPUStencilOpState(..)
  , GPUShaderCreateInfo(..)
  , GPUSamplerCreateInfo(..)
  , GPURenderStateCreateInfo(..)
  , GPUComputePipelineCreateInfo(..)
  , GPUTextureCreateInfo(..)
  , GPUBufferCreateInfo(..)
  , GPUTransferBufferCreateInfo(..)
  , GPUTextureTransferInfo(..)
  , GPUTransferBufferLocation(..)
  , GPUTextureRegion(..)
  , GPUBufferRegion(..)
  , GPUColorTargetInfo(..)
  , GPUDepthStencilTargetInfo(..)
  , GPUGraphicsPipelineCreateInfo(..)
  , sdlInitVideo
  , sdlInitAudio
  , sdlEventQuit
  , sdlGPUShaderFormatSpirv
  , sdlGPUShaderStageVertex
  , sdlGPUShaderStageFragment
  , sdlGPUFilterNearest
  , sdlGPUFilterLinear
  , sdlGPUSamplerMipmapModeNearest
  , sdlGPUSamplerMipmapModeLinear
  , sdlGPUSamplerAddressModeRepeat
  , sdlGPUSamplerAddressModeMirroredRepeat
  , sdlGPUSamplerAddressModeClampToEdge
  , sdlGPUCompareOpInvalid
  , sdlGPUCompareOpLess
  , sdlGPUCompareOpLessOrEqual
  , sdlGPUCompareOpAlways
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
  , sdlGPUBufferUsageComputeStorageRead
  , sdlGPUBufferUsageComputeStorageWrite
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
  , sdlAudioDeviceDefaultPlayback
  , sdlInit
  , sdlQuit
  , sdlGetError
  , sdlCreateWindow
  , sdlDestroyWindow
  , sdlSetWindowResizable
  , sdlShowWindow
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
  , sdlPushGPUComputeUniformData
  , sdlPushGPUFragmentUniformData
  , sdlBeginGPUComputePass
  , sdlEndGPUComputePass
  , sdlBindGPUComputePipeline
  , sdlBindGPUComputeSamplers
  , sdlBindGPUComputeStorageTextures
  , sdlBindGPUComputeStorageBuffers
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
  , sdlCreateGPURenderer
  , sdlDestroyRenderer
  , sdlGetGPURendererDevice
  , sdlSetRenderDrawColorFloat
  , sdlRenderClear
  , sdlRenderPresent
  , sdlRenderTexture
  , sdlRenderLine
  , sdlRenderLines
  , sdlRenderRect
  , sdlRenderFillRect
  , sdlCreateTexture
  , sdlSetRenderTarget
  , sdlGetRenderTarget
  , sdlGetTextureProperties
  , sdlCreateProperties
  , sdlDestroyProperties
  , sdlSetPointerProperty
  , sdlSetNumberProperty
  , sdlGetPointerProperty
  , sdlPropTextureGpuTexturePointer
  , sdlTextureAccessTarget
  , sdlPixelFormatRGBA8888
  , sdlPollEvent
  , sdlPumpEvents
  , sdlGetKeyboardState
  , sdlGetKeyFromScancode
  , sdlGetMouseState
  , sdlGetWindowSize
  , allocaEvent
  , peekEventType
  , sdlGetTicks
  , imgLoadTexture
  , imgLoadSurface
  , sdlDestroyTexture
  , sdlDestroySurface
  , sdlLockSurface
  , sdlUnlockSurface
  , sdlConvertSurface
  , ttfInit
  , ttfQuit
  , ttfOpenFont
  , ttfCloseFont
  , ttfSetFontSDF
  , ttfGetFontSDF
  , ttfCreateRendererTextEngine
  , ttfDestroyRendererTextEngine
  , ttfCreateGPUTextEngine
  , ttfCreateGPUTextEngineWithProperties
  , ttfDestroyGPUTextEngine
  , ttfCreateText
  , ttfDestroyText
  , ttfDrawRendererText
  , TTF_GPUAtlasDrawSequence(..)
  , ttfGetGPUTextDrawData
  , ttfSetTextPosition
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
  , mixGetTrackGain
  , mixStopTrack
  , mixTrackPlaying
  , mixPlayAudio
  , sdlCreateGPUShader
  , sdlReleaseGPUShader
  , sdlCreateGPURenderState
  , sdlDestroyGPURenderState
  , sdlSetGPURenderState
  , sdlSetGPURenderStateFragmentUniforms
  , sdlCreateGPUSampler
  , sdlReleaseGPUSampler
  ) where

import Data.Proxy (Proxy (..))
import Foreign
import Foreign.C.String
import Foreign.C.Types

-- SDL core types

type SDL_InitFlags = Word32

type SDL_WindowFlags = Word64

type SDL_PixelFormat = Word32

type SDL_TextureAccess = CInt

type SDL_GPUShaderFormat = Word32

type SDL_GPUShaderStage = CInt

type SDL_GPUFilter = CInt

type SDL_GPUSamplerMipmapMode = CInt

type SDL_GPUSamplerAddressMode = CInt

type SDL_GPUCompareOp = CInt

type SDL_GPUTextureFormat = CInt

type SDL_GPUTextureType = CInt

type SDL_GPUTextureUsageFlags = Word32

type SDL_GPUBufferUsageFlags = Word32

type SDL_GPUTransferBufferUsage = CInt

type SDL_GPUPrimitiveType = CInt

type SDL_GPULoadOp = CInt

type SDL_GPUStoreOp = CInt

type SDL_GPUSampleCount = CInt

type SDL_GPUVertexElementFormat = CInt

type SDL_GPUVertexInputRate = CInt

type SDL_GPUBlendOp = CInt

type SDL_GPUBlendFactor = CInt

type SDL_GPUColorComponentFlags = Word8

type SDL_GPUFillMode = CInt

type SDL_GPUCullMode = CInt

type SDL_GPUFrontFace = CInt

type SDL_GPUStencilOp = CInt

type SDL_EventType = Word32

type SDL_PropertiesID = Word32

type SDL_Keycode = Word32

type SDL_Keymod = Word16

type SDL_AudioDeviceID = Word32

data SDL_AudioSpec

sdlInitVideo :: SDL_InitFlags
sdlInitVideo = 0x00000020

sdlInitAudio :: SDL_InitFlags
sdlInitAudio = 0x00000010

sdlEventQuit :: SDL_EventType
sdlEventQuit = 0x00000100

sdlGPUShaderFormatSpirv :: SDL_GPUShaderFormat
sdlGPUShaderFormatSpirv = 1 `shiftL` 1

sdlGPUShaderStageVertex :: SDL_GPUShaderStage
sdlGPUShaderStageVertex = 0

sdlGPUShaderStageFragment :: SDL_GPUShaderStage
sdlGPUShaderStageFragment = 1

sdlGPUFilterNearest :: SDL_GPUFilter
sdlGPUFilterNearest = 0

sdlGPUFilterLinear :: SDL_GPUFilter
sdlGPUFilterLinear = 1

sdlGPUSamplerMipmapModeNearest :: SDL_GPUSamplerMipmapMode
sdlGPUSamplerMipmapModeNearest = 0

sdlGPUSamplerMipmapModeLinear :: SDL_GPUSamplerMipmapMode
sdlGPUSamplerMipmapModeLinear = 1

sdlGPUSamplerAddressModeRepeat :: SDL_GPUSamplerAddressMode
sdlGPUSamplerAddressModeRepeat = 0

sdlGPUSamplerAddressModeMirroredRepeat :: SDL_GPUSamplerAddressMode
sdlGPUSamplerAddressModeMirroredRepeat = 1

sdlGPUSamplerAddressModeClampToEdge :: SDL_GPUSamplerAddressMode
sdlGPUSamplerAddressModeClampToEdge = 2

sdlGPUCompareOpInvalid :: SDL_GPUCompareOp
sdlGPUCompareOpInvalid = 0

sdlGPUCompareOpLess :: SDL_GPUCompareOp
sdlGPUCompareOpLess = 2

sdlGPUCompareOpLessOrEqual :: SDL_GPUCompareOp
sdlGPUCompareOpLessOrEqual = 4

sdlGPUCompareOpAlways :: SDL_GPUCompareOp
sdlGPUCompareOpAlways = 8

sdlGPUTextureFormatRGBA8 :: SDL_GPUTextureFormat
sdlGPUTextureFormatRGBA8 = 4

sdlGPUTextureFormatD16UNORM :: SDL_GPUTextureFormat
sdlGPUTextureFormatD16UNORM = 58

sdlGPUTextureFormatD24UNORM :: SDL_GPUTextureFormat
sdlGPUTextureFormatD24UNORM = 59

sdlGPUTextureFormatD32Float :: SDL_GPUTextureFormat
sdlGPUTextureFormatD32Float = 60

sdlGPUTextureFormatD24UNORMS8UINT :: SDL_GPUTextureFormat
sdlGPUTextureFormatD24UNORMS8UINT = 61

sdlGPUTextureFormatD32FloatS8UINT :: SDL_GPUTextureFormat
sdlGPUTextureFormatD32FloatS8UINT = 62

sdlGPUTextureType2D :: SDL_GPUTextureType
sdlGPUTextureType2D = 0

sdlGPUTextureUsageSampler :: SDL_GPUTextureUsageFlags
sdlGPUTextureUsageSampler = 1 `shiftL` 0

sdlGPUTextureUsageColorTarget :: SDL_GPUTextureUsageFlags
sdlGPUTextureUsageColorTarget = 1 `shiftL` 1

sdlGPUTextureUsageDepthStencilTarget :: SDL_GPUTextureUsageFlags
sdlGPUTextureUsageDepthStencilTarget = 1 `shiftL` 2

sdlGPUTextureUsageComputeStorageRead :: SDL_GPUTextureUsageFlags
sdlGPUTextureUsageComputeStorageRead = 1 `shiftL` 4

sdlGPUTextureUsageComputeStorageWrite :: SDL_GPUTextureUsageFlags
sdlGPUTextureUsageComputeStorageWrite = 1 `shiftL` 5

sdlGPUTextureUsageComputeStorageSimultaneousReadWrite :: SDL_GPUTextureUsageFlags
sdlGPUTextureUsageComputeStorageSimultaneousReadWrite = 1 `shiftL` 6

sdlGPUBufferUsageVertex :: SDL_GPUBufferUsageFlags
sdlGPUBufferUsageVertex = 1 `shiftL` 0

sdlGPUBufferUsageComputeStorageRead :: SDL_GPUBufferUsageFlags
sdlGPUBufferUsageComputeStorageRead = 1 `shiftL` 4

sdlGPUBufferUsageComputeStorageWrite :: SDL_GPUBufferUsageFlags
sdlGPUBufferUsageComputeStorageWrite = 1 `shiftL` 5

sdlGPUTransferBufferUsageUpload :: SDL_GPUTransferBufferUsage
sdlGPUTransferBufferUsageUpload = 0

sdlGPUPrimitiveTypeTriangleList :: SDL_GPUPrimitiveType
sdlGPUPrimitiveTypeTriangleList = 0

sdlGPUPrimitiveTypeLineList :: SDL_GPUPrimitiveType
sdlGPUPrimitiveTypeLineList = 2

sdlGPULoadOpLoad :: SDL_GPULoadOp
sdlGPULoadOpLoad = 0

sdlGPULoadOpClear :: SDL_GPULoadOp
sdlGPULoadOpClear = 1

sdlGPUStoreOpStore :: SDL_GPUStoreOp
sdlGPUStoreOpStore = 0

sdlGPUSampleCount1 :: SDL_GPUSampleCount
sdlGPUSampleCount1 = 0

sdlGPUVertexElementFormatFloat2 :: SDL_GPUVertexElementFormat
sdlGPUVertexElementFormatFloat2 = 10

sdlGPUVertexElementFormatFloat4 :: SDL_GPUVertexElementFormat
sdlGPUVertexElementFormatFloat4 = 12

sdlGPUVertexInputRateVertex :: SDL_GPUVertexInputRate
sdlGPUVertexInputRateVertex = 0

sdlGPUBlendOpAdd :: SDL_GPUBlendOp
sdlGPUBlendOpAdd = 1

sdlGPUBlendFactorOne :: SDL_GPUBlendFactor
sdlGPUBlendFactorOne = 2

sdlGPUBlendFactorZero :: SDL_GPUBlendFactor
sdlGPUBlendFactorZero = 1

sdlGPUBlendFactorSrcAlpha :: SDL_GPUBlendFactor
sdlGPUBlendFactorSrcAlpha = 7

sdlGPUBlendFactorOneMinusSrcAlpha :: SDL_GPUBlendFactor
sdlGPUBlendFactorOneMinusSrcAlpha = 8

sdlGPUColorComponentRGBA :: SDL_GPUColorComponentFlags
sdlGPUColorComponentRGBA = 0x0F

sdlGPUFillModeFill :: SDL_GPUFillMode
sdlGPUFillModeFill = 0

sdlGPUCullModeNone :: SDL_GPUCullMode
sdlGPUCullModeNone = 0

sdlGPUFrontFaceCounterClockwise :: SDL_GPUFrontFace
sdlGPUFrontFaceCounterClockwise = 0

sdlGPUStencilOpKeep :: SDL_GPUStencilOp
sdlGPUStencilOpKeep = 1

sdlTextureAccessTarget :: SDL_TextureAccess
sdlTextureAccessTarget = 2

sdlPixelFormatRGBA8888 :: SDL_PixelFormat
sdlPixelFormatRGBA8888 = 0x16462004

sdlPropTextureGpuTexturePointer :: String
sdlPropTextureGpuTexturePointer = "SDL.texture.gpu.texture"

sdlAudioDeviceDefaultPlayback :: SDL_AudioDeviceID
sdlAudioDeviceDefaultPlayback = 0xFFFFFFFF

-- Opaque handles

data SDL_Window
newtype Window = Window (Ptr SDL_Window) deriving (Eq, Show)

data SDL_Renderer
newtype Renderer = Renderer (Ptr SDL_Renderer) deriving (Eq, Show)

data SDL_Texture
newtype Texture = Texture (Ptr SDL_Texture) deriving (Eq, Show)

data SDL_Surface
newtype Surface = Surface (Ptr SDL_Surface) deriving (Eq, Show)

data MIX_Mixer
newtype Mixer = Mixer (Ptr MIX_Mixer) deriving (Eq, Show)

data MIX_Audio
newtype Audio = Audio (Ptr MIX_Audio) deriving (Eq, Show)

data MIX_Track
newtype Track = Track (Ptr MIX_Track) deriving (Eq, Show)

data SDL_GPUDevice
newtype GPUDevice = GPUDevice (Ptr SDL_GPUDevice) deriving (Eq, Show)

data SDL_GPUCommandBuffer
newtype GPUCommandBuffer = GPUCommandBuffer (Ptr SDL_GPUCommandBuffer) deriving (Eq, Show)

data SDL_GPUComputePass
newtype GPUComputePass = GPUComputePass (Ptr SDL_GPUComputePass) deriving (Eq, Show)

data SDL_GPURenderPass
newtype GPURenderPass = GPURenderPass (Ptr SDL_GPURenderPass) deriving (Eq, Show)

data SDL_GPUComputePipeline
newtype GPUComputePipeline = GPUComputePipeline (Ptr SDL_GPUComputePipeline) deriving (Eq, Show)

data SDL_GPUGraphicsPipeline
newtype GPUGraphicsPipeline = GPUGraphicsPipeline (Ptr SDL_GPUGraphicsPipeline) deriving (Eq, Show)

data SDL_GPUBuffer
newtype GPUBuffer = GPUBuffer (Ptr SDL_GPUBuffer) deriving (Eq, Show)

data SDL_GPUTransferBuffer
newtype GPUTransferBuffer = GPUTransferBuffer (Ptr SDL_GPUTransferBuffer) deriving (Eq, Show)

data SDL_GPUCopyPass
newtype GPUCopyPass = GPUCopyPass (Ptr SDL_GPUCopyPass) deriving (Eq, Show)

data SDL_GPUTexture
newtype GPUTexture = GPUTexture (Ptr SDL_GPUTexture) deriving (Eq, Show)

data SDL_GPUShader
newtype GPUShader = GPUShader (Ptr SDL_GPUShader) deriving (Eq, Show)

data SDL_GPURenderState
newtype GPURenderState = GPURenderState (Ptr SDL_GPURenderState) deriving (Eq, Show)

data SDL_GPUSampler
newtype GPUSampler = GPUSampler (Ptr SDL_GPUSampler) deriving (Eq, Show)

data TTF_TextEngine
newtype TextEngine = TextEngine (Ptr TTF_TextEngine) deriving (Eq, Show)

data TTF_Font
newtype Font = Font (Ptr TTF_Font) deriving (Eq, Show)

data TTF_Text
newtype Text = Text (Ptr TTF_Text) deriving (Eq, Show)

-- Events

data SDL_Event

type EventPtr = Ptr SDL_Event

sdlEventSize :: Int
sdlEventSize = 128

sdlEventAlign :: Int
sdlEventAlign = 8

allocaEvent :: (EventPtr -> IO a) -> IO a
allocaEvent = allocaBytesAligned sdlEventSize sdlEventAlign

peekEventType :: EventPtr -> IO SDL_EventType
peekEventType ptr = peekByteOff (castPtr ptr) 0

-- Geometry

data FPoint = FPoint
  { fPointX :: CFloat
  , fPointY :: CFloat
  }
  deriving (Eq, Show)

instance Storable FPoint where
  sizeOf _ = 2 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    x <- peekByteOff ptr 0
    y <- peekByteOff ptr (sizeOf (undefined :: CFloat))
    pure (FPoint x y)
  poke ptr (FPoint x y) = do
    pokeByteOff ptr 0 x
    pokeByteOff ptr (sizeOf (undefined :: CFloat)) y

data FColor = FColor
  { fColorR :: CFloat
  , fColorG :: CFloat
  , fColorB :: CFloat
  , fColorA :: CFloat
  }
  deriving (Eq, Show)

instance Storable FColor where
  sizeOf _ = 4 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
    r <- peekByteOff ptr 0
    g <- peekByteOff ptr step
    b <- peekByteOff ptr (2 * step)
    a <- peekByteOff ptr (3 * step)
    pure (FColor r g b a)
  poke ptr (FColor r g b a) = do
    let step = sizeOf (undefined :: CFloat)
    pokeByteOff ptr 0 r
    pokeByteOff ptr step g
    pokeByteOff ptr (2 * step) b
    pokeByteOff ptr (3 * step) a


data FRect = FRect
  { fRectX :: CFloat
  , fRectY :: CFloat
  , fRectW :: CFloat
  , fRectH :: CFloat
  }
  deriving (Eq, Show)

instance Storable FRect where
  sizeOf _ = 4 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
    x <- peekByteOff ptr 0
    y <- peekByteOff ptr step
    w <- peekByteOff ptr (2 * step)
    h <- peekByteOff ptr (3 * step)
    pure (FRect x y w h)
  poke ptr (FRect x y w h) = do
    let step = sizeOf (undefined :: CFloat)
    pokeByteOff ptr 0 x
    pokeByteOff ptr step y
    pokeByteOff ptr (2 * step) w
    pokeByteOff ptr (3 * step) h

-- GPU structs

data GPUTextureSamplerBinding = GPUTextureSamplerBinding
  { gpuSamplerTexture :: GPUTexture
  , gpuSamplerSampler :: GPUSampler
  }
  deriving (Eq, Show)

data GPUStorageBufferReadWriteBinding = GPUStorageBufferReadWriteBinding
  { gpuStorageBuffer :: GPUBuffer
  , gpuStorageCycle :: CBool
  , gpuStoragePadding1 :: Word8
  , gpuStoragePadding2 :: Word8
  , gpuStoragePadding3 :: Word8
  }
  deriving (Eq, Show)

data GPUStorageTextureReadWriteBinding = GPUStorageTextureReadWriteBinding
  { gpuStorageTexture :: GPUTexture
  , gpuStorageMipLevel :: Word32
  , gpuStorageLayer :: Word32
  , gpuStorageCycle :: CBool
  , gpuStoragePadding1 :: Word8
  , gpuStoragePadding2 :: Word8
  , gpuStoragePadding3 :: Word8
  }
  deriving (Eq, Show)

instance Storable GPUTextureSamplerBinding where
  sizeOf _ = 2 * sizeOf (undefined :: Ptr ())
  alignment _ = alignment (undefined :: Ptr ())
  peek ptr = do
    texturePtr <- peekByteOff ptr 0
    samplerPtr <- peekByteOff ptr (sizeOf (undefined :: Ptr ()))
    pure (GPUTextureSamplerBinding (GPUTexture texturePtr) (GPUSampler samplerPtr))
  poke ptr (GPUTextureSamplerBinding (GPUTexture texturePtr) (GPUSampler samplerPtr)) = do
    pokeByteOff ptr 0 texturePtr
    pokeByteOff ptr (sizeOf (undefined :: Ptr ())) samplerPtr

gpuStorageBufferBindingSize :: Int
gpuStorageBufferBindingAlign :: Int
gpuStorageBufferBindingOffsets :: [Int]
(gpuStorageBufferBindingSize, gpuStorageBufferBindingAlign, gpuStorageBufferBindingOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuStorageBufferPtrOffset
  , gpuStorageBufferCycleOffset
  , gpuStorageBufferPadding1Offset
  , gpuStorageBufferPadding2Offset
  , gpuStorageBufferPadding3Offset
  ) =
  case gpuStorageBufferBindingOffsets of
    [a, b, c, d, e] -> (a, b, c, d, e)
    _ -> error "GPUStorageBufferReadWriteBinding layout mismatch"

instance Storable GPUStorageBufferReadWriteBinding where
  sizeOf _ = gpuStorageBufferBindingSize
  alignment _ = gpuStorageBufferBindingAlign
  peek ptr = do
    bufferPtr <- peekByteOff ptr gpuStorageBufferPtrOffset
    cycleFlag <- peekByteOff ptr gpuStorageBufferCycleOffset
    pad1 <- peekByteOff ptr gpuStorageBufferPadding1Offset
    pad2 <- peekByteOff ptr gpuStorageBufferPadding2Offset
    pad3 <- peekByteOff ptr gpuStorageBufferPadding3Offset
    pure GPUStorageBufferReadWriteBinding
      { gpuStorageBuffer = GPUBuffer bufferPtr
      , gpuStorageCycle = cycleFlag
      , gpuStoragePadding1 = pad1
      , gpuStoragePadding2 = pad2
      , gpuStoragePadding3 = pad3
      }
  poke ptr binding = do
    let GPUBuffer bufferPtr = binding.gpuStorageBuffer
    pokeByteOff ptr gpuStorageBufferPtrOffset bufferPtr
    pokeByteOff ptr gpuStorageBufferCycleOffset binding.gpuStorageCycle
    pokeByteOff ptr gpuStorageBufferPadding1Offset binding.gpuStoragePadding1
    pokeByteOff ptr gpuStorageBufferPadding2Offset binding.gpuStoragePadding2
    pokeByteOff ptr gpuStorageBufferPadding3Offset binding.gpuStoragePadding3

gpuStorageTextureBindingSize :: Int
gpuStorageTextureBindingAlign :: Int
gpuStorageTextureBindingOffsets :: [Int]
(gpuStorageTextureBindingSize, gpuStorageTextureBindingAlign, gpuStorageTextureBindingOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuStorageTexturePtrOffset
  , gpuStorageTextureMipOffset
  , gpuStorageTextureLayerOffset
  , gpuStorageTextureCycleOffset
  , gpuStorageTexturePadding1Offset
  , gpuStorageTexturePadding2Offset
  , gpuStorageTexturePadding3Offset
  ) =
  case gpuStorageTextureBindingOffsets of
    [a, b, c, d, e, f, g] -> (a, b, c, d, e, f, g)
    _ -> error "GPUStorageTextureReadWriteBinding layout mismatch"

instance Storable GPUStorageTextureReadWriteBinding where
  sizeOf _ = gpuStorageTextureBindingSize
  alignment _ = gpuStorageTextureBindingAlign
  peek ptr = do
    texPtr <- peekByteOff ptr gpuStorageTexturePtrOffset
    mip <- peekByteOff ptr gpuStorageTextureMipOffset
    layer <- peekByteOff ptr gpuStorageTextureLayerOffset
    cycleFlag <- peekByteOff ptr gpuStorageTextureCycleOffset
    pad1 <- peekByteOff ptr gpuStorageTexturePadding1Offset
    pad2 <- peekByteOff ptr gpuStorageTexturePadding2Offset
    pad3 <- peekByteOff ptr gpuStorageTexturePadding3Offset
    pure GPUStorageTextureReadWriteBinding
      { gpuStorageTexture = GPUTexture texPtr
      , gpuStorageMipLevel = mip
      , gpuStorageLayer = layer
      , gpuStorageCycle = cycleFlag
      , gpuStoragePadding1 = pad1
      , gpuStoragePadding2 = pad2
      , gpuStoragePadding3 = pad3
      }
  poke ptr binding = do
    let GPUTexture texPtr = binding.gpuStorageTexture
    pokeByteOff ptr gpuStorageTexturePtrOffset texPtr
    pokeByteOff ptr gpuStorageTextureMipOffset binding.gpuStorageMipLevel
    pokeByteOff ptr gpuStorageTextureLayerOffset binding.gpuStorageLayer
    pokeByteOff ptr gpuStorageTextureCycleOffset binding.gpuStorageCycle
    pokeByteOff ptr gpuStorageTexturePadding1Offset binding.gpuStoragePadding1
    pokeByteOff ptr gpuStorageTexturePadding2Offset binding.gpuStoragePadding2
    pokeByteOff ptr gpuStorageTexturePadding3Offset binding.gpuStoragePadding3

data GPUSamplerCreateInfo = GPUSamplerCreateInfo
  { gpuSamplerMinFilter :: SDL_GPUFilter
  , gpuSamplerMagFilter :: SDL_GPUFilter
  , gpuSamplerMipmapMode :: SDL_GPUSamplerMipmapMode
  , gpuSamplerAddressModeU :: SDL_GPUSamplerAddressMode
  , gpuSamplerAddressModeV :: SDL_GPUSamplerAddressMode
  , gpuSamplerAddressModeW :: SDL_GPUSamplerAddressMode
  , gpuSamplerMipLodBias :: CFloat
  , gpuSamplerMaxAnisotropy :: CFloat
  , gpuSamplerCompareOp :: SDL_GPUCompareOp
  , gpuSamplerMinLod :: CFloat
  , gpuSamplerMaxLod :: CFloat
  , gpuSamplerEnableAnisotropy :: CBool
  , gpuSamplerEnableCompare :: CBool
  , gpuSamplerPadding1 :: Word8
  , gpuSamplerPadding2 :: Word8
  , gpuSamplerProps :: SDL_PropertiesID
  }
  deriving (Eq, Show)

data GPUShaderCreateInfo = GPUShaderCreateInfo
  { gpuShaderCodeSize :: CSize
  , gpuShaderCode :: Ptr Word8
  , gpuShaderEntryPoint :: CString
  , gpuShaderFormat :: SDL_GPUShaderFormat
  , gpuShaderStage :: SDL_GPUShaderStage
  , gpuShaderNumSamplers :: Word32
  , gpuShaderNumStorageTextures :: Word32
  , gpuShaderNumStorageBuffers :: Word32
  , gpuShaderNumUniformBuffers :: Word32
  , gpuShaderProps :: SDL_PropertiesID
  }
  deriving (Eq, Show)

data GPUComputePipelineCreateInfo = GPUComputePipelineCreateInfo
  { gpuComputeCodeSize :: CSize
  , gpuComputeCode :: Ptr Word8
  , gpuComputeEntryPoint :: CString
  , gpuComputeFormat :: SDL_GPUShaderFormat
  , gpuComputeNumSamplers :: Word32
  , gpuComputeNumReadonlyStorageTextures :: Word32
  , gpuComputeNumReadonlyStorageBuffers :: Word32
  , gpuComputeNumReadwriteStorageTextures :: Word32
  , gpuComputeNumReadwriteStorageBuffers :: Word32
  , gpuComputeNumUniformBuffers :: Word32
  , gpuComputeThreadCountX :: Word32
  , gpuComputeThreadCountY :: Word32
  , gpuComputeThreadCountZ :: Word32
  , gpuComputeProps :: SDL_PropertiesID
  }
  deriving (Eq, Show)


data GPURenderStateCreateInfo = GPURenderStateCreateInfo
  { gpuRenderFragmentShader :: Ptr SDL_GPUShader
  , gpuRenderNumSamplerBindings :: CInt
  , gpuRenderSamplerBindings :: Ptr ()
  , gpuRenderNumStorageTextures :: CInt
  , gpuRenderStorageTextures :: Ptr ()
  , gpuRenderNumStorageBuffers :: CInt
  , gpuRenderStorageBuffers :: Ptr ()
  , gpuRenderProps :: SDL_PropertiesID
  }
  deriving (Eq, Show)

-- SDL_gpu structs

data GPUViewport = GPUViewport
  { gpuViewportX :: CFloat
  , gpuViewportY :: CFloat
  , gpuViewportW :: CFloat
  , gpuViewportH :: CFloat
  , gpuViewportMinDepth :: CFloat
  , gpuViewportMaxDepth :: CFloat
  }
  deriving (Eq, Show)

data GPUBufferBinding = GPUBufferBinding
  { gpuBufferBindingBuffer :: GPUBuffer
  , gpuBufferBindingOffset :: Word32
  }
  deriving (Eq, Show)

data GPUVertexBufferDescription = GPUVertexBufferDescription
  { gpuVertexBufferSlot :: Word32
  , gpuVertexBufferPitch :: Word32
  , gpuVertexBufferInputRate :: SDL_GPUVertexInputRate
  , gpuVertexBufferInstanceStepRate :: Word32
  }
  deriving (Eq, Show)

data GPUVertexAttribute = GPUVertexAttribute
  { gpuVertexAttributeLocation :: Word32
  , gpuVertexAttributeBufferSlot :: Word32
  , gpuVertexAttributeFormat :: SDL_GPUVertexElementFormat
  , gpuVertexAttributeOffset :: Word32
  }
  deriving (Eq, Show)

data GPUVertexInputState = GPUVertexInputState
  { gpuVertexInputBufferDescriptions :: Ptr GPUVertexBufferDescription
  , gpuVertexInputNumBuffers :: Word32
  , gpuVertexInputAttributes :: Ptr GPUVertexAttribute
  , gpuVertexInputNumAttributes :: Word32
  }
  deriving (Eq, Show)

data GPUColorTargetBlendState = GPUColorTargetBlendState
  { gpuBlendSrcColor :: SDL_GPUBlendFactor
  , gpuBlendDstColor :: SDL_GPUBlendFactor
  , gpuBlendColorOp :: SDL_GPUBlendOp
  , gpuBlendSrcAlpha :: SDL_GPUBlendFactor
  , gpuBlendDstAlpha :: SDL_GPUBlendFactor
  , gpuBlendAlphaOp :: SDL_GPUBlendOp
  , gpuBlendColorWriteMask :: SDL_GPUColorComponentFlags
  , gpuBlendEnable :: CBool
  , gpuBlendEnableColorWriteMask :: CBool
  , gpuBlendPadding1 :: Word8
  , gpuBlendPadding2 :: Word8
  }
  deriving (Eq, Show)

data GPUColorTargetDescription = GPUColorTargetDescription
  { gpuColorTargetFormat :: SDL_GPUTextureFormat
  , gpuColorTargetBlend :: GPUColorTargetBlendState
  }
  deriving (Eq, Show)

data GPUGraphicsPipelineTargetInfo = GPUGraphicsPipelineTargetInfo
  { gpuPipelineColorTargetDescriptions :: Ptr GPUColorTargetDescription
  , gpuPipelineNumColorTargets :: Word32
  , gpuPipelineDepthStencilFormat :: SDL_GPUTextureFormat
  , gpuPipelineHasDepthStencil :: CBool
  , gpuPipelinePadding1 :: Word8
  , gpuPipelinePadding2 :: Word8
  , gpuPipelinePadding3 :: Word8
  }
  deriving (Eq, Show)

data GPURasterizerState = GPURasterizerState
  { gpuRasterizerFillMode :: SDL_GPUFillMode
  , gpuRasterizerCullMode :: SDL_GPUCullMode
  , gpuRasterizerFrontFace :: SDL_GPUFrontFace
  , gpuRasterizerDepthBiasConstantFactor :: CFloat
  , gpuRasterizerDepthBiasClamp :: CFloat
  , gpuRasterizerDepthBiasSlopeFactor :: CFloat
  , gpuRasterizerEnableDepthBias :: CBool
  , gpuRasterizerEnableDepthClip :: CBool
  , gpuRasterizerPadding1 :: Word8
  , gpuRasterizerPadding2 :: Word8
  }
  deriving (Eq, Show)

data GPUMultisampleState = GPUMultisampleState
  { gpuMultisampleCount :: SDL_GPUSampleCount
  , gpuMultisampleMask :: Word32
  , gpuMultisampleEnableMask :: CBool
  , gpuMultisampleEnableAlphaToCoverage :: CBool
  , gpuMultisamplePadding2 :: Word8
  , gpuMultisamplePadding3 :: Word8
  }
  deriving (Eq, Show)

data GPUStencilOpState = GPUStencilOpState
  { gpuStencilFailOp :: SDL_GPUStencilOp
  , gpuStencilPassOp :: SDL_GPUStencilOp
  , gpuStencilDepthFailOp :: SDL_GPUStencilOp
  , gpuStencilCompareOp :: SDL_GPUCompareOp
  }
  deriving (Eq, Show)

data GPUDepthStencilState = GPUDepthStencilState
  { gpuDepthCompareOp :: SDL_GPUCompareOp
  , gpuDepthBackStencilState :: GPUStencilOpState
  , gpuDepthFrontStencilState :: GPUStencilOpState
  , gpuDepthCompareMask :: Word8
  , gpuDepthWriteMask :: Word8
  , gpuDepthEnableDepthTest :: CBool
  , gpuDepthEnableDepthWrite :: CBool
  , gpuDepthEnableStencilTest :: CBool
  , gpuDepthPadding1 :: Word8
  , gpuDepthPadding2 :: Word8
  , gpuDepthPadding3 :: Word8
  }
  deriving (Eq, Show)

data GPUGraphicsPipelineCreateInfo = GPUGraphicsPipelineCreateInfo
  { gpuPipelineVertexShader :: Ptr SDL_GPUShader
  , gpuPipelineFragmentShader :: Ptr SDL_GPUShader
  , gpuPipelineVertexInputState :: GPUVertexInputState
  , gpuPipelinePrimitiveType :: SDL_GPUPrimitiveType
  , gpuPipelineRasterizerState :: GPURasterizerState
  , gpuPipelineMultisampleState :: GPUMultisampleState
  , gpuPipelineDepthStencilState :: GPUDepthStencilState
  , gpuPipelineTargetInfo :: GPUGraphicsPipelineTargetInfo
  , gpuPipelineProps :: SDL_PropertiesID
  }
  deriving (Eq, Show)

data GPUTextureCreateInfo = GPUTextureCreateInfo
  { gpuTextureType :: SDL_GPUTextureType
  , gpuTextureFormat :: SDL_GPUTextureFormat
  , gpuTextureUsage :: SDL_GPUTextureUsageFlags
  , gpuTextureWidth :: Word32
  , gpuTextureHeight :: Word32
  , gpuTextureLayerCountOrDepth :: Word32
  , gpuTextureNumLevels :: Word32
  , gpuTextureSampleCount :: SDL_GPUSampleCount
  , gpuTextureProps :: SDL_PropertiesID
  }
  deriving (Eq, Show)

data GPUBufferCreateInfo = GPUBufferCreateInfo
  { gpuBufferUsage :: SDL_GPUBufferUsageFlags
  , gpuBufferSize :: Word32
  , gpuBufferProps :: SDL_PropertiesID
  }
  deriving (Eq, Show)

data GPUTransferBufferCreateInfo = GPUTransferBufferCreateInfo
  { gpuTransferUsage :: SDL_GPUTransferBufferUsage
  , gpuTransferSize :: Word32
  , gpuTransferProps :: SDL_PropertiesID
  }
  deriving (Eq, Show)

data GPUTextureTransferInfo = GPUTextureTransferInfo
  { gpuTransferBuffer :: GPUTransferBuffer
  , gpuTransferOffset :: Word32
  , gpuTransferPixelsPerRow :: Word32
  , gpuTransferRowsPerLayer :: Word32
  }
  deriving (Eq, Show)

data GPUTransferBufferLocation = GPUTransferBufferLocation
  { gpuTransferLocationBuffer :: GPUTransferBuffer
  , gpuTransferLocationOffset :: Word32
  }
  deriving (Eq, Show)

data GPUTextureRegion = GPUTextureRegion
  { gpuTextureRegionTexture :: GPUTexture
  , gpuTextureRegionMipLevel :: Word32
  , gpuTextureRegionLayer :: Word32
  , gpuTextureRegionX :: Word32
  , gpuTextureRegionY :: Word32
  , gpuTextureRegionZ :: Word32
  , gpuTextureRegionW :: Word32
  , gpuTextureRegionH :: Word32
  , gpuTextureRegionD :: Word32
  }
  deriving (Eq, Show)

data GPUBufferRegion = GPUBufferRegion
  { gpuBufferRegionBuffer :: GPUBuffer
  , gpuBufferRegionOffset :: Word32
  , gpuBufferRegionSize :: Word32
  }
  deriving (Eq, Show)

data GPUColorTargetInfo = GPUColorTargetInfo
  { gpuColorTargetTexture :: Ptr SDL_GPUTexture
  , gpuColorTargetMipLevel :: Word32
  , gpuColorTargetLayer :: Word32
  , gpuColorTargetClearColor :: FColor
  , gpuColorTargetLoadOp :: SDL_GPULoadOp
  , gpuColorTargetStoreOp :: SDL_GPUStoreOp
  , gpuColorTargetResolveTexture :: Ptr SDL_GPUTexture
  , gpuColorTargetResolveMipLevel :: Word32
  , gpuColorTargetResolveLayer :: Word32
  , gpuColorTargetCycle :: CBool
  , gpuColorTargetCycleResolve :: CBool
  , gpuColorTargetPadding1 :: Word8
  , gpuColorTargetPadding2 :: Word8
  }
  deriving (Eq, Show)

data GPUDepthStencilTargetInfo = GPUDepthStencilTargetInfo
  { gpuDepthStencilTexture :: Ptr SDL_GPUTexture
  , gpuDepthStencilClearDepth :: CFloat
  , gpuDepthStencilLoadOp :: SDL_GPULoadOp
  , gpuDepthStencilStoreOp :: SDL_GPUStoreOp
  , gpuDepthStencilStencilLoadOp :: SDL_GPULoadOp
  , gpuDepthStencilStencilStoreOp :: SDL_GPUStoreOp
  , gpuDepthStencilCycle :: CBool
  , gpuDepthStencilClearStencil :: Word8
  , gpuDepthStencilMipLevel :: Word8
  , gpuDepthStencilLayer :: Word8
  }
  deriving (Eq, Show)

data SurfaceInfo = SurfaceInfo
  { surfaceInfoFlags :: Word32
  , surfaceInfoFormat :: SDL_PixelFormat
  , surfaceInfoWidth :: CInt
  , surfaceInfoHeight :: CInt
  , surfaceInfoPitch :: CInt
  , surfaceInfoPixels :: Ptr ()
  , surfaceInfoRefcount :: CInt
  , surfaceInfoReserved :: Ptr ()
  }
  deriving (Eq, Show)

data TTF_GPUAtlasDrawSequence = TTF_GPUAtlasDrawSequence
  { ttfAtlasTexture :: GPUTexture
  , ttfAtlasXY :: Ptr FPoint
  , ttfAtlasUV :: Ptr FPoint
  , ttfAtlasNumVertices :: CInt
  , ttfAtlasIndices :: Ptr CInt
  , ttfAtlasNumIndices :: CInt
  , ttfAtlasImageType :: CInt
  , ttfAtlasNext :: Ptr TTF_GPUAtlasDrawSequence
  }
  deriving (Eq, Show)


data CField = CField
  { cFieldSize :: Int
  , cFieldAlign :: Int
  }

cField :: forall a. Storable a => Proxy a -> CField
cField _ = CField (sizeOf (undefined :: a)) (alignment (undefined :: a))

alignTo :: Int -> Int -> Int
alignTo n a = ((n + a - 1) `div` a) * a

structLayout :: [CField] -> (Int, Int, [Int])
structLayout fields = go 0 1 [] fields
  where
    go offset maxAlign acc [] =
      let size = alignTo offset maxAlign
      in (size, maxAlign, reverse acc)
    go offset maxAlign acc (CField sz al : rest) =
      let off = alignTo offset al
      in go (off + sz) (max maxAlign al) (off : acc) rest

gpuSamplerCreateInfoSize :: Int
gpuSamplerCreateInfoAlign :: Int
gpuSamplerCreateInfoOffsets :: [Int]
(gpuSamplerCreateInfoSize, gpuSamplerCreateInfoAlign, gpuSamplerCreateInfoOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CFloat)
    , cField (Proxy @CFloat)
    , cField (Proxy @CInt)
    , cField (Proxy @CFloat)
    , cField (Proxy @CFloat)
    , cField (Proxy @CBool)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    , cField (Proxy @Word32)
    ]

( gpuSamplerMinFilterOffset
  , gpuSamplerMagFilterOffset
  , gpuSamplerMipmapModeOffset
  , gpuSamplerAddressModeUOffset
  , gpuSamplerAddressModeVOffset
  , gpuSamplerAddressModeWOffset
  , gpuSamplerMipLodBiasOffset
  , gpuSamplerMaxAnisotropyOffset
  , gpuSamplerCompareOpOffset
  , gpuSamplerMinLodOffset
  , gpuSamplerMaxLodOffset
  , gpuSamplerEnableAnisotropyOffset
  , gpuSamplerEnableCompareOffset
  , gpuSamplerPadding1Offset
  , gpuSamplerPadding2Offset
  , gpuSamplerPropsOffset
  ) =
  case gpuSamplerCreateInfoOffsets of
    [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p] -> (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
    _ -> error "GPUSamplerCreateInfo layout mismatch"

instance Storable GPUSamplerCreateInfo where
  sizeOf _ = gpuSamplerCreateInfoSize
  alignment _ = gpuSamplerCreateInfoAlign
  peek ptr = do
    minFilter <- peekByteOff ptr gpuSamplerMinFilterOffset
    magFilter <- peekByteOff ptr gpuSamplerMagFilterOffset
    mipmapMode <- peekByteOff ptr gpuSamplerMipmapModeOffset
    addrU <- peekByteOff ptr gpuSamplerAddressModeUOffset
    addrV <- peekByteOff ptr gpuSamplerAddressModeVOffset
    addrW <- peekByteOff ptr gpuSamplerAddressModeWOffset
    mipBias <- peekByteOff ptr gpuSamplerMipLodBiasOffset
    maxAniso <- peekByteOff ptr gpuSamplerMaxAnisotropyOffset
    compareOp <- peekByteOff ptr gpuSamplerCompareOpOffset
    minLod <- peekByteOff ptr gpuSamplerMinLodOffset
    maxLod <- peekByteOff ptr gpuSamplerMaxLodOffset
    enableAniso <- peekByteOff ptr gpuSamplerEnableAnisotropyOffset
    enableCompare <- peekByteOff ptr gpuSamplerEnableCompareOffset
    pad1 <- peekByteOff ptr gpuSamplerPadding1Offset
    pad2 <- peekByteOff ptr gpuSamplerPadding2Offset
    props <- peekByteOff ptr gpuSamplerPropsOffset
    pure GPUSamplerCreateInfo
      { gpuSamplerMinFilter = minFilter
      , gpuSamplerMagFilter = magFilter
      , gpuSamplerMipmapMode = mipmapMode
      , gpuSamplerAddressModeU = addrU
      , gpuSamplerAddressModeV = addrV
      , gpuSamplerAddressModeW = addrW
      , gpuSamplerMipLodBias = mipBias
      , gpuSamplerMaxAnisotropy = maxAniso
      , gpuSamplerCompareOp = compareOp
      , gpuSamplerMinLod = minLod
      , gpuSamplerMaxLod = maxLod
      , gpuSamplerEnableAnisotropy = enableAniso
      , gpuSamplerEnableCompare = enableCompare
      , gpuSamplerPadding1 = pad1
      , gpuSamplerPadding2 = pad2
      , gpuSamplerProps = props
      }
  poke ptr info = do
    pokeByteOff ptr gpuSamplerMinFilterOffset info.gpuSamplerMinFilter
    pokeByteOff ptr gpuSamplerMagFilterOffset info.gpuSamplerMagFilter
    pokeByteOff ptr gpuSamplerMipmapModeOffset info.gpuSamplerMipmapMode
    pokeByteOff ptr gpuSamplerAddressModeUOffset info.gpuSamplerAddressModeU
    pokeByteOff ptr gpuSamplerAddressModeVOffset info.gpuSamplerAddressModeV
    pokeByteOff ptr gpuSamplerAddressModeWOffset info.gpuSamplerAddressModeW
    pokeByteOff ptr gpuSamplerMipLodBiasOffset info.gpuSamplerMipLodBias
    pokeByteOff ptr gpuSamplerMaxAnisotropyOffset info.gpuSamplerMaxAnisotropy
    pokeByteOff ptr gpuSamplerCompareOpOffset info.gpuSamplerCompareOp
    pokeByteOff ptr gpuSamplerMinLodOffset info.gpuSamplerMinLod
    pokeByteOff ptr gpuSamplerMaxLodOffset info.gpuSamplerMaxLod
    pokeByteOff ptr gpuSamplerEnableAnisotropyOffset info.gpuSamplerEnableAnisotropy
    pokeByteOff ptr gpuSamplerEnableCompareOffset info.gpuSamplerEnableCompare
    pokeByteOff ptr gpuSamplerPadding1Offset info.gpuSamplerPadding1
    pokeByteOff ptr gpuSamplerPadding2Offset info.gpuSamplerPadding2
    pokeByteOff ptr gpuSamplerPropsOffset info.gpuSamplerProps

gpuShaderCreateInfoSize :: Int
gpuShaderCreateInfoAlign :: Int
gpuShaderCreateInfoOffsets :: [Int]
(gpuShaderCreateInfoSize, gpuShaderCreateInfoAlign, gpuShaderCreateInfoOffsets) =
  structLayout
    [ cField (Proxy @CSize)
    , cField (Proxy @(Ptr Word8))
    , cField (Proxy @CString)
    , cField (Proxy @Word32)
    , cField (Proxy @CInt)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    ]

( gpuShaderCodeSizeOffset
  , gpuShaderCodeOffset
  , gpuShaderEntryOffset
  , gpuShaderFormatOffset
  , gpuShaderStageOffset
  , gpuShaderNumSamplersOffset
  , gpuShaderNumStorageTexturesOffset
  , gpuShaderNumStorageBuffersOffset
  , gpuShaderNumUniformBuffersOffset
  , gpuShaderPropsOffset
  ) =
  case gpuShaderCreateInfoOffsets of
    [a, b, c, d, e, f, g, h, i, j] -> (a, b, c, d, e, f, g, h, i, j)
    _ -> error "GPUShaderCreateInfo layout mismatch"

instance Storable GPUShaderCreateInfo where
  sizeOf _ = gpuShaderCreateInfoSize
  alignment _ = gpuShaderCreateInfoAlign
  peek ptr = do
    codeSize <- peekByteOff ptr gpuShaderCodeSizeOffset
    code <- peekByteOff ptr gpuShaderCodeOffset
    entry <- peekByteOff ptr gpuShaderEntryOffset
    format <- peekByteOff ptr gpuShaderFormatOffset
    stage <- peekByteOff ptr gpuShaderStageOffset
    samplers <- peekByteOff ptr gpuShaderNumSamplersOffset
    storageTextures <- peekByteOff ptr gpuShaderNumStorageTexturesOffset
    storageBuffers <- peekByteOff ptr gpuShaderNumStorageBuffersOffset
    uniformBuffers <- peekByteOff ptr gpuShaderNumUniformBuffersOffset
    props <- peekByteOff ptr gpuShaderPropsOffset
    pure GPUShaderCreateInfo
      { gpuShaderCodeSize = codeSize
      , gpuShaderCode = code
      , gpuShaderEntryPoint = entry
      , gpuShaderFormat = format
      , gpuShaderStage = stage
      , gpuShaderNumSamplers = samplers
      , gpuShaderNumStorageTextures = storageTextures
      , gpuShaderNumStorageBuffers = storageBuffers
      , gpuShaderNumUniformBuffers = uniformBuffers
      , gpuShaderProps = props
      }
  poke ptr info = do
    pokeByteOff ptr gpuShaderCodeSizeOffset info.gpuShaderCodeSize
    pokeByteOff ptr gpuShaderCodeOffset info.gpuShaderCode
    pokeByteOff ptr gpuShaderEntryOffset info.gpuShaderEntryPoint
    pokeByteOff ptr gpuShaderFormatOffset info.gpuShaderFormat
    pokeByteOff ptr gpuShaderStageOffset info.gpuShaderStage
    pokeByteOff ptr gpuShaderNumSamplersOffset info.gpuShaderNumSamplers
    pokeByteOff ptr gpuShaderNumStorageTexturesOffset info.gpuShaderNumStorageTextures
    pokeByteOff ptr gpuShaderNumStorageBuffersOffset info.gpuShaderNumStorageBuffers
    pokeByteOff ptr gpuShaderNumUniformBuffersOffset info.gpuShaderNumUniformBuffers
    pokeByteOff ptr gpuShaderPropsOffset info.gpuShaderProps

gpuComputePipelineCreateInfoSize :: Int
gpuComputePipelineCreateInfoAlign :: Int
gpuComputePipelineCreateInfoOffsets :: [Int]
(gpuComputePipelineCreateInfoSize, gpuComputePipelineCreateInfoAlign, gpuComputePipelineCreateInfoOffsets) =
  structLayout
    [ cField (Proxy @CSize)
    , cField (Proxy @(Ptr Word8))
    , cField (Proxy @CString)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    ]

( gpuComputeCodeSizeOffset
  , gpuComputeCodeOffset
  , gpuComputeEntryOffset
  , gpuComputeFormatOffset
  , gpuComputeNumSamplersOffset
  , gpuComputeNumReadonlyTexturesOffset
  , gpuComputeNumReadonlyBuffersOffset
  , gpuComputeNumReadwriteTexturesOffset
  , gpuComputeNumReadwriteBuffersOffset
  , gpuComputeNumUniformBuffersOffset
  , gpuComputeThreadCountXOffset
  , gpuComputeThreadCountYOffset
  , gpuComputeThreadCountZOffset
  , gpuComputePropsOffset
  ) =
  case gpuComputePipelineCreateInfoOffsets of
    [a, b, c, d, e, f, g, h, i, j, k, l, m, n] ->
      (a, b, c, d, e, f, g, h, i, j, k, l, m, n)
    _ -> error "GPUComputePipelineCreateInfo layout mismatch"

instance Storable GPUComputePipelineCreateInfo where
  sizeOf _ = gpuComputePipelineCreateInfoSize
  alignment _ = gpuComputePipelineCreateInfoAlign
  peek ptr = do
    codeSize <- peekByteOff ptr gpuComputeCodeSizeOffset
    code <- peekByteOff ptr gpuComputeCodeOffset
    entry <- peekByteOff ptr gpuComputeEntryOffset
    format <- peekByteOff ptr gpuComputeFormatOffset
    samplers <- peekByteOff ptr gpuComputeNumSamplersOffset
    readonlyTextures <- peekByteOff ptr gpuComputeNumReadonlyTexturesOffset
    readonlyBuffers <- peekByteOff ptr gpuComputeNumReadonlyBuffersOffset
    readwriteTextures <- peekByteOff ptr gpuComputeNumReadwriteTexturesOffset
    readwriteBuffers <- peekByteOff ptr gpuComputeNumReadwriteBuffersOffset
    uniformBuffers <- peekByteOff ptr gpuComputeNumUniformBuffersOffset
    threadsX <- peekByteOff ptr gpuComputeThreadCountXOffset
    threadsY <- peekByteOff ptr gpuComputeThreadCountYOffset
    threadsZ <- peekByteOff ptr gpuComputeThreadCountZOffset
    props <- peekByteOff ptr gpuComputePropsOffset
    pure GPUComputePipelineCreateInfo
      { gpuComputeCodeSize = codeSize
      , gpuComputeCode = code
      , gpuComputeEntryPoint = entry
      , gpuComputeFormat = format
      , gpuComputeNumSamplers = samplers
      , gpuComputeNumReadonlyStorageTextures = readonlyTextures
      , gpuComputeNumReadonlyStorageBuffers = readonlyBuffers
      , gpuComputeNumReadwriteStorageTextures = readwriteTextures
      , gpuComputeNumReadwriteStorageBuffers = readwriteBuffers
      , gpuComputeNumUniformBuffers = uniformBuffers
      , gpuComputeThreadCountX = threadsX
      , gpuComputeThreadCountY = threadsY
      , gpuComputeThreadCountZ = threadsZ
      , gpuComputeProps = props
      }
  poke ptr info = do
    pokeByteOff ptr gpuComputeCodeSizeOffset info.gpuComputeCodeSize
    pokeByteOff ptr gpuComputeCodeOffset info.gpuComputeCode
    pokeByteOff ptr gpuComputeEntryOffset info.gpuComputeEntryPoint
    pokeByteOff ptr gpuComputeFormatOffset info.gpuComputeFormat
    pokeByteOff ptr gpuComputeNumSamplersOffset info.gpuComputeNumSamplers
    pokeByteOff ptr gpuComputeNumReadonlyTexturesOffset info.gpuComputeNumReadonlyStorageTextures
    pokeByteOff ptr gpuComputeNumReadonlyBuffersOffset info.gpuComputeNumReadonlyStorageBuffers
    pokeByteOff ptr gpuComputeNumReadwriteTexturesOffset info.gpuComputeNumReadwriteStorageTextures
    pokeByteOff ptr gpuComputeNumReadwriteBuffersOffset info.gpuComputeNumReadwriteStorageBuffers
    pokeByteOff ptr gpuComputeNumUniformBuffersOffset info.gpuComputeNumUniformBuffers
    pokeByteOff ptr gpuComputeThreadCountXOffset info.gpuComputeThreadCountX
    pokeByteOff ptr gpuComputeThreadCountYOffset info.gpuComputeThreadCountY
    pokeByteOff ptr gpuComputeThreadCountZOffset info.gpuComputeThreadCountZ
    pokeByteOff ptr gpuComputePropsOffset info.gpuComputeProps

gpuRenderStateSize :: Int
gpuRenderStateAlign :: Int
gpuRenderStateOffsets :: [Int]
(gpuRenderStateSize, gpuRenderStateAlign, gpuRenderStateOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @CInt)
    , cField (Proxy @(Ptr ()))
    , cField (Proxy @CInt)
    , cField (Proxy @(Ptr ()))
    , cField (Proxy @CInt)
    , cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    ]

( gpuRenderFragmentShaderOffset
  , gpuRenderNumSamplerBindingsOffset
  , gpuRenderSamplerBindingsOffset
  , gpuRenderNumStorageTexturesOffset
  , gpuRenderStorageTexturesOffset
  , gpuRenderNumStorageBuffersOffset
  , gpuRenderStorageBuffersOffset
  , gpuRenderPropsOffset
  ) =
  case gpuRenderStateOffsets of
    [a, b, c, d, e, f, g, h] -> (a, b, c, d, e, f, g, h)
    _ -> error "GPURenderStateCreateInfo layout mismatch"

instance Storable GPURenderStateCreateInfo where
  sizeOf _ = gpuRenderStateSize
  alignment _ = gpuRenderStateAlign
  peek ptr = do
    frag <- peekByteOff ptr gpuRenderFragmentShaderOffset
    samplerCount <- peekByteOff ptr gpuRenderNumSamplerBindingsOffset
    samplerBindings <- peekByteOff ptr gpuRenderSamplerBindingsOffset
    storageTexCount <- peekByteOff ptr gpuRenderNumStorageTexturesOffset
    storageTex <- peekByteOff ptr gpuRenderStorageTexturesOffset
    storageBufCount <- peekByteOff ptr gpuRenderNumStorageBuffersOffset
    storageBuf <- peekByteOff ptr gpuRenderStorageBuffersOffset
    props <- peekByteOff ptr gpuRenderPropsOffset
    pure GPURenderStateCreateInfo
      { gpuRenderFragmentShader = frag
      , gpuRenderNumSamplerBindings = samplerCount
      , gpuRenderSamplerBindings = samplerBindings
      , gpuRenderNumStorageTextures = storageTexCount
      , gpuRenderStorageTextures = storageTex
      , gpuRenderNumStorageBuffers = storageBufCount
      , gpuRenderStorageBuffers = storageBuf
      , gpuRenderProps = props
      }
  poke ptr info = do
    pokeByteOff ptr gpuRenderFragmentShaderOffset info.gpuRenderFragmentShader
    pokeByteOff ptr gpuRenderNumSamplerBindingsOffset info.gpuRenderNumSamplerBindings
    pokeByteOff ptr gpuRenderSamplerBindingsOffset info.gpuRenderSamplerBindings
    pokeByteOff ptr gpuRenderNumStorageTexturesOffset info.gpuRenderNumStorageTextures
    pokeByteOff ptr gpuRenderStorageTexturesOffset info.gpuRenderStorageTextures
    pokeByteOff ptr gpuRenderNumStorageBuffersOffset info.gpuRenderNumStorageBuffers
    pokeByteOff ptr gpuRenderStorageBuffersOffset info.gpuRenderStorageBuffers
    pokeByteOff ptr gpuRenderPropsOffset info.gpuRenderProps

instance Storable GPUViewport where
  sizeOf _ = 6 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
    x <- peekByteOff ptr 0
    y <- peekByteOff ptr step
    w <- peekByteOff ptr (2 * step)
    h <- peekByteOff ptr (3 * step)
    minD <- peekByteOff ptr (4 * step)
    maxD <- peekByteOff ptr (5 * step)
    pure (GPUViewport x y w h minD maxD)
  poke ptr (GPUViewport x y w h minD maxD) = do
    let step = sizeOf (undefined :: CFloat)
    pokeByteOff ptr 0 x
    pokeByteOff ptr step y
    pokeByteOff ptr (2 * step) w
    pokeByteOff ptr (3 * step) h
    pokeByteOff ptr (4 * step) minD
    pokeByteOff ptr (5 * step) maxD

gpuBufferBindingSize :: Int
gpuBufferBindingAlign :: Int
gpuBufferBindingOffsets :: [Int]
(gpuBufferBindingSize, gpuBufferBindingAlign, gpuBufferBindingOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    ]

( gpuBufferBindingBufferOffset
  , gpuBufferBindingOffsetOffset
  ) =
  case gpuBufferBindingOffsets of
    [a, b] -> (a, b)
    _ -> error "GPUBufferBinding layout mismatch"

instance Storable GPUBufferBinding where
  sizeOf _ = gpuBufferBindingSize
  alignment _ = gpuBufferBindingAlign
  peek ptr = do
    bufPtr <- peekByteOff ptr gpuBufferBindingBufferOffset
    offset <- peekByteOff ptr gpuBufferBindingOffsetOffset
    pure GPUBufferBinding
      { gpuBufferBindingBuffer = GPUBuffer bufPtr
      , gpuBufferBindingOffset = offset
      }
  poke ptr binding = do
    let GPUBuffer bufPtr = binding.gpuBufferBindingBuffer
    pokeByteOff ptr gpuBufferBindingBufferOffset bufPtr
    pokeByteOff ptr gpuBufferBindingOffsetOffset binding.gpuBufferBindingOffset

gpuVertexBufferDescriptionSize :: Int
gpuVertexBufferDescriptionAlign :: Int
gpuVertexBufferDescriptionOffsets :: [Int]
(gpuVertexBufferDescriptionSize, gpuVertexBufferDescriptionAlign, gpuVertexBufferDescriptionOffsets) =
  structLayout
    [ cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @CInt)
    , cField (Proxy @Word32)
    ]

( gpuVertexBufferSlotOffset
  , gpuVertexBufferPitchOffset
  , gpuVertexBufferInputRateOffset
  , gpuVertexBufferInstanceStepRateOffset
  ) =
  case gpuVertexBufferDescriptionOffsets of
    [a, b, c, d] -> (a, b, c, d)
    _ -> error "GPUVertexBufferDescription layout mismatch"

instance Storable GPUVertexBufferDescription where
  sizeOf _ = gpuVertexBufferDescriptionSize
  alignment _ = gpuVertexBufferDescriptionAlign
  peek ptr = do
    slot <- peekByteOff ptr gpuVertexBufferSlotOffset
    pitch <- peekByteOff ptr gpuVertexBufferPitchOffset
    rate <- peekByteOff ptr gpuVertexBufferInputRateOffset
    stepRate <- peekByteOff ptr gpuVertexBufferInstanceStepRateOffset
    pure GPUVertexBufferDescription
      { gpuVertexBufferSlot = slot
      , gpuVertexBufferPitch = pitch
      , gpuVertexBufferInputRate = rate
      , gpuVertexBufferInstanceStepRate = stepRate
      }
  poke ptr desc = do
    pokeByteOff ptr gpuVertexBufferSlotOffset desc.gpuVertexBufferSlot
    pokeByteOff ptr gpuVertexBufferPitchOffset desc.gpuVertexBufferPitch
    pokeByteOff ptr gpuVertexBufferInputRateOffset desc.gpuVertexBufferInputRate
    pokeByteOff ptr gpuVertexBufferInstanceStepRateOffset desc.gpuVertexBufferInstanceStepRate

gpuVertexAttributeSize :: Int
gpuVertexAttributeAlign :: Int
gpuVertexAttributeOffsets :: [Int]
(gpuVertexAttributeSize, gpuVertexAttributeAlign, gpuVertexAttributeOffsets) =
  structLayout
    [ cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @CInt)
    , cField (Proxy @Word32)
    ]

( gpuVertexAttributeLocationOffset
  , gpuVertexAttributeBufferSlotOffset
  , gpuVertexAttributeFormatOffset
  , gpuVertexAttributeOffsetOffset
  ) =
  case gpuVertexAttributeOffsets of
    [a, b, c, d] -> (a, b, c, d)
    _ -> error "GPUVertexAttribute layout mismatch"

instance Storable GPUVertexAttribute where
  sizeOf _ = gpuVertexAttributeSize
  alignment _ = gpuVertexAttributeAlign
  peek ptr = do
    location <- peekByteOff ptr gpuVertexAttributeLocationOffset
    slot <- peekByteOff ptr gpuVertexAttributeBufferSlotOffset
    fmt <- peekByteOff ptr gpuVertexAttributeFormatOffset
    offset <- peekByteOff ptr gpuVertexAttributeOffsetOffset
    pure GPUVertexAttribute
      { gpuVertexAttributeLocation = location
      , gpuVertexAttributeBufferSlot = slot
      , gpuVertexAttributeFormat = fmt
      , gpuVertexAttributeOffset = offset
      }
  poke ptr attr = do
    pokeByteOff ptr gpuVertexAttributeLocationOffset attr.gpuVertexAttributeLocation
    pokeByteOff ptr gpuVertexAttributeBufferSlotOffset attr.gpuVertexAttributeBufferSlot
    pokeByteOff ptr gpuVertexAttributeFormatOffset attr.gpuVertexAttributeFormat
    pokeByteOff ptr gpuVertexAttributeOffsetOffset attr.gpuVertexAttributeOffset

gpuVertexInputStateSize :: Int
gpuVertexInputStateAlign :: Int
gpuVertexInputStateOffsets :: [Int]
(gpuVertexInputStateSize, gpuVertexInputStateAlign, gpuVertexInputStateOffsets) =
  structLayout
    [ cField (Proxy @(Ptr GPUVertexBufferDescription))
    , cField (Proxy @Word32)
    , cField (Proxy @(Ptr GPUVertexAttribute))
    , cField (Proxy @Word32)
    ]

( gpuVertexInputBuffersOffset
  , gpuVertexInputNumBuffersOffset
  , gpuVertexInputAttributesOffset
  , gpuVertexInputNumAttributesOffset
  ) =
  case gpuVertexInputStateOffsets of
    [a, b, c, d] -> (a, b, c, d)
    _ -> error "GPUVertexInputState layout mismatch"

instance Storable GPUVertexInputState where
  sizeOf _ = gpuVertexInputStateSize
  alignment _ = gpuVertexInputStateAlign
  peek ptr = do
    buffers <- peekByteOff ptr gpuVertexInputBuffersOffset
    numBuffers <- peekByteOff ptr gpuVertexInputNumBuffersOffset
    attrs <- peekByteOff ptr gpuVertexInputAttributesOffset
    numAttrs <- peekByteOff ptr gpuVertexInputNumAttributesOffset
    pure GPUVertexInputState
      { gpuVertexInputBufferDescriptions = buffers
      , gpuVertexInputNumBuffers = numBuffers
      , gpuVertexInputAttributes = attrs
      , gpuVertexInputNumAttributes = numAttrs
      }
  poke ptr state = do
    pokeByteOff ptr gpuVertexInputBuffersOffset state.gpuVertexInputBufferDescriptions
    pokeByteOff ptr gpuVertexInputNumBuffersOffset state.gpuVertexInputNumBuffers
    pokeByteOff ptr gpuVertexInputAttributesOffset state.gpuVertexInputAttributes
    pokeByteOff ptr gpuVertexInputNumAttributesOffset state.gpuVertexInputNumAttributes

gpuColorTargetBlendStateSize :: Int
gpuColorTargetBlendStateAlign :: Int
gpuColorTargetBlendStateOffsets :: [Int]
(gpuColorTargetBlendStateSize, gpuColorTargetBlendStateAlign, gpuColorTargetBlendStateOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @Word8)
    , cField (Proxy @CBool)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuBlendSrcColorOffset
  , gpuBlendDstColorOffset
  , gpuBlendColorOpOffset
  , gpuBlendSrcAlphaOffset
  , gpuBlendDstAlphaOffset
  , gpuBlendAlphaOpOffset
  , gpuBlendColorWriteMaskOffset
  , gpuBlendEnableOffset
  , gpuBlendEnableColorWriteMaskOffset
  , gpuBlendPadding1Offset
  , gpuBlendPadding2Offset
  ) =
  case gpuColorTargetBlendStateOffsets of
    [a, b, c, d, e, f, g, h, i, j, k] -> (a, b, c, d, e, f, g, h, i, j, k)
    _ -> error "GPUColorTargetBlendState layout mismatch"

instance Storable GPUColorTargetBlendState where
  sizeOf _ = gpuColorTargetBlendStateSize
  alignment _ = gpuColorTargetBlendStateAlign
  peek ptr = do
    srcColor <- peekByteOff ptr gpuBlendSrcColorOffset
    dstColor <- peekByteOff ptr gpuBlendDstColorOffset
    colorOp <- peekByteOff ptr gpuBlendColorOpOffset
    srcAlpha <- peekByteOff ptr gpuBlendSrcAlphaOffset
    dstAlpha <- peekByteOff ptr gpuBlendDstAlphaOffset
    alphaOp <- peekByteOff ptr gpuBlendAlphaOpOffset
    writeMask <- peekByteOff ptr gpuBlendColorWriteMaskOffset
    enable <- peekByteOff ptr gpuBlendEnableOffset
    enableMask <- peekByteOff ptr gpuBlendEnableColorWriteMaskOffset
    pad1 <- peekByteOff ptr gpuBlendPadding1Offset
    pad2 <- peekByteOff ptr gpuBlendPadding2Offset
    pure GPUColorTargetBlendState
      { gpuBlendSrcColor = srcColor
      , gpuBlendDstColor = dstColor
      , gpuBlendColorOp = colorOp
      , gpuBlendSrcAlpha = srcAlpha
      , gpuBlendDstAlpha = dstAlpha
      , gpuBlendAlphaOp = alphaOp
      , gpuBlendColorWriteMask = writeMask
      , gpuBlendEnable = enable
      , gpuBlendEnableColorWriteMask = enableMask
      , gpuBlendPadding1 = pad1
      , gpuBlendPadding2 = pad2
      }
  poke ptr st = do
    pokeByteOff ptr gpuBlendSrcColorOffset st.gpuBlendSrcColor
    pokeByteOff ptr gpuBlendDstColorOffset st.gpuBlendDstColor
    pokeByteOff ptr gpuBlendColorOpOffset st.gpuBlendColorOp
    pokeByteOff ptr gpuBlendSrcAlphaOffset st.gpuBlendSrcAlpha
    pokeByteOff ptr gpuBlendDstAlphaOffset st.gpuBlendDstAlpha
    pokeByteOff ptr gpuBlendAlphaOpOffset st.gpuBlendAlphaOp
    pokeByteOff ptr gpuBlendColorWriteMaskOffset st.gpuBlendColorWriteMask
    pokeByteOff ptr gpuBlendEnableOffset st.gpuBlendEnable
    pokeByteOff ptr gpuBlendEnableColorWriteMaskOffset st.gpuBlendEnableColorWriteMask
    pokeByteOff ptr gpuBlendPadding1Offset st.gpuBlendPadding1
    pokeByteOff ptr gpuBlendPadding2Offset st.gpuBlendPadding2

gpuColorTargetDescriptionSize :: Int
gpuColorTargetDescriptionAlign :: Int
gpuColorTargetDescriptionOffsets :: [Int]
(gpuColorTargetDescriptionSize, gpuColorTargetDescriptionAlign, gpuColorTargetDescriptionOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @GPUColorTargetBlendState)
    ]

( gpuColorTargetFormatOffset
  , gpuColorTargetBlendOffset
  ) =
  case gpuColorTargetDescriptionOffsets of
    [a, b] -> (a, b)
    _ -> error "GPUColorTargetDescription layout mismatch"

instance Storable GPUColorTargetDescription where
  sizeOf _ = gpuColorTargetDescriptionSize
  alignment _ = gpuColorTargetDescriptionAlign
  peek ptr = do
    fmt <- peekByteOff ptr gpuColorTargetFormatOffset
    blend <- peekByteOff ptr gpuColorTargetBlendOffset
    pure GPUColorTargetDescription
      { gpuColorTargetFormat = fmt
      , gpuColorTargetBlend = blend
      }
  poke ptr desc = do
    pokeByteOff ptr gpuColorTargetFormatOffset desc.gpuColorTargetFormat
    pokeByteOff ptr gpuColorTargetBlendOffset desc.gpuColorTargetBlend

gpuGraphicsPipelineTargetInfoSize :: Int
gpuGraphicsPipelineTargetInfoAlign :: Int
gpuGraphicsPipelineTargetInfoOffsets :: [Int]
(gpuGraphicsPipelineTargetInfoSize, gpuGraphicsPipelineTargetInfoAlign, gpuGraphicsPipelineTargetInfoOffsets) =
  structLayout
    [ cField (Proxy @(Ptr GPUColorTargetDescription))
    , cField (Proxy @Word32)
    , cField (Proxy @CInt)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuPipelineColorTargetDescriptionsOffset
  , gpuPipelineNumColorTargetsOffset
  , gpuPipelineDepthStencilFormatOffset
  , gpuPipelineHasDepthStencilOffset
  , gpuPipelinePadding1Offset
  , gpuPipelinePadding2Offset
  , gpuPipelinePadding3Offset
  ) =
  case gpuGraphicsPipelineTargetInfoOffsets of
    [a, b, c, d, e, f, g] -> (a, b, c, d, e, f, g)
    _ -> error "GPUGraphicsPipelineTargetInfo layout mismatch"

instance Storable GPUGraphicsPipelineTargetInfo where
  sizeOf _ = gpuGraphicsPipelineTargetInfoSize
  alignment _ = gpuGraphicsPipelineTargetInfoAlign
  peek ptr = do
    descs <- peekByteOff ptr gpuPipelineColorTargetDescriptionsOffset
    num <- peekByteOff ptr gpuPipelineNumColorTargetsOffset
    depthFmt <- peekByteOff ptr gpuPipelineDepthStencilFormatOffset
    hasDepth <- peekByteOff ptr gpuPipelineHasDepthStencilOffset
    pad1 <- peekByteOff ptr gpuPipelinePadding1Offset
    pad2 <- peekByteOff ptr gpuPipelinePadding2Offset
    pad3 <- peekByteOff ptr gpuPipelinePadding3Offset
    pure GPUGraphicsPipelineTargetInfo
      { gpuPipelineColorTargetDescriptions = descs
      , gpuPipelineNumColorTargets = num
      , gpuPipelineDepthStencilFormat = depthFmt
      , gpuPipelineHasDepthStencil = hasDepth
      , gpuPipelinePadding1 = pad1
      , gpuPipelinePadding2 = pad2
      , gpuPipelinePadding3 = pad3
      }
  poke ptr info = do
    pokeByteOff ptr gpuPipelineColorTargetDescriptionsOffset info.gpuPipelineColorTargetDescriptions
    pokeByteOff ptr gpuPipelineNumColorTargetsOffset info.gpuPipelineNumColorTargets
    pokeByteOff ptr gpuPipelineDepthStencilFormatOffset info.gpuPipelineDepthStencilFormat
    pokeByteOff ptr gpuPipelineHasDepthStencilOffset info.gpuPipelineHasDepthStencil
    pokeByteOff ptr gpuPipelinePadding1Offset info.gpuPipelinePadding1
    pokeByteOff ptr gpuPipelinePadding2Offset info.gpuPipelinePadding2
    pokeByteOff ptr gpuPipelinePadding3Offset info.gpuPipelinePadding3

gpuRasterizerStateSize :: Int
gpuRasterizerStateAlign :: Int
gpuRasterizerStateOffsets :: [Int]
(gpuRasterizerStateSize, gpuRasterizerStateAlign, gpuRasterizerStateOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CFloat)
    , cField (Proxy @CFloat)
    , cField (Proxy @CFloat)
    , cField (Proxy @CBool)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuRasterizerFillModeOffset
  , gpuRasterizerCullModeOffset
  , gpuRasterizerFrontFaceOffset
  , gpuRasterizerDepthBiasConstantOffset
  , gpuRasterizerDepthBiasClampOffset
  , gpuRasterizerDepthBiasSlopeOffset
  , gpuRasterizerEnableDepthBiasOffset
  , gpuRasterizerEnableDepthClipOffset
  , gpuRasterizerPadding1Offset
  , gpuRasterizerPadding2Offset
  ) =
  case gpuRasterizerStateOffsets of
    [a, b, c, d, e, f, g, h, i, j] -> (a, b, c, d, e, f, g, h, i, j)
    _ -> error "GPURasterizerState layout mismatch"

instance Storable GPURasterizerState where
  sizeOf _ = gpuRasterizerStateSize
  alignment _ = gpuRasterizerStateAlign
  peek ptr = do
    fill <- peekByteOff ptr gpuRasterizerFillModeOffset
    cull <- peekByteOff ptr gpuRasterizerCullModeOffset
    front <- peekByteOff ptr gpuRasterizerFrontFaceOffset
    biasConst <- peekByteOff ptr gpuRasterizerDepthBiasConstantOffset
    biasClamp <- peekByteOff ptr gpuRasterizerDepthBiasClampOffset
    biasSlope <- peekByteOff ptr gpuRasterizerDepthBiasSlopeOffset
    enableBias <- peekByteOff ptr gpuRasterizerEnableDepthBiasOffset
    enableClip <- peekByteOff ptr gpuRasterizerEnableDepthClipOffset
    pad1 <- peekByteOff ptr gpuRasterizerPadding1Offset
    pad2 <- peekByteOff ptr gpuRasterizerPadding2Offset
    pure GPURasterizerState
      { gpuRasterizerFillMode = fill
      , gpuRasterizerCullMode = cull
      , gpuRasterizerFrontFace = front
      , gpuRasterizerDepthBiasConstantFactor = biasConst
      , gpuRasterizerDepthBiasClamp = biasClamp
      , gpuRasterizerDepthBiasSlopeFactor = biasSlope
      , gpuRasterizerEnableDepthBias = enableBias
      , gpuRasterizerEnableDepthClip = enableClip
      , gpuRasterizerPadding1 = pad1
      , gpuRasterizerPadding2 = pad2
      }
  poke ptr st = do
    pokeByteOff ptr gpuRasterizerFillModeOffset st.gpuRasterizerFillMode
    pokeByteOff ptr gpuRasterizerCullModeOffset st.gpuRasterizerCullMode
    pokeByteOff ptr gpuRasterizerFrontFaceOffset st.gpuRasterizerFrontFace
    pokeByteOff ptr gpuRasterizerDepthBiasConstantOffset st.gpuRasterizerDepthBiasConstantFactor
    pokeByteOff ptr gpuRasterizerDepthBiasClampOffset st.gpuRasterizerDepthBiasClamp
    pokeByteOff ptr gpuRasterizerDepthBiasSlopeOffset st.gpuRasterizerDepthBiasSlopeFactor
    pokeByteOff ptr gpuRasterizerEnableDepthBiasOffset st.gpuRasterizerEnableDepthBias
    pokeByteOff ptr gpuRasterizerEnableDepthClipOffset st.gpuRasterizerEnableDepthClip
    pokeByteOff ptr gpuRasterizerPadding1Offset st.gpuRasterizerPadding1
    pokeByteOff ptr gpuRasterizerPadding2Offset st.gpuRasterizerPadding2

gpuMultisampleStateSize :: Int
gpuMultisampleStateAlign :: Int
gpuMultisampleStateOffsets :: [Int]
(gpuMultisampleStateSize, gpuMultisampleStateAlign, gpuMultisampleStateOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @Word32)
    , cField (Proxy @CBool)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuMultisampleCountOffset
  , gpuMultisampleMaskOffset
  , gpuMultisampleEnableMaskOffset
  , gpuMultisampleEnableAlphaToCoverageOffset
  , gpuMultisamplePadding2Offset
  , gpuMultisamplePadding3Offset
  ) =
  case gpuMultisampleStateOffsets of
    [a, b, c, d, e, f] -> (a, b, c, d, e, f)
    _ -> error "GPUMultisampleState layout mismatch"

instance Storable GPUMultisampleState where
  sizeOf _ = gpuMultisampleStateSize
  alignment _ = gpuMultisampleStateAlign
  peek ptr = do
    count <- peekByteOff ptr gpuMultisampleCountOffset
    mask <- peekByteOff ptr gpuMultisampleMaskOffset
    enableMask <- peekByteOff ptr gpuMultisampleEnableMaskOffset
    enableAlpha <- peekByteOff ptr gpuMultisampleEnableAlphaToCoverageOffset
    pad2 <- peekByteOff ptr gpuMultisamplePadding2Offset
    pad3 <- peekByteOff ptr gpuMultisamplePadding3Offset
    pure GPUMultisampleState
      { gpuMultisampleCount = count
      , gpuMultisampleMask = mask
      , gpuMultisampleEnableMask = enableMask
      , gpuMultisampleEnableAlphaToCoverage = enableAlpha
      , gpuMultisamplePadding2 = pad2
      , gpuMultisamplePadding3 = pad3
      }
  poke ptr st = do
    pokeByteOff ptr gpuMultisampleCountOffset st.gpuMultisampleCount
    pokeByteOff ptr gpuMultisampleMaskOffset st.gpuMultisampleMask
    pokeByteOff ptr gpuMultisampleEnableMaskOffset st.gpuMultisampleEnableMask
    pokeByteOff ptr gpuMultisampleEnableAlphaToCoverageOffset st.gpuMultisampleEnableAlphaToCoverage
    pokeByteOff ptr gpuMultisamplePadding2Offset st.gpuMultisamplePadding2
    pokeByteOff ptr gpuMultisamplePadding3Offset st.gpuMultisamplePadding3

gpuStencilOpStateSize :: Int
gpuStencilOpStateAlign :: Int
gpuStencilOpStateOffsets :: [Int]
(gpuStencilOpStateSize, gpuStencilOpStateAlign, gpuStencilOpStateOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    ]

( gpuStencilFailOpOffset
  , gpuStencilPassOpOffset
  , gpuStencilDepthFailOpOffset
  , gpuStencilCompareOpOffset
  ) =
  case gpuStencilOpStateOffsets of
    [a, b, c, d] -> (a, b, c, d)
    _ -> error "GPUStencilOpState layout mismatch"

instance Storable GPUStencilOpState where
  sizeOf _ = gpuStencilOpStateSize
  alignment _ = gpuStencilOpStateAlign
  peek ptr = do
    failOp <- peekByteOff ptr gpuStencilFailOpOffset
    passOp <- peekByteOff ptr gpuStencilPassOpOffset
    depthFailOp <- peekByteOff ptr gpuStencilDepthFailOpOffset
    compareOp <- peekByteOff ptr gpuStencilCompareOpOffset
    pure GPUStencilOpState
      { gpuStencilFailOp = failOp
      , gpuStencilPassOp = passOp
      , gpuStencilDepthFailOp = depthFailOp
      , gpuStencilCompareOp = compareOp
      }
  poke ptr st = do
    pokeByteOff ptr gpuStencilFailOpOffset st.gpuStencilFailOp
    pokeByteOff ptr gpuStencilPassOpOffset st.gpuStencilPassOp
    pokeByteOff ptr gpuStencilDepthFailOpOffset st.gpuStencilDepthFailOp
    pokeByteOff ptr gpuStencilCompareOpOffset st.gpuStencilCompareOp

gpuDepthStencilStateSize :: Int
gpuDepthStencilStateAlign :: Int
gpuDepthStencilStateOffsets :: [Int]
(gpuDepthStencilStateSize, gpuDepthStencilStateAlign, gpuDepthStencilStateOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @GPUStencilOpState)
    , cField (Proxy @GPUStencilOpState)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    , cField (Proxy @CBool)
    , cField (Proxy @CBool)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuDepthCompareOpOffset
  , gpuDepthBackStencilOffset
  , gpuDepthFrontStencilOffset
  , gpuDepthCompareMaskOffset
  , gpuDepthWriteMaskOffset
  , gpuDepthEnableTestOffset
  , gpuDepthEnableWriteOffset
  , gpuDepthEnableStencilOffset
  , gpuDepthPadding1Offset
  , gpuDepthPadding2Offset
  , gpuDepthPadding3Offset
  ) =
  case gpuDepthStencilStateOffsets of
    [a, b, c, d, e, f, g, h, i, j, k] -> (a, b, c, d, e, f, g, h, i, j, k)
    _ -> error "GPUDepthStencilState layout mismatch"

instance Storable GPUDepthStencilState where
  sizeOf _ = gpuDepthStencilStateSize
  alignment _ = gpuDepthStencilStateAlign
  peek ptr = do
    cmp <- peekByteOff ptr gpuDepthCompareOpOffset
    back <- peekByteOff ptr gpuDepthBackStencilOffset
    front <- peekByteOff ptr gpuDepthFrontStencilOffset
    cmpMask <- peekByteOff ptr gpuDepthCompareMaskOffset
    writeMask <- peekByteOff ptr gpuDepthWriteMaskOffset
    enableTest <- peekByteOff ptr gpuDepthEnableTestOffset
    enableWrite <- peekByteOff ptr gpuDepthEnableWriteOffset
    enableStencil <- peekByteOff ptr gpuDepthEnableStencilOffset
    pad1 <- peekByteOff ptr gpuDepthPadding1Offset
    pad2 <- peekByteOff ptr gpuDepthPadding2Offset
    pad3 <- peekByteOff ptr gpuDepthPadding3Offset
    pure GPUDepthStencilState
      { gpuDepthCompareOp = cmp
      , gpuDepthBackStencilState = back
      , gpuDepthFrontStencilState = front
      , gpuDepthCompareMask = cmpMask
      , gpuDepthWriteMask = writeMask
      , gpuDepthEnableDepthTest = enableTest
      , gpuDepthEnableDepthWrite = enableWrite
      , gpuDepthEnableStencilTest = enableStencil
      , gpuDepthPadding1 = pad1
      , gpuDepthPadding2 = pad2
      , gpuDepthPadding3 = pad3
      }
  poke ptr st = do
    pokeByteOff ptr gpuDepthCompareOpOffset st.gpuDepthCompareOp
    pokeByteOff ptr gpuDepthBackStencilOffset st.gpuDepthBackStencilState
    pokeByteOff ptr gpuDepthFrontStencilOffset st.gpuDepthFrontStencilState
    pokeByteOff ptr gpuDepthCompareMaskOffset st.gpuDepthCompareMask
    pokeByteOff ptr gpuDepthWriteMaskOffset st.gpuDepthWriteMask
    pokeByteOff ptr gpuDepthEnableTestOffset st.gpuDepthEnableDepthTest
    pokeByteOff ptr gpuDepthEnableWriteOffset st.gpuDepthEnableDepthWrite
    pokeByteOff ptr gpuDepthEnableStencilOffset st.gpuDepthEnableStencilTest
    pokeByteOff ptr gpuDepthPadding1Offset st.gpuDepthPadding1
    pokeByteOff ptr gpuDepthPadding2Offset st.gpuDepthPadding2
    pokeByteOff ptr gpuDepthPadding3Offset st.gpuDepthPadding3

gpuGraphicsPipelineCreateInfoSize :: Int
gpuGraphicsPipelineCreateInfoAlign :: Int
gpuGraphicsPipelineCreateInfoOffsets :: [Int]
(gpuGraphicsPipelineCreateInfoSize, gpuGraphicsPipelineCreateInfoAlign, gpuGraphicsPipelineCreateInfoOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @(Ptr ()))
    , cField (Proxy @GPUVertexInputState)
    , cField (Proxy @CInt)
    , cField (Proxy @GPURasterizerState)
    , cField (Proxy @GPUMultisampleState)
    , cField (Proxy @GPUDepthStencilState)
    , cField (Proxy @GPUGraphicsPipelineTargetInfo)
    , cField (Proxy @Word32)
    ]

( gpuPipelineVertexShaderOffset
  , gpuPipelineFragmentShaderOffset
  , gpuPipelineVertexInputStateOffset
  , gpuPipelinePrimitiveTypeOffset
  , gpuPipelineRasterizerStateOffset
  , gpuPipelineMultisampleStateOffset
  , gpuPipelineDepthStencilStateOffset
  , gpuPipelineTargetInfoOffset
  , gpuPipelinePropsOffset
  ) =
  case gpuGraphicsPipelineCreateInfoOffsets of
    [a, b, c, d, e, f, g, h, i] -> (a, b, c, d, e, f, g, h, i)
    _ -> error "GPUGraphicsPipelineCreateInfo layout mismatch"

instance Storable GPUGraphicsPipelineCreateInfo where
  sizeOf _ = gpuGraphicsPipelineCreateInfoSize
  alignment _ = gpuGraphicsPipelineCreateInfoAlign
  peek ptr = do
    vert <- peekByteOff ptr gpuPipelineVertexShaderOffset
    frag <- peekByteOff ptr gpuPipelineFragmentShaderOffset
    vertexInput <- peekByteOff ptr gpuPipelineVertexInputStateOffset
    prim <- peekByteOff ptr gpuPipelinePrimitiveTypeOffset
    raster <- peekByteOff ptr gpuPipelineRasterizerStateOffset
    multi <- peekByteOff ptr gpuPipelineMultisampleStateOffset
    depth <- peekByteOff ptr gpuPipelineDepthStencilStateOffset
    target <- peekByteOff ptr gpuPipelineTargetInfoOffset
    props <- peekByteOff ptr gpuPipelinePropsOffset
    pure GPUGraphicsPipelineCreateInfo
      { gpuPipelineVertexShader = vert
      , gpuPipelineFragmentShader = frag
      , gpuPipelineVertexInputState = vertexInput
      , gpuPipelinePrimitiveType = prim
      , gpuPipelineRasterizerState = raster
      , gpuPipelineMultisampleState = multi
      , gpuPipelineDepthStencilState = depth
      , gpuPipelineTargetInfo = target
      , gpuPipelineProps = props
      }
  poke ptr info = do
    pokeByteOff ptr gpuPipelineVertexShaderOffset info.gpuPipelineVertexShader
    pokeByteOff ptr gpuPipelineFragmentShaderOffset info.gpuPipelineFragmentShader
    pokeByteOff ptr gpuPipelineVertexInputStateOffset info.gpuPipelineVertexInputState
    pokeByteOff ptr gpuPipelinePrimitiveTypeOffset info.gpuPipelinePrimitiveType
    pokeByteOff ptr gpuPipelineRasterizerStateOffset info.gpuPipelineRasterizerState
    pokeByteOff ptr gpuPipelineMultisampleStateOffset info.gpuPipelineMultisampleState
    pokeByteOff ptr gpuPipelineDepthStencilStateOffset info.gpuPipelineDepthStencilState
    pokeByteOff ptr gpuPipelineTargetInfoOffset info.gpuPipelineTargetInfo
    pokeByteOff ptr gpuPipelinePropsOffset info.gpuPipelineProps

gpuTextureCreateInfoSize :: Int
gpuTextureCreateInfoAlign :: Int
gpuTextureCreateInfoOffsets :: [Int]
(gpuTextureCreateInfoSize, gpuTextureCreateInfoAlign, gpuTextureCreateInfoOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @CInt)
    , cField (Proxy @Word32)
    ]

( gpuTextureTypeOffset
  , gpuTextureFormatOffset
  , gpuTextureUsageOffset
  , gpuTextureWidthOffset
  , gpuTextureHeightOffset
  , gpuTextureLayerOffset
  , gpuTextureNumLevelsOffset
  , gpuTextureSampleCountOffset
  , gpuTexturePropsOffset
  ) =
  case gpuTextureCreateInfoOffsets of
    [a, b, c, d, e, f, g, h, i] -> (a, b, c, d, e, f, g, h, i)
    _ -> error "GPUTextureCreateInfo layout mismatch"

instance Storable GPUTextureCreateInfo where
  sizeOf _ = gpuTextureCreateInfoSize
  alignment _ = gpuTextureCreateInfoAlign
  peek ptr = do
    ty <- peekByteOff ptr gpuTextureTypeOffset
    fmt <- peekByteOff ptr gpuTextureFormatOffset
    usage <- peekByteOff ptr gpuTextureUsageOffset
    w <- peekByteOff ptr gpuTextureWidthOffset
    h <- peekByteOff ptr gpuTextureHeightOffset
    layer <- peekByteOff ptr gpuTextureLayerOffset
    levels <- peekByteOff ptr gpuTextureNumLevelsOffset
    sample <- peekByteOff ptr gpuTextureSampleCountOffset
    props <- peekByteOff ptr gpuTexturePropsOffset
    pure GPUTextureCreateInfo
      { gpuTextureType = ty
      , gpuTextureFormat = fmt
      , gpuTextureUsage = usage
      , gpuTextureWidth = w
      , gpuTextureHeight = h
      , gpuTextureLayerCountOrDepth = layer
      , gpuTextureNumLevels = levels
      , gpuTextureSampleCount = sample
      , gpuTextureProps = props
      }
  poke ptr info = do
    pokeByteOff ptr gpuTextureTypeOffset info.gpuTextureType
    pokeByteOff ptr gpuTextureFormatOffset info.gpuTextureFormat
    pokeByteOff ptr gpuTextureUsageOffset info.gpuTextureUsage
    pokeByteOff ptr gpuTextureWidthOffset info.gpuTextureWidth
    pokeByteOff ptr gpuTextureHeightOffset info.gpuTextureHeight
    pokeByteOff ptr gpuTextureLayerOffset info.gpuTextureLayerCountOrDepth
    pokeByteOff ptr gpuTextureNumLevelsOffset info.gpuTextureNumLevels
    pokeByteOff ptr gpuTextureSampleCountOffset info.gpuTextureSampleCount
    pokeByteOff ptr gpuTexturePropsOffset info.gpuTextureProps

gpuBufferCreateInfoSize :: Int
gpuBufferCreateInfoAlign :: Int
gpuBufferCreateInfoOffsets :: [Int]
(gpuBufferCreateInfoSize, gpuBufferCreateInfoAlign, gpuBufferCreateInfoOffsets) =
  structLayout
    [ cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    ]

( gpuBufferUsageOffset
  , gpuBufferSizeOffset
  , gpuBufferPropsOffset
  ) =
  case gpuBufferCreateInfoOffsets of
    [a, b, c] -> (a, b, c)
    _ -> error "GPUBufferCreateInfo layout mismatch"

instance Storable GPUBufferCreateInfo where
  sizeOf _ = gpuBufferCreateInfoSize
  alignment _ = gpuBufferCreateInfoAlign
  peek ptr = do
    usage <- peekByteOff ptr gpuBufferUsageOffset
    size <- peekByteOff ptr gpuBufferSizeOffset
    props <- peekByteOff ptr gpuBufferPropsOffset
    pure GPUBufferCreateInfo
      { gpuBufferUsage = usage
      , gpuBufferSize = size
      , gpuBufferProps = props
      }
  poke ptr info = do
    pokeByteOff ptr gpuBufferUsageOffset info.gpuBufferUsage
    pokeByteOff ptr gpuBufferSizeOffset info.gpuBufferSize
    pokeByteOff ptr gpuBufferPropsOffset info.gpuBufferProps

gpuTransferBufferCreateInfoSize :: Int
gpuTransferBufferCreateInfoAlign :: Int
gpuTransferBufferCreateInfoOffsets :: [Int]
(gpuTransferBufferCreateInfoSize, gpuTransferBufferCreateInfoAlign, gpuTransferBufferCreateInfoOffsets) =
  structLayout
    [ cField (Proxy @CInt)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    ]

( gpuTransferUsageOffset
  , gpuTransferSizeOffset
  , gpuTransferPropsOffset
  ) =
  case gpuTransferBufferCreateInfoOffsets of
    [a, b, c] -> (a, b, c)
    _ -> error "GPUTransferBufferCreateInfo layout mismatch"

instance Storable GPUTransferBufferCreateInfo where
  sizeOf _ = gpuTransferBufferCreateInfoSize
  alignment _ = gpuTransferBufferCreateInfoAlign
  peek ptr = do
    usage <- peekByteOff ptr gpuTransferUsageOffset
    size <- peekByteOff ptr gpuTransferSizeOffset
    props <- peekByteOff ptr gpuTransferPropsOffset
    pure GPUTransferBufferCreateInfo
      { gpuTransferUsage = usage
      , gpuTransferSize = size
      , gpuTransferProps = props
      }
  poke ptr info = do
    pokeByteOff ptr gpuTransferUsageOffset info.gpuTransferUsage
    pokeByteOff ptr gpuTransferSizeOffset info.gpuTransferSize
    pokeByteOff ptr gpuTransferPropsOffset info.gpuTransferProps

gpuTextureTransferInfoSize :: Int
gpuTextureTransferInfoAlign :: Int
gpuTextureTransferInfoOffsets :: [Int]
(gpuTextureTransferInfoSize, gpuTextureTransferInfoAlign, gpuTextureTransferInfoOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    ]

( gpuTextureTransferBufferOffset
  , gpuTextureTransferOffsetOffset
  , gpuTextureTransferPixelsPerRowOffset
  , gpuTextureTransferRowsPerLayerOffset
  ) =
  case gpuTextureTransferInfoOffsets of
    [a, b, c, d] -> (a, b, c, d)
    _ -> error "GPUTextureTransferInfo layout mismatch"

instance Storable GPUTextureTransferInfo where
  sizeOf _ = gpuTextureTransferInfoSize
  alignment _ = gpuTextureTransferInfoAlign
  peek ptr = do
    bufPtr <- peekByteOff ptr gpuTextureTransferBufferOffset
    offset <- peekByteOff ptr gpuTextureTransferOffsetOffset
    ppr <- peekByteOff ptr gpuTextureTransferPixelsPerRowOffset
    rpl <- peekByteOff ptr gpuTextureTransferRowsPerLayerOffset
    pure GPUTextureTransferInfo
      { gpuTransferBuffer = GPUTransferBuffer bufPtr
      , gpuTransferOffset = offset
      , gpuTransferPixelsPerRow = ppr
      , gpuTransferRowsPerLayer = rpl
      }
  poke ptr info = do
    let GPUTransferBuffer bufPtr = info.gpuTransferBuffer
    pokeByteOff ptr gpuTextureTransferBufferOffset bufPtr
    pokeByteOff ptr gpuTextureTransferOffsetOffset info.gpuTransferOffset
    pokeByteOff ptr gpuTextureTransferPixelsPerRowOffset info.gpuTransferPixelsPerRow
    pokeByteOff ptr gpuTextureTransferRowsPerLayerOffset info.gpuTransferRowsPerLayer

gpuTransferBufferLocationSize :: Int
gpuTransferBufferLocationAlign :: Int
gpuTransferBufferLocationOffsets :: [Int]
(gpuTransferBufferLocationSize, gpuTransferBufferLocationAlign, gpuTransferBufferLocationOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    ]

( gpuTransferLocationBufferOffset
  , gpuTransferLocationOffsetOffset
  ) =
  case gpuTransferBufferLocationOffsets of
    [a, b] -> (a, b)
    _ -> error "GPUTransferBufferLocation layout mismatch"

instance Storable GPUTransferBufferLocation where
  sizeOf _ = gpuTransferBufferLocationSize
  alignment _ = gpuTransferBufferLocationAlign
  peek ptr = do
    bufPtr <- peekByteOff ptr gpuTransferLocationBufferOffset
    offset <- peekByteOff ptr gpuTransferLocationOffsetOffset
    pure GPUTransferBufferLocation
      { gpuTransferLocationBuffer = GPUTransferBuffer bufPtr
      , gpuTransferLocationOffset = offset
      }
  poke ptr info = do
    let GPUTransferBuffer bufPtr = info.gpuTransferLocationBuffer
    pokeByteOff ptr gpuTransferLocationBufferOffset bufPtr
    pokeByteOff ptr gpuTransferLocationOffsetOffset info.gpuTransferLocationOffset

gpuTextureRegionSize :: Int
gpuTextureRegionAlign :: Int
gpuTextureRegionOffsets :: [Int]
(gpuTextureRegionSize, gpuTextureRegionAlign, gpuTextureRegionOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    ]

( gpuTextureRegionTextureOffset
  , gpuTextureRegionMipLevelOffset
  , gpuTextureRegionLayerOffset
  , gpuTextureRegionXOffset
  , gpuTextureRegionYOffset
  , gpuTextureRegionZOffset
  , gpuTextureRegionWOffset
  , gpuTextureRegionHOffset
  , gpuTextureRegionDOffset
  ) =
  case gpuTextureRegionOffsets of
    [a, b, c, d, e, f, g, h, i] -> (a, b, c, d, e, f, g, h, i)
    _ -> error "GPUTextureRegion layout mismatch"

instance Storable GPUTextureRegion where
  sizeOf _ = gpuTextureRegionSize
  alignment _ = gpuTextureRegionAlign
  peek ptr = do
    texPtr <- peekByteOff ptr gpuTextureRegionTextureOffset
    mip <- peekByteOff ptr gpuTextureRegionMipLevelOffset
    layer <- peekByteOff ptr gpuTextureRegionLayerOffset
    x <- peekByteOff ptr gpuTextureRegionXOffset
    y <- peekByteOff ptr gpuTextureRegionYOffset
    z <- peekByteOff ptr gpuTextureRegionZOffset
    w <- peekByteOff ptr gpuTextureRegionWOffset
    h <- peekByteOff ptr gpuTextureRegionHOffset
    d <- peekByteOff ptr gpuTextureRegionDOffset
    pure GPUTextureRegion
      { gpuTextureRegionTexture = GPUTexture texPtr
      , gpuTextureRegionMipLevel = mip
      , gpuTextureRegionLayer = layer
      , gpuTextureRegionX = x
      , gpuTextureRegionY = y
      , gpuTextureRegionZ = z
      , gpuTextureRegionW = w
      , gpuTextureRegionH = h
      , gpuTextureRegionD = d
      }
  poke ptr info = do
    let GPUTexture texPtr = info.gpuTextureRegionTexture
    pokeByteOff ptr gpuTextureRegionTextureOffset texPtr
    pokeByteOff ptr gpuTextureRegionMipLevelOffset info.gpuTextureRegionMipLevel
    pokeByteOff ptr gpuTextureRegionLayerOffset info.gpuTextureRegionLayer
    pokeByteOff ptr gpuTextureRegionXOffset info.gpuTextureRegionX
    pokeByteOff ptr gpuTextureRegionYOffset info.gpuTextureRegionY
    pokeByteOff ptr gpuTextureRegionZOffset info.gpuTextureRegionZ
    pokeByteOff ptr gpuTextureRegionWOffset info.gpuTextureRegionW
    pokeByteOff ptr gpuTextureRegionHOffset info.gpuTextureRegionH
    pokeByteOff ptr gpuTextureRegionDOffset info.gpuTextureRegionD

gpuBufferRegionSize :: Int
gpuBufferRegionAlign :: Int
gpuBufferRegionOffsets :: [Int]
(gpuBufferRegionSize, gpuBufferRegionAlign, gpuBufferRegionOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    ]

( gpuBufferRegionBufferOffset
  , gpuBufferRegionOffsetOffset
  , gpuBufferRegionSizeOffset
  ) =
  case gpuBufferRegionOffsets of
    [a, b, c] -> (a, b, c)
    _ -> error "GPUBufferRegion layout mismatch"

instance Storable GPUBufferRegion where
  sizeOf _ = gpuBufferRegionSize
  alignment _ = gpuBufferRegionAlign
  peek ptr = do
    bufPtr <- peekByteOff ptr gpuBufferRegionBufferOffset
    offset <- peekByteOff ptr gpuBufferRegionOffsetOffset
    size <- peekByteOff ptr gpuBufferRegionSizeOffset
    pure GPUBufferRegion
      { gpuBufferRegionBuffer = GPUBuffer bufPtr
      , gpuBufferRegionOffset = offset
      , gpuBufferRegionSize = size
      }
  poke ptr info = do
    let GPUBuffer bufPtr = info.gpuBufferRegionBuffer
    pokeByteOff ptr gpuBufferRegionBufferOffset bufPtr
    pokeByteOff ptr gpuBufferRegionOffsetOffset info.gpuBufferRegionOffset
    pokeByteOff ptr gpuBufferRegionSizeOffset info.gpuBufferRegionSize

gpuColorTargetInfoSize :: Int
gpuColorTargetInfoAlign :: Int
gpuColorTargetInfoOffsets :: [Int]
(gpuColorTargetInfoSize, gpuColorTargetInfoAlign, gpuColorTargetInfoOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @FColor)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @(Ptr ()))
    , cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @CBool)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuColorTargetTextureOffset
  , gpuColorTargetMipLevelOffset
  , gpuColorTargetLayerOffset
  , gpuColorTargetClearColorOffset
  , gpuColorTargetLoadOpOffset
  , gpuColorTargetStoreOpOffset
  , gpuColorTargetResolveTextureOffset
  , gpuColorTargetResolveMipLevelOffset
  , gpuColorTargetResolveLayerOffset
  , gpuColorTargetCycleOffset
  , gpuColorTargetCycleResolveOffset
  , gpuColorTargetPadding1Offset
  , gpuColorTargetPadding2Offset
  ) =
  case gpuColorTargetInfoOffsets of
    [a, b, c, d, e, f, g, h, i, j, k, l, m] -> (a, b, c, d, e, f, g, h, i, j, k, l, m)
    _ -> error "GPUColorTargetInfo layout mismatch"

instance Storable GPUColorTargetInfo where
  sizeOf _ = gpuColorTargetInfoSize
  alignment _ = gpuColorTargetInfoAlign
  peek ptr = do
    tex <- peekByteOff ptr gpuColorTargetTextureOffset
    mip <- peekByteOff ptr gpuColorTargetMipLevelOffset
    layer <- peekByteOff ptr gpuColorTargetLayerOffset
    clearColor <- peekByteOff ptr gpuColorTargetClearColorOffset
    loadOp <- peekByteOff ptr gpuColorTargetLoadOpOffset
    storeOp <- peekByteOff ptr gpuColorTargetStoreOpOffset
    resolveTex <- peekByteOff ptr gpuColorTargetResolveTextureOffset
    resolveMip <- peekByteOff ptr gpuColorTargetResolveMipLevelOffset
    resolveLayer <- peekByteOff ptr gpuColorTargetResolveLayerOffset
    cycle <- peekByteOff ptr gpuColorTargetCycleOffset
    cycleResolve <- peekByteOff ptr gpuColorTargetCycleResolveOffset
    pad1 <- peekByteOff ptr gpuColorTargetPadding1Offset
    pad2 <- peekByteOff ptr gpuColorTargetPadding2Offset
    pure GPUColorTargetInfo
      { gpuColorTargetTexture = tex
      , gpuColorTargetMipLevel = mip
      , gpuColorTargetLayer = layer
      , gpuColorTargetClearColor = clearColor
      , gpuColorTargetLoadOp = loadOp
      , gpuColorTargetStoreOp = storeOp
      , gpuColorTargetResolveTexture = resolveTex
      , gpuColorTargetResolveMipLevel = resolveMip
      , gpuColorTargetResolveLayer = resolveLayer
      , gpuColorTargetCycle = cycle
      , gpuColorTargetCycleResolve = cycleResolve
      , gpuColorTargetPadding1 = pad1
      , gpuColorTargetPadding2 = pad2
      }
  poke ptr info = do
    pokeByteOff ptr gpuColorTargetTextureOffset info.gpuColorTargetTexture
    pokeByteOff ptr gpuColorTargetMipLevelOffset info.gpuColorTargetMipLevel
    pokeByteOff ptr gpuColorTargetLayerOffset info.gpuColorTargetLayer
    pokeByteOff ptr gpuColorTargetClearColorOffset info.gpuColorTargetClearColor
    pokeByteOff ptr gpuColorTargetLoadOpOffset info.gpuColorTargetLoadOp
    pokeByteOff ptr gpuColorTargetStoreOpOffset info.gpuColorTargetStoreOp
    pokeByteOff ptr gpuColorTargetResolveTextureOffset info.gpuColorTargetResolveTexture
    pokeByteOff ptr gpuColorTargetResolveMipLevelOffset info.gpuColorTargetResolveMipLevel
    pokeByteOff ptr gpuColorTargetResolveLayerOffset info.gpuColorTargetResolveLayer
    pokeByteOff ptr gpuColorTargetCycleOffset info.gpuColorTargetCycle
    pokeByteOff ptr gpuColorTargetCycleResolveOffset info.gpuColorTargetCycleResolve
    pokeByteOff ptr gpuColorTargetPadding1Offset info.gpuColorTargetPadding1
    pokeByteOff ptr gpuColorTargetPadding2Offset info.gpuColorTargetPadding2

gpuDepthStencilTargetInfoSize :: Int
gpuDepthStencilTargetInfoAlign :: Int
gpuDepthStencilTargetInfoOffsets :: [Int]
(gpuDepthStencilTargetInfoSize, gpuDepthStencilTargetInfoAlign, gpuDepthStencilTargetInfoOffsets) =
  structLayout
    [ cField (Proxy @(Ptr SDL_GPUTexture))
    , cField (Proxy @CFloat)
    , cField (Proxy @SDL_GPULoadOp)
    , cField (Proxy @SDL_GPUStoreOp)
    , cField (Proxy @SDL_GPULoadOp)
    , cField (Proxy @SDL_GPUStoreOp)
    , cField (Proxy @CBool)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    , cField (Proxy @Word8)
    ]

( gpuDepthStencilTextureOffset
  , gpuDepthStencilClearDepthOffset
  , gpuDepthStencilLoadOpOffset
  , gpuDepthStencilStoreOpOffset
  , gpuDepthStencilStencilLoadOpOffset
  , gpuDepthStencilStencilStoreOpOffset
  , gpuDepthStencilCycleOffset
  , gpuDepthStencilClearStencilOffset
  , gpuDepthStencilMipLevelOffset
  , gpuDepthStencilLayerOffset
  ) =
  case gpuDepthStencilTargetInfoOffsets of
    [a, b, c, d, e, f, g, h, i, j] -> (a, b, c, d, e, f, g, h, i, j)
    _ -> error "GPUDepthStencilTargetInfo layout mismatch"

instance Storable GPUDepthStencilTargetInfo where
  sizeOf _ = gpuDepthStencilTargetInfoSize
  alignment _ = gpuDepthStencilTargetInfoAlign
  peek ptr = do
    tex <- peekByteOff ptr gpuDepthStencilTextureOffset
    clearDepth <- peekByteOff ptr gpuDepthStencilClearDepthOffset
    loadOp <- peekByteOff ptr gpuDepthStencilLoadOpOffset
    storeOp <- peekByteOff ptr gpuDepthStencilStoreOpOffset
    stencilLoadOp <- peekByteOff ptr gpuDepthStencilStencilLoadOpOffset
    stencilStoreOp <- peekByteOff ptr gpuDepthStencilStencilStoreOpOffset
    cycle <- peekByteOff ptr gpuDepthStencilCycleOffset
    clearStencil <- peekByteOff ptr gpuDepthStencilClearStencilOffset
    mip <- peekByteOff ptr gpuDepthStencilMipLevelOffset
    layer <- peekByteOff ptr gpuDepthStencilLayerOffset
    pure GPUDepthStencilTargetInfo
      { gpuDepthStencilTexture = tex
      , gpuDepthStencilClearDepth = clearDepth
      , gpuDepthStencilLoadOp = loadOp
      , gpuDepthStencilStoreOp = storeOp
      , gpuDepthStencilStencilLoadOp = stencilLoadOp
      , gpuDepthStencilStencilStoreOp = stencilStoreOp
      , gpuDepthStencilCycle = cycle
      , gpuDepthStencilClearStencil = clearStencil
      , gpuDepthStencilMipLevel = mip
      , gpuDepthStencilLayer = layer
      }
  poke ptr info = do
    pokeByteOff ptr gpuDepthStencilTextureOffset info.gpuDepthStencilTexture
    pokeByteOff ptr gpuDepthStencilClearDepthOffset info.gpuDepthStencilClearDepth
    pokeByteOff ptr gpuDepthStencilLoadOpOffset info.gpuDepthStencilLoadOp
    pokeByteOff ptr gpuDepthStencilStoreOpOffset info.gpuDepthStencilStoreOp
    pokeByteOff ptr gpuDepthStencilStencilLoadOpOffset info.gpuDepthStencilStencilLoadOp
    pokeByteOff ptr gpuDepthStencilStencilStoreOpOffset info.gpuDepthStencilStencilStoreOp
    pokeByteOff ptr gpuDepthStencilCycleOffset info.gpuDepthStencilCycle
    pokeByteOff ptr gpuDepthStencilClearStencilOffset info.gpuDepthStencilClearStencil
    pokeByteOff ptr gpuDepthStencilMipLevelOffset info.gpuDepthStencilMipLevel
    pokeByteOff ptr gpuDepthStencilLayerOffset info.gpuDepthStencilLayer

surfaceInfoSize :: Int
surfaceInfoAlign :: Int
surfaceInfoOffsets :: [Int]
(surfaceInfoSize, surfaceInfoAlign, surfaceInfoOffsets) =
  structLayout
    [ cField (Proxy @Word32)
    , cField (Proxy @Word32)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @(Ptr ()))
    , cField (Proxy @CInt)
    , cField (Proxy @(Ptr ()))
    ]

( surfaceInfoFlagsOffset
  , surfaceInfoFormatOffset
  , surfaceInfoWidthOffset
  , surfaceInfoHeightOffset
  , surfaceInfoPitchOffset
  , surfaceInfoPixelsOffset
  , surfaceInfoRefcountOffset
  , surfaceInfoReservedOffset
  ) =
  case surfaceInfoOffsets of
    [a, b, c, d, e, f, g, h] -> (a, b, c, d, e, f, g, h)
    _ -> error "SurfaceInfo layout mismatch"

instance Storable SurfaceInfo where
  sizeOf _ = surfaceInfoSize
  alignment _ = surfaceInfoAlign
  peek ptr = do
    flags <- peekByteOff ptr surfaceInfoFlagsOffset
    fmt <- peekByteOff ptr surfaceInfoFormatOffset
    w <- peekByteOff ptr surfaceInfoWidthOffset
    h <- peekByteOff ptr surfaceInfoHeightOffset
    pitch <- peekByteOff ptr surfaceInfoPitchOffset
    pixels <- peekByteOff ptr surfaceInfoPixelsOffset
    refcount <- peekByteOff ptr surfaceInfoRefcountOffset
    reserved <- peekByteOff ptr surfaceInfoReservedOffset
    pure SurfaceInfo
      { surfaceInfoFlags = flags
      , surfaceInfoFormat = fmt
      , surfaceInfoWidth = w
      , surfaceInfoHeight = h
      , surfaceInfoPitch = pitch
      , surfaceInfoPixels = pixels
      , surfaceInfoRefcount = refcount
      , surfaceInfoReserved = reserved
      }
  poke ptr info = do
    pokeByteOff ptr surfaceInfoFlagsOffset info.surfaceInfoFlags
    pokeByteOff ptr surfaceInfoFormatOffset info.surfaceInfoFormat
    pokeByteOff ptr surfaceInfoWidthOffset info.surfaceInfoWidth
    pokeByteOff ptr surfaceInfoHeightOffset info.surfaceInfoHeight
    pokeByteOff ptr surfaceInfoPitchOffset info.surfaceInfoPitch
    pokeByteOff ptr surfaceInfoPixelsOffset info.surfaceInfoPixels
    pokeByteOff ptr surfaceInfoRefcountOffset info.surfaceInfoRefcount
    pokeByteOff ptr surfaceInfoReservedOffset info.surfaceInfoReserved

ttfGpuAtlasDrawSequenceSize :: Int
ttfGpuAtlasDrawSequenceAlign :: Int
ttfGpuAtlasDrawSequenceOffsets :: [Int]
(ttfGpuAtlasDrawSequenceSize, ttfGpuAtlasDrawSequenceAlign, ttfGpuAtlasDrawSequenceOffsets) =
  structLayout
    [ cField (Proxy @(Ptr ()))
    , cField (Proxy @(Ptr FPoint))
    , cField (Proxy @(Ptr FPoint))
    , cField (Proxy @CInt)
    , cField (Proxy @(Ptr CInt))
    , cField (Proxy @CInt)
    , cField (Proxy @CInt)
    , cField (Proxy @(Ptr TTF_GPUAtlasDrawSequence))
    ]

( ttfAtlasTextureOffset
  , ttfAtlasXYOffset
  , ttfAtlasUVOffset
  , ttfAtlasNumVerticesOffset
  , ttfAtlasIndicesOffset
  , ttfAtlasNumIndicesOffset
  , ttfAtlasImageTypeOffset
  , ttfAtlasNextOffset
  ) =
  case ttfGpuAtlasDrawSequenceOffsets of
    [a, b, c, d, e, f, g, h] -> (a, b, c, d, e, f, g, h)
    _ -> error "TTF_GPUAtlasDrawSequence layout mismatch"

instance Storable TTF_GPUAtlasDrawSequence where
  sizeOf _ = ttfGpuAtlasDrawSequenceSize
  alignment _ = ttfGpuAtlasDrawSequenceAlign
  peek ptr = do
    texPtr <- peekByteOff ptr ttfAtlasTextureOffset
    xy <- peekByteOff ptr ttfAtlasXYOffset
    uv <- peekByteOff ptr ttfAtlasUVOffset
    numVerts <- peekByteOff ptr ttfAtlasNumVerticesOffset
    idx <- peekByteOff ptr ttfAtlasIndicesOffset
    numIdx <- peekByteOff ptr ttfAtlasNumIndicesOffset
    imgType <- peekByteOff ptr ttfAtlasImageTypeOffset
    nextPtr <- peekByteOff ptr ttfAtlasNextOffset
    pure TTF_GPUAtlasDrawSequence
      { ttfAtlasTexture = GPUTexture texPtr
      , ttfAtlasXY = xy
      , ttfAtlasUV = uv
      , ttfAtlasNumVertices = numVerts
      , ttfAtlasIndices = idx
      , ttfAtlasNumIndices = numIdx
      , ttfAtlasImageType = imgType
      , ttfAtlasNext = nextPtr
      }
  poke ptr seqInfo = do
    let GPUTexture texPtr = seqInfo.ttfAtlasTexture
    pokeByteOff ptr ttfAtlasTextureOffset texPtr
    pokeByteOff ptr ttfAtlasXYOffset seqInfo.ttfAtlasXY
    pokeByteOff ptr ttfAtlasUVOffset seqInfo.ttfAtlasUV
    pokeByteOff ptr ttfAtlasNumVerticesOffset seqInfo.ttfAtlasNumVertices
    pokeByteOff ptr ttfAtlasIndicesOffset seqInfo.ttfAtlasIndices
    pokeByteOff ptr ttfAtlasNumIndicesOffset seqInfo.ttfAtlasNumIndices
    pokeByteOff ptr ttfAtlasImageTypeOffset seqInfo.ttfAtlasImageType
    pokeByteOff ptr ttfAtlasNextOffset seqInfo.ttfAtlasNext

-- Helpers

fromCBool :: CBool -> Bool
fromCBool v = v /= 0

maybePtr :: Maybe a -> (a -> Ptr b) -> Ptr b
maybePtr Nothing _ = nullPtr
maybePtr (Just x) f = f x

-- SDL core bindings

foreign import ccall unsafe "SDL_Init" c_SDL_Init :: SDL_InitFlags -> IO CBool

foreign import ccall unsafe "SDL_Quit" c_SDL_Quit :: IO ()

foreign import ccall unsafe "SDL_GetError" c_SDL_GetError :: IO CString

sdlInit :: SDL_InitFlags -> IO Bool
sdlInit flags = fromCBool <$> c_SDL_Init flags

sdlQuit :: IO ()
sdlQuit = c_SDL_Quit

sdlGetError :: IO String
sdlGetError = c_SDL_GetError >>= peekCString

foreign import ccall unsafe "SDL_CreateWindow" c_SDL_CreateWindow
  :: CString -> CInt -> CInt -> SDL_WindowFlags -> IO (Ptr SDL_Window)

foreign import ccall unsafe "SDL_DestroyWindow" c_SDL_DestroyWindow
  :: Ptr SDL_Window -> IO ()

foreign import ccall unsafe "SDL_SetWindowResizable" c_SDL_SetWindowResizable
  :: Ptr SDL_Window -> CBool -> IO CBool

foreign import ccall unsafe "SDL_ShowWindow" c_SDL_ShowWindow
  :: Ptr SDL_Window -> IO CBool

sdlCreateWindow :: String -> Int -> Int -> SDL_WindowFlags -> IO (Maybe Window)
sdlCreateWindow title w h flags =
  withCString title $ \cTitle -> do
    ptr <- c_SDL_CreateWindow cTitle (fromIntegral w) (fromIntegral h) flags
    pure $ if ptr == nullPtr then Nothing else Just (Window ptr)

sdlDestroyWindow :: Window -> IO ()
sdlDestroyWindow (Window ptr) = c_SDL_DestroyWindow ptr

sdlSetWindowResizable :: Window -> Bool -> IO Bool
sdlSetWindowResizable (Window ptr) resizable =
  fromCBool <$> c_SDL_SetWindowResizable ptr (if resizable then 1 else 0)

sdlShowWindow :: Window -> IO Bool
sdlShowWindow (Window ptr) =
  fromCBool <$> c_SDL_ShowWindow ptr

-- SDL_gpu bindings

foreign import ccall unsafe "SDL_CreateGPUDevice" c_SDL_CreateGPUDevice
  :: SDL_GPUShaderFormat -> CBool -> CString -> IO (Ptr SDL_GPUDevice)

foreign import ccall unsafe "SDL_DestroyGPUDevice" c_SDL_DestroyGPUDevice
  :: Ptr SDL_GPUDevice -> IO ()

foreign import ccall unsafe "SDL_ClaimWindowForGPUDevice" c_SDL_ClaimWindowForGPUDevice
  :: Ptr SDL_GPUDevice -> Ptr SDL_Window -> IO CBool

foreign import ccall unsafe "SDL_ReleaseWindowFromGPUDevice" c_SDL_ReleaseWindowFromGPUDevice
  :: Ptr SDL_GPUDevice -> Ptr SDL_Window -> IO ()

foreign import ccall unsafe "SDL_GetGPUSwapchainTextureFormat" c_SDL_GetGPUSwapchainTextureFormat
  :: Ptr SDL_GPUDevice -> Ptr SDL_Window -> IO SDL_GPUTextureFormat

foreign import ccall unsafe "SDL_AcquireGPUCommandBuffer" c_SDL_AcquireGPUCommandBuffer
  :: Ptr SDL_GPUDevice -> IO (Ptr SDL_GPUCommandBuffer)

foreign import ccall unsafe "SDL_SubmitGPUCommandBuffer" c_SDL_SubmitGPUCommandBuffer
  :: Ptr SDL_GPUCommandBuffer -> IO CBool

foreign import ccall unsafe "SDL_WaitAndAcquireGPUSwapchainTexture" c_SDL_WaitAndAcquireGPUSwapchainTexture
  :: Ptr SDL_GPUCommandBuffer -> Ptr SDL_Window -> Ptr (Ptr SDL_GPUTexture) -> Ptr Word32 -> Ptr Word32 -> IO CBool

foreign import ccall unsafe "SDL_BeginGPURenderPass" c_SDL_BeginGPURenderPass
  :: Ptr SDL_GPUCommandBuffer -> Ptr GPUColorTargetInfo -> Word32 -> Ptr GPUDepthStencilTargetInfo -> IO (Ptr SDL_GPURenderPass)

foreign import ccall unsafe "SDL_EndGPURenderPass" c_SDL_EndGPURenderPass
  :: Ptr SDL_GPURenderPass -> IO ()

foreign import ccall unsafe "SDL_BeginGPUComputePass" c_SDL_BeginGPUComputePass
  :: Ptr SDL_GPUCommandBuffer
  -> Ptr GPUStorageTextureReadWriteBinding
  -> Word32
  -> Ptr GPUStorageBufferReadWriteBinding
  -> Word32
  -> IO (Ptr SDL_GPUComputePass)

foreign import ccall unsafe "SDL_EndGPUComputePass" c_SDL_EndGPUComputePass
  :: Ptr SDL_GPUComputePass -> IO ()

foreign import ccall unsafe "SDL_BindGPUComputePipeline" c_SDL_BindGPUComputePipeline
  :: Ptr SDL_GPUComputePass -> Ptr SDL_GPUComputePipeline -> IO ()

foreign import ccall unsafe "SDL_BindGPUComputeSamplers" c_SDL_BindGPUComputeSamplers
  :: Ptr SDL_GPUComputePass -> Word32 -> Ptr GPUTextureSamplerBinding -> Word32 -> IO ()

foreign import ccall unsafe "SDL_BindGPUComputeStorageTextures" c_SDL_BindGPUComputeStorageTextures
  :: Ptr SDL_GPUComputePass -> Word32 -> Ptr (Ptr SDL_GPUTexture) -> Word32 -> IO ()

foreign import ccall unsafe "SDL_BindGPUComputeStorageBuffers" c_SDL_BindGPUComputeStorageBuffers
  :: Ptr SDL_GPUComputePass -> Word32 -> Ptr (Ptr SDL_GPUBuffer) -> Word32 -> IO ()

foreign import ccall unsafe "SDL_DispatchGPUCompute" c_SDL_DispatchGPUCompute
  :: Ptr SDL_GPUComputePass -> Word32 -> Word32 -> Word32 -> IO ()

foreign import ccall unsafe "SDL_BindGPUGraphicsPipeline" c_SDL_BindGPUGraphicsPipeline
  :: Ptr SDL_GPURenderPass -> Ptr SDL_GPUGraphicsPipeline -> IO ()

foreign import ccall unsafe "SDL_SetGPUViewport" c_SDL_SetGPUViewport
  :: Ptr SDL_GPURenderPass -> Ptr GPUViewport -> IO ()

foreign import ccall unsafe "SDL_BindGPUVertexBuffers" c_SDL_BindGPUVertexBuffers
  :: Ptr SDL_GPURenderPass -> Word32 -> Ptr GPUBufferBinding -> Word32 -> IO ()

foreign import ccall unsafe "SDL_BindGPUFragmentSamplers" c_SDL_BindGPUFragmentSamplers
  :: Ptr SDL_GPURenderPass -> Word32 -> Ptr GPUTextureSamplerBinding -> Word32 -> IO ()

foreign import ccall unsafe "SDL_BindGPUFragmentStorageTextures" c_SDL_BindGPUFragmentStorageTextures
  :: Ptr SDL_GPURenderPass -> Word32 -> Ptr (Ptr SDL_GPUTexture) -> Word32 -> IO ()

foreign import ccall unsafe "SDL_DrawGPUPrimitives" c_SDL_DrawGPUPrimitives
  :: Ptr SDL_GPURenderPass -> Word32 -> Word32 -> Word32 -> Word32 -> IO ()

foreign import ccall unsafe "SDL_PushGPUVertexUniformData" c_SDL_PushGPUVertexUniformData
  :: Ptr SDL_GPUCommandBuffer -> Word32 -> Ptr () -> Word32 -> IO ()

foreign import ccall unsafe "SDL_PushGPUFragmentUniformData" c_SDL_PushGPUFragmentUniformData
  :: Ptr SDL_GPUCommandBuffer -> Word32 -> Ptr () -> Word32 -> IO ()

foreign import ccall unsafe "SDL_PushGPUComputeUniformData" c_SDL_PushGPUComputeUniformData
  :: Ptr SDL_GPUCommandBuffer -> Word32 -> Ptr () -> Word32 -> IO ()

foreign import ccall unsafe "SDL_CreateGPUGraphicsPipeline" c_SDL_CreateGPUGraphicsPipeline
  :: Ptr SDL_GPUDevice -> Ptr GPUGraphicsPipelineCreateInfo -> IO (Ptr SDL_GPUGraphicsPipeline)

foreign import ccall unsafe "SDL_ReleaseGPUGraphicsPipeline" c_SDL_ReleaseGPUGraphicsPipeline
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUGraphicsPipeline -> IO ()

foreign import ccall unsafe "SDL_CreateGPUComputePipeline" c_SDL_CreateGPUComputePipeline
  :: Ptr SDL_GPUDevice -> Ptr GPUComputePipelineCreateInfo -> IO (Ptr SDL_GPUComputePipeline)

foreign import ccall unsafe "SDL_ReleaseGPUComputePipeline" c_SDL_ReleaseGPUComputePipeline
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUComputePipeline -> IO ()

foreign import ccall unsafe "SDL_CreateGPUTexture" c_SDL_CreateGPUTexture
  :: Ptr SDL_GPUDevice -> Ptr GPUTextureCreateInfo -> IO (Ptr SDL_GPUTexture)

foreign import ccall unsafe "SDL_ReleaseGPUTexture" c_SDL_ReleaseGPUTexture
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUTexture -> IO ()

foreign import ccall unsafe "SDL_CreateGPUBuffer" c_SDL_CreateGPUBuffer
  :: Ptr SDL_GPUDevice -> Ptr GPUBufferCreateInfo -> IO (Ptr SDL_GPUBuffer)

foreign import ccall unsafe "SDL_ReleaseGPUBuffer" c_SDL_ReleaseGPUBuffer
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUBuffer -> IO ()

foreign import ccall unsafe "SDL_CreateGPUTransferBuffer" c_SDL_CreateGPUTransferBuffer
  :: Ptr SDL_GPUDevice -> Ptr GPUTransferBufferCreateInfo -> IO (Ptr SDL_GPUTransferBuffer)

foreign import ccall unsafe "SDL_ReleaseGPUTransferBuffer" c_SDL_ReleaseGPUTransferBuffer
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUTransferBuffer -> IO ()

foreign import ccall unsafe "SDL_MapGPUTransferBuffer" c_SDL_MapGPUTransferBuffer
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUTransferBuffer -> CBool -> IO (Ptr ())

foreign import ccall unsafe "SDL_UnmapGPUTransferBuffer" c_SDL_UnmapGPUTransferBuffer
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUTransferBuffer -> IO ()

foreign import ccall unsafe "SDL_BeginGPUCopyPass" c_SDL_BeginGPUCopyPass
  :: Ptr SDL_GPUCommandBuffer -> IO (Ptr SDL_GPUCopyPass)

foreign import ccall unsafe "SDL_EndGPUCopyPass" c_SDL_EndGPUCopyPass
  :: Ptr SDL_GPUCopyPass -> IO ()

foreign import ccall unsafe "SDL_UploadToGPUTexture" c_SDL_UploadToGPUTexture
  :: Ptr SDL_GPUCopyPass -> Ptr GPUTextureTransferInfo -> Ptr GPUTextureRegion -> CBool -> IO ()

foreign import ccall unsafe "SDL_UploadToGPUBuffer" c_SDL_UploadToGPUBuffer
  :: Ptr SDL_GPUCopyPass -> Ptr GPUTransferBufferLocation -> Ptr GPUBufferRegion -> CBool -> IO ()

foreign import ccall unsafe "SDL_GetGPUTextureFormatFromPixelFormat" c_SDL_GetGPUTextureFormatFromPixelFormat
  :: SDL_PixelFormat -> IO SDL_GPUTextureFormat

sdlCreateGPUDevice :: SDL_GPUShaderFormat -> Bool -> IO (Maybe GPUDevice)
sdlCreateGPUDevice formats debugMode = do
  ptr <- c_SDL_CreateGPUDevice formats (if debugMode then 1 else 0) nullPtr
  pure $ if ptr == nullPtr then Nothing else Just (GPUDevice ptr)

sdlDestroyGPUDevice :: GPUDevice -> IO ()
sdlDestroyGPUDevice (GPUDevice dev) = c_SDL_DestroyGPUDevice dev

sdlClaimWindowForGPUDevice :: GPUDevice -> Window -> IO Bool
sdlClaimWindowForGPUDevice (GPUDevice dev) (Window win) =
  fromCBool <$> c_SDL_ClaimWindowForGPUDevice dev win

sdlReleaseWindowFromGPUDevice :: GPUDevice -> Window -> IO ()
sdlReleaseWindowFromGPUDevice (GPUDevice dev) (Window win) =
  c_SDL_ReleaseWindowFromGPUDevice dev win

sdlGetGPUSwapchainTextureFormat :: GPUDevice -> Window -> IO SDL_GPUTextureFormat
sdlGetGPUSwapchainTextureFormat (GPUDevice dev) (Window win) =
  c_SDL_GetGPUSwapchainTextureFormat dev win

sdlAcquireGPUCommandBuffer :: GPUDevice -> IO (Maybe GPUCommandBuffer)
sdlAcquireGPUCommandBuffer (GPUDevice dev) = do
  ptr <- c_SDL_AcquireGPUCommandBuffer dev
  pure $ if ptr == nullPtr then Nothing else Just (GPUCommandBuffer ptr)

sdlSubmitGPUCommandBuffer :: GPUCommandBuffer -> IO Bool
sdlSubmitGPUCommandBuffer (GPUCommandBuffer cmd) =
  fromCBool <$> c_SDL_SubmitGPUCommandBuffer cmd

sdlWaitAndAcquireGPUSwapchainTexture :: GPUCommandBuffer -> Window -> IO (Maybe (GPUTexture, Word32, Word32))
sdlWaitAndAcquireGPUSwapchainTexture (GPUCommandBuffer cmd) (Window win) =
  alloca $ \texPtrPtr ->
    alloca $ \wPtr ->
      alloca $ \hPtr -> do
        ok <- c_SDL_WaitAndAcquireGPUSwapchainTexture cmd win texPtrPtr wPtr hPtr
        if not (fromCBool ok)
          then pure Nothing
          else do
            texPtr <- peek texPtrPtr
            if texPtr == nullPtr
              then pure Nothing
              else do
                w <- peek wPtr
                h <- peek hPtr
                pure (Just (GPUTexture texPtr, w, h))

sdlBeginGPURenderPass :: GPUCommandBuffer -> GPUColorTargetInfo -> Maybe GPUDepthStencilTargetInfo -> IO (Maybe GPURenderPass)
sdlBeginGPURenderPass (GPUCommandBuffer cmd) targetInfo depthInfo =
  with targetInfo $ \targetPtr ->
    withMaybe depthInfo $ \depthPtr -> do
      passPtr <- c_SDL_BeginGPURenderPass cmd targetPtr 1 depthPtr
      pure $ if passPtr == nullPtr then Nothing else Just (GPURenderPass passPtr)
  where
    withMaybe Nothing action = action nullPtr
    withMaybe (Just value) action = with value action

sdlEndGPURenderPass :: GPURenderPass -> IO ()
sdlEndGPURenderPass (GPURenderPass pass) = c_SDL_EndGPURenderPass pass

sdlBeginGPUComputePass :: GPUCommandBuffer -> [GPUStorageTextureReadWriteBinding] -> [GPUStorageBufferReadWriteBinding] -> IO (Maybe GPUComputePass)
sdlBeginGPUComputePass (GPUCommandBuffer cmd) textures buffers =
  withMaybeArray textures $ \texPtr texCount ->
    withMaybeArray buffers $ \bufPtr bufCount -> do
      passPtr <- c_SDL_BeginGPUComputePass cmd texPtr (fromIntegral texCount) bufPtr (fromIntegral bufCount)
      pure $ if passPtr == nullPtr then Nothing else Just (GPUComputePass passPtr)
  where
    withMaybeArray [] action = action nullPtr 0
    withMaybeArray xs action =
      withArrayLen xs $ \count ptr -> action ptr count

sdlEndGPUComputePass :: GPUComputePass -> IO ()
sdlEndGPUComputePass (GPUComputePass pass) = c_SDL_EndGPUComputePass pass

sdlBindGPUComputePipeline :: GPUComputePass -> GPUComputePipeline -> IO ()
sdlBindGPUComputePipeline (GPUComputePass pass) (GPUComputePipeline pipeline) =
  c_SDL_BindGPUComputePipeline pass pipeline

sdlBindGPUComputeSamplers :: GPUComputePass -> Word32 -> [GPUTextureSamplerBinding] -> IO ()
sdlBindGPUComputeSamplers (GPUComputePass pass) firstSlot bindings =
  if null bindings
    then pure ()
    else
      withArrayLen bindings $ \count ptr ->
        c_SDL_BindGPUComputeSamplers pass firstSlot ptr (fromIntegral count)

sdlBindGPUComputeStorageTextures :: GPUComputePass -> Word32 -> [GPUTexture] -> IO ()
sdlBindGPUComputeStorageTextures (GPUComputePass pass) firstSlot textures =
  if null textures
    then pure ()
    else
      let texturePtrs = map (\(GPUTexture ptr) -> ptr) textures
      in withArrayLen texturePtrs $ \count ptr ->
        c_SDL_BindGPUComputeStorageTextures pass firstSlot (castPtr ptr) (fromIntegral count)

sdlBindGPUComputeStorageBuffers :: GPUComputePass -> Word32 -> [GPUBuffer] -> IO ()
sdlBindGPUComputeStorageBuffers (GPUComputePass pass) firstSlot buffers =
  if null buffers
    then pure ()
    else
      let bufferPtrs = map (\(GPUBuffer ptr) -> ptr) buffers
      in withArrayLen bufferPtrs $ \count ptr ->
        c_SDL_BindGPUComputeStorageBuffers pass firstSlot (castPtr ptr) (fromIntegral count)

sdlDispatchGPUCompute :: GPUComputePass -> Word32 -> Word32 -> Word32 -> IO ()
sdlDispatchGPUCompute (GPUComputePass pass) groupX groupY groupZ =
  c_SDL_DispatchGPUCompute pass groupX groupY groupZ

sdlBindGPUGraphicsPipeline :: GPURenderPass -> GPUGraphicsPipeline -> IO ()
sdlBindGPUGraphicsPipeline (GPURenderPass pass) (GPUGraphicsPipeline pipeline) =
  c_SDL_BindGPUGraphicsPipeline pass pipeline

sdlSetGPUViewport :: GPURenderPass -> GPUViewport -> IO ()
sdlSetGPUViewport (GPURenderPass pass) viewport =
  with viewport $ \viewportPtr -> c_SDL_SetGPUViewport pass viewportPtr

sdlBindGPUVertexBuffers :: GPURenderPass -> Word32 -> [GPUBufferBinding] -> IO ()
sdlBindGPUVertexBuffers (GPURenderPass pass) firstSlot bindings =
  if null bindings
    then pure ()
    else
      withArrayLen bindings $ \count ptr ->
        c_SDL_BindGPUVertexBuffers pass firstSlot ptr (fromIntegral count)

sdlBindGPUFragmentSamplers :: GPURenderPass -> Word32 -> [GPUTextureSamplerBinding] -> IO ()
sdlBindGPUFragmentSamplers (GPURenderPass pass) firstSlot bindings =
  if null bindings
    then pure ()
    else
      withArrayLen bindings $ \count ptr ->
        c_SDL_BindGPUFragmentSamplers pass firstSlot ptr (fromIntegral count)

sdlBindGPUFragmentStorageTextures :: GPURenderPass -> Word32 -> [GPUTexture] -> IO ()
sdlBindGPUFragmentStorageTextures (GPURenderPass pass) firstSlot textures =
  if null textures
    then pure ()
    else
      let texturePtrs = map (\(GPUTexture ptr) -> ptr) textures
      in withArrayLen texturePtrs $ \count ptr ->
        c_SDL_BindGPUFragmentStorageTextures pass firstSlot (castPtr ptr) (fromIntegral count)

sdlDrawGPUPrimitives :: GPURenderPass -> Word32 -> Word32 -> Word32 -> Word32 -> IO ()
sdlDrawGPUPrimitives (GPURenderPass pass) numVertices numInstances firstVertex firstInstance =
  c_SDL_DrawGPUPrimitives pass numVertices numInstances firstVertex firstInstance

sdlPushGPUVertexUniformData :: GPUCommandBuffer -> Word32 -> Ptr () -> Word32 -> IO ()
sdlPushGPUVertexUniformData (GPUCommandBuffer cmd) slot ptr len =
  c_SDL_PushGPUVertexUniformData cmd slot ptr len

sdlPushGPUFragmentUniformData :: GPUCommandBuffer -> Word32 -> Ptr () -> Word32 -> IO ()
sdlPushGPUFragmentUniformData (GPUCommandBuffer cmd) slot ptr len =
  c_SDL_PushGPUFragmentUniformData cmd slot ptr len

sdlPushGPUComputeUniformData :: GPUCommandBuffer -> Word32 -> Ptr () -> Word32 -> IO ()
sdlPushGPUComputeUniformData (GPUCommandBuffer cmd) slot ptr len =
  c_SDL_PushGPUComputeUniformData cmd slot ptr len

sdlCreateGPUGraphicsPipeline :: GPUDevice -> GPUGraphicsPipelineCreateInfo -> IO (Maybe GPUGraphicsPipeline)
sdlCreateGPUGraphicsPipeline (GPUDevice dev) info =
  with info $ \ptr -> do
    pipeline <- c_SDL_CreateGPUGraphicsPipeline dev ptr
    pure $ if pipeline == nullPtr then Nothing else Just (GPUGraphicsPipeline pipeline)

sdlReleaseGPUGraphicsPipeline :: GPUDevice -> GPUGraphicsPipeline -> IO ()
sdlReleaseGPUGraphicsPipeline (GPUDevice dev) (GPUGraphicsPipeline pipeline) =
  c_SDL_ReleaseGPUGraphicsPipeline dev pipeline

sdlCreateGPUComputePipeline :: GPUDevice -> GPUComputePipelineCreateInfo -> IO (Maybe GPUComputePipeline)
sdlCreateGPUComputePipeline (GPUDevice dev) info =
  with info $ \ptr -> do
    pipeline <- c_SDL_CreateGPUComputePipeline dev ptr
    pure $ if pipeline == nullPtr then Nothing else Just (GPUComputePipeline pipeline)

sdlReleaseGPUComputePipeline :: GPUDevice -> GPUComputePipeline -> IO ()
sdlReleaseGPUComputePipeline (GPUDevice dev) (GPUComputePipeline pipeline) =
  c_SDL_ReleaseGPUComputePipeline dev pipeline

sdlCreateGPUTexture :: GPUDevice -> GPUTextureCreateInfo -> IO (Maybe GPUTexture)
sdlCreateGPUTexture (GPUDevice dev) info =
  with info $ \ptr -> do
    tex <- c_SDL_CreateGPUTexture dev ptr
    pure $ if tex == nullPtr then Nothing else Just (GPUTexture tex)

sdlReleaseGPUTexture :: GPUDevice -> GPUTexture -> IO ()
sdlReleaseGPUTexture (GPUDevice dev) (GPUTexture tex) =
  c_SDL_ReleaseGPUTexture dev tex

sdlCreateGPUBuffer :: GPUDevice -> GPUBufferCreateInfo -> IO (Maybe GPUBuffer)
sdlCreateGPUBuffer (GPUDevice dev) info =
  with info $ \ptr -> do
    buf <- c_SDL_CreateGPUBuffer dev ptr
    pure $ if buf == nullPtr then Nothing else Just (GPUBuffer buf)

sdlReleaseGPUBuffer :: GPUDevice -> GPUBuffer -> IO ()
sdlReleaseGPUBuffer (GPUDevice dev) (GPUBuffer buf) =
  c_SDL_ReleaseGPUBuffer dev buf

sdlCreateGPUTransferBuffer :: GPUDevice -> GPUTransferBufferCreateInfo -> IO (Maybe GPUTransferBuffer)
sdlCreateGPUTransferBuffer (GPUDevice dev) info =
  with info $ \ptr -> do
    buf <- c_SDL_CreateGPUTransferBuffer dev ptr
    pure $ if buf == nullPtr then Nothing else Just (GPUTransferBuffer buf)

sdlReleaseGPUTransferBuffer :: GPUDevice -> GPUTransferBuffer -> IO ()
sdlReleaseGPUTransferBuffer (GPUDevice dev) (GPUTransferBuffer buf) =
  c_SDL_ReleaseGPUTransferBuffer dev buf

sdlMapGPUTransferBuffer :: GPUDevice -> GPUTransferBuffer -> Bool -> IO (Maybe (Ptr ()))
sdlMapGPUTransferBuffer (GPUDevice dev) (GPUTransferBuffer buf) cycleBuffer = do
  ptr <- c_SDL_MapGPUTransferBuffer dev buf (if cycleBuffer then 1 else 0)
  pure $ if ptr == nullPtr then Nothing else Just ptr

sdlUnmapGPUTransferBuffer :: GPUDevice -> GPUTransferBuffer -> IO ()
sdlUnmapGPUTransferBuffer (GPUDevice dev) (GPUTransferBuffer buf) =
  c_SDL_UnmapGPUTransferBuffer dev buf

sdlBeginGPUCopyPass :: GPUCommandBuffer -> IO (Maybe GPUCopyPass)
sdlBeginGPUCopyPass (GPUCommandBuffer cmd) = do
  pass <- c_SDL_BeginGPUCopyPass cmd
  pure $ if pass == nullPtr then Nothing else Just (GPUCopyPass pass)

sdlEndGPUCopyPass :: GPUCopyPass -> IO ()
sdlEndGPUCopyPass (GPUCopyPass pass) = c_SDL_EndGPUCopyPass pass

sdlUploadToGPUTexture :: GPUCopyPass -> GPUTextureTransferInfo -> GPUTextureRegion -> Bool -> IO ()
sdlUploadToGPUTexture (GPUCopyPass pass) source dest cycleTex =
  with source $ \srcPtr ->
    with dest $ \dstPtr ->
      c_SDL_UploadToGPUTexture pass srcPtr dstPtr (if cycleTex then 1 else 0)

sdlUploadToGPUBuffer :: GPUCopyPass -> GPUTransferBufferLocation -> GPUBufferRegion -> Bool -> IO ()
sdlUploadToGPUBuffer (GPUCopyPass pass) source dest cycleBuf =
  with source $ \srcPtr ->
    with dest $ \dstPtr ->
      c_SDL_UploadToGPUBuffer pass srcPtr dstPtr (if cycleBuf then 1 else 0)

sdlGetGPUTextureFormatFromPixelFormat :: SDL_PixelFormat -> IO SDL_GPUTextureFormat
sdlGetGPUTextureFormatFromPixelFormat fmt =
  c_SDL_GetGPUTextureFormatFromPixelFormat fmt

foreign import ccall unsafe "SDL_CreateGPURenderer" c_SDL_CreateGPURenderer
  :: Ptr SDL_GPUDevice -> Ptr SDL_Window -> IO (Ptr SDL_Renderer)

foreign import ccall unsafe "SDL_DestroyRenderer" c_SDL_DestroyRenderer
  :: Ptr SDL_Renderer -> IO ()

foreign import ccall unsafe "SDL_GetGPURendererDevice" c_SDL_GetGPURendererDevice
  :: Ptr SDL_Renderer -> IO (Ptr SDL_GPUDevice)

sdlCreateGPURenderer :: Maybe GPUDevice -> Maybe Window -> IO (Maybe Renderer)
sdlCreateGPURenderer gpu win = do
  let gpuPtr = maybePtr gpu (\(GPUDevice p) -> p)
  let winPtr = maybePtr win (\(Window p) -> p)
  ptr <- c_SDL_CreateGPURenderer gpuPtr winPtr
  pure $ if ptr == nullPtr then Nothing else Just (Renderer ptr)

sdlDestroyRenderer :: Renderer -> IO ()
sdlDestroyRenderer (Renderer ptr) = c_SDL_DestroyRenderer ptr

sdlGetGPURendererDevice :: Renderer -> IO (Maybe GPUDevice)
sdlGetGPURendererDevice (Renderer ptr) = do
  gpu <- c_SDL_GetGPURendererDevice ptr
  pure $ if gpu == nullPtr then Nothing else Just (GPUDevice gpu)

foreign import ccall unsafe "SDL_SetRenderDrawColorFloat" c_SDL_SetRenderDrawColorFloat
  :: Ptr SDL_Renderer -> CFloat -> CFloat -> CFloat -> CFloat -> IO CBool

foreign import ccall unsafe "SDL_RenderClear" c_SDL_RenderClear
  :: Ptr SDL_Renderer -> IO CBool

foreign import ccall unsafe "SDL_RenderPresent" c_SDL_RenderPresent
  :: Ptr SDL_Renderer -> IO ()

foreign import ccall unsafe "SDL_CreateTexture" c_SDL_CreateTexture
  :: Ptr SDL_Renderer -> SDL_PixelFormat -> SDL_TextureAccess -> CInt -> CInt -> IO (Ptr SDL_Texture)

foreign import ccall unsafe "SDL_RenderTexture" c_SDL_RenderTexture
  :: Ptr SDL_Renderer -> Ptr SDL_Texture -> Ptr FRect -> Ptr FRect -> IO CBool

foreign import ccall unsafe "SDL_RenderLine" c_SDL_RenderLine
  :: Ptr SDL_Renderer -> CFloat -> CFloat -> CFloat -> CFloat -> IO CBool

foreign import ccall unsafe "SDL_RenderLines" c_SDL_RenderLines
  :: Ptr SDL_Renderer -> Ptr FPoint -> CInt -> IO CBool

foreign import ccall unsafe "SDL_RenderRect" c_SDL_RenderRect
  :: Ptr SDL_Renderer -> Ptr FRect -> IO CBool

foreign import ccall unsafe "SDL_RenderFillRect" c_SDL_RenderFillRect
  :: Ptr SDL_Renderer -> Ptr FRect -> IO CBool

foreign import ccall unsafe "SDL_SetRenderTarget" c_SDL_SetRenderTarget
  :: Ptr SDL_Renderer -> Ptr SDL_Texture -> IO CBool

foreign import ccall unsafe "SDL_GetRenderTarget" c_SDL_GetRenderTarget
  :: Ptr SDL_Renderer -> IO (Ptr SDL_Texture)

sdlSetRenderDrawColorFloat :: Renderer -> CFloat -> CFloat -> CFloat -> CFloat -> IO Bool
sdlSetRenderDrawColorFloat (Renderer ptr) r g b a =
  fromCBool <$> c_SDL_SetRenderDrawColorFloat ptr r g b a

sdlRenderClear :: Renderer -> IO Bool
sdlRenderClear (Renderer ptr) = fromCBool <$> c_SDL_RenderClear ptr

sdlRenderPresent :: Renderer -> IO ()
sdlRenderPresent (Renderer ptr) = c_SDL_RenderPresent ptr

sdlCreateTexture :: Renderer -> SDL_PixelFormat -> SDL_TextureAccess -> Int -> Int -> IO (Maybe Texture)
sdlCreateTexture (Renderer r) format access w h = do
  ptr <- c_SDL_CreateTexture r format access (fromIntegral w) (fromIntegral h)
  pure $ if ptr == nullPtr then Nothing else Just (Texture ptr)

sdlRenderTexture :: Renderer -> Texture -> Ptr FRect -> Ptr FRect -> IO Bool
sdlRenderTexture (Renderer r) (Texture t) src dst =
  fromCBool <$> c_SDL_RenderTexture r t src dst

sdlRenderLine :: Renderer -> CFloat -> CFloat -> CFloat -> CFloat -> IO Bool
sdlRenderLine (Renderer r) x1 y1 x2 y2 =
  fromCBool <$> c_SDL_RenderLine r x1 y1 x2 y2

sdlRenderLines :: Renderer -> Ptr FPoint -> Int -> IO Bool
sdlRenderLines (Renderer r) pts count =
  fromCBool <$> c_SDL_RenderLines r pts (fromIntegral count)

sdlRenderRect :: Renderer -> Ptr FRect -> IO Bool
sdlRenderRect (Renderer r) rect =
  fromCBool <$> c_SDL_RenderRect r rect

sdlRenderFillRect :: Renderer -> Ptr FRect -> IO Bool
sdlRenderFillRect (Renderer r) rect =
  fromCBool <$> c_SDL_RenderFillRect r rect

sdlSetRenderTarget :: Renderer -> Maybe Texture -> IO Bool
sdlSetRenderTarget (Renderer r) target =
  fromCBool <$> c_SDL_SetRenderTarget r (maybe nullPtr (\(Texture t) -> t) target)

sdlGetRenderTarget :: Renderer -> IO (Maybe Texture)
sdlGetRenderTarget (Renderer r) = do
  ptr <- c_SDL_GetRenderTarget r
  pure $ if ptr == nullPtr then Nothing else Just (Texture ptr)

foreign import ccall unsafe "SDL_GetTextureProperties" c_SDL_GetTextureProperties
  :: Ptr SDL_Texture -> IO SDL_PropertiesID

sdlGetTextureProperties :: Texture -> IO SDL_PropertiesID
sdlGetTextureProperties (Texture t) = c_SDL_GetTextureProperties t

foreign import ccall unsafe "SDL_CreateProperties" c_SDL_CreateProperties
  :: IO SDL_PropertiesID

foreign import ccall unsafe "SDL_DestroyProperties" c_SDL_DestroyProperties
  :: SDL_PropertiesID -> IO ()

foreign import ccall unsafe "SDL_SetPointerProperty" c_SDL_SetPointerProperty
  :: SDL_PropertiesID -> CString -> Ptr () -> IO CBool

foreign import ccall unsafe "SDL_SetNumberProperty" c_SDL_SetNumberProperty
  :: SDL_PropertiesID -> CString -> Int64 -> IO CBool

sdlCreateProperties :: IO SDL_PropertiesID
sdlCreateProperties = c_SDL_CreateProperties

sdlDestroyProperties :: SDL_PropertiesID -> IO ()
sdlDestroyProperties = c_SDL_DestroyProperties

sdlSetPointerProperty :: SDL_PropertiesID -> String -> Ptr () -> IO Bool
sdlSetPointerProperty props name value =
  fromCBool <$> withCString name (\cName -> c_SDL_SetPointerProperty props cName value)

sdlSetNumberProperty :: SDL_PropertiesID -> String -> Int64 -> IO Bool
sdlSetNumberProperty props name value =
  fromCBool <$> withCString name (\cName -> c_SDL_SetNumberProperty props cName value)

foreign import ccall unsafe "SDL_GetPointerProperty" c_SDL_GetPointerProperty
  :: SDL_PropertiesID -> CString -> Ptr () -> IO (Ptr ())

sdlGetPointerProperty :: SDL_PropertiesID -> String -> Ptr () -> IO (Ptr ())
sdlGetPointerProperty props name def =
  withCString name (\cName -> c_SDL_GetPointerProperty props cName def)

foreign import ccall unsafe "SDL_PollEvent" c_SDL_PollEvent
  :: EventPtr -> IO CBool

sdlPollEvent :: EventPtr -> IO Bool
sdlPollEvent ptr = fromCBool <$> c_SDL_PollEvent ptr

foreign import ccall unsafe "SDL_PumpEvents" c_SDL_PumpEvents
  :: IO ()

sdlPumpEvents :: IO ()
sdlPumpEvents = c_SDL_PumpEvents

foreign import ccall unsafe "SDL_GetKeyboardState" c_SDL_GetKeyboardState
  :: Ptr CInt -> IO (Ptr Word8)

foreign import ccall unsafe "SDL_GetKeyFromScancode" c_SDL_GetKeyFromScancode
  :: CInt -> SDL_Keymod -> CBool -> IO SDL_Keycode

sdlGetKeyboardState :: IO (Ptr Word8, Int)
sdlGetKeyboardState =
  alloca $ \lenPtr -> do
    ptr <- c_SDL_GetKeyboardState lenPtr
    len <- peek lenPtr
    pure (ptr, fromIntegral len)

sdlGetKeyFromScancode :: Int -> SDL_Keymod -> Bool -> IO SDL_Keycode
sdlGetKeyFromScancode scancode modstate keyEvent =
  c_SDL_GetKeyFromScancode (fromIntegral scancode) modstate (if keyEvent then 1 else 0)

foreign import ccall unsafe "SDL_GetMouseState" c_SDL_GetMouseState
  :: Ptr CFloat -> Ptr CFloat -> IO Word32

sdlGetMouseState :: Ptr CFloat -> Ptr CFloat -> IO Word32
sdlGetMouseState = c_SDL_GetMouseState

foreign import ccall unsafe "SDL_GetWindowSize" c_SDL_GetWindowSize
  :: Ptr SDL_Window -> Ptr CInt -> Ptr CInt -> IO ()

sdlGetWindowSize :: Window -> IO (Int, Int)
sdlGetWindowSize (Window win) =
  alloca $ \wPtr ->
    alloca $ \hPtr -> do
      c_SDL_GetWindowSize win wPtr hPtr
      w <- peek wPtr
      h <- peek hPtr
      pure (fromIntegral w, fromIntegral h)

foreign import ccall unsafe "SDL_GetTicks" c_SDL_GetTicks
  :: IO Word64

sdlGetTicks :: IO Word64
sdlGetTicks = c_SDL_GetTicks

-- SDL_image

foreign import ccall unsafe "IMG_LoadTexture" c_IMG_LoadTexture
  :: Ptr SDL_Renderer -> CString -> IO (Ptr SDL_Texture)

imgLoadTexture :: Renderer -> FilePath -> IO (Maybe Texture)
imgLoadTexture (Renderer r) path =
  withCString path $ \cPath -> do
    ptr <- c_IMG_LoadTexture r cPath
    pure $ if ptr == nullPtr then Nothing else Just (Texture ptr)

foreign import ccall unsafe "IMG_Load" c_IMG_Load
  :: CString -> IO (Ptr SDL_Surface)

imgLoadSurface :: FilePath -> IO (Maybe Surface)
imgLoadSurface path =
  withCString path $ \cPath -> do
    ptr <- c_IMG_Load cPath
    pure $ if ptr == nullPtr then Nothing else Just (Surface ptr)

foreign import ccall unsafe "SDL_DestroySurface" c_SDL_DestroySurface
  :: Ptr SDL_Surface -> IO ()

sdlDestroySurface :: Surface -> IO ()
sdlDestroySurface (Surface ptr) = c_SDL_DestroySurface ptr

foreign import ccall unsafe "SDL_LockSurface" c_SDL_LockSurface
  :: Ptr SDL_Surface -> IO CBool

foreign import ccall unsafe "SDL_UnlockSurface" c_SDL_UnlockSurface
  :: Ptr SDL_Surface -> IO ()

sdlLockSurface :: Surface -> IO Bool
sdlLockSurface (Surface ptr) = fromCBool <$> c_SDL_LockSurface ptr

sdlUnlockSurface :: Surface -> IO ()
sdlUnlockSurface (Surface ptr) = c_SDL_UnlockSurface ptr

foreign import ccall unsafe "SDL_ConvertSurface" c_SDL_ConvertSurface
  :: Ptr SDL_Surface -> SDL_PixelFormat -> IO (Ptr SDL_Surface)

sdlConvertSurface :: Surface -> SDL_PixelFormat -> IO (Maybe Surface)
sdlConvertSurface (Surface ptr) fmt = do
  converted <- c_SDL_ConvertSurface ptr fmt
  pure $ if converted == nullPtr then Nothing else Just (Surface converted)

foreign import ccall unsafe "SDL_DestroyTexture" c_SDL_DestroyTexture
  :: Ptr SDL_Texture -> IO ()

sdlDestroyTexture :: Texture -> IO ()
sdlDestroyTexture (Texture ptr) = c_SDL_DestroyTexture ptr

-- SDL_ttf

foreign import ccall unsafe "TTF_Init" c_TTF_Init :: IO CBool

foreign import ccall unsafe "TTF_Quit" c_TTF_Quit :: IO ()

foreign import ccall unsafe "TTF_OpenFont" c_TTF_OpenFont
  :: CString -> CFloat -> IO (Ptr TTF_Font)

foreign import ccall unsafe "TTF_CloseFont" c_TTF_CloseFont
  :: Ptr TTF_Font -> IO ()

foreign import ccall unsafe "TTF_SetFontSDF" c_TTF_SetFontSDF
  :: Ptr TTF_Font -> CBool -> IO CBool

foreign import ccall unsafe "TTF_GetFontSDF" c_TTF_GetFontSDF
  :: Ptr TTF_Font -> IO CBool

foreign import ccall unsafe "TTF_CreateRendererTextEngine" c_TTF_CreateRendererTextEngine
  :: Ptr SDL_Renderer -> IO (Ptr TTF_TextEngine)

foreign import ccall unsafe "TTF_DestroyRendererTextEngine" c_TTF_DestroyRendererTextEngine
  :: Ptr TTF_TextEngine -> IO ()

foreign import ccall unsafe "TTF_CreateGPUTextEngine" c_TTF_CreateGPUTextEngine
  :: Ptr SDL_GPUDevice -> IO (Ptr TTF_TextEngine)

foreign import ccall unsafe "TTF_CreateGPUTextEngineWithProperties" c_TTF_CreateGPUTextEngineWithProperties
  :: SDL_PropertiesID -> IO (Ptr TTF_TextEngine)

foreign import ccall unsafe "TTF_DestroyGPUTextEngine" c_TTF_DestroyGPUTextEngine
  :: Ptr TTF_TextEngine -> IO ()

foreign import ccall unsafe "TTF_CreateText" c_TTF_CreateText
  :: Ptr TTF_TextEngine -> Ptr TTF_Font -> CString -> CSize -> IO (Ptr TTF_Text)

foreign import ccall unsafe "TTF_DestroyText" c_TTF_DestroyText
  :: Ptr TTF_Text -> IO ()

foreign import ccall unsafe "TTF_SetTextPosition" c_TTF_SetTextPosition
  :: Ptr TTF_Text -> CInt -> CInt -> IO CBool

foreign import ccall unsafe "TTF_DrawRendererText" c_TTF_DrawRendererText
  :: Ptr TTF_Text -> CFloat -> CFloat -> IO CBool

ttfInit :: IO Bool
ttfInit = fromCBool <$> c_TTF_Init

ttfQuit :: IO ()
ttfQuit = c_TTF_Quit

ttfOpenFont :: FilePath -> Float -> IO (Maybe Font)
ttfOpenFont path size =
  withCString path $ \cPath -> do
    ptr <- c_TTF_OpenFont cPath (realToFrac size)
    pure $ if ptr == nullPtr then Nothing else Just (Font ptr)

ttfCloseFont :: Font -> IO ()
ttfCloseFont (Font ptr) = c_TTF_CloseFont ptr

ttfSetFontSDF :: Font -> Bool -> IO Bool
ttfSetFontSDF (Font ptr) enabled =
  fromCBool <$> c_TTF_SetFontSDF ptr (if enabled then 1 else 0)

ttfGetFontSDF :: Font -> IO Bool
ttfGetFontSDF (Font ptr) = fromCBool <$> c_TTF_GetFontSDF ptr

ttfCreateRendererTextEngine :: Renderer -> IO (Maybe TextEngine)
ttfCreateRendererTextEngine (Renderer r) = do
  ptr <- c_TTF_CreateRendererTextEngine r
  pure $ if ptr == nullPtr then Nothing else Just (TextEngine ptr)

ttfDestroyRendererTextEngine :: TextEngine -> IO ()
ttfDestroyRendererTextEngine (TextEngine ptr) = c_TTF_DestroyRendererTextEngine ptr

ttfCreateGPUTextEngine :: GPUDevice -> IO (Maybe TextEngine)
ttfCreateGPUTextEngine (GPUDevice dev) = do
  ptr <- c_TTF_CreateGPUTextEngine dev
  pure $ if ptr == nullPtr then Nothing else Just (TextEngine ptr)

ttfCreateGPUTextEngineWithProperties :: SDL_PropertiesID -> IO (Maybe TextEngine)
ttfCreateGPUTextEngineWithProperties props = do
  ptr <- c_TTF_CreateGPUTextEngineWithProperties props
  pure $ if ptr == nullPtr then Nothing else Just (TextEngine ptr)

ttfDestroyGPUTextEngine :: TextEngine -> IO ()
ttfDestroyGPUTextEngine (TextEngine ptr) = c_TTF_DestroyGPUTextEngine ptr

ttfCreateText :: TextEngine -> Font -> String -> IO (Maybe Text)
ttfCreateText (TextEngine eng) (Font font) str =
  withCString str $ \cStr -> do
    ptr <- c_TTF_CreateText eng font cStr 0
    pure $ if ptr == nullPtr then Nothing else Just (Text ptr)

ttfDestroyText :: Text -> IO ()
ttfDestroyText (Text ptr) = c_TTF_DestroyText ptr

ttfSetTextPosition :: Text -> Int -> Int -> IO Bool
ttfSetTextPosition (Text ptr) x y =
  fromCBool <$> c_TTF_SetTextPosition ptr (fromIntegral x) (fromIntegral y)

ttfDrawRendererText :: Text -> Float -> Float -> IO Bool
ttfDrawRendererText (Text txt) x y =
  fromCBool <$> c_TTF_DrawRendererText txt (realToFrac x) (realToFrac y)

-- GPU text draw data

foreign import ccall unsafe "TTF_GetGPUTextDrawData" c_TTF_GetGPUTextDrawData
  :: Ptr TTF_Text -> IO (Ptr TTF_GPUAtlasDrawSequence)

ttfGetGPUTextDrawData :: Text -> IO (Ptr TTF_GPUAtlasDrawSequence)
ttfGetGPUTextDrawData (Text txt) = c_TTF_GetGPUTextDrawData txt

-- SDL_mixer

foreign import ccall unsafe "MIX_CreateMixerDevice" c_MIX_CreateMixerDevice
  :: SDL_AudioDeviceID -> Ptr SDL_AudioSpec -> IO (Ptr MIX_Mixer)

foreign import ccall unsafe "MIX_Init" c_MIX_Init
  :: IO CBool

foreign import ccall unsafe "MIX_Quit" c_MIX_Quit
  :: IO ()

foreign import ccall unsafe "MIX_DestroyMixer" c_MIX_DestroyMixer
  :: Ptr MIX_Mixer -> IO ()

foreign import ccall unsafe "MIX_CreateTrack" c_MIX_CreateTrack
  :: Ptr MIX_Mixer -> IO (Ptr MIX_Track)

foreign import ccall unsafe "MIX_DestroyTrack" c_MIX_DestroyTrack
  :: Ptr MIX_Track -> IO ()

foreign import ccall unsafe "MIX_LoadAudio" c_MIX_LoadAudio
  :: Ptr MIX_Mixer -> CString -> CBool -> IO (Ptr MIX_Audio)

foreign import ccall unsafe "MIX_DestroyAudio" c_MIX_DestroyAudio
  :: Ptr MIX_Audio -> IO ()

foreign import ccall unsafe "MIX_SetTrackAudio" c_MIX_SetTrackAudio
  :: Ptr MIX_Track -> Ptr MIX_Audio -> IO CBool

foreign import ccall unsafe "MIX_PlayTrack" c_MIX_PlayTrack
  :: Ptr MIX_Track -> SDL_PropertiesID -> IO CBool

foreign import ccall unsafe "MIX_SetTrackLoops" c_MIX_SetTrackLoops
  :: Ptr MIX_Track -> CInt -> IO CBool

foreign import ccall unsafe "MIX_SetTrackGain" c_MIX_SetTrackGain
  :: Ptr MIX_Track -> CFloat -> IO CBool

foreign import ccall unsafe "MIX_GetTrackGain" c_MIX_GetTrackGain
  :: Ptr MIX_Track -> IO CFloat

foreign import ccall unsafe "MIX_PlayAudio" c_MIX_PlayAudio
  :: Ptr MIX_Mixer -> Ptr MIX_Audio -> IO CBool

foreign import ccall unsafe "MIX_StopTrack" c_MIX_StopTrack
  :: Ptr MIX_Track -> Int64 -> IO CBool

foreign import ccall unsafe "MIX_TrackPlaying" c_MIX_TrackPlaying
  :: Ptr MIX_Track -> IO CBool

mixCreateMixerDevice :: SDL_AudioDeviceID -> IO (Maybe Mixer)
mixCreateMixerDevice devid = do
  ptr <- c_MIX_CreateMixerDevice devid nullPtr
  pure $ if ptr == nullPtr then Nothing else Just (Mixer ptr)

mixInit :: IO Bool
mixInit = fromCBool <$> c_MIX_Init

mixQuit :: IO ()
mixQuit = c_MIX_Quit

mixDestroyMixer :: Mixer -> IO ()
mixDestroyMixer (Mixer mixer) = c_MIX_DestroyMixer mixer

mixCreateTrack :: Mixer -> IO (Maybe Track)
mixCreateTrack (Mixer mixer) = do
  ptr <- c_MIX_CreateTrack mixer
  pure $ if ptr == nullPtr then Nothing else Just (Track ptr)

mixDestroyTrack :: Track -> IO ()
mixDestroyTrack (Track track) = c_MIX_DestroyTrack track

mixLoadAudio :: Mixer -> String -> Bool -> IO (Maybe Audio)
mixLoadAudio (Mixer mixer) path predecode =
  withCString path $ \cPath -> do
    ptr <- c_MIX_LoadAudio mixer cPath (if predecode then 1 else 0)
    pure $ if ptr == nullPtr then Nothing else Just (Audio ptr)

mixDestroyAudio :: Audio -> IO ()
mixDestroyAudio (Audio audio) = c_MIX_DestroyAudio audio

mixSetTrackAudio :: Track -> Audio -> IO Bool
mixSetTrackAudio (Track track) (Audio audio) =
  fromCBool <$> c_MIX_SetTrackAudio track audio

mixPlayTrack :: Track -> SDL_PropertiesID -> IO Bool
mixPlayTrack (Track track) options =
  fromCBool <$> c_MIX_PlayTrack track options

mixSetTrackLoops :: Track -> Int -> IO Bool
mixSetTrackLoops (Track track) loops =
  fromCBool <$> c_MIX_SetTrackLoops track (fromIntegral loops)

mixSetTrackGain :: Track -> Float -> IO Bool
mixSetTrackGain (Track track) gain =
  fromCBool <$> c_MIX_SetTrackGain track (realToFrac gain)

mixGetTrackGain :: Track -> IO Float
mixGetTrackGain (Track track) =
  realToFrac <$> c_MIX_GetTrackGain track

mixPlayAudio :: Mixer -> Audio -> IO Bool
mixPlayAudio (Mixer mixer) (Audio audio) =
  fromCBool <$> c_MIX_PlayAudio mixer audio

mixStopTrack :: Track -> Int64 -> IO Bool
mixStopTrack (Track track) fadeFrames =
  fromCBool <$> c_MIX_StopTrack track fadeFrames

mixTrackPlaying :: Track -> IO Bool
mixTrackPlaying (Track track) =
  fromCBool <$> c_MIX_TrackPlaying track

-- GPU shaders and render state

foreign import ccall unsafe "SDL_CreateGPUSampler" c_SDL_CreateGPUSampler
  :: Ptr SDL_GPUDevice -> Ptr GPUSamplerCreateInfo -> IO (Ptr SDL_GPUSampler)

foreign import ccall unsafe "SDL_ReleaseGPUSampler" c_SDL_ReleaseGPUSampler
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUSampler -> IO ()

foreign import ccall unsafe "SDL_CreateGPUShader" c_SDL_CreateGPUShader
  :: Ptr SDL_GPUDevice -> Ptr GPUShaderCreateInfo -> IO (Ptr SDL_GPUShader)

foreign import ccall unsafe "SDL_ReleaseGPUShader" c_SDL_ReleaseGPUShader
  :: Ptr SDL_GPUDevice -> Ptr SDL_GPUShader -> IO ()

foreign import ccall unsafe "SDL_CreateGPURenderState" c_SDL_CreateGPURenderState
  :: Ptr SDL_Renderer -> Ptr GPURenderStateCreateInfo -> IO (Ptr SDL_GPURenderState)

foreign import ccall unsafe "SDL_DestroyGPURenderState" c_SDL_DestroyGPURenderState
  :: Ptr SDL_GPURenderState -> IO ()

foreign import ccall unsafe "SDL_SetGPURenderState" c_SDL_SetGPURenderState
  :: Ptr SDL_Renderer -> Ptr SDL_GPURenderState -> IO CBool

foreign import ccall unsafe "SDL_SetGPURenderStateFragmentUniforms" c_SDL_SetGPURenderStateFragmentUniforms
  :: Ptr SDL_GPURenderState -> Word32 -> Ptr () -> Word32 -> IO CBool

sdlCreateGPUShader :: GPUDevice -> GPUShaderCreateInfo -> IO (Maybe GPUShader)
sdlCreateGPUShader (GPUDevice dev) info =
  with info $ \ptr -> do
    shader <- c_SDL_CreateGPUShader dev ptr
    pure $ if shader == nullPtr then Nothing else Just (GPUShader shader)

sdlCreateGPUSampler :: GPUDevice -> GPUSamplerCreateInfo -> IO (Maybe GPUSampler)
sdlCreateGPUSampler (GPUDevice dev) info =
  with info $ \ptr -> do
    sampler <- c_SDL_CreateGPUSampler dev ptr
    pure $ if sampler == nullPtr then Nothing else Just (GPUSampler sampler)

sdlReleaseGPUSampler :: GPUDevice -> GPUSampler -> IO ()
sdlReleaseGPUSampler (GPUDevice dev) (GPUSampler sampler) =
  c_SDL_ReleaseGPUSampler dev sampler

sdlReleaseGPUShader :: GPUDevice -> GPUShader -> IO ()
sdlReleaseGPUShader (GPUDevice dev) (GPUShader shader) =
  c_SDL_ReleaseGPUShader dev shader

sdlCreateGPURenderState :: Renderer -> GPURenderStateCreateInfo -> IO (Maybe GPURenderState)
sdlCreateGPURenderState (Renderer r) info =
  with info $ \ptr -> do
    state <- c_SDL_CreateGPURenderState r ptr
    pure $ if state == nullPtr then Nothing else Just (GPURenderState state)

sdlDestroyGPURenderState :: GPURenderState -> IO ()
sdlDestroyGPURenderState (GPURenderState state) = c_SDL_DestroyGPURenderState state

sdlSetGPURenderState :: Renderer -> Maybe GPURenderState -> IO Bool
sdlSetGPURenderState (Renderer r) state = do
  let ptr = maybePtr state (\(GPURenderState s) -> s)
  fromCBool <$> c_SDL_SetGPURenderState r ptr

sdlSetGPURenderStateFragmentUniforms
  :: GPURenderState
  -> Word32
  -> Ptr ()
  -> Word32
  -> IO Bool
sdlSetGPURenderStateFragmentUniforms (GPURenderState state) slot ptr len =
  fromCBool <$> c_SDL_SetGPURenderStateFragmentUniforms state slot ptr len
