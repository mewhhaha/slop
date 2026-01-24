{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}

module Seedl
  ( Config(..)
  , defaultConfig
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
  , RenderTarget
  , createRenderTarget
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
  , Vec4(..)
  , rect
  , point
  , rgb
  , rgba
  , Texture(..)
  , Font (..)
  , Track(..)
  , ShaderAsset(..)
  , SdfFontAsset(..)
  , setFontSDF
  , getFontSDF
  , Text
  , Audio(..)
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
  , MusicAsset(..)
  , ChunkAsset(..)
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
  , withShader
  , setShaderUniformCached
  , setShaderUniformBytesCached
  , withShaderUniform
  ) where

import Control.Exception (SomeException, bracket, bracket_, finally, try)
import Control.Monad (replicateM, unless, void, when)
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
  , Mixer(..)
  , Audio(..)
  , Track(..)
  , GPUDevice (..)
  , GPUShader (..)
  , GPURenderState (..)
  , GPURenderStateCreateInfo (..)
  , GPUShaderCreateInfo (..)
  , Renderer (..)
  , Text
  , TextEngine (..)
  , Texture(..)
  , imgLoadTexture
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
  , sdlCreateTexture
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
  , sdlGetKeyFromScancode
  , sdlGetTicks
  , sdlGPUShaderFormatSpirv
  , sdlGPUShaderStageFragment
  , sdlInit
  , sdlInitAudio
  , sdlInitVideo
  , sdlGetWindowSize
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
  , sdlGetRenderTarget
  , sdlSetWindowResizable
  , sdlSetGPURenderStateFragmentUniforms
  , sdlSetRenderDrawColorFloat
  , sdlSetRenderTarget
  , sdlSetGPURenderState
  , sdlTextureAccessTarget
  , sdlPixelFormatRGBA8888
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
  { windowTitle = "Slop"
  , windowWidth = 1280
  , windowHeight = 720
  , windowResizable = True
  }


data Window = Window
  { appWindow :: SDL.Window
  , appRenderer :: Renderer
  , appGPUDevice :: GPUDevice
  , appTextEngine :: TextEngine
  , appMixer :: Mixer
  , appMusicTrack :: IORef (Maybe Track)
  , appBlendPools :: IORef [TrackPool]
  , appAssets :: AssetManager
  , appTargets :: IORef (Map.Map (Ptr ()) Texture)
  , appPipelineTargets :: IORef (Map.Map Int (RenderTarget, (Int, Int)))
  , appRenderState :: IORef RenderState
  }

newtype WindowM a = WindowM (ReaderT Window IO a)
  deriving (Functor, Applicative, Monad, MonadIO, MonadReader Window)

newtype Loop a = Loop (WindowM a)
  deriving (Functor, Applicative, Monad, MonadIO)

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

newtype DList a = DList ([a] -> [a])

instance Semigroup (DList a) where
  DList f <> DList g = DList (f . g)

instance Monoid (DList a) where
  mempty = DList id

singleton :: a -> DList a
singleton x = DList (x :)

toList :: DList a -> [a]
toList (DList f) = f []

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

instance AssetLoader TextureAsset where
  type AssetType TextureAsset = Texture
  loadAssetIO app (TextureAsset path) = do
    result <- imgLoadTexture (app.appRenderer) path
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
    result <- ttfCreateText (app.appTextEngine) font str
    case result of
      Nothing -> Left <$> sdlGetError
      Just textObj -> pure (Right textObj)
  unloadAssetIO _ _ = ttfDestroyText
  assetLabel (TextAsset _ str) = str

instance AssetLoader MusicAsset where
  type AssetType MusicAsset = Audio
  loadAssetIO app (MusicAsset path) = do
    result <- mixLoadAudio app.appMixer path False
    case result of
      Nothing -> Left <$> sdlGetError
      Just audio -> pure (Right audio)
  unloadAssetIO _ _ = mixDestroyAudio
  assetLabel (MusicAsset path) = path

instance AssetLoader ChunkAsset where
  type AssetType ChunkAsset = Audio
  loadAssetIO app (ChunkAsset path) = do
    result <- mixLoadAudio app.appMixer path True
    case result of
      Nothing -> Left <$> sdlGetError
      Just audio -> pure (Right audio)
  unloadAssetIO _ _ = mixDestroyAudio
  assetLabel (ChunkAsset path) = path

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
    let bytes = spec.shaderSpirvBytes
    let samplers = spec.shaderSamplers
    let storageTextures = spec.shaderStorageTextures
    let storageBuffers = spec.shaderStorageBuffers
    let uniformBuffers = spec.shaderUniformBuffers
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
  atomically (writeTQueue (mgr.amQueue) (StopCommand stopVar))
  atomically (readTMVar stopVar)
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
          case Map.lookup assetId (st.msAssets) of
            Just (AssetSlot typ (SlotLoading var)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotFailed err)) (st.msAssets) }
              void (tryPutTMVar var (Left err))
            _ -> pure ()
      Right asset -> do
        let dyn = toDyn asset
        let finalizer = unloadAssetIO app spec asset
        let typ = typeOf asset
        cancelled <- atomically $ do
          st <- readTVar stateVar
          case Map.lookup assetId (st.msAssets) of
            Just (AssetSlot _ (SlotLoading var)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotReady dyn finalizer)) (st.msAssets) }
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
          case Map.lookup assetId (st.msAssets) of
            Nothing -> pure (False, Nothing, True)
            Just (AssetSlot _ (SlotReady _ oldFin)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotReady dyn finalizer)) (st.msAssets) }
              pure (True, Just oldFin, False)
            Just (AssetSlot _ (SlotFailed _)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotReady dyn finalizer)) (st.msAssets) }
              pure (True, Nothing, False)
            Just (AssetSlot _ (SlotLoading _)) -> do
              writeTVar stateVar st { msAssets = Map.insert assetId (AssetSlot typ (SlotReady dyn finalizer)) (st.msAssets) }
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
  let slot = AssetSlot (typeRep (Proxy :: Proxy a)) (SlotLoading var)
  writeTVar (mgr.amState) st { msNextId = newId + 1, msAssets = Map.insert newId slot (st.msAssets) }
  pure (AssetId newId, var)

loadAsset :: forall spec. AssetLoader spec => spec -> WindowM (Either String (AssetId (AssetType spec)))
loadAsset spec = do
  app <- ask
  let mgr = app.appAssets
  (assetId, _) <- liftIO (registerLoading @(AssetType spec) mgr)
  result <- liftIO (try @SomeException (loadAssetIO app spec))
  let resolved = case result of
        Left ex -> Left (show ex)
        Right ok -> ok
  liftIO $ case resolved of
    Left err -> do
      atomically $ do
        st <- readTVar (mgr.amState)
        case Map.lookup (assetId.unAssetId) (st.msAssets) of
          Just (AssetSlot typ (SlotLoading var)) -> do
            writeTVar (mgr.amState) st { msAssets = Map.insert (assetId.unAssetId) (AssetSlot typ (SlotFailed err)) (st.msAssets) }
            void (tryPutTMVar var (Left err))
          _ -> pure ()
    Right asset -> do
      let dyn = toDyn asset
      let finalizer = unloadAssetIO app spec asset
      let typ = typeOf asset
      cancelled <- atomically $ do
        st <- readTVar (mgr.amState)
        case Map.lookup (assetId.unAssetId) (st.msAssets) of
          Just (AssetSlot _ (SlotLoading var)) -> do
            writeTVar (mgr.amState) st { msAssets = Map.insert (assetId.unAssetId) (AssetSlot typ (SlotReady dyn finalizer)) (st.msAssets) }
            void (tryPutTMVar var (Right ()))
            pure False
          Nothing -> pure True
          _ -> pure False
      if cancelled then finalizer else pure ()
  pure (fmap (const assetId) resolved)

loadAssetAsync :: forall spec. AssetLoader spec => spec -> WindowM (AssetId (AssetType spec))
loadAssetAsync spec = do
  app <- ask
  let mgr = app.appAssets
  (assetId, _) <- liftIO (registerLoading @(AssetType spec) mgr)
  liftIO $ atomically $
    writeTQueue (mgr.amQueue) (AssetCommand (assetId.unAssetId) spec RequestLoad Nothing)
  pure assetId

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
      liftIO $ atomically $
        writeTQueue (mgr.amQueue) (AssetCommand (assetId.unAssetId) spec RequestReload (Just notify))
      pure (AssetUpdate notify)
    else do
      liftIO $ atomically (putTMVar notify (Left "asset not found"))
      pure (AssetUpdate notify)

awaitAssetUpdate :: AssetUpdate -> WindowM (Either String ())
awaitAssetUpdate (AssetUpdate var) = liftIO (atomically (readTMVar var))

awaitAsset :: forall a. Typeable a => AssetId a -> WindowM (Either String a)
awaitAsset assetId = do
  app <- ask
  let mgr = app.appAssets
  mWait <- liftIO $ atomically $ do
    st <- readTVar (mgr.amState)
    case Map.lookup (assetId.unAssetId) (st.msAssets) of
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
  liftIO (removeAllAssetsIO app (app.appAssets))


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
  draw :: a -> Loop ()

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

newtype RenderTarget = RenderTarget Texture

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

newtype PassM a = PassM (Writer (DList Op) a)
  deriving (Functor, Applicative, Monad)

newtype PlanM a = PlanM (Writer (DList Pass) a)
  deriving (Functor, Applicative, Monad)

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

applyShaderUniform :: Shader -> ShaderUniform -> Loop ()
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
    let title = cfg.windowTitle
    let width = cfg.windowWidth
    let height = cfg.windowHeight
    window <- require "SDL_CreateWindow" (sdlCreateWindow title width height 0)
    bracket (pure window) sdlDestroyWindow $ \win -> do
      void $ sdlSetWindowResizable win (cfg.windowResizable)
      renderer <- require "SDL_CreateGPURenderer" (sdlCreateGPURenderer Nothing (Just win))
      bracket (pure renderer) sdlDestroyRenderer $ \ren -> do
        gpu <- require "SDL_GetGPURendererDevice" (sdlGetGPURendererDevice ren)
        textEngine <- require "TTF_CreateRendererTextEngine" (ttfCreateRendererTextEngine ren)
        bracket (pure textEngine) ttfDestroyRendererTextEngine $ \engine -> do
          mixer <- require "MIX_CreateMixerDevice" (mixCreateMixerDevice sdlAudioDeviceDefaultPlayback)
          bracket (pure mixer) mixDestroyMixer $ \mix -> do
            musicTrackRef <- newIORef Nothing
            blendPools <- newIORef []
            targets <- newIORef Map.empty
            pipelineTargets <- newIORef Map.empty
            renderState <- newIORef (RenderState Map.empty Map.empty 0)
            let placeholderAssets = error "AssetManager not initialized"
            let windowBase = Window
                  { appWindow = win
                  , appRenderer = ren
                  , appGPUDevice = gpu
                  , appTextEngine = engine
                  , appMixer = mix
                  , appMusicTrack = musicTrackRef
                  , appBlendPools = blendPools
                  , appAssets = placeholderAssets
                  , appTargets = targets
                  , appPipelineTargets = pipelineTargets
                  , appRenderState = renderState
                  }
            bracket (initAssetManager windowBase) (shutdownAssetManager windowBase) $ \assets -> do
              let windowHandle = windowBase { appAssets = assets }
              action windowHandle `finally` cleanupRenderTargets windowHandle
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
renderTargetKey (Texture ptr) = castPtr ptr

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

cleanupRenderTargets :: Window -> IO ()
cleanupRenderTargets window = do
  targets <- atomicModifyIORef' (window.appTargets) $ \targets ->
    (Map.empty, Map.elems targets)
  mapM_ sdlDestroyTexture targets

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
clearIO window (Color r g b a) = do
  void $ sdlSetRenderDrawColorFloat (window.appRenderer) (realToFrac r) (realToFrac g) (realToFrac b) (realToFrac a)
  void $ sdlRenderClear (window.appRenderer)

presentIO :: Window -> IO ()
presentIO window = sdlRenderPresent window.appRenderer

setDrawColorIO :: Window -> Color -> IO ()
setDrawColorIO window (Color r g b a) =
  void $ sdlSetRenderDrawColorFloat (window.appRenderer) (realToFrac r) (realToFrac g) (realToFrac b) (realToFrac a)

drawLineIO :: Window -> Color -> FPoint -> FPoint -> IO ()
drawLineIO window color (FPoint x1 y1) (FPoint x2 y2) = do
  setDrawColorIO window color
  void $ sdlRenderLine (window.appRenderer) x1 y1 x2 y2

drawRectIO :: Window -> Color -> FRect -> IO ()
drawRectIO window color rectShape = do
  setDrawColorIO window color
  alloca $ \ptr -> do
    poke ptr rectShape
    void $ sdlRenderRect (window.appRenderer) ptr

fillRectIO :: Window -> Color -> FRect -> IO ()
fillRectIO window color rectShape = do
  setDrawColorIO window color
  alloca $ \ptr -> do
    poke ptr rectShape
    void $ sdlRenderFillRect (window.appRenderer) ptr

drawTextureIO :: Window -> Texture -> Maybe FRect -> FRect -> IO ()
drawTextureIO window texture src dst =
  withMaybe src $ \srcPtr ->
    with dst $ \dstPtr ->
      void $ sdlRenderTexture (window.appRenderer) texture srcPtr dstPtr

getRenderTargetIO :: Window -> IO (Maybe Texture)
getRenderTargetIO window = sdlGetRenderTarget (window.appRenderer)

setRenderTargetIO :: Window -> Maybe Texture -> IO ()
setRenderTargetIO window target = do
  ok <- sdlSetRenderTarget (window.appRenderer) target
  unless ok $ do
    err <- sdlGetError
    ioError (userError ("SDL_SetRenderTarget failed: " <> err))

withMaybe :: Storable a => Maybe a -> (Ptr a -> IO b) -> IO b
withMaybe Nothing f = f nullPtr
withMaybe (Just value) f = with value f

loadTextureIO :: Window -> FilePath -> IO Texture
loadTextureIO window path = require "IMG_LoadTexture" (imgLoadTexture (window.appRenderer) path)

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
createTextIO window font str = require "TTF_CreateText" (ttfCreateText (window.appTextEngine) font str)

destroyTextIO :: Text -> IO ()
destroyTextIO = ttfDestroyText

drawTextIO :: Window -> Text -> Float -> Float -> IO ()
drawTextIO _ textObj x y = void $ ttfDrawRendererText textObj x y

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

-- WindowM wrappers

loop :: a -> (Frame -> a -> Loop (LoopControl a)) -> WindowM (LoopExit a)
loop initialState onFrame = do
  window <- ask
  start <- liftIO sdlGetTicks
  liftIO sdlPumpEvents
  initialInput <- liftIO readInputState
  let go previous frameId prevInput state = do
        liftIO sdlPumpEvents
        quitRequested <- liftIO pollQuit
        now <- liftIO sdlGetTicks
        currentInput <- liftIO readInputState
        (winW, winH) <- liftIO (sdlGetWindowSize (window.appWindow))
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

createRenderTarget :: Int -> Int -> WindowM RenderTarget
createRenderTarget width height = do
  window <- ask
  tex <- liftIO $
    require
      "SDL_CreateTexture"
      (sdlCreateTexture (window.appRenderer) sdlPixelFormatRGBA8888 sdlTextureAccessTarget width height)
  liftIO (registerRenderTarget window tex)
  pure (RenderTarget tex)

destroyTarget :: RenderTarget -> WindowM ()
destroyTarget (RenderTarget tex) = do
  window <- ask
  removed <- liftIO (unregisterRenderTarget window tex)
  if removed
    then liftIO (destroyTextureIO tex)
    else pure ()

render :: RenderTarget -> Loop () -> Loop ()
render (RenderTarget tex) (Loop action) =
  Loop $ do
    window <- ask
    prev <- liftIO (getRenderTargetIO window)
    liftIO $
      bracket_
        (setRenderTargetIO window (Just tex))
        (setRenderTargetIO window prev)
        (runWindowM window action)

drawRender :: RenderTarget -> Maybe FRect -> FRect -> Loop ()
drawRender (RenderTarget tex) src dst = do
  drawTexture tex src dst

output :: RenderTarget -> Maybe FRect -> FRect -> Loop ()
output = drawRender

postProcess :: RenderTarget -> RenderTarget -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> Loop ()
postProcess (RenderTarget inputTex) (RenderTarget outputTex) shader uniforms src dst = do
  render (RenderTarget outputTex) $ do
    withShader shader $ do
      mapM_ (applyShaderUniform shader) uniforms
      drawTexture inputTex src dst

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

passDraw :: Drawable a => a -> PassM ()
passDraw item = PassM (tell (singleton (OpDraw (DrawItem item))))

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
        OpDraw item -> draw item
        OpBlit target src dst -> drawRender target src dst
        OpShader shader uniforms opsList -> do
          mapM_ (applyShaderUniform shader) uniforms
          withShader shader (runOps opsList)

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
    liftIO (void $ ttfDrawRendererText textObj x y)

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
      shader <- require "SDL_CreateGPUShader" (sdlCreateGPUShader (window.appGPUDevice) createInfo)
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
      stateResult <- sdlCreateGPURenderState (window.appRenderer) stateInfo
      case stateResult of
        Nothing -> do
          sdlReleaseGPUShader (window.appGPUDevice) shader
          err <- sdlGetError
          ioError (userError ("SDL_CreateGPURenderState failed: " <> err))
        Just gpuState ->
          pure Shader
            { shaderState = gpuState
            , shaderHandle = shader
            , shaderDevice = window.appGPUDevice
            }

destroyShaderIO :: Shader -> IO ()
destroyShaderIO shader = do
  sdlDestroyGPURenderState (shader.shaderState)
  sdlReleaseGPUShader (shader.shaderDevice) (shader.shaderHandle)

withShaderIO :: Window -> Shader -> IO a -> IO a
withShaderIO window shader action = do
  ok <- sdlSetGPURenderState (window.appRenderer) (Just (shader.shaderState))
  unless ok $ do
    err <- sdlGetError
    ioError (userError ("SDL_SetGPURenderState failed: " <> err))
  action `finally` void (sdlSetGPURenderState (window.appRenderer) Nothing)

setShaderUniformIO :: Storable a => Shader -> Word32 -> a -> IO ()
setShaderUniformIO shader slot value =
  with value $ \ptr -> do
    let sizeBytes = fromIntegral (sizeOf value)
    ok <- sdlSetGPURenderStateFragmentUniforms (shader.shaderState) slot (castPtr ptr) sizeBytes
    unless ok $ do
      err <- sdlGetError
      ioError (userError ("SDL_SetGPURenderStateFragmentUniforms failed: " <> err))

setShaderUniformBytesIO :: Shader -> Word32 -> ByteString -> IO ()
setShaderUniformBytesIO shader slot bytes =
  BS.useAsCStringLen bytes $ \(ptr, len) -> do
    ok <- sdlSetGPURenderStateFragmentUniforms (shader.shaderState) slot (castPtr ptr) (fromIntegral len)
    unless ok $ do
      err <- sdlGetError
      ioError (userError ("SDL_SetGPURenderStateFragmentUniforms failed: " <> err))

shaderUniformKey :: Shader -> Word32 -> UniformKey
shaderUniformKey shader slot =
  case shader.shaderState of
    GPURenderState ptr -> (castPtr ptr, slot)

toBytes :: Storable a => a -> IO ByteString
toBytes value =
  BSI.create (sizeOf value) $ \ptr ->
    poke (castPtr ptr) value

setShaderUniformCached :: Storable a => Shader -> Word32 -> a -> Loop ()
setShaderUniformCached shader slot value = do
  bytes <- liftIO (toBytes value)
  setShaderUniformBytesCached shader slot bytes

setShaderUniformBytesCached :: Shader -> Word32 -> ByteString -> Loop ()
setShaderUniformBytesCached shader slot bytes =
  Loop $ do
    window <- ask
    let key = shaderUniformKey shader slot
    let ref = window.appRenderState
    shouldUpdate <- liftIO $
      atomicModifyIORef' ref $ \st ->
        case Map.lookup key (st.rsUniformCache) of
          Just old | old == bytes -> (st, False)
          _ ->
            let cache' = Map.insert key bytes (st.rsUniformCache)
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
  let GPURenderState ptr = shader.shaderState
  atomicModifyIORef' (window.appRenderState) $ \st ->
    let cache' = Map.filterWithKey (\(p, _) _ -> p /= castPtr ptr) (st.rsUniformCache)
    in (st { rsUniformCache = cache' }, ())

evictTextCacheForFontIO :: Window -> Font -> IO ()
evictTextCacheForFontIO window font = do
  let Font fontPtr = font
  stale <- atomicModifyIORef' (window.appRenderState) $ \st ->
    let (keep, dropMap) = Map.partitionWithKey (\(p, _) _ -> p /= castPtr fontPtr) (st.rsTextCache)
        st' = st { rsTextCache = keep }
    in (st', map (\ct -> ct.ctText) (Map.elems dropMap))
  mapM_ ttfDestroyText stale

destroyShader :: Shader -> WindowM ()
destroyShader shader = do
  window <- ask
  liftIO (evictShaderCacheIO window shader)
  liftIO (destroyShaderIO shader)

withShader :: Shader -> Loop a -> Loop a
withShader shader (Loop action) =
  Loop $ do
    window <- ask
    liftIO $
      bracket
        (do
          ok <- sdlSetGPURenderState (window.appRenderer) (Just (shader.shaderState))
          unless ok $ do
            err <- sdlGetError
            ioError (userError ("SDL_SetGPURenderState failed: " <> err))
        )
        (\_ -> void (sdlSetGPURenderState (window.appRenderer) Nothing))
        (\_ -> runWindowM window action)

withShaderUniform :: Storable a => Shader -> Word32 -> a -> Loop b -> Loop b
withShaderUniform shader slot value action = do
  setShaderUniformCached shader slot value
  withShader shader action
