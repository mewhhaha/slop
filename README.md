# Slop

Slop is a small SDL3.4 + SDL_gpu rendering + audio toolkit for Haskell.
It focuses on textures/sprites, declarative render pipelines, async assets,
and SDL3_mixer audio pools + crossfades.

## Features

- SDL3.4 + SDL_gpu backend (`SDL_CreateGPUDevice` + swapchain).
- Standard 2D/3D pipelines with camera helpers (`basic2D`, `basicUI`, `basic3D`).
- Declarative render pipeline DSL (graph or explicit targets).
- Custom graphics + compute pipelines when you need them.
- SDL_ttf TextEngine support + automatic per-frame text caching.
- Keycode-based input with just-pressed/just-released.
- PNG screenshots of the next presented frame.
- Async asset manager with hot reload on by default.
- SDL3_mixer pools (round-robin, oldest, priority, blend/crossfade).
- Spirdo demo integration (WESL -> SPIR-V). The library itself does not depend on Spirdo.

## Requirements

- SDL3 >= 3.4
- SDL3_image
- SDL3_ttf
- SDL3_mixer

`cabal.project` pins Spirdo only for the demo/tools; the library is Spirdo-free.

## Build / Run

```sh
cabal build
cabal run -f demo slop
```

If you only need the library, keep the demo disabled:

```
package slop
  flags: -demo
```

## Quickstart

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Slop

main :: IO ()
main = runWindow defaultConfig $ do
  let load spec = loadAssetAsync spec >>= awaitAsset
  texture <- load (TextureAsset "assets/sprite.bmp")
  font <- load (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)

  loop () $ \frame _ -> do
    when (frame.quitRequested || keyPressed KeyEscape frame.input) $
      pure (Quit ())

    let (w, h) = frame.renderSize
    let cam = camera2DScreen (fromIntegral w, fromIntegral h)

    clear (rgb 0.06 0.07 0.1)
    draw (basic2D cam) (Sprite texture Nothing (rect 80 120 160 160) Nothing)
    clip (rect 32 32 240 80) $
      draw basicUI (text font "Slop" 40 40)

    pure (Continue ())
```

## Concepts

- **WindowM**: the application monad used for setup, frame callbacks, rendering, assets, and audio. `runWindow` initializes SDL, the GPU device, swapchain, mixer, and asset manager.
- **Frame**: snapshot of inputs, timing, window size, drawable size, and quitRequested.
  - `frame.size` = logical window size.
  - `frame.renderSize` = swapchain/drawable pixel size (use this for rendering).
  - `frame.dpiScale` = `renderSize / size` as a `V2 Float`.

Call `screenshot "frame.png"` during a frame to save that frame after its
recorded drawing commands have completed.

Use `clip bounds action` to keep drawing inside target-pixel bounds. Nested
clips intersect, so reusable components cannot escape a parent's viewport.

`Slop` is the common window/input/2D/resource/audio façade. Advanced code opts into focused modules:

- `Slop.GPU` for custom graphics, compute, shaders, bindings, and render targets.
- `Slop.Pipeline` or `Slop.Pipeline.Graph` for declarative render pipelines.
- `Slop.SDL.Raw` only for low-level SDL interop. Common geometry (`FPoint`/`FRect`) is exported by `Slop` and `Slop.Draw2D`.

### Config patches

Use `ConfigPatch` to compose config overrides with `Semigroup/Monoid`:

```haskell
let patch =
      mconcat
        [ mempty { patchWindowTitle = Last (Just "Slop demo") }
        , mempty { patchAssetWorkers = Last (Just 4) }
        ]
let cfg = applyConfigPatch defaultConfig patch
runWindow cfg ...
```

### Asset worker threads

`assetWorkers` controls background worker count (`0` = auto by GHC capabilities).

```haskell
runWindow defaultConfig { assetWorkers = 4 } ...
```

Enable lightweight debug logging:

```haskell
runWindow defaultConfig { debugLog = True } ...
```

## Render Pipelines

Slop gives you two pipeline styles:

- **Graph DSL** (`Slop.Pipeline.Graph`): implicit targets, auto-resize, best for most apps.
- **Explicit targets** (`Slop.Pipeline` + `createRenderTarget`): manual but precise.

### Graph DSL (recommended)

```haskell
import Slop hiding (clear, draw)
import Slop.Pipeline.Graph

_ <- loop () $ \frame _ -> do
  let (w, h) = frame.renderSize
  let winRect = fullscreenRect frame.renderSize
  let cam = camera2DScreen (fromIntegral w, fromIntegral h)

  let scene = pass $ mconcat
        [ clear (rgb 0.06 0.07 0.1)
        , draw (basic2D cam) (Sprite texture Nothing (rect 80 120 160 160) Nothing)
        , draw basicUI (text font "Slop" 40 40)
        ]
  let pipeline =
        outputOf scene Nothing winRect

  render frame.renderSize pipeline
  pure (Continue ())
```

`compile` returns a pure `GraphPlan` you can reuse or inspect, and `renderPlan` executes it.

Reusable plan (precompile once, render every frame):

```haskell
let plan = compile (outputOf scene Nothing winRect)
...
renderPlan frame.renderSize plan
```

### Compute in the graph

```haskell
let scene = pass $ mconcat
      [ clear (rgb 0 0 0)
      , draw (basic2D cam) (Sprite outTex Nothing (rect 0 0 256 256) Nothing)
      ]
let pipeline =
      compute computePipe
        [ computeStorageTextureRW 0 outTex
        , computeUniformBytes 0 paramsBytes
        ]
        (groupsX, groupsY, 1)
        *> outputOf scene Nothing winRect
```

### Explicit targets

```haskell
withRenderTarget 512 512 $ \target -> do
  render target (clear (rgb 0 0 0))
```

### Size helpers (safer invariants)

```haskell
let size = size2D 512 512
tex <- createTexture2DSize size
rt <- createRenderTargetSize size
```

The convenience constructors clamp non-positive values to `1`. Use
`mkSize2D`, `mkSize3D`, `mkThreads2D`, or `mkThreads3D` when invalid input
must be rejected instead.

## Standard Pipelines

Slop ships with standard pipelines; most code should use these:

- `basic2D cam` — standard alpha blending, **camera required**.
- `basicUI` — premultiplied alpha in screen space.
- `basicParticle` — additive blending.
- `basic3D cam` — depth test/write on, blending off, for meshes.

`As2D` is a composable context with `draw2DBlend`, `draw2DCamera`, and
`draw2DEffect` fields. The standard values can be adjusted with record updates
when a shader, camera, and non-default blend mode are needed together.

### 2D camera helpers

```haskell
let cam = camera2D (V2 320 180) 1 (640, 360)
draw (basic2D cam) (RectOutline (rgb 0.2 0.8 0.9) (rect 100 100 120 80))
```

### 3D camera helpers

```haskell
let cam = camera3D (V3 0 0 5) (V3 0 0 0) (V3 0 1 0) (pi/3) (16/9) 0.1 100
mesh <- createMesh3D vertices
draw (basic3D cam) (mesh3D mesh identity [])
```

The 3D helpers follow SDL_gpu's left-handed coordinate system and `0..1` depth range.
`Vertex3D` layout: `vec4 position`, `vec2 uv`, `vec4 color`.

## Game Recipes

### Stateful loop + input (top‑down movement)

```haskell
data Game = Game
  { playerPos :: V2 Float
  } deriving (Eq, Show)

let speed = 220 :: Float
_ <- loop (Game (V2 200 200)) $ \frame game -> do
  let now = frame.input.inputNow
  let dx = (if keyDown KeyD now then 1 else 0) - (if keyDown KeyA now then 1 else 0)
  let dy = (if keyDown KeyS now then 1 else 0) - (if keyDown KeyW now then 1 else 0)
  let pos' =
        game.playerPos
          + V2 (fromIntegral dx * speed * frame.delta)
               (fromIntegral dy * speed * frame.delta)
  let (rw, rh) = frame.renderSize
  let cam = camera2DScreen (fromIntegral rw, fromIntegral rh)
  let V2 px py = pos'

  clear (rgb 0.05 0.06 0.1)
  draw (basic2D cam) (Sprite texture Nothing (rect px py 64 64) Nothing)
  pure (Continue game { playerPos = pos' })
```

### Sprite atlas animation (frame‑based)

```haskell
let frameW = 64
let frameH = 64
let frames = 8
let ix = floor (frame.time * 12) `mod` frames
let src = rect (fromIntegral (ix * frameW)) 0 (fromIntegral frameW) (fromIntegral frameH)
draw (basic2D cam) (Sprite atlas (Just src) (rect 120 140 128 128) Nothing)
```

### Audio pools (music + sfx)

```haskell
blend <- createTrackPool PoolBlend 2
sfxPool <- createTrackPool PoolRoundRobin 8
crossfadeToLoop blend ambience 0

_ <- loop () $ \frame _ -> do
  when (keyPressed KeySpace frame.input) $
    playPool sfxPool sfx
  when (keyPressed KeyB frame.input) $
    crossfadeToLoop blend ambienceAlt 2.0
  pure (Continue ())
```

### Async assets (non‑blocking)

```haskell
spriteId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")

_ <- loop () $ \frame _ -> do
  mSprite <- getAsset spriteId
  case mSprite of
    Nothing -> draw basicUI (text font "Loading..." 40 40)
    Just sprite -> draw (basic2D cam) (Sprite sprite Nothing (rect 80 120 128 128) Nothing)
  pure (Continue ())
```

## Shaders

Slop supports custom graphics and compute pipelines (`Pipeline`, `Binding`, `ComputeBinding`).
The demo uses Spirdo to compile WESL -> SPIR-V. Slop itself is Spirdo-free.
For predictable sampler bindings, use `wesl` with the inline pragma `// spirdo:sampler=combined`.
Import `Slop.GPU` for this API.

### Slop shader ABI (predictable bindings)

Slop’s custom fragment path follows SDL_gpu’s SPIR-V descriptor-set conventions:

- **Fragment samplers / textures / storage textures** live in `@group(2)`.
- **Fragment uniform buffers** live in `@group(3)`.
- Reflected layouts bind values by name and retain slot positions inside `ReflectedShaderLayout`.
- Slop binds samplers as a **combined sampler array** starting at slot 0.
- Use `Shader2D` / `Shader2DAsset` for sprite/text overrides (this path enforces the ABI).
- Separate `texture` + `sampler` bindings **must be combined** (add `// spirdo:sampler=combined`) for the 2D override path.

If these don’t match your shader, you’ll now get a clear runtime error instead of a black frame.
Keep custom shader bindings aligned with these rules for predictable results.

Minimal fragment ABI example:

```wgsl
// spirdo:sampler=combined
struct Params { time: f32; _pad0: f32; renderSize: vec2<f32>; dpiScale: vec2<f32>; _pad1: vec2<f32>; };
@group(3) @binding(0) var<uniform> globals: Params;
@group(2) @binding(0) var tex0: texture_2d<f32>;
@group(2) @binding(1) var tex1: texture_2d<f32>;
@group(2) @binding(2) var samp0: sampler;
@group(2) @binding(3) var samp1: sampler;
```
Compile this with Spirdo so texture+sampler pairs collapse into Slop’s combined sampler slots.
Keep **texture bindings contiguous** (`0..N-1`) so sampler slots are predictable.

### Sprite shader override (Shader2D)

```haskell
layout <- either throwError pure $ shaderLayoutFromReflection "fx" ShaderFragment
  [ ReflectedBinding "globals" 3 0 (ReflectedUniform 32)
  , ReflectedBinding "params" 3 1 (ReflectedUniform (sizeOf params))
  , ReflectedBinding "source" 2 0 ReflectedSampledTexture
  , ReflectedBinding "noiseTex" 2 1 ReflectedSampledTexture
  ]
shader2d <- load (ReflectedShader2DAsset (shaderSpirv shaderSource) layout)

-- Make sure your WESL shader uses group(3) for uniforms and group(2) for samplers.
-- Add `// spirdo:sampler=combined` to the shader source.
fx <- spriteEffectNamed shader2d
  [ NamedUniform "params" params
  , NamedSamplerWith "noiseTex" noiseTex sampler
  ]

draw (basic2D cam) (Sprite tex Nothing dst (Just fx))
```
`shaderLayoutFromReflection` rejects duplicate names/locations, wrong descriptor groups, unsupported kinds, and non-contiguous slots. `spriteEffectNamed` then rejects missing, duplicate, kind-incompatible, or incorrectly sized values with the shader and binding names attached. Reordering reflected declarations does not change renderer code. The positional `ShaderCounts`/`fUniform`/`fSampler` API remains in `Slop.GPU` as the low-level path for shaders without reflection.

### Spirdo quick recipe (combined sampler mode)

Use the inline pragma and keep texture bindings contiguous:

```haskell
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

import Spirdo.Wesl.Reflection
  ( defaultCompileOptions
  , imports
  , shaderSpirv
  , spirv
  , wesl
  )

scanlineShader = $(spirv defaultCompileOptions imports [wesl|
// spirdo:sampler=combined
struct Params { time: f32; _pad0: f32; renderSize: vec2<f32>; _pad1: vec2<f32>; };
@group(3) @binding(0) var<uniform> params: Params;
@group(2) @binding(0) var tex0: texture_2d<f32>;
@group(2) @binding(1) var samp0: sampler;

@fragment
fn main(@location(0) uv: vec2<f32>, @location(1) color: vec4<f32>) -> @location(0) vec4<f32> {
  let tex = textureSample(tex0, samp0, uv);
  let scan = 0.85 + 0.15 * sin(uv.y * params.renderSize.y * 0.25 + params.time * 18.0);
  return vec4(tex.rgb * scan, tex.a) * color;
}
|])

layout <- either throwError pure $ shaderLayoutFromReflection "scanline" ShaderFragment
  [ ReflectedBinding "params" 3 0 (ReflectedUniform 32)
  , ReflectedBinding "tex0" 2 0 ReflectedSampledTexture
  ]
shader2d <- load (ReflectedShader2DAsset (shaderSpirv scanlineShader) layout)
fx <- spriteEffectNamed shader2d [NamedUniform "params" params]
draw (basic2D cam) (Sprite tex Nothing dst (Just fx))
```

If you’re using Spirdo’s `inputsFor` for custom pipelines, remember:
in `SamplerCombined` mode sampler bindings are **not** part of the interface.
Use `sampledTexture @"tex0" texHandle samplerHandle` in the input builder, or
bind sampler slots explicitly in Slop with `ShaderSamplerWith`.

### Uniform safety

Size-checked helpers return `Result`, so failures use the same error vocabulary as shader creation and asset loading:

```haskell
let u = shaderUniformSized 0 16 params      -- Result ShaderUniform
let u' = shaderUniformBytesSized 0 16 bytes -- Result ShaderUniform
```

### Sampler bindings (contiguous slots)

Slop treats samplers as an array of slots starting at 0. Slots can be sparse (gaps are
filled with a safe placeholder), but for clarity most examples bind densely (0..N-1):

If you compile with Spirdo, add `// spirdo:sampler=combined` so sampler slots match Slop.

```haskell
let fx =
      SpriteEffect shader2d
        [ ShaderSamplerWith 0 albedoTex sampler
        , ShaderSamplerWith 1 noiseTex sampler
        ]
draw basicUI (Sprite albedoTex Nothing (rect 40 40 256 256) (Just fx))
```

If a shader has optional textures, you can either skip the slot (Slop fills it) or bind
an explicit placeholder (e.g. a 1x1 white texture).
These samplers correspond to `@group(2)` in your fragment shader.

### Globals (auto-bound uniform)

Slop auto-binds a global uniform at slot 0 for fragment shaders that declare at least one
uniform buffer. Use it for time and render size without manual plumbing:

```wgsl
struct Globals {
  time: f32,
  _pad0: f32,
  renderSize: vec2<f32>,
  dpiScale: vec2<f32>,
  _pad1: vec2<f32>,
};

@group(3) @binding(0) var<uniform> globals: Globals;
```

You can still override slot 0 explicitly via `withShaderBindings` if needed.
If you add your own uniforms, start them at `@binding(1)` (group 3) to avoid clobbering `Globals`.

### Fullscreen UV helper

Sprites already provide a canonical `uv` in `[0..1]`. For screen-space overrides, draw a full
screen sprite using the drawable size:

```haskell
let dst = fullscreenRect frame.renderSize
draw basicUI (Sprite tex Nothing dst (Just fx))
```

This avoids manual `frag_coord` math in shaders.

## Text

Use `TextStyle` to control color or override the fragment shader for text via `textShader`.
Text created via `text`/`textWith` is cached automatically per frame. `drawText` and
`measureText` use the same cache.
Text helpers take `Data.Text.Text` (enable `OverloadedStrings` or use `Data.Text.pack`).

If you want compositional style changes, use `TextStylePatch` (e.g. `patchTextShader`):

```haskell
let patch =
      mconcat
        [ patchTextColor (rgb 1 0.6 0.2)
        , patchTextBlend (Just BlendAdditive)
        ]
let style = applyTextStylePatch defaultTextStyle patch
draw basicUI (textWith style font "Patched text" 40 40)
```

```haskell
let style = textColor (rgb 1 0.6 0.2) defaultTextStyle
draw basicUI (textWith style font "Warm text" 40 40)
```

Measure text size for layout:

```haskell
size <- measureText font "Measure me"
-- size :: V2 Float (width, height)
```

`measureText` uses the text cache (same cache as `drawText`/`text`).

### Resource ownership

Normal direct acquisition functions (`loadTexture`, `loadFont`, `createText`, and the constructors in `Slop.GPU`) register their result with the window. Shutdown releases those resources in reverse acquisition order, including when setup or the frame loop throws. The corresponding `destroy*` functions remain available for early release and unregister the resource before destroying it.

Assets have the same guarantee through the asset manager. `withResource` is available when a lifetime should end before window shutdown:

```haskell
withResource
  (do target <- createRenderTarget 512 512
      pure Resource { resourceValue = target, resourceRelease = destroyTarget target })
  (\target -> render target (clear (rgb 0 0 0)))
```

## Input

Input is **keycode-based** (layout-aware), not raw scancodes.

```haskell
when (keyPressed KeySpace frame.input) ...
when (keyReleased KeyB frame.input) ...
```

Additional per-frame input:

```haskell
let typed = frame.input.text
let wheel = frame.input.wheel
let mods = frame.input.mods
let events = frame.input.events
```

`text`/`typed` values are `Data.Text.Text`.

Input events:

```haskell
forM_ frame.input.events $ \ev ->
  case ev of
    EventText t -> ...
    EventMouseWheel d -> ...
    EventQuit -> ...
```

Text input is enabled by default; you can control it explicitly:

```haskell
_ <- startTextInput
_ <- stopTextInput
```

## Assets

Assets are typed and managed in `WindowM`. Async loads run on background threads,
but GPU-backed assets load on the **main thread** even when requested via `loadAssetAsync`.

```haskell
let load spec = loadAssetAsync spec >>= awaitAsset
texture <- load (TextureAsset "assets/sprite.bmp")
```

`loadAsset`, `awaitAsset`, and `awaitAssetUpdate` throw `Error`, whose constructors retain the operation and offending asset, shader, binding, or SDL call. Use the result variants when failure is expected and recoverable:

```haskell
texId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")
result <- awaitAssetResult texId
case result of
  Left err -> logDebug (renderError err)
  Right texture -> ...
```

Custom `AssetLoader` implementations return `Result` from `loadAssetIO`, so extension loaders use the same error model without converting failures through `String`.

If you're not using `loop`, call `processMainAssets` to progress main-thread loads.

### Non-blocking asset reads in the loop

Use `getAsset` to poll without blocking and render a fallback while it loads:

```haskell
data DemoState = DemoState
  { texId :: Maybe (AssetId Texture)
  , tex   :: Maybe Texture
  }

loop (DemoState Nothing Nothing) $ \frame st -> do
  st' <- case st.texId of
    Nothing -> do
      tid <- loadAssetAsync (TextureAsset "assets/sprite.bmp")
      pure st { texId = Just tid }
    Just _ -> pure st

  tex' <- case st'.tex of
    Just t  -> pure (Just t)
    Nothing -> case st'.texId of
      Nothing  -> pure Nothing
      Just tid -> getAsset tid

  let st'' = st' { tex = tex' }

  case st''.tex of
    Just t  -> draw (basic2D cam) (Sprite t Nothing dst Nothing)
    Nothing -> draw basicUI (text font "Loading..." 40 40)

  pure (Continue st'')
```

### Hot Reload

Hot reload is enabled by default. It watches file-backed assets (textures, fonts, audio)
and updates them when timestamps change.

```haskell
enableHotReload 0.5
-- or
disableHotReload
```

Use `getAsset`/`awaitAsset` to see the refreshed values if you cached a value locally.

## Noise Textures

Generate procedural noise on the GPU (compute) into a texture:

```haskell
let noiseSettings = defaultNoiseSettings
      { noiseType = NoisePerlin
      , noiseScale = 16
      , noiseOctaves = 4
      , noiseComputeThreads2D = threads2D 8 8
      }
noiseTex <- createNoiseTexture2D 512 512 noiseSettings
```

Draw it like a normal sprite:

```haskell
draw basicUI (Sprite noiseTex Nothing (rect 40 80 256 256) Nothing)
```

Noise types supported: `NoiseWhite`, `NoiseValue`, `NoisePerlin`, `NoiseVoronoi`, `NoiseSimplex`, `NoiseSimplex2`.

Examples:

```haskell
white <- createNoiseTexture2D 256 256 defaultNoiseSettings { noiseType = NoiseWhite }
cell <- createNoiseTexture2D 256 256 defaultNoiseSettings
  { noiseType = NoiseVoronoi
  , noiseScale = 32
  , noiseVoronoiJitter = 0.7
  }
```

Noise textures can also be created as assets for automatic cleanup:

```haskell
let load spec = loadAssetAsync spec >>= awaitAsset
noiseTex <- load (NoiseTexture2DAsset 256 256 defaultNoiseSettings)
```

Looping (tiled) noise:

```haskell
let settings =
      loopNoise2D 256 256
        defaultNoiseSettings
          { noiseType = NoisePerlin
          , noiseScale = 16
          , noiseOctaves = 4
          }
noiseTex <- createNoiseTexture2D 256 256 settings
```

`loopNoise2D/loopNoise3D` sets `noisePeriod2D/3D` based on your texture size and `noiseScale`,
so the noise tiles seamlessly across the full texture. If you want exact control, set
`noisePeriod2D/3D` manually.

When `noisePeriod2D/3D` is set, Slop generates noise over a half-open domain `[0,1)` so the
texture tiles without duplicate endpoints. Use repeat wrap in your sampler for seamless loops.
For animated 3D noise, pass time continuously (no `fract`) and rely on repeat addressing to wrap.

3D noise textures are also supported:

```haskell
volume <- createNoiseTexture3D 64 64 64 defaultNoiseSettings
```

Custom compute thread sizes:

```haskell
let volumeSettings = defaultNoiseSettings
      { noiseComputeThreads3D = threads3D 4 4 4 }
volume <- createNoiseTexture3D 64 64 64 volumeSettings
```

Looping 3D volumes:

```haskell
let volumeSize = 160
let volumeSettings =
      loopNoise3D volumeSize volumeSize volumeSize
        defaultNoiseSettings
          { noiseType = NoisePerlin
          , noiseScale = 8
          , noiseOctaves = 5
          }
volume <- createNoiseTexture3D volumeSize volumeSize volumeSize volumeSettings
```

Higher resolution looks smoother (more slices):

```haskell
let hiRes =
      loopNoise3D 192 192 192
        defaultNoiseSettings
          { noiseType = NoisePerlin
          , noiseScale = 10
          , noiseOctaves = 5
          }
volume <- createNoiseTexture3D 192 192 192 hiRes
```

Use a custom shader to sample `texture_3d` (pass time or a slice as Z):

```haskell
let load spec = loadAssetAsync spec >>= awaitAsset
volume <- load (NoiseTexture3DAsset 64 64 64 defaultNoiseSettings)

fx <- spriteEffectNamed shader2d
  [ NamedSamplerWith "noiseTex3D" volume sampler
  , NamedUniform "time" time
  ]

draw (basic2D cam) (Sprite tex Nothing (rect 40 80 256 256) (Just fx))
```
In your fragment shader, sample with `texture_3d`:

```haskell
-- WESL-ish (spirdo)
-- @group(2) @binding(0) var noiseTex3D: texture_3d<f32>;
-- @group(2) @binding(1) var noiseSampler: sampler;
-- let n = textureSample(noiseTex3D, noiseSampler, vec3(in.uv, time));
```

## Audio

Slop wraps SDL3_mixer and **streams audio from disk** by default:

- `MusicAsset` / `ChunkAsset` resolve to `AudioStream FilePath`.
- Playback uses `SDL_IOFromFile` + `MIX_SetTrackIOStream`.
- No upfront decode / RAM load.

If you want fully loaded audio, create it yourself and use `AudioLoaded` (advanced).

### Pools

```haskell
blend <- createTrackPool PoolBlend 2
crossfadeToLoop blend ambience 0

when (keyPressed KeyB frame.input) $ do
  crossfadeToLoop blend ambienceAlt 2.0
```

Pool strategies:

- `PoolRoundRobin`
- `PoolOldest`
- `PoolPriority`
- `PoolBlend` (crossfade)

Blend pools auto-update each frame; no manual ticking required.

### Track pool priorities (SFX)

```haskell
pool <- createTrackPool PoolPriority 8
_ <- playPoolPriority pool sfx (Just 10)
```

## Do / Don't

### Rendering

Do:
- Use `basic2D` + a camera for most 2D work.
- Keep UI/text in `basicUI` (screen-space, premultiplied alpha).
- Use the Graph DSL for post-process chains and multi-pass overrides.
- Use `frame.renderSize` for rendering math (HiDPI swapchains can differ from `frame.size`).

Don't:
- Mix UI and world-space sprites in the same camera unless that's deliberate.
- Create/destroy GPU textures every frame (use assets or cached render targets).
- Assume fragment-only helpers apply to vertex/compute stages.
- Assume `frame.size` matches the drawable/swapchain size on HiDPI displays.

### Assets

Do:
- Use `loadAssetAsync` and `awaitAsset` for file-backed assets.
- Call `processMainAssets` if you bypass the built-in `loop`.
- Let the asset manager own textures/shaders/pipelines so cleanup is automatic.

Don't:
- Create GPU resources on worker threads.
- Cache a reloaded asset forever without re-fetching it.

### Audio

Do:
- Use pools for overlapping SFX or crossfades.
- Stream music from disk (default behavior).

Don't:
- Decode large audio blobs into RAM unless you really need it.

### Input

Do:
- Use keycodes (`KeyA`, `KeySpace`) to respect keyboard layout.

Don't:
- Depend on scancode positions unless you're building a keybinding editor.

### Shaders

Do:
- Keep sprite overrides fragment-only unless you define a custom pipeline.
- Prefer `shaderUniformSized` to avoid mismatch crashes.
- Keep sampler slots stable and explicit; Slop will fill gaps if you use sparse slots.

Don't:
- Assume the swapchain/backbuffer can be sampled directly (it can't).

## Demo

See `exe/Main.hs` for a single demo that combines: pipeline graph, sprites, text,
custom shaders, compute, and audio pools.

Regenerate the embedded default shader byte lists with:

```sh
cabal run -f demo slop-spirv-gen
```
