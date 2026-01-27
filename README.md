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
  let load label spec = loadAssetAsync spec >>= awaitAsset >>= expect label
  texture <- load "texture" (TextureAsset "assets/sprite.bmp")

  loop () $ \frame _ -> do
    when (frame.quitRequested || keyPressed KeyEscape frame.input) $
      pure (Quit ())

    let (w, h) = frame.renderSize
    let cam = camera2DScreen (fromIntegral w, fromIntegral h)

    clear (rgb 0.06 0.07 0.1)
    draw (basic2D cam) (Sprite texture Nothing (rect 80 120 160 160) Nothing)
    draw basicUI (text font "Slop" 40 40)

    pure (Continue ())
```

## Concepts

- **WindowM**: main application monad. `runWindow` initializes SDL, GPU device, swapchain, mixer, and assets.
- **Loop**: rendering monad used inside the frame loop.
- **Frame**: snapshot of inputs, timing, window size, drawable size, and quitRequested.
  - `frame.size` = logical window size.
  - `frame.renderSize` = swapchain/drawable pixel size (use this for rendering).
  - `frame.dpiScale` = `renderSize / size` as a `V2 Float`.

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
import Slop hiding (clear, draw, output, render)
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

## Standard Pipelines

Slop ships with standard pipelines; most code should use these:

- `basic2D cam` — standard alpha blending, **camera required**.
- `basicUI` — premultiplied alpha in screen space.
- `basicParticle` — additive blending.
- `basic3D cam` — depth test/write on, blending off, for meshes.

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

`Vertex3D` layout: `vec4 position`, `vec2 uv`, `vec4 color`.

## Shaders

Slop supports custom graphics and compute pipelines (`Pipeline`, `Binding`, `ComputeBinding`).
The demo uses Spirdo to compile WESL -> SPIR-V. Slop itself is Spirdo-free.

### Sprite shader override (fragment)

```haskell
effect <- spriteEffectNamed fx
  [ NamedUniform "params" params
  , NamedSamplerWith "noiseTex" noiseTex sampler
  ]

draw (basic2D cam) (Sprite tex Nothing dst (Just effect))
```

### Uniform safety

Size-checked helpers return `Either String` instead of crashing:

```haskell
let u = shaderUniformSized 0 16 params      -- Either String ShaderUniform
let u' = shaderUniformBytesSized 0 16 bytes -- Either String ShaderUniform
```

### Sampler bindings (contiguous slots)

Slop treats samplers as a contiguous array of slots starting at 0. Always bind samplers
densely (0..N-1) to avoid binding errors:

```haskell
let effect =
      SpriteEffect shader
        [ ShaderSamplerWith 0 albedoTex sampler
        , ShaderSamplerWith 1 noiseTex sampler
        ]
draw basicUI (Sprite albedoTex Nothing (rect 40 40 256 256) (Just effect))
```

If a shader has optional textures, still bind a valid placeholder (e.g. a 1x1 white texture)
to keep slots contiguous.

### SlopGlobals (auto-bound uniform)

Slop auto-binds a global uniform at slot 0 for fragment shaders that declare at least one
uniform buffer. Use it for time and render size without manual plumbing:

```wgsl
struct SlopGlobals {
  time: f32,
  _pad0: f32,
  renderSize: vec2<f32>,
  dpiScale: vec2<f32>,
  _pad1: vec2<f32>,
};

@group(0) @binding(0) var<uniform> slop: SlopGlobals;
```

You can still override slot 0 explicitly via `withShaderBindings` if needed.
If you add your own uniforms, start them at `@binding(1)` to avoid clobbering `SlopGlobals`.

### Fullscreen UV helper

Sprites already provide a canonical `uv` in `[0..1]`. For screen-space effects, draw a full
screen sprite using the drawable size:

```haskell
let dst = fullscreenRect frame.renderSize
draw basicUI (Sprite tex Nothing dst (Just effect))
```

This avoids manual `frag_coord` math in shaders.

## Text

Use `TextStyle` to control color or override the fragment shader for text.
Text created via `text`/`textWith` is cached automatically per frame. `drawText` and
`measureText` use the same cache.
Text helpers take `Data.Text.Text` (enable `OverloadedStrings` or use `Data.Text.pack`).

If you want compositional style changes, use `TextStylePatch`:

```haskell
let patch =
      mconcat
        [ patchTextColor (rgb 1 0.6 0.2)
        , patchTextBlend (Just BlendAdditive)
        ]
let style = applyTextStylePatch textStyle patch
draw basicUI (textWith style font "Patched text" 40 40)
```

```haskell
let style = textColor (rgb 1 0.6 0.2) textStyle
draw basicUI (textWith style font "Warm text" 40 40)
```

Measure text size for layout:

```haskell
size <- measureText font "Measure me"
-- size :: V2 Float (width, height)
```

`measureText` uses the text cache (same cache as `drawText`/`text`).

### Resource helpers (explicit lifetime)

```haskell
withResource
  (do target <- createRenderTarget 512 512
      pure Resource { resourceValue = target, resourceRelease = destroyTarget target })
  (\target -> render target (clear (rgb 0 0 0)))
```

### Uniform caching (avoid redundant uploads)

```haskell
cache <- liftIO newUniformCache
let paramsBytes = ...
setShaderUniformBytesCachedWith cache shader 0 paramsBytes
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
let load label spec = loadAssetAsync spec >>= awaitAsset >>= expect label
texture <- load "texture" (TextureAsset "assets/sprite.bmp")
```

Typed errors:

```haskell
texId <- loadAssetE (TextureAsset "assets/sprite.bmp")
texture <- expectE "texture" =<< awaitAssetE texId
```

If you're not using `loop`, call `processMainAssets` to progress main-thread loads.

### Non-blocking asset reads in the loop

Use `getAsset` (or the `getAssetReady` alias) to poll without blocking and render a fallback while it loads:

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

Noise types supported: `NoiseWhite`, `NoiseValue`, `NoisePerlin`, `NoiseVoronoi`.

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
let load label spec = loadAssetAsync spec >>= awaitAsset >>= expect label
noiseTex <- load "noise" (NoiseTexture2DAsset 256 256 defaultNoiseSettings)
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
let load label spec = loadAssetAsync spec >>= awaitAsset >>= expect label
volume <- load "noise3d" (NoiseTexture3DAsset 64 64 64 defaultNoiseSettings)

let effect =
      SpriteEffect shader
        [ NamedSamplerWith "noiseTex3D" volume sampler
        , NamedUniform "time" time
        ]

draw (basic2D cam) (Sprite tex Nothing (rect 40 80 256 256) (Just effect))
```
In your fragment shader, sample with `texture_3d`:

```haskell
-- WESL-ish (spirdo)
-- @group(0) @binding(0) var noiseTex3D: texture_3d<f32>;
-- @group(0) @binding(1) var noiseSampler: sampler;
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
_ <- runLoop (crossfadeToLoop blend ambience 0)

when (keyPressed KeyB frame.input) $ do
  _ <- crossfadeToLoop blend ambienceAlt 2.0
  pure ()
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
- Use the Graph DSL for post-process chains and multi-pass effects.
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
- Keep fragment samplers contiguous (Slop expects combined sampler slots 0..N-1).

Don't:
- Assume the swapchain/backbuffer can be sampled directly (it can't).

## Demo

See `exe/Main.hs` for a single demo that combines: pipeline graph, sprites, text,
custom shaders, compute, and audio pools.
