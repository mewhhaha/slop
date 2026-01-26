{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}

module Slop.Pipeline.Graph
  ( Node
  , Graph
  , PassM
  , pass
  , clear
  , draw
  , drawMesh
  , compute
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

import qualified Slop as S
import Slop.Internal.DList (DList, singleton, toList)
import Slop
  ( Binding
  , Color
  , ComputeBinding
  , ComputePipeline
  , Draw
  , DrawItem (..)
  , Loop
  , Mesh
  , Pipeline
  , RenderTarget
  , Shader
  , ShaderUniform (..)
  , askWindow
  , dispatchCompute
  , liftLoop
  , withShaderBindings
  )
import Slop.SDL.Raw (FRect)
import Data.Word (Word32)

newtype Node = Node Int

data Op
  = OpClear Color
  | OpDraw DrawItem
  | OpDrawMesh Pipeline Mesh [Binding]
  | OpBlit Node (Maybe FRect) FRect
  | OpShader Shader [ShaderUniform] [Op]

data Step
  = StepPass Node [Op]
  | StepOutput Node (Maybe FRect) FRect
  | StepCompute ComputePipeline [ComputeBinding] (Word32, Word32, Word32)

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

draw :: Draw ctx a => ctx -> a -> PassM ()
draw ctx item = PassM (tell (singleton (OpDraw (DrawItem ctx item))))

drawMesh :: Pipeline -> Mesh -> [Binding] -> PassM ()
drawMesh pipeline mesh bindings =
  PassM (tell (singleton (OpDrawMesh pipeline mesh bindings)))

compute :: ComputePipeline -> [ComputeBinding] -> (Word32, Word32, Word32) -> Graph ()
compute pipeline bindings groups =
  Graph (tell (singleton (StepCompute pipeline bindings groups)))

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
    StepCompute pipeline bindings groups ->
      liftLoop (dispatchCompute pipeline bindings groups)

runOps :: (Int, Int) -> [Op] -> Loop ()
runOps size = mapM_ (runOp size)

runOp :: (Int, Int) -> Op -> Loop ()
runOp size op =
  case op of
    OpClear color -> clearTarget color
    OpDraw item -> drawTarget item
    OpDrawMesh pipeline mesh bindings ->
      S.drawMesh pipeline mesh bindings
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

drawTarget :: DrawItem -> Loop ()
drawTarget (DrawItem ctx item) = S.draw ctx item

blitTarget :: RenderTarget -> Maybe FRect -> FRect -> Loop ()
blitTarget = S.output

passWithShader :: Shader -> [ShaderUniform] -> Loop a -> Loop a
passWithShader shader uniforms action =
  withShaderBindings shader uniforms action
