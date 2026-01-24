{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}

module Seedl.Pipeline.Graph
  ( Node
  , Graph
  , PassM
  , pass
  , clear
  , draw
  , blit
  , withShader
  , postProcess
  , merge
  , output
  , fork
  , join
  , linear
  , render
  ) where

import Control.Monad (foldM)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.State.Strict (StateT, evalStateT, get, modify')
import Control.Monad.Writer.Strict (Writer, execWriter, runWriter, tell)
import Data.IORef (readIORef, writeIORef)
import qualified Data.Map.Strict as Map

import qualified Seedl as S
import Seedl
  ( Color
  , Drawable
  , DrawItem (..)
  , Loop
  , RenderTarget
  , Shader
  , ShaderUniform (..)
  , askWindow
  , liftLoop
  , setShaderUniformBytesCached
  , setShaderUniformCached
  )
import Seedl.SDL.Raw (FRect)

newtype DList a = DList ([a] -> [a])

instance Semigroup (DList a) where
  DList f <> DList g = DList (f . g)

instance Monoid (DList a) where
  mempty = DList id

singleton :: a -> DList a
singleton x = DList (x :)

toList :: DList a -> [a]
toList (DList f) = f []

newtype Node = Node Int

data Op
  = OpClear Color
  | OpDraw DrawItem
  | OpBlit Node (Maybe FRect) FRect
  | OpShader Shader [ShaderUniform] [Op]

data Step
  = StepPass Node [Op]
  | StepOutput Node (Maybe FRect) FRect

newtype PassM a = PassM (Writer (DList Op) a)
  deriving (Functor, Applicative, Monad)

newtype Graph a = Graph (StateT Int (Writer (DList Step)) a)
  deriving (Functor, Applicative, Monad)

pass :: PassM a -> Graph Node
pass (PassM action) = Graph $ do
  nodeId <- get
  modify' (+ 1)
  let (_, opsList) = runWriter action
  tell (singleton (StepPass (Node nodeId) (toList opsList)))
  pure (Node nodeId)

clear :: Color -> PassM ()
clear color = PassM (tell (singleton (OpClear color)))

draw :: Drawable a => a -> PassM ()
draw item = PassM (tell (singleton (OpDraw (DrawItem item))))

blit :: Node -> Maybe FRect -> FRect -> PassM ()
blit node src dst = PassM (tell (singleton (OpBlit node src dst)))

withShader :: Shader -> [ShaderUniform] -> PassM a -> PassM a
withShader shader uniforms (PassM action) =
  PassM $ do
    let (value, opsList) = runWriter action
    tell (singleton (OpShader shader uniforms (toList opsList)))
    pure value

postProcess :: Node -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> Graph Node
postProcess input shader uniforms src dst =
  pass (withShader shader uniforms (blit input src dst))

merge :: [Node] -> Maybe FRect -> FRect -> Graph Node
merge inputs src dst =
  pass (mapM_ (\node -> blit node src dst) inputs)

output :: Node -> Maybe FRect -> FRect -> Graph ()
output node src dst = Graph (tell (singleton (StepOutput node src dst)))

fork :: Graph a -> Graph b -> Graph (a, b)
fork (Graph left) (Graph right) =
  Graph $ do
    a <- left
    b <- right
    pure (a, b)

join :: [Node] -> Maybe FRect -> FRect -> Graph Node
join = merge

linear :: Node -> [(Shader, [ShaderUniform])] -> Maybe FRect -> FRect -> Graph Node
linear start passes src dst =
  foldM (\node (shader, uniforms) -> postProcess node shader uniforms src dst) start passes

render :: (Int, Int) -> Graph a -> Loop ()
render size (Graph action) = do
  let steps = toList (execWriter (evalStateT action 0))
  mapM_ (runStep size) steps

runStep :: (Int, Int) -> Step -> Loop ()
runStep size step =
  case step of
    StepPass node opsList -> do
      target <- ensureTarget node size
      S.render target (runOps size opsList)
    StepOutput node src dst -> do
      target <- ensureTarget node size
      blitTarget target src dst

runOps :: (Int, Int) -> [Op] -> Loop ()
runOps size = mapM_ (runOp size)

runOp :: (Int, Int) -> Op -> Loop ()
runOp size op =
  case op of
    OpClear color -> clearTarget color
    OpDraw item -> drawTarget item
    OpBlit node src dst -> do
      target <- ensureTarget node size
      blitTarget target src dst
    OpShader shader uniforms opsList -> do
      passWithShader shader uniforms (runOps size opsList)

ensureTarget :: Node -> (Int, Int) -> Loop RenderTarget
ensureTarget (Node nodeId) size = do
  window <- liftLoop askWindow
  targets <- liftLoop (liftIO (readIORef window.appPipelineTargets))
  case Map.lookup nodeId targets of
    Just (target, targetSize)
      | targetSize == size -> pure target
      | otherwise -> do
          _ <- liftLoop (S.destroyTarget target)
          target' <- liftLoop (S.createRenderTarget (fst size) (snd size))
          liftLoop (liftIO (writeIORef window.appPipelineTargets (Map.insert nodeId (target', size) targets)))
          pure target'
    Nothing -> do
      target' <- liftLoop (S.createRenderTarget (fst size) (snd size))
      liftLoop (liftIO (writeIORef window.appPipelineTargets (Map.insert nodeId (target', size) targets)))
      pure target'

clearTarget :: Color -> Loop ()
clearTarget = S.clear

drawTarget :: Drawable a => a -> Loop ()
drawTarget = S.draw

blitTarget :: RenderTarget -> Maybe FRect -> FRect -> Loop ()
blitTarget = S.output

passWithShader :: Shader -> [ShaderUniform] -> Loop a -> Loop a
passWithShader shader uniforms action = do
  mapM_ (applyUniform shader) uniforms
  S.withShader shader action

applyUniform :: Shader -> ShaderUniform -> Loop ()
applyUniform shader uniform =
  case uniform of
    ShaderUniform slot value -> setShaderUniformCached shader slot value
    ShaderUniformBytes slot bytes -> setShaderUniformBytesCached shader slot bytes
