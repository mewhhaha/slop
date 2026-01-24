{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Seedl.SDL.Raw
  ( SDL_InitFlags
  , SDL_WindowFlags
  , SDL_PixelFormat
  , SDL_TextureAccess
  , SDL_GPUShaderFormat
  , SDL_GPUShaderStage
  , SDL_EventType
  , SDL_PropertiesID
  , Window(..)
  , Renderer(..)
  , Texture(..)
  , GPUDevice(..)
  , GPUShader(..)
  , GPURenderState(..)
  , TextEngine(..)
  , Font(..)
  , Text(..)
  , SDL_Event
  , FRect(..)
  , FPoint(..)
  , GPUShaderCreateInfo(..)
  , GPURenderStateCreateInfo(..)
  , sdlInitVideo
  , sdlEventQuit
  , sdlGPUShaderFormatSpirv
  , sdlGPUShaderStageVertex
  , sdlGPUShaderStageFragment
  , sdlInit
  , sdlQuit
  , sdlGetError
  , sdlCreateWindow
  , sdlDestroyWindow
  , sdlSetWindowResizable
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
  , sdlTextureAccessTarget
  , sdlPixelFormatRGBA8888
  , sdlPollEvent
  , sdlPumpEvents
  , sdlGetKeyboardState
  , sdlGetMouseState
  , sdlGetWindowSize
  , allocaEvent
  , peekEventType
  , sdlGetTicks
  , imgLoadTexture
  , sdlDestroyTexture
  , ttfInit
  , ttfQuit
  , ttfOpenFont
  , ttfCloseFont
  , ttfSetFontSDF
  , ttfGetFontSDF
  , ttfCreateRendererTextEngine
  , ttfDestroyRendererTextEngine
  , ttfCreateGPUTextEngine
  , ttfDestroyGPUTextEngine
  , ttfCreateText
  , ttfDestroyText
  , ttfDrawRendererText
  , TTF_GPUAtlasDrawSequence
  , ttfGetGPUTextDrawData
  , sdlCreateGPUShader
  , sdlReleaseGPUShader
  , sdlCreateGPURenderState
  , sdlDestroyGPURenderState
  , sdlSetGPURenderState
  , sdlSetGPURenderStateFragmentUniforms
  ) where

import Data.Bits (shiftL)
import Data.Proxy (Proxy (..))
import Data.Word (Word32, Word64, Word8)
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

type SDL_EventType = Word32

type SDL_PropertiesID = Word32

sdlInitVideo :: SDL_InitFlags
sdlInitVideo = 0x00000020

sdlEventQuit :: SDL_EventType
sdlEventQuit = 0x00000100

sdlGPUShaderFormatSpirv :: SDL_GPUShaderFormat
sdlGPUShaderFormatSpirv = 1 `shiftL` 1

sdlGPUShaderStageVertex :: SDL_GPUShaderStage
sdlGPUShaderStageVertex = 0

sdlGPUShaderStageFragment :: SDL_GPUShaderStage
sdlGPUShaderStageFragment = 1

sdlTextureAccessTarget :: SDL_TextureAccess
sdlTextureAccessTarget = 2

sdlPixelFormatRGBA8888 :: SDL_PixelFormat
sdlPixelFormatRGBA8888 = 0x16462004

-- Opaque handles

data SDL_Window
newtype Window = Window (Ptr SDL_Window) deriving (Eq, Show)

data SDL_Renderer
newtype Renderer = Renderer (Ptr SDL_Renderer) deriving (Eq, Show)

data SDL_Texture
newtype Texture = Texture (Ptr SDL_Texture) deriving (Eq, Show)

data SDL_GPUDevice
newtype GPUDevice = GPUDevice (Ptr SDL_GPUDevice) deriving (Eq, Show)

data SDL_GPUShader
newtype GPUShader = GPUShader (Ptr SDL_GPUShader) deriving (Eq, Show)

data SDL_GPURenderState
newtype GPURenderState = GPURenderState (Ptr SDL_GPURenderState) deriving (Eq, Show)

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

sdlGetKeyboardState :: IO (Ptr Word8, Int)
sdlGetKeyboardState =
  alloca $ \lenPtr -> do
    ptr <- c_SDL_GetKeyboardState lenPtr
    len <- peek lenPtr
    pure (ptr, fromIntegral len)

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

foreign import ccall unsafe "TTF_DestroyGPUTextEngine" c_TTF_DestroyGPUTextEngine
  :: Ptr TTF_TextEngine -> IO ()

foreign import ccall unsafe "TTF_CreateText" c_TTF_CreateText
  :: Ptr TTF_TextEngine -> Ptr TTF_Font -> CString -> CSize -> IO (Ptr TTF_Text)

foreign import ccall unsafe "TTF_DestroyText" c_TTF_DestroyText
  :: Ptr TTF_Text -> IO ()

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

ttfDestroyGPUTextEngine :: TextEngine -> IO ()
ttfDestroyGPUTextEngine (TextEngine ptr) = c_TTF_DestroyGPUTextEngine ptr

ttfCreateText :: TextEngine -> Font -> String -> IO (Maybe Text)
ttfCreateText (TextEngine eng) (Font font) str =
  withCString str $ \cStr -> do
    ptr <- c_TTF_CreateText eng font cStr 0
    pure $ if ptr == nullPtr then Nothing else Just (Text ptr)

ttfDestroyText :: Text -> IO ()
ttfDestroyText (Text ptr) = c_TTF_DestroyText ptr

ttfDrawRendererText :: Text -> Float -> Float -> IO Bool
ttfDrawRendererText (Text txt) x y =
  fromCBool <$> c_TTF_DrawRendererText txt (realToFrac x) (realToFrac y)

-- GPU text draw data

data TTF_GPUAtlasDrawSequence

foreign import ccall unsafe "TTF_GetGPUTextDrawData" c_TTF_GetGPUTextDrawData
  :: Ptr TTF_Text -> IO (Ptr TTF_GPUAtlasDrawSequence)

ttfGetGPUTextDrawData :: Text -> IO (Ptr TTF_GPUAtlasDrawSequence)
ttfGetGPUTextDrawData (Text txt) = c_TTF_GetGPUTextDrawData txt

-- GPU shaders and render state

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
