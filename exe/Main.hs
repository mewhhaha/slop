{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

import Control.Monad ((>=>))
import Control.Monad.IO.Class (liftIO)
import Data.ByteString (ByteString)
import Slop hiding (clear, draw, output, pass, postProcess, render, withShader)
import Slop.Pipeline.Graph
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
  let center = vec2(0.5, 0.5);
  let offset = uv - center;
  let r = length(offset);
  let barrel = 1.0 + 0.12 * r * r;
  let uvDistorted = center + offset * barrel;

  let chroma = (0.0015 + 0.0015 * sin(params.time * 0.7)) * (1.0 + r * 1.5);
  let sampleR = textureSample(spriteTex, spriteSamp, uvDistorted + vec2(chroma, 0.0));
  let sampleG = textureSample(spriteTex, spriteSamp, uvDistorted);
  let sampleB = textureSample(spriteTex, spriteSamp, uvDistorted - vec2(chroma, 0.0));

  let vignette = 1.0 - smoothstep(0.35, 0.95, r);
  let scan = 0.92 + 0.08 * sin(uv.y * params.height * 0.25 + params.time * 18.0);
  let noise = fract(sin(dot(uv * vec2(12.9898, 78.233), vec2(12.9898, 78.233)) + params.time * 10.0) * 43758.5453);

  var color = vec3(sampleR.r, sampleG.g, sampleB.b);
  color = color * vignette * scan;
  color = color + (noise - 0.5) * 0.02;

  return vec4(color.r * inColor.r, color.g * inColor.g, color.b * inColor.b, sampleG.a * inColor.a);
}
|]

demoShaderAsset :: ShaderAsset
demoShaderAsset = ShaderAsset demoShaderSpirv 1 0 0 1

main :: IO ()
main = do
  let cfg =
        defaultConfig
          { windowTitle = "Slop SDL3.4 demo",
            windowWidth = 960,
            windowHeight = 540,
            windowResizable = True
          }
  runWindow cfg $ do
    let crash = either (liftIO . ioError . userError) pure
        (>==) = (>=>)
    texId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")
    fontId <- loadAssetAsync (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)
    ambienceId <- loadAssetAsync (MusicAsset "assets/ambience - air conditioner.wav")
    ambienceAltId <- loadAssetAsync (MusicAsset "assets/ambience - car sedan idling.wav")
    sfxId <- loadAssetAsync (ChunkAsset "assets/air duster 7.wav")

    texture <- (awaitAsset >== crash) texId
    font <- (awaitAsset >== crash) fontId
    ambience <- (awaitAsset >== crash) ambienceId
    ambienceAlt <- (awaitAsset >== crash) ambienceAltId
    sfx <- (awaitAsset >== crash) sfxId

    shaderId <- (loadAsset >== crash) demoShaderAsset
    shader <- (awaitAsset >== crash) shaderId

    blend <- createTrackPool PoolBlend 2
    sfxPool <- createTrackPool PoolRoundRobin 8
    _ <- runLoop (crossfadeToLoop blend ambience 0)

    _ <- loop (0 :: Int) $ \frame active -> do
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
              draw (text font "Slop + SDL3.4" 80 40)
            post <- postProcess scene shader uniforms Nothing winRect
            output post Nothing winRect

      active' <- if keyPressed KeyB frame.input
        then do
          let next = if active == 0 then 1 else 0
          _ <- if next == 0
            then crossfadeToLoop blend ambience 2.0
            else crossfadeToLoop blend ambienceAlt 2.0
          pure next
        else pure active

      _ <- if keyPressed keySpace frame.input
        then playPool sfxPool sfx
        else pure False

      render (winWInt, winHInt) pipeline

      pure (Continue active')

    removeAllAssets
    pure ()
