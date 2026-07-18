{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}

-- | A render-graph DSL that allocates, resizes, and prunes node targets.
module Slop.Pipeline.Graph
  ( Node
  , Graph
  , GraphPlan
  , PassM
  , compile
  , pass
  , clear
  , draw
  , drawMesh
  , compute
  , blit
  , withShader
  , postProcess
  , postProcessOf
  , merge
  , mergeOf
  , output
  , outputOf
  , fork
  , linear
  , renderPlan
  , render
  ) where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.State.Strict (StateT, evalStateT, get, modify')
import Control.Monad.Writer.Strict (Writer, execWriter, runWriter, tell)
import Data.Foldable (traverse_)
import Data.IORef (atomicModifyIORef', readIORef, writeIORef)
import qualified Data.IntMap.Strict as IntMap
import qualified Data.Set as Set

import qualified Slop.Internal as S
import Slop.Internal.DList (DList, singleton, toList)
import Slop.Internal
  ( Binding
  , Color
  , ComputeBinding
  , ComputePipeline
  , Draw
  , DrawItem (..)
  , WindowM
  , Mesh
  , Pipeline
  , RenderTarget
  , Shader
  , ShaderUniform (..)
  , askWindow
  , dispatchCompute
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
  deriving (Functor, Applicative)

newtype Graph a = Graph (StateT Int (Writer (DList Step)) a)
  deriving (Functor, Applicative)

newtype GraphPlan = GraphPlan [Step]

instance Semigroup a => Semigroup (PassM a) where
  PassM a <> PassM b = PassM (liftA2 (<>) a b)

instance Monoid a => Monoid (PassM a) where
  mempty = pure mempty

instance Semigroup a => Semigroup (Graph a) where
  Graph a <> Graph b = Graph (liftA2 (<>) a b)

instance Monoid a => Monoid (Graph a) where
  mempty = pure mempty

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

postProcessOf :: Graph Node -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> Graph Node
postProcessOf input shader uniforms src dst =
  withNodeGraph input (\node -> postProcess node shader uniforms src dst)

merge :: [Node] -> Maybe FRect -> FRect -> Graph Node
merge inputs src dst =
  pass (traverse_ (\node -> blit node src dst) inputs)

mergeOf :: [Graph Node] -> Maybe FRect -> FRect -> Graph Node
mergeOf inputs src dst =
  withNodeGraph (sequenceA inputs) (\nodes -> merge nodes src dst)

output :: Node -> Maybe FRect -> FRect -> Graph ()
output node src dst = Graph (tell (singleton (StepOutput node src dst)))

outputOf :: Graph Node -> Maybe FRect -> FRect -> Graph ()
outputOf input src dst =
  withNodeGraph input (\node -> output node src dst)

fork :: Graph a -> Graph b -> Graph (a, b)
fork (Graph left) (Graph right) =
  Graph (liftA2 (,) left right)

linear :: Node -> [(Shader, [ShaderUniform])] -> Maybe FRect -> FRect -> Graph Node
linear start passes src dst =
  Graph (go start passes)
  where
    go current [] = pure current
    go current ((shader, uniforms) : rest) = do
      let Graph step = postProcess current shader uniforms src dst
      next <- step
      go next rest

compile :: Graph a -> GraphPlan
compile (Graph action) =
  GraphPlan (toList (execWriter (evalStateT action 0)))

renderPlan :: (Int, Int) -> GraphPlan -> WindowM ()
renderPlan size (GraphPlan steps) = do
  mapM_ (runStep size) steps
  pruneTargets (collectNodes steps)

render :: (Int, Int) -> Graph a -> WindowM ()
render size graph =
  renderPlan size (compile graph)

runStep :: (Int, Int) -> Step -> WindowM ()
runStep size step =
  case step of
    StepPass node opsList -> do
      target <- ensureTarget node size
      S.render target (runOps size opsList)
    StepOutput node src dst -> do
      target <- ensureTarget node size
      blitTarget target src dst
    StepCompute pipeline bindings groups ->
      dispatchCompute pipeline bindings groups

runOps :: (Int, Int) -> [Op] -> WindowM ()
runOps size = mapM_ (runOp size)

runOp :: (Int, Int) -> Op -> WindowM ()
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

ensureTarget :: Node -> (Int, Int) -> WindowM RenderTarget
ensureTarget (Node nodeId) size = do
  window <- askWindow
  targets <- liftIO (readIORef window.appPipelineTargets)
  case IntMap.lookup nodeId targets of
    Just (target, targetSize)
      | targetSize == size -> pure target
      | otherwise -> do
          target' <- S.createRenderTarget (fst size) (snd size)
          liftIO (writeIORef window.appPipelineTargets (IntMap.insert nodeId (target', size) targets))
          S.destroyTarget target
          pure target'
    Nothing -> do
      target' <- S.createRenderTarget (fst size) (snd size)
      liftIO (writeIORef window.appPipelineTargets (IntMap.insert nodeId (target', size) targets))
      pure target'

clearTarget :: Color -> WindowM ()
clearTarget = S.clear

drawTarget :: DrawItem -> WindowM ()
drawTarget (DrawItem ctx item) = S.draw ctx item

blitTarget :: RenderTarget -> Maybe FRect -> FRect -> WindowM ()
blitTarget = S.output

passWithShader :: Shader -> [ShaderUniform] -> WindowM a -> WindowM a
passWithShader shader uniforms action =
  withShaderBindings shader uniforms action

withNodeGraph :: Graph a -> (a -> Graph b) -> Graph b
withNodeGraph (Graph action) f =
  Graph $ do
    value <- action
    let Graph action' = f value
    action'

collectNodes :: [Step] -> Set.Set Int
collectNodes = foldl' stepNodes Set.empty
  where
    stepNodes acc step =
      case step of
        StepPass (Node nodeId) opsList ->
          Set.insert nodeId (acc <> collectOps opsList)
        StepOutput (Node nodeId) _ _ ->
          Set.insert nodeId acc
        StepCompute {} -> acc
    collectOps opsList = foldl' opNodes Set.empty opsList
    opNodes acc op =
      case op of
        OpBlit (Node nodeId) _ _ ->
          Set.insert nodeId acc
        OpShader _ _ opsList ->
          acc <> collectOps opsList
        _ -> acc

pruneTargets :: Set.Set Int -> WindowM ()
pruneTargets used = do
  window <- askWindow
  stale <- liftIO $
    atomicModifyIORef' window.appPipelineTargets $ \targets ->
      let (keep, dropTargets) = IntMap.partitionWithKey (\k _ -> Set.member k used) targets
      in (keep, IntMap.elems dropTargets)
  mapM_ (\(target, _) -> S.destroyTarget target) stale
