{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

import Control.Monad ((>=>))
import Control.Monad.IO.Class (liftIO)
import Data.ByteString (ByteString)
import Seedl hiding (clear, draw, output, pass, postProcess, render, withShader)
import Seedl.Pipeline.Graph
import Spirdo.Wesl (shaderSpirv, wesl)

demoShaderSpirv :: ByteString
demoShaderSpirv =
  shaderSpirv
    [wesl|
struct Params {
  time: f32,
  width: f32,
  height: f32,
  _pad: f32,
};

@group(3) @binding(0) var<uniform> params: Params;
@group(2) @binding(0) var spriteTex: texture_2d<f32>;
@group(2) @binding(1) var spriteSamp: sampler;

@fragment
fn main(@location(0) inColor: vec4<f32>, @location(1) uv: vec2<f32>) -> @location(0) vec4<f32> {
  let pulse = 0.6 + 0.4 * sin(params.time);
  let base = textureSample(spriteTex, spriteSamp, uv);
  return vec4(
    base.r * inColor.r * pulse,
    base.g * inColor.g * pulse,
    base.b * inColor.b * pulse,
    base.a * inColor.a
  );
}
|]

demoShaderAsset :: ShaderAsset
demoShaderAsset = ShaderAsset demoShaderSpirv 1 0 0 1

main :: IO ()
main = do
  let cfg =
        defaultConfig
          { windowTitle = "Seedl SDL3.4 demo",
            windowWidth = 960,
            windowHeight = 540,
            windowResizable = True
          }
  runWindow cfg $ do
    let crash = either (liftIO . ioError . userError) pure
        (>==) = (>=>)
    texId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")
    fontId <- loadAssetAsync (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)

    texture <- (awaitAsset >== crash) texId
    font <- (awaitAsset >== crash) fontId

    shaderId <- (loadAsset >== crash) demoShaderAsset
    shader <- (awaitAsset >== crash) shaderId

    _ <- loop () $ \frame _ -> do
      let (winWInt, winHInt) = frame.size
      let winW = fromIntegral winWInt
      let winH = fromIntegral winHInt
      let winRect = rect 0 0 winW winH
      let params =
            Vec4
              frame.time
              winW
              winH
              0
      let uniforms = [ShaderUniform 0 params]
      let pipeline = do
            scene <- pass $ do
              clear (rgb 0.06 0.07 0.1)
              draw (Line (rgb 0.95 0.35 0.35) (point 80 90) (point 400 130))
              draw (RectOutline (rgb 0.2 0.8 0.9) (rect 80 150 200 120))
              draw (RectFill (rgba 0.25 0.25 0.8 0.9) (rect 320 150 120 120))
              draw (Sprite texture Nothing (rect 80 320 160 160) Nothing)
              draw (text font "Seedl + SDL3.4" 80 40)
            post <- postProcess scene shader uniforms Nothing winRect
            output post Nothing winRect

      render (winWInt, winHInt) pipeline

      pure (Continue ())

    removeAllAssets
    pure ()
