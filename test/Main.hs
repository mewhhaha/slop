{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.Int (Int32)
import qualified Data.Text as T

import Slop
import Slop.GPU

main :: IO ()
main = do
  basicGeometryIsBackendNeutral
  advancedCameraIsAvailableFromGPU
  reflectedCountsIgnoreDeclarationOrder
  duplicateReflectedNamesCarryBindingEvidence
  invalidDescriptorGroupCarriesBindingEvidence
  namedUniformsFollowReflectedSlots
  missingNamedUniformFailsBeforeDrawing
  duplicateNamedUniformFailsBeforeDrawing
  wrongNamedBindingTypeFailsBeforeDrawing
  uniformSizeMismatchIsTyped

basicGeometryIsBackendNeutral :: IO ()
basicGeometryIsBackendNeutral = do
  let rectangle :: FRect
      rectangle = rect 1 2 3 4
  let windowTypeIsPublic :: Maybe Window
      windowTypeIsPublic = Nothing
  rectangle `seq` pure ()
  windowTypeIsPublic `seq` pure ()

advancedCameraIsAvailableFromGPU :: IO ()
advancedCameraIsAvailableFromGPU = do
  let camera = camera3D (V3 0 0 5) (V3 0 0 0) (V3 0 1 0) (pi / 3) (16 / 9) 0.1 100
  camera `seq` pure ()

reflectedCountsIgnoreDeclarationOrder :: IO ()
reflectedCountsIgnoreDeclarationOrder = do
  layout <- expectRight $ shaderLayoutFromReflection "post-process" ShaderFragment
    [ ReflectedBinding "noise" 2 1 ReflectedSampledTexture
    , ReflectedBinding "globals" 3 0 (ReflectedUniform 32)
    , ReflectedBinding "source" 2 0 ReflectedSampledTexture
    ]
  let ShaderCounts samplers storageTextures storageBuffers uniforms = shaderCountsFromReflection layout
  assertEqual "sampler count" 2 samplers
  assertEqual "storage texture count" 0 storageTextures
  assertEqual "storage buffer count" 0 storageBuffers
  assertEqual "uniform count" 1 uniforms

duplicateReflectedNamesCarryBindingEvidence :: IO ()
duplicateReflectedNamesCarryBindingEvidence =
  case shaderLayoutFromReflection "duplicate-test" ShaderFragment
    [ ReflectedBinding "source" 2 0 ReflectedSampledTexture
    , ReflectedBinding "source" 2 1 ReflectedSampledTexture
    ] of
    Left SlopShaderFailure { errorResource = shaderName, errorBinding = Just bindingName } -> do
      assertEqual "shader name" "duplicate-test" shaderName
      assertEqual "binding name" "source" bindingName
    Left err -> fail ("expected shader and binding evidence, got " <> T.unpack (renderSlopError err))
    Right _ -> fail "duplicate reflected binding name was accepted"

invalidDescriptorGroupCarriesBindingEvidence :: IO ()
invalidDescriptorGroupCarriesBindingEvidence =
  case shaderLayoutFromReflection "wrong-group" ShaderFragment
    [ReflectedBinding "params" 2 0 (ReflectedUniform 4)] of
    Left SlopShaderFailure { errorBinding = Just "params" } -> pure ()
    Left err -> fail ("expected descriptor group evidence, got " <> T.unpack (renderSlopError err))
    Right _ -> fail "fragment uniform in the wrong descriptor group was accepted"

namedUniformsFollowReflectedSlots :: IO ()
namedUniformsFollowReflectedSlots = do
  layout <- expectRight $ shaderLayoutFromReflection "uniform-order" ShaderFragment
    [ ReflectedBinding "second" 3 1 (ReflectedUniform 4)
    , ReflectedBinding "first" 3 0 (ReflectedUniform 4)
    ]
  bindings <- expectRight $ resolveReflectedUniforms layout
    [ NamedUniform "second" (2 :: Int32)
    , NamedUniform "first" (1 :: Int32)
    ]
  case bindings of
    [ShaderUniform secondSlot _, ShaderUniform firstSlot _] -> do
      assertEqual "second reflected slot" 1 secondSlot
      assertEqual "first reflected slot" 0 firstSlot
    _ -> fail "reflected uniforms did not resolve to uniform bindings"

missingNamedUniformFailsBeforeDrawing :: IO ()
missingNamedUniformFailsBeforeDrawing = do
  layout <- expectRight $ shaderLayoutFromReflection "missing-uniform" ShaderFragment
    [ ReflectedBinding "globals" 3 0 (ReflectedUniform 32)
    , ReflectedBinding "params" 3 1 (ReflectedUniform 4)
    ]
  case resolveReflectedUniforms layout [] of
    Left SlopShaderFailure { errorBinding = Just "params" } -> pure ()
    Left err -> fail ("expected missing params evidence, got " <> T.unpack (renderSlopError err))
    Right _ -> fail "missing reflected uniform was accepted"

duplicateNamedUniformFailsBeforeDrawing :: IO ()
duplicateNamedUniformFailsBeforeDrawing = do
  layout <- expectRight $ shaderLayoutFromReflection "duplicate-uniform" ShaderFragment
    [ ReflectedBinding "globals" 3 0 (ReflectedUniform 32)
    , ReflectedBinding "params" 3 1 (ReflectedUniform 4)
    ]
  case resolveReflectedUniforms layout
    [ NamedUniform "params" (1 :: Int32)
    , NamedUniform "params" (2 :: Int32)
    ] of
    Left SlopShaderFailure { errorBinding = Just "params" } -> pure ()
    Left err -> fail ("expected duplicate params evidence, got " <> T.unpack (renderSlopError err))
    Right _ -> fail "duplicate reflected uniform was accepted"

wrongNamedBindingTypeFailsBeforeDrawing :: IO ()
wrongNamedBindingTypeFailsBeforeDrawing = do
  layout <- expectRight $ shaderLayoutFromReflection "wrong-binding-type" ShaderFragment
    [ReflectedBinding "source" 2 0 ReflectedSampledTexture]
  case resolveReflectedUniforms layout [NamedUniform "source" (1 :: Int32)] of
    Left SlopShaderFailure { errorBinding = Just "source" } -> pure ()
    Left err -> fail ("expected binding type evidence, got " <> T.unpack (renderSlopError err))
    Right _ -> fail "uniform value was accepted for a sampled texture"

uniformSizeMismatchIsTyped :: IO ()
uniformSizeMismatchIsTyped =
  case shaderUniformChecked 3 16 (1 :: Int32) of
    Left SlopShaderFailure { errorBinding = Just "3" } -> pure ()
    Left err -> fail ("expected uniform slot evidence, got " <> T.unpack (renderSlopError err))
    Right _ -> fail "uniform size mismatch was accepted"

expectRight :: SlopResult a -> IO a
expectRight result =
  case result of
    Left err -> fail (T.unpack (renderSlopError err))
    Right value -> pure value

assertEqual :: (Eq a, Show a) => String -> a -> a -> IO ()
assertEqual label expected actual =
  if expected == actual
    then pure ()
    else fail (label <> ": expected " <> show expected <> ", got " <> show actual)
