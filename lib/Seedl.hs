{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

module Seedl
  ( Config(..)
  , defaultConfig
  , WindowM
  , Window(..)
  , Render
  , runWindowM
  , runRender
  , render
  , runWindow
  , runWindowIO
  , askWindow
  , liftWindow
  , liftRender
  , loop
  , clear
  , present
  , setDrawColor
  , drawLine
  , drawRect
  , fillRect
  , drawTexture
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
  , keyDown
  , keyPressed
  , keyReleased
  , mouseButtonDown
  , mouseButtonPressed
  , mouseButtonReleased
  , Color(..)
  , Vec2(..)
  , Vec4(..)
  , rect
  , point
  , rgb
  , rgba
  , Texture
  , Font (..)
  , ShaderAsset(..)
  , SdfFontAsset(..)
  , setFontSDF
  , getFontSDF
  , Text
  , Shader
  , Drawable(..)
  , DrawItem(..)
  , Line(..)
  , RectOutline(..)
  , RectFill(..)
  , Sprite(..)
  , Label(..)
  , TextDraw(..)
  , text
  , ShaderUniform(..)
  , AssetId(..)
  , AnyAssetId(..)
  , AssetStatus(..)
  , AssetUpdate
  , AssetLoader(..)
  , TextureAsset(..)
  , FontAsset(..)
  , TextAsset(..)
  , loadAsset
  , loadAssetAsync
  , awaitAsset
  , getAsset
  , getAssetStatus
  , removeAsset
  , removeAssets
  , removeAssets_
  , removeAllAssets
  , reloadAssetAsync
  , awaitAssetUpdate
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
  , withShader
  , setShaderUniformCached
  , setShaderUniformBytesCached
  , withShaderUniform
  ) where

import Control.Exception (SomeException, bracket, bracket_, finally, try)
import Control.Monad (unless, void)
import Control.Concurrent (ThreadId, forkIO)
import Control.Concurrent.STM
  ( TMVar
  , TQueue
  , TVar
  , atomically
  , newEmptyTMVar
  , newTQueueIO
  , newTVarIO
  , putTMVar
  , readTMVar
  , readTQueue
  , readTVar
  , tryPutTMVar
  , writeTQueue
  , writeTVar
  )
import Control.Monad.Reader (MonadReader (..), ReaderT (..))
import Control.Monad.IO.Class (MonadIO (..))
import Data.Bits ((.&.), shiftL)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Internal as BSI
import Data.Dynamic (Dynamic, fromDynamic, toDyn)
import Data.IntSet (IntSet)
import qualified Data.IntSet as IntSet
import Data.IORef (IORef, atomicModifyIORef', newIORef)
import qualified Data.Map.Strict as Map
import Data.Proxy (Proxy (..))
import Data.Typeable (TypeRep, Typeable, typeOf, typeRep)
import Data.Word (Word8, Word32, Word64)
import Foreign (Ptr, Storable (..), alloca, castPtr, nullPtr, peek, poke, pokeByteOff, with)
import Foreign.C.String (withCString)
import Foreign.C.Types (CFloat (..))

import qualified Seedl.SDL.Raw as SDL
import Seedl.SDL.Raw
  ( FPoint (..)
  , FRect (..)
  , Font (..)
  , GPUDevice (..)
  , GPUShader (..)
  , GPURenderState (..)
  , GPURenderStateCreateInfo (..)
  , GPUShaderCreateInfo (..)
  , Renderer (..)
  , Text
  , TextEngine (..)
  , Texture
  , imgLoadTexture
  , sdlCreateGPURenderer
  , sdlCreateGPUShader
  , sdlCreateGPURenderState
  , sdlCreateWindow
  , sdlDestroyGPURenderState
  , sdlDestroyRenderer
  , sdlDestroyTexture
  , sdlDestroyWindow
  , sdlEventQuit
  , sdlGetError
  , sdlGetGPURendererDevice
  , sdlGetKeyboardState
  , sdlGetTicks
  , sdlGPUShaderFormatSpirv
  , sdlGPUShaderStageFragment
  , sdlInit
  , sdlInitVideo
  , sdlGetMouseState
  , sdlPollEvent
  , sdlPumpEvents
  , sdlQuit
  , sdlReleaseGPUShader
  , sdlRenderClear
  , sdlRenderFillRect
  , sdlRenderLine
  , sdlRenderPresent
  , sdlRenderRect
  , sdlRenderTexture
  , sdlSetWindowResizable
  , sdlSetGPURenderStateFragmentUniforms
  , sdlSetRenderDrawColorFloat
  , sdlSetGPURenderState
  , ttfCreateRendererTextEngine
  , ttfCreateText
  , ttfDestroyRendererTextEngine
  , ttfDestroyText
  , ttfDrawRendererText
  , ttfInit
  , ttfGetFontSDF
  , ttfOpenFont
  , ttfQuit
  , ttfCloseFont
  , ttfSetFontSDF
  , allocaEvent
  , peekEventType
  )

data Config = Config
  { windowTitle :: String
  , windowWidth :: Int
  , windowHeight :: Int
  , windowResizable :: Bool
  }
  deriving (Eq, Show)

defaultConfig :: Config
defaultConfig = Config
  { windowTitle = "Seedl"
  , windowWidth = 1280
  , windowHeight = 720
  , windowResizable = True
  }


data Window = Window
  { appWindow :: SDL.Window
  , appRenderer :: Renderer
  , appGPUDevice :: GPUDevice
  , appTextEngine :: TextEngine
  , appAssets :: AssetManager
  , appRenderState :: IORef RenderState
  }

newtype WindowM a = WindowM (ReaderT Window IO a)
  deriving (Functor, Applicative, Monad, MonadIO, MonadReader Window)

newtype Render a = Render
  { unRender :: ReaderT Window IO a
  }
  deriving (Functor, Applicative, Monad, MonadIO, MonadReader Window)

data RenderState = RenderState
  { rsUniformCache :: !(Map.Map UniformKey ByteString)
  , rsTextCache :: !(Map.Map TextCacheKey CachedText)
  , rsFrameId :: !Word64
  }

type UniformKey = (Ptr (), Word32)

type TextCacheKey = (Ptr (), String)

data CachedText = CachedText
  { ctText :: !Text
  , ctLastUsed :: !Word64
  }

runWindowM :: Window -> WindowM a -> IO a
runWindowM window (WindowM action) =
  runReaderT action window

runRender :: Window -> Render a -> IO a
runRender window (Render action) =
  runReaderT action window

runWindow :: Config -> WindowM a -> IO a
runWindow cfg action = runWindowIO cfg (\window -> runWindowM window action)

askWindow :: WindowM Window
askWindow = ask

liftWindow :: (Window -> IO a) -> WindowM a
liftWindow f = do
  window <- ask
  liftIO (f window)

liftRender :: (Window -> IO a) -> Render a
liftRender f = do
  window <- ask
  liftIO (f window)

render :: Render a -> WindowM a
render action = do
  window <- ask
  liftIO (runRender window action)

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

class Typeable (AssetType spec) => AssetLoader spec where
  type AssetType spec
  loadAssetIO :: Window -> spec -> IO (Either String (AssetType spec))
  unloadAssetIO :: Window -> spec -> AssetType spec -> IO ()
  assetLabel :: spec -> String

data TextureAsset = TextureAsset FilePath
  deriving (Eq, Show)

data FontAsset = FontAsset FilePath Float
  deriving (Eq, Show)

data TextAsset = TextAsset Font String
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

instance AssetLoader TextureAsset where
  type AssetType TextureAsset = Texture
  loadAssetIO app (TextureAsset path) = do
    result <- imgLoadTexture (appRenderer app) path
    case result of
      Nothing -> Left <$> sdlGetError
      Just tex -> pure (Right tex)
  unloadAssetIO _ _ = sdlDestroyTexture
  assetLabel (TextureAsset path) = path

instance AssetLoader FontAsset where
  type AssetType FontAsset = Font
  loadAssetIO _ (FontAsset path size) = do
    result <- ttfOpenFont path size
    case result of
      Nothing -> Left <$> sdlGetError
      Just font -> pure (Right font)
  unloadAssetIO _ _ = ttfCloseFont
  assetLabel (FontAsset path _) = path

instance AssetLoader TextAsset where
  type AssetType TextAsset = Text
  loadAssetIO app (TextAsset font str) = do
    result <- ttfCreateText (appTextEngine app) font str
    case result of
      Nothing -> Left <$> sdlGetError
      Just textObj -> pure (Right textObj)
  unloadAssetIO _ _ = ttfDestroyText
  assetLabel (TextAsset _ str) = str

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

instance AssetLoader ShaderAsset where
  type AssetType ShaderAsset = Shader
  loadAssetIO app spec = do
    let bytes = shaderSpirvBytes spec
    let samplers = shaderSamplers spec
    let storageTextures = shaderStorageTextures spec
    let storageBuffers = shaderStorageBuffers spec
    let uniformBuffers = shaderUniformBuffers spec
    Right <$> createShaderFromSpirvWithIO app bytes samplers storageTextures storageBuffers uniformBuffers
  unloadAssetIO _ _ = destroyShaderIO
  assetLabel _ = "shader"

data AssetManager = AssetManager
  { amState :: !(TVar ManagerState)
  , amQueue :: !(TQueue AssetCommand)
  , amThread :: !ThreadId
  }

data ManagerState = ManagerState
  { msNextId :: !Int
  , msAssets :: !(Map.Map Int AssetSlot)
  }

data AssetSlot = AssetSlot
  { slotType :: !TypeRep
  , slotState :: !SlotState
  }

data SlotState
  = SlotLoading !(TMVar (Either String ()))
  | SlotReady !Dynamic !(IO ())
  | SlotFailed !String

data RequestMode = RequestLoad | RequestReload

data AssetCommand where
  AssetCommand :: AssetLoader spec => Int -> spec -> RequestMode -> Maybe (TMVar (Either String ())) -> AssetCommand
  StopCommand :: TMVar () -> AssetCommand

initAssetManager :: Window -> IO AssetManager
initAssetManager app = do
  stateVar <- newTVarIO ManagerState { msNextId = 0, msAssets = Map.empty }
  queue <- newTQueueIO
  tid <- forkIO (assetWorker app stateVar queue)
  pure AssetManager
    { amState = stateVar
    , amQueue = queue
    , amThread = tid
    }

shutdownAssetManager :: Window -> AssetManager -> IO ()
shutdownAssetManager app mgr = do
  stopVar <- atomically newEmptyTMVar
  atomically (writeTQueue (amQueue mgr) (StopCommand stopVar))
  atomically (readTMVar stopVar)
  cleanupAssets app mgr

cleanupAssets :: Window -> AssetManager -> IO ()
cleanupAssets app mgr = removeAllAssetsIO app mgr

removeAllAssetsIO :: Window -> AssetManager -> IO ()
removeAllAssetsIO app mgr = do
  entries <- atomically $ do
    st <- readTVar (amState mgr)
    writeTVar (amState mgr) st { msAssets = Map.empty }
    pure (Map.elems (msAssets st))
  mapM_ (finalizeEntry app) entries
  where
    finalizeEntry _ (AssetSlot _ (SlotFailed _)) = pure ()
    finalizeEntry _ (AssetSlot _ (SlotLoading var)) =
      void (atomically (tryPutTMVar var (Left "asset removed")))
    finalizeEntry app' (AssetSlot _ (SlotReady dyn finalizer)) = do
      case fromDynamic dyn :: Maybe Shader of
        Just shader -> evictShaderCacheIO app' shader
        Nothing -> pure ()
      case fromDynamic dyn :: Maybe Font of
        Just font -> evictTextCacheForFontIO app' font
        Nothing -> pure ()
      finalizer

assetWorker :: Window -> TVar ManagerState -> TQueue AssetCommand -> IO ()
assetWorker app stateVar queue = go
  where
    go = do
      cmd <- atomically (readTQueue queue)
      case cmd of
        StopCommand done -> atomically (putTMVar done ())
        AssetCommand assetId spec mode notify -> do
          result <- try @SomeException (loadAssetIO app spec)
          let resolved = case result of
                Left ex -> Left (show ex)
                Right ok -> ok
          case mode of
            RequestLoad -> finishLoad assetId spec resolved notify
            RequestReload -> finishReload assetId spec resolved notify
          go

    finishLoad :: forall spec. AssetLoader spec => Int -> spec -> Either String (AssetType spec) -> Maybe (TMVar (Either String ())) -> IO ()
    finishLoad assetId spec result _ = case result of
      Left err -> do
        atomically $ do
          st <- readTVar stateVar
          case Map.lookup assetId (msAssets st) of
            Just (AssetSlot typ (SlotLoading var)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotFailed err)) (msAssets st) }
              void (tryPutTMVar var (Left err))
            _ -> pure ()
      Right asset -> do
        let dyn = toDyn asset
        let finalizer = unloadAssetIO app spec asset
        let typ = typeOf asset
        cancelled <- atomically $ do
          st <- readTVar stateVar
          case Map.lookup assetId (msAssets st) of
            Just (AssetSlot _ (SlotLoading var)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotReady dyn finalizer)) (msAssets st) }
              void (tryPutTMVar var (Right ()))
              pure False
            Nothing -> pure True
            _ -> pure False
        if cancelled then finalizer else pure ()

    finishReload :: forall spec. AssetLoader spec => Int -> spec -> Either String (AssetType spec) -> Maybe (TMVar (Either String ())) -> IO ()
    finishReload assetId spec result notify = case result of
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
          case Map.lookup assetId (msAssets st) of
            Nothing -> pure (False, Nothing, True)
            Just (AssetSlot _ (SlotReady _ oldFin)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotReady dyn finalizer)) (msAssets st) }
              pure (True, Just oldFin, False)
            Just (AssetSlot _ (SlotFailed _)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotReady dyn finalizer)) (msAssets st) }
              pure (True, Nothing, False)
            Just (AssetSlot _ (SlotLoading _)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotReady dyn finalizer)) (msAssets st) }
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
  st <- readTVar (amState mgr)
  var <- newEmptyTMVar
  let newId = msNextId st
  let slot = AssetSlot (typeRep (Proxy :: Proxy a)) (SlotLoading var)
  writeTVar (amState mgr) st { msNextId = newId + 1, msAssets = Map.insert newId slot (msAssets st) }
  pure (AssetId newId, var)

loadAsset :: forall spec. AssetLoader spec => spec -> WindowM (Either String (AssetId (AssetType spec)))
loadAsset spec = do
  app <- ask
  let mgr = appAssets app
  (assetId, _) <- liftIO (registerLoading @(AssetType spec) mgr)
  result <- liftIO (try @SomeException (loadAssetIO app spec))
  let resolved = case result of
        Left ex -> Left (show ex)
        Right ok -> ok
  liftIO $ case resolved of
    Left err -> do
      atomically $ do
        st <- readTVar (amState mgr)
        case Map.lookup (unAssetId assetId) (msAssets st) of
          Just (AssetSlot typ (SlotLoading var)) -> do
            writeTVar (amState mgr) st { msAssets = Map.insert (unAssetId assetId) (AssetSlot typ (SlotFailed err)) (msAssets st) }
            void (tryPutTMVar var (Left err))
          _ -> pure ()
    Right asset -> do
      let dyn = toDyn asset
      let finalizer = unloadAssetIO app spec asset
      let typ = typeOf asset
      cancelled <- atomically $ do
        st <- readTVar (amState mgr)
        case Map.lookup (unAssetId assetId) (msAssets st) of
          Just (AssetSlot _ (SlotLoading var)) -> do
            writeTVar (amState mgr) st { msAssets = Map.insert (unAssetId assetId) (AssetSlot typ (SlotReady dyn finalizer)) (msAssets st) }
            void (tryPutTMVar var (Right ()))
            pure False
          Nothing -> pure True
          _ -> pure False
      if cancelled then finalizer else pure ()
  pure (fmap (const assetId) resolved)

loadAssetAsync :: forall spec. AssetLoader spec => spec -> WindowM (AssetId (AssetType spec))
loadAssetAsync spec = do
  app <- ask
  let mgr = appAssets app
  (assetId, _) <- liftIO (registerLoading @(AssetType spec) mgr)
  liftIO $ atomically $
    writeTQueue (amQueue mgr) (AssetCommand (unAssetId assetId) spec RequestLoad Nothing)
  pure assetId

reloadAssetAsync :: forall spec. AssetLoader spec => AssetId (AssetType spec) -> spec -> WindowM AssetUpdate
reloadAssetAsync assetId spec = do
  app <- ask
  let mgr = appAssets app
  notify <- liftIO (atomically newEmptyTMVar)
  exists <- liftIO $ atomically $ do
    st <- readTVar (amState mgr)
    pure (Map.member (unAssetId assetId) (msAssets st))
  if exists
    then do
      liftIO $ atomically $
        writeTQueue (amQueue mgr) (AssetCommand (unAssetId assetId) spec RequestReload (Just notify))
      pure (AssetUpdate notify)
    else do
      liftIO $ atomically (putTMVar notify (Left "asset not found"))
      pure (AssetUpdate notify)

awaitAssetUpdate :: AssetUpdate -> WindowM (Either String ())
awaitAssetUpdate (AssetUpdate var) = liftIO (atomically (readTMVar var))

awaitAsset :: forall a. Typeable a => AssetId a -> WindowM (Either String a)
awaitAsset assetId = do
  app <- ask
  let mgr = appAssets app
  mWait <- liftIO $ atomically $ do
    st <- readTVar (amState mgr)
    case Map.lookup (unAssetId assetId) (msAssets st) of
      Just (AssetSlot _ (SlotLoading var)) -> pure (Just var)
      _ -> pure Nothing
  case mWait of
    Just var -> do
      _ <- liftIO (atomically (readTMVar var))
      getAfterWait
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
  let mgr = appAssets app
  liftIO $ atomically $ do
    st <- readTVar (amState mgr)
    pure $ do
      slot <- Map.lookup (unAssetId assetId) (msAssets st)
      let typ = slotType slot
      let slotState' = slotState slot
      if typ /= typeRep (Proxy :: Proxy a)
        then Nothing
        else case slotState' of
          SlotLoading _ -> Just AssetLoading
          SlotFailed err -> Just (AssetFailed err)
          SlotReady dyn _ -> fromDynamic dyn >>= \value -> Just (AssetReady value)

removeAsset :: AssetId a -> WindowM Bool
removeAsset assetId = do
  app <- ask
  let mgr = appAssets app
  toFinalize <- liftIO $ atomically $ do
    st <- readTVar (amState mgr)
    case Map.lookup (unAssetId assetId) (msAssets st) of
      Nothing -> pure (Left False)
      Just slot -> do
        writeTVar (amState mgr) st { msAssets = Map.delete (unAssetId assetId) (msAssets st) }
        case slotState slot of
          SlotLoading var -> do
            void (tryPutTMVar var (Left "asset removed"))
            pure (Left True)
          SlotFailed _ -> pure (Left True)
          SlotReady dyn finalizer -> pure (Right (dyn, finalizer))
  case toFinalize of
    Left ok -> pure ok
    Right (dyn, finalizer) -> do
      case fromDynamic dyn :: Maybe Shader of
        Just shader -> liftIO (evictShaderCacheIO app shader)
        Nothing -> pure ()
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
  liftIO (removeAllAssetsIO app (appAssets app))


data Frame = Frame
  { frameDelta :: Float
  , frameTime :: Float
  , frameTicks :: Word64
  , frameQuitRequested :: Bool
  , frameInput :: InputFrame
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

newtype Key = Key Int
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

mouseButtonMask :: MouseButton -> Word32
mouseButtonMask (MouseButton button) = 1 `shiftL` fromIntegral (button - 1)

keyDown :: Key -> InputState -> Bool
keyDown (Key scancode) InputState { inputKeysDown = keys } =
  IntSet.member scancode keys

keyPressed :: Key -> InputFrame -> Bool
keyPressed key InputFrame { inputPrev = prevState, inputNow = nowState } =
  keyDown key nowState && not (keyDown key prevState)

keyReleased :: Key -> InputFrame -> Bool
keyReleased key InputFrame { inputPrev = prevState, inputNow = nowState } =
  not (keyDown key nowState) && keyDown key prevState

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

rgb :: Float -> Float -> Float -> Color
rgb r g b = Color r g b 1

rgba :: Float -> Float -> Float -> Float -> Color
rgba = Color


data Vec2 = Vec2 !Float !Float deriving (Eq, Show)

data Vec4 = Vec4 !Float !Float !Float !Float deriving (Eq, Show)

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

rect :: Float -> Float -> Float -> Float -> FRect
rect x y w h = FRect (realToFrac x) (realToFrac y) (realToFrac w) (realToFrac h)

point :: Float -> Float -> FPoint
point x y = FPoint (realToFrac x) (realToFrac y)

class Drawable a where
  draw :: a -> Render ()

data DrawItem where
  DrawItem :: Drawable a => a -> DrawItem

data Line = Line Color FPoint FPoint
  deriving (Eq, Show)

data RectOutline = RectOutline Color FRect
  deriving (Eq, Show)

data RectFill = RectFill Color FRect
  deriving (Eq, Show)

data Sprite = Sprite Texture (Maybe FRect) FRect (Maybe (Shader, [ShaderUniform]))

data Label = Label Text Float Float

data TextDraw = TextDraw Font String Float Float

text :: Font -> String -> Float -> Float -> TextDraw
text = TextDraw

data ShaderUniform where
  ShaderUniform :: Storable a => Word32 -> a -> ShaderUniform
  ShaderUniformBytes :: Word32 -> ByteString -> ShaderUniform

instance Drawable Line where
  draw (Line color p1 p2) = drawLine color p1 p2

instance Drawable RectOutline where
  draw (RectOutline color rectShape) = drawRect color rectShape

instance Drawable RectFill where
  draw (RectFill color rectShape) = fillRect color rectShape

instance Drawable Sprite where
  draw (Sprite texture src dst shaderSpec) =
    case shaderSpec of
      Nothing -> drawTexture texture src dst
      Just (sh, uniforms) -> do
        mapM_ (applyShaderUniform sh) uniforms
        withShader sh (drawTexture texture src dst)

instance Drawable Label where
  draw (Label textObj x y) = drawText textObj x y

instance Drawable TextDraw where
  draw (TextDraw font str x y) = drawTextCached font str x y

applyShaderUniform :: Shader -> ShaderUniform -> Render ()
applyShaderUniform shader uniform =
  case uniform of
    ShaderUniform slot value -> setShaderUniformCached shader slot value
    ShaderUniformBytes slot bytes -> setShaderUniformBytesCached shader slot bytes

instance Drawable DrawItem where
  draw (DrawItem item) = draw item

instance Drawable a => Drawable [a] where
  draw = mapM_ draw

runWindowIO :: Config -> (Window -> IO a) -> IO a
runWindowIO cfg action =
  bracket_ initSDL shutdownSDL $ do
    let title = windowTitle cfg
    let width = windowWidth cfg
    let height = windowHeight cfg
    window <- require "SDL_CreateWindow" (sdlCreateWindow title width height 0)
    bracket (pure window) sdlDestroyWindow $ \win -> do
      void $ sdlSetWindowResizable win (windowResizable cfg)
      renderer <- require "SDL_CreateGPURenderer" (sdlCreateGPURenderer Nothing (Just win))
      bracket (pure renderer) sdlDestroyRenderer $ \ren -> do
        gpu <- require "SDL_GetGPURendererDevice" (sdlGetGPURendererDevice ren)
        textEngine <- require "TTF_CreateRendererTextEngine" (ttfCreateRendererTextEngine ren)
        bracket (pure textEngine) ttfDestroyRendererTextEngine $ \engine -> do
          renderState <- newIORef (RenderState Map.empty Map.empty 0)
          let placeholderAssets = error "AssetManager not initialized"
          let windowBase = Window
                { appWindow = win
                , appRenderer = ren
                , appGPUDevice = gpu
                , appTextEngine = engine
                , appAssets = placeholderAssets
                , appRenderState = renderState
                }
          bracket (initAssetManager windowBase) (shutdownAssetManager windowBase) $ \assets -> do
            let windowHandle = windowBase { appAssets = assets }
            action windowHandle
  where
    initSDL = do
      ok <- sdlInit sdlInitVideo
      unless ok $ die "SDL_Init"
      okFont <- ttfInit
      unless okFont $ die "TTF_Init"
    shutdownSDL = do
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

loopIO :: Window -> a -> (Frame -> a -> IO (LoopControl a)) -> IO (LoopExit a)
loopIO window initialState onFrame = do
  start <- sdlGetTicks
  sdlPumpEvents
  initialInput <- readInputState
  let go previous frameId prevInput state = do
        sdlPumpEvents
        quitRequested <- pollQuit
        now <- sdlGetTicks
        currentInput <- readInputState
        let dt = fromIntegral (now - previous) / 1000
            t = fromIntegral (now - start) / 1000
            nextFrame = frameId + 1
        setFrameId window nextFrame
        control <- onFrame Frame
          { frameDelta = dt
          , frameTime = t
          , frameTicks = now
          , frameQuitRequested = quitRequested
          , frameInput = InputFrame prevInput currentInput
          } state
        pruneTextCache window
        presentIO window
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

readKeySet :: Ptr Word8 -> Int -> IO IntSet
readKeySet ptr count = go 0 IntSet.empty
  where
    go idx acc
      | idx >= count = pure acc
      | otherwise = do
          value <- peekByteOff ptr idx :: IO Word8
          let acc' = if value == 0 then acc else IntSet.insert idx acc
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
clearIO window (Color r g b a) = do
  void $ sdlSetRenderDrawColorFloat (appRenderer window) (realToFrac r) (realToFrac g) (realToFrac b) (realToFrac a)
  void $ sdlRenderClear (appRenderer window)

presentIO :: Window -> IO ()
presentIO = sdlRenderPresent . appRenderer

setDrawColorIO :: Window -> Color -> IO ()
setDrawColorIO window (Color r g b a) =
  void $ sdlSetRenderDrawColorFloat (appRenderer window) (realToFrac r) (realToFrac g) (realToFrac b) (realToFrac a)

drawLineIO :: Window -> Color -> FPoint -> FPoint -> IO ()
drawLineIO window color (FPoint x1 y1) (FPoint x2 y2) = do
  setDrawColorIO window color
  void $ sdlRenderLine (appRenderer window) x1 y1 x2 y2

drawRectIO :: Window -> Color -> FRect -> IO ()
drawRectIO window color rectShape = do
  setDrawColorIO window color
  alloca $ \ptr -> do
    poke ptr rectShape
    void $ sdlRenderRect (appRenderer window) ptr

fillRectIO :: Window -> Color -> FRect -> IO ()
fillRectIO window color rectShape = do
  setDrawColorIO window color
  alloca $ \ptr -> do
    poke ptr rectShape
    void $ sdlRenderFillRect (appRenderer window) ptr

drawTextureIO :: Window -> Texture -> Maybe FRect -> FRect -> IO ()
drawTextureIO window texture src dst =
  withMaybe src $ \srcPtr ->
    with dst $ \dstPtr ->
      void $ sdlRenderTexture (appRenderer window) texture srcPtr dstPtr

withMaybe :: Storable a => Maybe a -> (Ptr a -> IO b) -> IO b
withMaybe Nothing f = f nullPtr
withMaybe (Just value) f = with value f

loadTextureIO :: Window -> FilePath -> IO Texture
loadTextureIO window path = require "IMG_LoadTexture" (imgLoadTexture (appRenderer window) path)

destroyTextureIO :: Texture -> IO ()
destroyTextureIO = sdlDestroyTexture

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
createTextIO window font str = require "TTF_CreateText" (ttfCreateText (appTextEngine window) font str)

destroyTextIO :: Text -> IO ()
destroyTextIO = ttfDestroyText

drawTextIO :: Window -> Text -> Float -> Float -> IO ()
drawTextIO _ textObj x y = void $ ttfDrawRendererText textObj x y

setFrameId :: Window -> Word64 -> IO ()
setFrameId window frameId =
  atomicModifyIORef' (appRenderState window) $ \st ->
    (st { rsFrameId = frameId }, ())

pruneTextCache :: Window -> IO ()
pruneTextCache window = do
  stale <- atomicModifyIORef' (appRenderState window) $ \st ->
    let (keep, dropMap) = Map.partition (\ct -> ctLastUsed ct == rsFrameId st) (rsTextCache st)
        st' = st { rsTextCache = keep }
    in (st', map ctText (Map.elems dropMap))
  mapM_ ttfDestroyText stale

-- WindowM wrappers

loop :: a -> (Frame -> a -> WindowM (LoopControl a)) -> WindowM (LoopExit a)
loop initialState onFrame = do
  window <- ask
  liftIO (loopIO window initialState (\frame state -> runWindowM window (onFrame frame state)))

clear :: Color -> Render ()
clear color = liftRender (`clearIO` color)

present :: Render ()
present = liftRender presentIO

setDrawColor :: Color -> Render ()
setDrawColor color = liftRender (`setDrawColorIO` color)

drawLine :: Color -> FPoint -> FPoint -> Render ()
drawLine color p1 p2 = liftRender (\window -> drawLineIO window color p1 p2)

drawRect :: Color -> FRect -> Render ()
drawRect color rectShape = liftRender (\window -> drawRectIO window color rectShape)

fillRect :: Color -> FRect -> Render ()
fillRect color rectShape = liftRender (\window -> fillRectIO window color rectShape)

drawTexture :: Texture -> Maybe FRect -> FRect -> Render ()
drawTexture texture src dst = liftRender (\window -> drawTextureIO window texture src dst)

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

drawText :: Text -> Float -> Float -> Render ()
drawText textObj x y = liftRender (\window -> drawTextIO window textObj x y)

drawTextCached :: Font -> String -> Float -> Float -> Render ()
drawTextCached font str x y = do
  window <- ask
  frameId <- liftIO $ atomicModifyIORef' (appRenderState window) (\st -> (st, rsFrameId st))
  let Font fontPtr = font
  let key = (castPtr fontPtr, str)
  cached <- liftIO $ atomicModifyIORef' (appRenderState window) $ \st ->
    case Map.lookup key (rsTextCache st) of
      Just entry ->
        let entry' = entry { ctLastUsed = frameId }
            cache' = Map.insert key entry' (rsTextCache st)
        in (st { rsTextCache = cache' }, Just (ctText entry))
      Nothing -> (st, Nothing)
  textObj <- case cached of
    Just t -> pure t
    Nothing -> do
      t <- liftIO (createTextIO window font str)
      liftIO $ atomicModifyIORef' (appRenderState window) $ \st ->
        let cache' = Map.insert key (CachedText t frameId) (rsTextCache st)
        in (st { rsTextCache = cache' }, ())
      pure t
  liftIO (void $ ttfDrawRendererText textObj x y)

-- Shaders

data Shader = Shader
  { shaderState :: GPURenderState
  , shaderHandle :: GPUShader
  , shaderDevice :: GPUDevice
  }

createShaderFromSpirvIO :: Window -> ByteString -> IO Shader
createShaderFromSpirvIO window spirv =
  createShaderFromSpirvWithIO window spirv 0 0 0 0

createShaderFromSpirvWithIO :: Window -> ByteString -> Word32 -> Word32 -> Word32 -> Word32 -> IO Shader
createShaderFromSpirvWithIO window spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers =
  BS.useAsCStringLen spirv $ \(ptr, len) ->
    withCString "main" $ \entry -> do
      let createInfo = GPUShaderCreateInfo
            { gpuShaderCodeSize = fromIntegral len
            , gpuShaderCode = castPtr ptr
            , gpuShaderEntryPoint = entry
            , gpuShaderFormat = sdlGPUShaderFormatSpirv
            , gpuShaderStage = sdlGPUShaderStageFragment
            , gpuShaderNumSamplers = numSamplers
            , gpuShaderNumStorageTextures = numStorageTextures
            , gpuShaderNumStorageBuffers = numStorageBuffers
            , gpuShaderNumUniformBuffers = numUniformBuffers
            , gpuShaderProps = 0
            }
      shader <- require "SDL_CreateGPUShader" (sdlCreateGPUShader (appGPUDevice window) createInfo)
      let GPUShader shaderPtr = shader
      let stateInfo = GPURenderStateCreateInfo
            { gpuRenderFragmentShader = shaderPtr
            , gpuRenderNumSamplerBindings = 0
            , gpuRenderSamplerBindings = nullPtr
            , gpuRenderNumStorageTextures = 0
            , gpuRenderStorageTextures = nullPtr
            , gpuRenderNumStorageBuffers = 0
            , gpuRenderStorageBuffers = nullPtr
            , gpuRenderProps = 0
            }
      stateResult <- sdlCreateGPURenderState (appRenderer window) stateInfo
      case stateResult of
        Nothing -> do
          sdlReleaseGPUShader (appGPUDevice window) shader
          err <- sdlGetError
          ioError (userError ("SDL_CreateGPURenderState failed: " <> err))
        Just gpuState ->
          pure Shader
            { shaderState = gpuState
            , shaderHandle = shader
            , shaderDevice = appGPUDevice window
            }

destroyShaderIO :: Shader -> IO ()
destroyShaderIO shader = do
  sdlDestroyGPURenderState (shaderState shader)
  sdlReleaseGPUShader (shaderDevice shader) (shaderHandle shader)

withShaderIO :: Window -> Shader -> IO a -> IO a
withShaderIO window shader action = do
  ok <- sdlSetGPURenderState (appRenderer window) (Just (shaderState shader))
  unless ok $ do
    err <- sdlGetError
    ioError (userError ("SDL_SetGPURenderState failed: " <> err))
  action `finally` void (sdlSetGPURenderState (appRenderer window) Nothing)

setShaderUniformIO :: Storable a => Shader -> Word32 -> a -> IO ()
setShaderUniformIO shader slot value =
  with value $ \ptr -> do
    let sizeBytes = fromIntegral (sizeOf value)
    ok <- sdlSetGPURenderStateFragmentUniforms (shaderState shader) slot (castPtr ptr) sizeBytes
    unless ok $ do
      err <- sdlGetError
      ioError (userError ("SDL_SetGPURenderStateFragmentUniforms failed: " <> err))

setShaderUniformBytesIO :: Shader -> Word32 -> ByteString -> IO ()
setShaderUniformBytesIO shader slot bytes =
  BS.useAsCStringLen bytes $ \(ptr, len) -> do
    ok <- sdlSetGPURenderStateFragmentUniforms (shaderState shader) slot (castPtr ptr) (fromIntegral len)
    unless ok $ do
      err <- sdlGetError
      ioError (userError ("SDL_SetGPURenderStateFragmentUniforms failed: " <> err))

shaderUniformKey :: Shader -> Word32 -> UniformKey
shaderUniformKey shader slot =
  case shaderState shader of
    GPURenderState ptr -> (castPtr ptr, slot)

toBytes :: Storable a => a -> IO ByteString
toBytes value =
  BSI.create (sizeOf value) $ \ptr ->
    poke (castPtr ptr) value

setShaderUniformCached :: Storable a => Shader -> Word32 -> a -> Render ()
setShaderUniformCached shader slot value = do
  bytes <- liftIO (toBytes value)
  setShaderUniformBytesCached shader slot bytes

setShaderUniformBytesCached :: Shader -> Word32 -> ByteString -> Render ()
setShaderUniformBytesCached shader slot bytes = do
  let key = shaderUniformKey shader slot
  ref <- appRenderState <$> ask
  shouldUpdate <- liftIO $
    atomicModifyIORef' ref $ \st ->
      case Map.lookup key (rsUniformCache st) of
        Just old | old == bytes -> (st, False)
        _ ->
          let cache' = Map.insert key bytes (rsUniformCache st)
          in (st { rsUniformCache = cache' }, True)
  if shouldUpdate
    then liftIO (setShaderUniformBytesIO shader slot bytes)
    else pure ()

createShaderFromSpirv :: ByteString -> WindowM Shader
createShaderFromSpirv spirv = liftWindow (\window -> createShaderFromSpirvIO window spirv)

createShaderFromSpirvWith :: ByteString -> Word32 -> Word32 -> Word32 -> Word32 -> WindowM Shader
createShaderFromSpirvWith spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers =
  liftWindow (\window -> createShaderFromSpirvWithIO window spirv numSamplers numStorageTextures numStorageBuffers numUniformBuffers)

evictShaderCacheIO :: Window -> Shader -> IO ()
evictShaderCacheIO window shader = do
  let GPURenderState ptr = shaderState shader
  atomicModifyIORef' (appRenderState window) $ \st ->
    let cache' = Map.filterWithKey (\(p, _) _ -> p /= castPtr ptr) (rsUniformCache st)
    in (st { rsUniformCache = cache' }, ())

evictTextCacheForFontIO :: Window -> Font -> IO ()
evictTextCacheForFontIO window font = do
  let Font fontPtr = font
  stale <- atomicModifyIORef' (appRenderState window) $ \st ->
    let (keep, dropMap) = Map.partitionWithKey (\(p, _) _ -> p /= castPtr fontPtr) (rsTextCache st)
        st' = st { rsTextCache = keep }
    in (st', map ctText (Map.elems dropMap))
  mapM_ ttfDestroyText stale

destroyShader :: Shader -> WindowM ()
destroyShader shader = do
  window <- ask
  liftIO (evictShaderCacheIO window shader)
  liftIO (destroyShaderIO shader)

withShader :: Shader -> Render a -> Render a
withShader shader action = do
  window <- ask
  liftIO $
    bracket
      (do
        ok <- sdlSetGPURenderState (appRenderer window) (Just (shaderState shader))
        unless ok $ do
          err <- sdlGetError
          ioError (userError ("SDL_SetGPURenderState failed: " <> err))
      )
      (\_ -> void (sdlSetGPURenderState (appRenderer window) Nothing))
      (\_ -> runReaderT (unRender action) window)

withShaderUniform :: Storable a => Shader -> Word32 -> a -> Render b -> Render b
withShaderUniform shader slot value action = do
  setShaderUniformCached shader slot value
  withShader shader action
