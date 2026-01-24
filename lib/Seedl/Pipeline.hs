{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}

module Seedl.Pipeline
  ( TargetRef(..)
  , RenderPlan
  , PlanM
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

import Seedl
  ( Color
  , Drawable
  , PassM
  , PlanM
  , RenderPlan
  , RenderTarget
  , Shader
  , ShaderUniform
  , TargetRef(..)
  , Loop
  , plan
  , pass
  , passBlit
  , passClear
  , passDraw
  , passPostProcess
  , passWithShader
  , runPlan
  )
import Seedl.SDL.Raw (FRect)

clear :: Color -> PassM ()
clear = passClear

draw :: Drawable a => a -> PassM ()
draw = passDraw

blit :: RenderTarget -> Maybe FRect -> FRect -> PassM ()
blit = passBlit

withShader :: Shader -> [ShaderUniform] -> PassM a -> PassM a
withShader = passWithShader

postProcess :: RenderTarget -> Shader -> [ShaderUniform] -> Maybe FRect -> FRect -> PassM ()
postProcess = passPostProcess

newtype Pipeline a = Pipeline (PlanM a)
  deriving (Functor, Applicative, Monad)

pipeline :: Pipeline a -> RenderPlan
pipeline (Pipeline action) = plan action

runPipeline :: Pipeline a -> Loop ()
runPipeline = runPlan . pipeline

fork :: Pipeline a -> Pipeline b -> Pipeline (a, b)
fork (Pipeline left) (Pipeline right) =
  Pipeline $ do
    a <- left
    b <- right
    pure (a, b)

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
postProcessTo input outputTarget shader uniforms src dst = do
  passTo (Target outputTarget) (postProcess input shader uniforms src dst)
  pure outputTarget

merge :: RenderTarget -> [RenderTarget] -> Maybe FRect -> FRect -> Pipeline RenderTarget
merge outputTarget inputs src dst = do
  passTo (Target outputTarget) (mapM_ (\target -> blit target src dst) inputs)
  pure outputTarget

linear :: RenderTarget -> RenderTarget -> [(Shader, [ShaderUniform])] -> Maybe FRect -> FRect -> Pipeline RenderTarget
linear first second passes src dst = go first second passes
  where
    go current _ [] = pure current
    go current next ((shader, uniforms) : rest) = do
      _ <- postProcessTo current next shader uniforms src dst
      go next current rest
