{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}

module Slop.Pipeline
  ( TargetRef(..)
  , RenderPlan
  , PlanM(..)
  , PassM
  , Pipeline
  , plan
  , pass
  , pipeline
  , runPlan
  , runPipeline
  , fork
  , join
  , passTo
  , into
  , output
  , postProcessTo
  , merge
  , linear
  , clear
  , draw
  , blit
  , withShader
  , postProcess
  ) where

import Data.Foldable (traverse_)
import Slop.Internal
  ( Color
  , Draw
  , PassM
  , PlanM(..)
  , RenderPlan
  , RenderTarget
  , Shader
  , ShaderUniform
  , TargetRef(..)
  , WindowM
  , plan
  , pass
  , passBlit
  , passClear
  , passDraw
  , passPostProcess
  , passWithShader
  , runPlan
  )
import Slop.SDL.Raw (FRect)

clear :: Color -> PassM ()
clear = passClear

draw :: Draw ctx a => ctx -> a -> PassM ()
draw = passDraw

blit :: RenderTarget -> Maybe FRect -> FRect -> PassM ()
blit = passBlit

withShader :: Shader -> [ShaderUniform] -> PassM a -> PassM a
withShader = passWithShader

postProcess :: RenderTarget -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> PassM ()
postProcess = passPostProcess

newtype Pipeline a = Pipeline (PlanM a)
  deriving (Functor, Applicative)

instance Semigroup a => Semigroup (Pipeline a) where
  Pipeline a <> Pipeline b = Pipeline (liftA2 (<>) a b)

instance Monoid a => Monoid (Pipeline a) where
  mempty = pure mempty

pipeline :: Pipeline a -> RenderPlan
pipeline (Pipeline action) = plan action

runPipeline :: Pipeline a -> WindowM ()
runPipeline = runPlan . pipeline

fork :: Pipeline a -> Pipeline b -> Pipeline (a, b)
fork (Pipeline left) (Pipeline right) =
  Pipeline (liftA2 (,) left right)

join :: RenderTarget -> [RenderTarget] -> Maybe FRect -> FRect -> Pipeline RenderTarget
join = merge

passTo :: TargetRef -> PassM a -> Pipeline a
passTo targetRef ops = Pipeline (pass targetRef ops)

into :: RenderTarget -> PassM a -> Pipeline a
into target = passTo (Target target)

output :: RenderTarget -> Maybe FRect -> FRect -> Pipeline ()
output target src dst =
  passTo WindowTarget (blit target src dst)

postProcessTo :: RenderTarget -> RenderTarget -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> Pipeline RenderTarget
postProcessTo input outputTarget shader uniforms src dst =
  Pipeline (pass (Target outputTarget) (postProcess input shader uniforms src dst) *> pure outputTarget)

merge :: RenderTarget -> [RenderTarget] -> Maybe FRect -> FRect -> Pipeline RenderTarget
merge outputTarget inputs src dst =
  Pipeline (pass (Target outputTarget) (traverse_ (\target -> blit target src dst) inputs) *> pure outputTarget)

linear :: RenderTarget -> RenderTarget -> [(Shader, [ShaderUniform])] -> Maybe FRect -> FRect -> Pipeline RenderTarget
linear first second passes src dst =
  Pipeline (PlanM (go first second passes))
  where
    go current _ [] = pure current
    go current next ((shader, uniforms) : rest) = do
      let Pipeline (PlanM step) = postProcessTo current next shader uniforms src dst
      current' <- step
      go current' current rest
