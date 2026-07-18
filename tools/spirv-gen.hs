{-# LANGUAGE DataKinds #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

import qualified Data.ByteString as BS
import Spirdo.Wesl.Reflection
  ( defaultCompileOptions
  , imports
  , shaderSpirv
  , spirv
  , wesl
  )

vertexSpirv :: BS.ByteString
vertexSpirv = shaderSpirv $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
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
|])

vertex3DSpirv :: BS.ByteString
vertex3DSpirv = shaderSpirv $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
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
|])

fragmentSpirv :: BS.ByteString
fragmentSpirv = shaderSpirv $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
@group(2) @binding(0)
var spriteTex: texture_2d<f32>;
@group(2) @binding(1)
var spriteSamp: sampler;

@fragment
fn main(@location(0) uv: vec2<f32>, @location(1) color: vec4<f32>) -> @location(0) vec4<f32> {
let tex = textureSample(spriteTex, spriteSamp, uv);
return tex * color;
}
|])

noise2DSpirv :: BS.ByteString
noise2DSpirv = shaderSpirv $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
struct Params {
  dims: vec4<f32>;
  scale: vec4<f32>;
  extras: vec4<f32>;
  period: vec4<f32>;
};

@group(2) @binding(0)
var<uniform> params: Params;

@group(1) @binding(0)
var<storage> out_tex: texture_storage_2d<rgba8unorm, read_write>;

fn mix32(v: u32) -> u32 {
  var h = v ^ (v >> u32(16));
  h = h * u32(2146121005);
  h = h ^ (h >> u32(15));
  h = h * u32(2221713035);
  return h ^ (h >> u32(16));
}

fn hash2(seed: u32, x: u32, y: u32) -> f32 {
  let h = mix32(x * u32(374761393) + y * u32(668265263) + seed * u32(1442695041));
  return f32(h & u32(65535)) / 65535.0;
}

fn smoothstep01(t: f32) -> f32 {
  return t * t * (3.0 - 2.0 * t);
}

fn lerp(a: f32, b: f32, t: f32) -> f32 {
  return a + (b - a) * t;
}

fn clamp01(v: f32) -> f32 {
  return clamp(v, 0.0, 1.0);
}

fn wrapIndex(v: u32, period: u32) -> u32 {
  if (period == u32(0)) {
    return v;
  }
  return v % period;
}

fn wrapIndexI(v: i32, period: i32) -> i32 {
  if (period <= 0) {
    return v;
  }
  let m = v % period;
  return select(m, m + period, m < 0);
}

fn wrapDelta(d: f32, period: f32) -> f32 {
  if (period <= 0.0) {
    return d;
  }
  let r = d - period * floor(d / period);
  return select(r, r - period, r > period * 0.5);
}

fn valueNoise2(seed: u32, x: f32, y: f32, px: u32, py: u32) -> f32 {
  let x0 = i32(floor(x));
  let y0 = i32(floor(y));
  let x1 = x0 + 1;
  let y1 = y0 + 1;
  let fx = smoothstep01(x - f32(x0));
  let fy = smoothstep01(y - f32(y0));
  let n00 = hash2(seed, wrapIndex(u32(x0), px), wrapIndex(u32(y0), py));
  let n10 = hash2(seed, wrapIndex(u32(x1), px), wrapIndex(u32(y0), py));
  let n01 = hash2(seed, wrapIndex(u32(x0), px), wrapIndex(u32(y1), py));
  let n11 = hash2(seed, wrapIndex(u32(x1), px), wrapIndex(u32(y1), py));
  let nx0 = lerp(n00, n10, fx);
  let nx1 = lerp(n01, n11, fx);
  return lerp(nx0, nx1, fy);
}

fn grad2(seed: u32, x: i32, y: i32, px: u32, py: u32) -> vec2<f32> {
  let h = hash2(seed, wrapIndex(u32(x), px), wrapIndex(u32(y), py));
  let angle = h * 6.2831853;
  return vec2(cos(angle), sin(angle));
}

fn perlin2(seed: u32, x: f32, y: f32, px: u32, py: u32) -> f32 {
  let x0 = i32(floor(x));
  let y0 = i32(floor(y));
  let x1 = x0 + 1;
  let y1 = y0 + 1;
  let fx = smoothstep01(x - f32(x0));
  let fy = smoothstep01(y - f32(y0));
  let g00 = grad2(seed, x0, y0, px, py);
  let g10 = grad2(seed, x1, y0, px, py);
  let g01 = grad2(seed, x0, y1, px, py);
  let g11 = grad2(seed, x1, y1, px, py);
  let p00 = g00.x * (x - f32(x0)) + g00.y * (y - f32(y0));
  let p10 = g10.x * (x - f32(x1)) + g10.y * (y - f32(y0));
  let p01 = g01.x * (x - f32(x0)) + g01.y * (y - f32(y1));
  let p11 = g11.x * (x - f32(x1)) + g11.y * (y - f32(y1));
  let nx0 = lerp(p00, p10, fx);
  let nx1 = lerp(p01, p11, fx);
  return clamp01(lerp(nx0, nx1, fy) * 0.5 + 0.5);
}

fn simplex2(seed: u32, x: f32, y: f32, px: u32, py: u32) -> f32 {
  let F2 = 0.3660254038;
  let G2 = 0.2113248654;
  let s = (x + y) * F2;
  let i = i32(floor(x + s));
  let j = i32(floor(y + s));
  let t = f32(i + j) * G2;
  let x0 = x - (f32(i) - t);
  let y0 = y - (f32(j) - t);
  var i1 = 0;
  var j1 = 1;
  if (x0 > y0) {
    i1 = 1;
    j1 = 0;
  }
  let x1 = x0 - f32(i1) + G2;
  let y1 = y0 - f32(j1) + G2;
  let x2 = x0 - 1.0 + 2.0 * G2;
  let y2 = y0 - 1.0 + 2.0 * G2;

  var n0 = 0.0;
  var n1 = 0.0;
  var n2 = 0.0;
  let t0 = 0.5 - x0 * x0 - y0 * y0;
  if (t0 > 0.0) {
    let g0 = grad2(seed, i, j, px, py);
    let t0q = t0 * t0;
    n0 = t0q * t0q * (g0.x * x0 + g0.y * y0);
  }
  let t1 = 0.5 - x1 * x1 - y1 * y1;
  if (t1 > 0.0) {
    let g1 = grad2(seed, i + i1, j + j1, px, py);
    let t1q = t1 * t1;
    n1 = t1q * t1q * (g1.x * x1 + g1.y * y1);
  }
  let t2 = 0.5 - x2 * x2 - y2 * y2;
  if (t2 > 0.0) {
    let g2 = grad2(seed, i + 1, j + 1, px, py);
    let t2q = t2 * t2;
    n2 = t2q * t2q * (g2.x * x2 + g2.y * y2);
  }
  let n = (n0 + n1 + n2) * 70.0;
  return clamp01(n * 0.5 + 0.5);
}

fn simplex2b(seed: u32, x: f32, y: f32, px: u32, py: u32) -> f32 {
  let r = 0.7071067812;
  let xr = (x + y) * r;
  let yr = (y - x) * r;
  return simplex2(seed + u32(1297), xr, yr, px, py);
}

fn cellPoint2(seed: u32, jitter: f32, cx: i32, cy: i32, px: u32, py: u32) -> vec2<f32> {
  let wx = wrapIndexI(cx, i32(px));
  let wy = wrapIndexI(cy, i32(py));
  let hx = hash2(seed, u32(wx), u32(wy));
  let hy = hash2(seed, u32(wx + 17), u32(wy + 31));
  return vec2((hx - 0.5) * jitter + 0.5, (hy - 0.5) * jitter + 0.5);
}

fn voronoi2(seed: u32, jitter: f32, x: f32, y: f32, px: u32, py: u32) -> f32 {
  let x0 = i32(floor(x));
  let y0 = i32(floor(y));
  var best = 1000000000.0;
  for (var dx = -1; dx <= 1; dx = dx + 1) {
    for (var dy = -1; dy <= 1; dy = dy + 1) {
      let cx = x0 + dx;
      let cy = y0 + dy;
      let p = cellPoint2(seed, jitter, cx, cy, px, py);
      let posx = f32(cx) + p.x;
      let posy = f32(cy) + p.y;
      let ddx = wrapDelta(posx - x, f32(px));
      let ddy = wrapDelta(posy - y, f32(py));
      let d = ddx * ddx + ddy * ddy;
      best = min(best, d);
    }
  }
  return clamp01(1.0 - sqrt(best) / 1.4142135);
}

fn noise2(kind: u32, seed: u32, x: f32, y: f32, px: u32, py: u32, jitter: f32) -> f32 {
  if (kind == u32(1)) {
    return valueNoise2(seed, x, y, px, py);
  }
  if (kind == u32(2)) {
    return perlin2(seed, x, y, px, py);
  }
  if (kind == u32(3)) {
    return voronoi2(seed, jitter, x, y, px, py);
  }
  if (kind == u32(4)) {
    return simplex2(seed, x, y, px, py);
  }
  return simplex2b(seed, x, y, px, py);
}

fn fractal2(kind: u32, seed: u32, x: f32, y: f32, scale: f32, octaves: u32, lacun: f32, gain: f32, periodX: f32, periodY: f32, jitter: f32) -> f32 {
  var amp = 1.0;
  var freq = 1.0;
  var acc = 0.0;
  var norm = 0.0;
  var i = u32(0);
  loop {
    if (i >= octaves) { break; }
    let px = select(u32(0), u32(max(1.0, floor(periodX * freq + 0.5))), periodX > 0.0);
    let py = select(u32(0), u32(max(1.0, floor(periodY * freq + 0.5))), periodY > 0.0);
    let nx = x / scale * freq;
    let ny = y / scale * freq;
    let v = noise2(kind, seed, nx, ny, px, py, jitter);
    acc = acc + v * amp;
    norm = norm + amp;
    amp = amp * gain;
    freq = freq * lacun;
    i = i + u32(1);
  }
  return select(0.0, acc / norm, norm > 0.0);
}

@compute @workgroup_size(8, 8, 1)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
  let width = u32(params.dims.x);
  let height = u32(params.dims.y);
  if (gid.x >= width || gid.y >= height) {
    return;
  }
  let kind = u32(params.dims.w);
  let scale = max(0.0001, params.scale.x);
  let octs = max(u32(1), u32(params.scale.y));
  let lacun = params.scale.z;
  let gain = params.scale.w;
  let seed = u32(params.extras.x);
  let jitter = params.extras.y;
  let contrast = params.extras.z;
  let brightness = params.extras.w;
  let periodX = params.period.x;
  let periodY = params.period.y;
  let xCoord = select(f32(gid.x), f32(gid.x) * (periodX * scale / params.dims.x), periodX > 0.0);
  let yCoord = select(f32(gid.y), f32(gid.y) * (periodY * scale / params.dims.y), periodY > 0.0);

  var base = 0.0;
  if (kind == u32(0)) {
    base = hash2(seed, u32(floor(xCoord)), u32(floor(yCoord)));
  } else {
    base = fractal2(kind, seed, xCoord, yCoord, scale, octs, lacun, gain, periodX, periodY, jitter);
  }

  let contrasted = (base - 0.5) * contrast + 0.5 + brightness;
  let v = clamp01(contrasted);
  textureStore(out_tex, vec2(i32(gid.x), i32(gid.y)), vec4(v, v, v, 1.0));
}
|])

noise3DSpirv :: BS.ByteString
noise3DSpirv = shaderSpirv $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
struct Params {
  dims: vec4<f32>;
  scale: vec4<f32>;
  extras: vec4<f32>;
  period: vec4<f32>;
};

@group(2) @binding(0)
var<uniform> params: Params;

@group(1) @binding(0)
var<storage> out_tex: texture_storage_3d<rgba8unorm, read_write>;

fn mix32(v: u32) -> u32 {
  var h = v ^ (v >> u32(16));
  h = h * u32(2146121005);
  h = h ^ (h >> u32(15));
  h = h * u32(2221713035);
  return h ^ (h >> u32(16));
}

fn hash3(seed: u32, x: u32, y: u32, z: u32) -> f32 {
  let h = mix32(x * u32(374761393) + y * u32(668265263) + z * u32(2246822519) + seed * u32(3266489917));
  return f32(h & u32(65535)) / 65535.0;
}

fn smoothstep01(t: f32) -> f32 {
  return t * t * (3.0 - 2.0 * t);
}

fn lerp(a: f32, b: f32, t: f32) -> f32 {
  return a + (b - a) * t;
}

fn clamp01(v: f32) -> f32 {
  return clamp(v, 0.0, 1.0);
}

fn wrapIndex(v: u32, period: u32) -> u32 {
  if (period == u32(0)) {
    return v;
  }
  return v % period;
}

fn wrapIndexI(v: i32, period: i32) -> i32 {
  if (period <= 0) {
    return v;
  }
  let m = v % period;
  return select(m, m + period, m < 0);
}

fn wrapDelta(d: f32, period: f32) -> f32 {
  if (period <= 0.0) {
    return d;
  }
  let r = d - period * floor(d / period);
  return select(r, r - period, r > period * 0.5);
}

fn valueNoise3(seed: u32, x: f32, y: f32, z: f32, px: u32, py: u32, pz: u32) -> f32 {
  let x0 = i32(floor(x));
  let y0 = i32(floor(y));
  let z0 = i32(floor(z));
  let x1 = x0 + 1;
  let y1 = y0 + 1;
  let z1 = z0 + 1;
  let fx = smoothstep01(x - f32(x0));
  let fy = smoothstep01(y - f32(y0));
  let fz = smoothstep01(z - f32(z0));
  let n000 = hash3(seed, wrapIndex(u32(x0), px), wrapIndex(u32(y0), py), wrapIndex(u32(z0), pz));
  let n100 = hash3(seed, wrapIndex(u32(x1), px), wrapIndex(u32(y0), py), wrapIndex(u32(z0), pz));
  let n010 = hash3(seed, wrapIndex(u32(x0), px), wrapIndex(u32(y1), py), wrapIndex(u32(z0), pz));
  let n110 = hash3(seed, wrapIndex(u32(x1), px), wrapIndex(u32(y1), py), wrapIndex(u32(z0), pz));
  let n001 = hash3(seed, wrapIndex(u32(x0), px), wrapIndex(u32(y0), py), wrapIndex(u32(z1), pz));
  let n101 = hash3(seed, wrapIndex(u32(x1), px), wrapIndex(u32(y0), py), wrapIndex(u32(z1), pz));
  let n011 = hash3(seed, wrapIndex(u32(x0), px), wrapIndex(u32(y1), py), wrapIndex(u32(z1), pz));
  let n111 = hash3(seed, wrapIndex(u32(x1), px), wrapIndex(u32(y1), py), wrapIndex(u32(z1), pz));
  let nx00 = lerp(n000, n100, fx);
  let nx10 = lerp(n010, n110, fx);
  let nx01 = lerp(n001, n101, fx);
  let nx11 = lerp(n011, n111, fx);
  let nxy0 = lerp(nx00, nx10, fy);
  let nxy1 = lerp(nx01, nx11, fy);
  return lerp(nxy0, nxy1, fz);
}

fn grad3(seed: u32, x: i32, y: i32, z: i32, px: u32, py: u32, pz: u32) -> vec3<f32> {
  let h = hash3(seed, wrapIndex(u32(x), px), wrapIndex(u32(y), py), wrapIndex(u32(z), pz));
  let theta = h * 6.2831853;
  let zc = h * 2.0 - 1.0;
  let r = sqrt(max(0.0, 1.0 - zc * zc));
  return vec3(r * cos(theta), r * sin(theta), zc);
}

fn perlin3(seed: u32, x: f32, y: f32, z: f32, px: u32, py: u32, pz: u32) -> f32 {
  let x0 = i32(floor(x));
  let y0 = i32(floor(y));
  let z0 = i32(floor(z));
  let x1 = x0 + 1;
  let y1 = y0 + 1;
  let z1 = z0 + 1;
  let fx = smoothstep01(x - f32(x0));
  let fy = smoothstep01(y - f32(y0));
  let fz = smoothstep01(z - f32(z0));
  let g000 = grad3(seed, x0, y0, z0, px, py, pz);
  let g100 = grad3(seed, x1, y0, z0, px, py, pz);
  let g010 = grad3(seed, x0, y1, z0, px, py, pz);
  let g110 = grad3(seed, x1, y1, z0, px, py, pz);
  let g001 = grad3(seed, x0, y0, z1, px, py, pz);
  let g101 = grad3(seed, x1, y0, z1, px, py, pz);
  let g011 = grad3(seed, x0, y1, z1, px, py, pz);
  let g111 = grad3(seed, x1, y1, z1, px, py, pz);
  let p000 = g000.x * (x - f32(x0)) + g000.y * (y - f32(y0)) + g000.z * (z - f32(z0));
  let p100 = g100.x * (x - f32(x1)) + g100.y * (y - f32(y0)) + g100.z * (z - f32(z0));
  let p010 = g010.x * (x - f32(x0)) + g010.y * (y - f32(y1)) + g010.z * (z - f32(z0));
  let p110 = g110.x * (x - f32(x1)) + g110.y * (y - f32(y1)) + g110.z * (z - f32(z0));
  let p001 = g001.x * (x - f32(x0)) + g001.y * (y - f32(y0)) + g001.z * (z - f32(z1));
  let p101 = g101.x * (x - f32(x1)) + g101.y * (y - f32(y0)) + g101.z * (z - f32(z1));
  let p011 = g011.x * (x - f32(x0)) + g011.y * (y - f32(y1)) + g011.z * (z - f32(z1));
  let p111 = g111.x * (x - f32(x1)) + g111.y * (y - f32(y1)) + g111.z * (z - f32(z1));
  let nx00 = lerp(p000, p100, fx);
  let nx10 = lerp(p010, p110, fx);
  let nx01 = lerp(p001, p101, fx);
  let nx11 = lerp(p011, p111, fx);
  let nxy0 = lerp(nx00, nx10, fy);
  let nxy1 = lerp(nx01, nx11, fy);
  return clamp01(lerp(nxy0, nxy1, fz) * 0.5 + 0.5);
}

fn simplex3(seed: u32, x: f32, y: f32, z: f32, px: u32, py: u32, pz: u32) -> f32 {
  let F3 = 0.3333333333;
  let G3 = 0.1666666667;
  let s = (x + y + z) * F3;
  let i = i32(floor(x + s));
  let j = i32(floor(y + s));
  let k = i32(floor(z + s));
  let t = f32(i + j + k) * G3;
  let x0 = x - (f32(i) - t);
  let y0 = y - (f32(j) - t);
  let z0 = z - (f32(k) - t);
  var i1 = 0;
  var j1 = 0;
  var k1 = 0;
  var i2 = 0;
  var j2 = 0;
  var k2 = 0;
  if (x0 >= y0) {
    if (y0 >= z0) {
      i1 = 1;
      j1 = 0;
      k1 = 0;
      i2 = 1;
      j2 = 1;
      k2 = 0;
    } else {
      if (x0 >= z0) {
        i1 = 1;
        j1 = 0;
        k1 = 0;
        i2 = 1;
        j2 = 0;
        k2 = 1;
      } else {
        i1 = 0;
        j1 = 0;
        k1 = 1;
        i2 = 1;
        j2 = 0;
        k2 = 1;
      }
    }
  } else {
    if (y0 < z0) {
      i1 = 0;
      j1 = 0;
      k1 = 1;
      i2 = 0;
      j2 = 1;
      k2 = 1;
    } else {
      if (x0 < z0) {
        i1 = 0;
        j1 = 1;
        k1 = 0;
        i2 = 0;
        j2 = 1;
        k2 = 1;
      } else {
        i1 = 0;
        j1 = 1;
        k1 = 0;
        i2 = 1;
        j2 = 1;
        k2 = 0;
      }
    }
  }
  let x1 = x0 - f32(i1) + G3;
  let y1 = y0 - f32(j1) + G3;
  let z1 = z0 - f32(k1) + G3;
  let x2 = x0 - f32(i2) + 2.0 * G3;
  let y2 = y0 - f32(j2) + 2.0 * G3;
  let z2 = z0 - f32(k2) + 2.0 * G3;
  let x3 = x0 - 1.0 + 3.0 * G3;
  let y3 = y0 - 1.0 + 3.0 * G3;
  let z3 = z0 - 1.0 + 3.0 * G3;

  var n0 = 0.0;
  var n1 = 0.0;
  var n2 = 0.0;
  var n3 = 0.0;
  let t0 = 0.6 - x0 * x0 - y0 * y0 - z0 * z0;
  if (t0 > 0.0) {
    let g0 = grad3(seed, i, j, k, px, py, pz);
    let t0q = t0 * t0;
    n0 = t0q * t0q * (g0.x * x0 + g0.y * y0 + g0.z * z0);
  }
  let t1 = 0.6 - x1 * x1 - y1 * y1 - z1 * z1;
  if (t1 > 0.0) {
    let g1 = grad3(seed, i + i1, j + j1, k + k1, px, py, pz);
    let t1q = t1 * t1;
    n1 = t1q * t1q * (g1.x * x1 + g1.y * y1 + g1.z * z1);
  }
  let t2 = 0.6 - x2 * x2 - y2 * y2 - z2 * z2;
  if (t2 > 0.0) {
    let g2 = grad3(seed, i + i2, j + j2, k + k2, px, py, pz);
    let t2q = t2 * t2;
    n2 = t2q * t2q * (g2.x * x2 + g2.y * y2 + g2.z * z2);
  }
  let t3 = 0.6 - x3 * x3 - y3 * y3 - z3 * z3;
  if (t3 > 0.0) {
    let g3 = grad3(seed, i + 1, j + 1, k + 1, px, py, pz);
    let t3q = t3 * t3;
    n3 = t3q * t3q * (g3.x * x3 + g3.y * y3 + g3.z * z3);
  }
  let n = (n0 + n1 + n2 + n3) * 32.0;
  return clamp01(n * 0.5 + 0.5);
}

fn simplex3b(seed: u32, x: f32, y: f32, z: f32, px: u32, py: u32, pz: u32) -> f32 {
  let r = 0.7071067812;
  let xr = (x + y) * r;
  let yr = (y - x) * r;
  return simplex3(seed + u32(1297), xr, yr, z, px, py, pz);
}

fn cellPoint3(seed: u32, jitter: f32, cx: i32, cy: i32, cz: i32, px: u32, py: u32, pz: u32) -> vec3<f32> {
  let wx = wrapIndexI(cx, i32(px));
  let wy = wrapIndexI(cy, i32(py));
  let wz = wrapIndexI(cz, i32(pz));
  let hx = hash3(seed, u32(wx), u32(wy), u32(wz));
  let hy = hash3(seed, u32(wx + 17), u32(wy + 31), u32(wz + 57));
  let hz = hash3(seed, u32(wx + 29), u32(wy + 71), u32(wz + 19));
  return vec3((hx - 0.5) * jitter + 0.5, (hy - 0.5) * jitter + 0.5, (hz - 0.5) * jitter + 0.5);
}

fn voronoi3(seed: u32, jitter: f32, x: f32, y: f32, z: f32, px: u32, py: u32, pz: u32) -> f32 {
  let x0 = i32(floor(x));
  let y0 = i32(floor(y));
  let z0 = i32(floor(z));
  var best = 1000000000.0;
  for (var dx = -1; dx <= 1; dx = dx + 1) {
    for (var dy = -1; dy <= 1; dy = dy + 1) {
      for (var dz = -1; dz <= 1; dz = dz + 1) {
        let cx = x0 + dx;
        let cy = y0 + dy;
        let cz = z0 + dz;
        let p = cellPoint3(seed, jitter, cx, cy, cz, px, py, pz);
        let posx = f32(cx) + p.x;
        let posy = f32(cy) + p.y;
        let posz = f32(cz) + p.z;
        let ddx = wrapDelta(posx - x, f32(px));
        let ddy = wrapDelta(posy - y, f32(py));
        let ddz = wrapDelta(posz - z, f32(pz));
        let d = ddx * ddx + ddy * ddy + ddz * ddz;
        best = min(best, d);
      }
    }
  }
  return clamp01(1.0 - sqrt(best) / 1.7320508);
}

fn noise3(kind: u32, seed: u32, x: f32, y: f32, z: f32, px: u32, py: u32, pz: u32, jitter: f32) -> f32 {
  if (kind == u32(1)) {
    return valueNoise3(seed, x, y, z, px, py, pz);
  }
  if (kind == u32(2)) {
    return perlin3(seed, x, y, z, px, py, pz);
  }
  if (kind == u32(3)) {
    return voronoi3(seed, jitter, x, y, z, px, py, pz);
  }
  if (kind == u32(4)) {
    return simplex3(seed, x, y, z, px, py, pz);
  }
  return simplex3b(seed, x, y, z, px, py, pz);
}

fn fractal3(kind: u32, seed: u32, x: f32, y: f32, z: f32, scale: f32, octaves: u32, lacun: f32, gain: f32, periodX: f32, periodY: f32, periodZ: f32, jitter: f32) -> f32 {
  var amp = 1.0;
  var freq = 1.0;
  var acc = 0.0;
  var norm = 0.0;
  var i = u32(0);
  loop {
    if (i >= octaves) { break; }
    let px = select(u32(0), u32(max(1.0, floor(periodX * freq + 0.5))), periodX > 0.0);
    let py = select(u32(0), u32(max(1.0, floor(periodY * freq + 0.5))), periodY > 0.0);
    let pz = select(u32(0), u32(max(1.0, floor(periodZ * freq + 0.5))), periodZ > 0.0);
    let nx = x / scale * freq;
    let ny = y / scale * freq;
    let nz = z / scale * freq;
    let v = noise3(kind, seed, nx, ny, nz, px, py, pz, jitter);
    acc = acc + v * amp;
    norm = norm + amp;
    amp = amp * gain;
    freq = freq * lacun;
    i = i + u32(1);
  }
  return select(0.0, acc / norm, norm > 0.0);
}

@compute @workgroup_size(4, 4, 4)
fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
  let width = u32(params.dims.x);
  let height = u32(params.dims.y);
  let depth = u32(params.dims.z);
  if (gid.x >= width || gid.y >= height || gid.z >= depth) {
    return;
  }
  let kind = u32(params.dims.w);
  let scale = max(0.0001, params.scale.x);
  let octs = max(u32(1), u32(params.scale.y));
  let lacun = params.scale.z;
  let gain = params.scale.w;
  let seed = u32(params.extras.x);
  let jitter = params.extras.y;
  let contrast = params.extras.z;
  let brightness = params.extras.w;
  let periodX = params.period.x;
  let periodY = params.period.y;
  let periodZ = params.period.z;
  let xCoord = select(f32(gid.x), f32(gid.x) * (periodX * scale / params.dims.x), periodX > 0.0);
  let yCoord = select(f32(gid.y), f32(gid.y) * (periodY * scale / params.dims.y), periodY > 0.0);
  let zCoord = select(f32(gid.z), f32(gid.z) * (periodZ * scale / params.dims.z), periodZ > 0.0);

  var base = 0.0;
  if (kind == u32(0)) {
    base = hash3(seed, u32(floor(xCoord)), u32(floor(yCoord)), u32(floor(zCoord)));
  } else {
    base = fractal3(kind, seed, xCoord, yCoord, zCoord, scale, octs, lacun, gain, periodX, periodY, periodZ, jitter);
  }

  let contrasted = (base - 0.5) * contrast + 0.5 + brightness;
  let v = clamp01(contrasted);
  textureStore(out_tex, vec3(i32(gid.x), i32(gid.y), i32(gid.z)), vec4(v, v, v, 1.0));
}
|])

main :: IO ()
main = do
  putStrLn "vertex"
  print (BS.unpack vertexSpirv)
  putStrLn "vertex3d"
  print (BS.unpack vertex3DSpirv)
  putStrLn "fragment"
  print (BS.unpack fragmentSpirv)
  putStrLn "noise2d"
  print (BS.unpack noise2DSpirv)
  putStrLn "noise3d"
  print (BS.unpack noise3DSpirv)
