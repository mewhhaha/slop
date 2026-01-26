{-# LANGUAGE DataKinds #-}
{-# LANGUAGE QuasiQuotes #-}

import Spirdo.Wesl (shaderSpirv, wesl)
import qualified Data.ByteString as BS

vertexSpirv :: BS.ByteString
vertexSpirv = shaderSpirv [wesl|
struct VsOut {
@builtin(position) position: vec4<f32>;
@location(0) uv: vec2<f32>;
@location(1) color: vec4<f32>;
};

@vertex
fn main(@location(0) in_pos: vec2<f32>, @location(1) in_uv: vec2<f32>, @location(2) in_color: vec4<f32>) -> VsOut {
let pos = vec4(in_pos.x, in_pos.y, 0.0, 1.0);
return VsOut(pos, in_uv, in_color);
}
|]

vertex3DSpirv :: BS.ByteString
vertex3DSpirv = shaderSpirv [wesl|
struct VsOut {
@builtin(position) position: vec4<f32>;
@location(0) uv: vec2<f32>;
@location(1) color: vec4<f32>;
};

struct MVP {
  m: mat4x4<f32>;
};

@group(0) @binding(0)
var<uniform> uMVP: MVP;

@vertex
fn main(@location(0) in_pos: vec4<f32>, @location(1) in_uv: vec2<f32>, @location(2) in_color: vec4<f32>) -> VsOut {
let pos = vec4(
  dot(uMVP.m[0], in_pos),
  dot(uMVP.m[1], in_pos),
  dot(uMVP.m[2], in_pos),
  dot(uMVP.m[3], in_pos)
);
return VsOut(pos, in_uv, in_color);
}
|]

fragmentSpirv :: BS.ByteString
fragmentSpirv = shaderSpirv [wesl|
@group(2) @binding(0)
var spriteTex: texture_2d<f32>;
@group(2) @binding(1)
var spriteSamp: sampler;

@fragment
fn main(@location(0) uv: vec2<f32>, @location(1) color: vec4<f32>) -> @location(0) vec4<f32> {
let tex = textureSample(spriteTex, spriteSamp, uv);
return tex * color;
}
|]

main :: IO ()
main = do
  putStrLn "vertex"
  print (BS.unpack vertexSpirv)
  putStrLn "vertex3d"
  print (BS.unpack vertex3DSpirv)
  putStrLn "fragment"
  print (BS.unpack fragmentSpirv)
