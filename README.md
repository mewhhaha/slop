# Slop

Slop is a small SDL3.4-based rendering + audio toolkit for Haskell. It focuses on textures/sprites, a declarative render pipeline, async asset loading, and SDL3_mixer audio with track pools and crossfades.

## Features

- SDL3.4 SDL_gpu backend (`SDL_CreateGPUDevice` + swapchain) with custom graphics + compute pipelines.
- Declarative pipeline builders (`defaultGraphics`/`graphicsPipeline`, `defaultCompute`/`computePipeline`).
- Declarative render pipelines (graph DSL or explicit targets) with implicit render targets.
- SDL_ttf TextEngine support + optional SDF fonts.
- Keycode-based input with just-pressed/just-released helpers.
- Async asset manager with background loading + typed asset IDs.
- SDL3_mixer audio pools (round-robin, oldest, priority, blend/crossfade).
- Spirdo shader integration for the demo/tools (WESL -> SPIR-V).

## Requirements

- SDL3 >= 3.4
- SDL3_image
- SDL3_ttf
- SDL3_mixer

`cabal.project` pins `spirdo` for the demo/tools; the library does not require it.

## Build / Run

```sh
cabal build
cabal run -f demo slop
```

If you only need the library (e.g. as a dependency), the demo executable stays disabled by default. You can also pin it off explicitly in your `cabal.project`:

```
package slop
  flags: -demo
```

### Asset worker threads

`assetWorkers` controls how many background worker threads handle `AssetAny` loads. Set it to `0` to auto-pick based on GHC capabilities.

```haskell
let cfg = defaultConfig { assetWorkers = 4 }
runWindow cfg ...
```

## Modules

- `Slop` — public API, window/loop, rendering helpers, assets, audio pools.
- `Slop.SDL.Raw` — raw SDL3 + SDL_gpu / SDL3_image / SDL3_ttf / SDL3_mixer FFI bindings.
- `Slop.Pipeline` — explicit render targets + pass-based pipeline helpers.
- `Slop.Pipeline.Graph` — graph-based pipeline DSL (implicit targets, works with `draw`).
- `Slop.Storable.Generic` — Generic-based helpers for writing `Storable` instances.

## Window + Loop

The main loop runs in `WindowM` and renders via the `Loop` monad.

```haskell
import Slop

main :: IO ()
main = runWindow defaultConfig $ do
  texId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")
  texture <- awaitAsset texId >>= either (error . ("texture: " <>)) pure
  loop () $ \frame _ -> do
    when (frame.quitRequested || keyPressed KeyEscape frame.input) $
      pure (Quit ())
    let (winWInt, winHInt) = frame.size
    let cam = camera2DScreen (fromIntegral winWInt, fromIntegral winHInt)
    clear (rgb 0.06 0.07 0.1)
    draw (basic2D cam) (Sprite texture Nothing (rect 80 320 160 160) Nothing)
    draw (basic2D cam) (Sprite texture Nothing (rect 280 320 160 160) (Just (spriteEffect shader uniforms)))
    pure (Continue ())
```

`Frame` includes time, delta, window size, quitRequested, and `InputFrame` with key/mouse state.

Custom pipelines are supported, but the examples below stick to the standard 2D pipeline.

### Config patches

Use `ConfigPatch` to compose overrides with a `Semigroup`/`Monoid`:

```haskell
let patch =
      mconcat
        [ mempty { patchWindowTitle = Last (Just "Slop demo") }
        , mempty { patchAssetWorkers = Last (Just 4) }
        ]
let cfg = applyConfigPatch defaultConfig patch
runWindow cfg ...
```

### Reducing memory

If you want to reduce GPU memory usage from the text atlas, set a smaller atlas size:

```haskell
let cfg = defaultConfig { textAtlasSize = Just 1024 }
runWindow cfg ...
```

## Render Pipeline (Graph DSL)

Build a pipeline graph and render it each frame. The graph automatically manages render targets per node and resizes them when the window size changes.

```haskell
import Slop hiding (clear, draw, output, pass, postProcess, render, withShader)
import Slop.Pipeline.Graph

_ <- loop () $ \frame _ -> do
  let (winWInt, winHInt) = frame.size
  let winRect = rect 0 0 (fromIntegral winWInt) (fromIntegral winHInt)
  let cam = camera2DScreen (fromIntegral winWInt, fromIntegral winHInt)
  let pipeline = do
        scene <- pass $ do
          clear (rgb 0.06 0.07 0.1)
          draw (basic2D cam) (Sprite texture Nothing (rect 80 320 160 160) Nothing)
          draw basicUI (text font "Slop + SDL3.4" 80 40)
        output scene Nothing winRect
  render (winWInt, winHInt) pipeline
  pure (Continue ())
```

If you want explicit targets instead, use `Slop.Pipeline` or `createRenderTarget` + `render`.

`withRenderTarget` handles cleanup for you:

```haskell
withRenderTarget 512 512 $ \target -> do
  render target (clear (rgb 0 0 0))
```

Compute steps can live in the graph too:

```haskell
let pipeline = do
      compute computePipe
        [ computeStorageTextureRW 0 outTex
        , computeUniformBytes 0 paramsBytes
        ]
        (groupsX, groupsY, 1)
      scene <- pass $ do
        clear (rgb 0 0 0)
        draw (basic2D cam) (Sprite outTex Nothing (rect 0 0 256 256) Nothing)
      output scene Nothing winRect
```

## Custom pipelines

Slop supports custom graphics/compute pipelines with explicit bindings (`Pipeline`, `Binding`, `ComputeBinding`), but the README and demo keep to the standard 2D pipeline. If you need custom layouts or shaders, see the public API and `exe/Main.hs` for Spirdo adapter helpers.

### Standard 2D pipeline

For 2D draws the pipeline is fixed (sprite layout, triangles, swapchain target). Use `SpriteEffect` to apply a fragment shader override:

```haskell
draw (basic2D cam) (Sprite tex Nothing dst Nothing)
draw (basic2D cam) (Sprite tex Nothing dst (Just (spriteEffect fx uniforms)))
```

If you want a shader on a single sprite, use `SpriteEffect`:

```haskell
effect <- spriteEffectNamed fx
  [ NamedUniform "params" params
  , NamedSamplerWith "noiseTex" noiseTexture sampler
  ]
draw (basic2D cam) (Sprite tex Nothing dst (Just effect))
```

The built-in draw contexts only differ by blend mode today:

- `basic2D`: standard alpha blending (camera required).
- `basicUI` / `basicUIWith`: premultiplied alpha (best for UI/text atlases).
- `basicParticle` / `basicParticleWith`: additive blending.
- `basic3D`: 3D mesh pipeline (depth test/write on; blending off).

`basic2D` uses a camera transform. `basicUI` stays in raw screen space.

`basic3D` is meant for meshes, not the built-in 2D shapes. It enables depth test/write, uses a 4D position attribute, and builds the model-view-projection matrix from the camera + model:

```haskell
mesh <- createMesh3D vertices
let cam = camera3D (Vec3 0 0 5) (Vec3 0 0 0) (Vec3 0 1 0) (pi/3) (16/9) 0.1 100
draw (basic3D cam) (mesh3D mesh mat4Identity [])
```

`Vertex3D` packs position as `vec4` (x, y, z, w), UV as `vec2`, and color as `vec4` in that order.

For 2D, you can supply a camera transform that maps world coordinates to NDC on the CPU:

```haskell
let cam2 = camera2D (Vec2 320 180) 1 (640, 360)
draw (basic2D cam2) (RectOutline (rgb 0.2 0.8 0.9) (rect 100 100 120 80))
```

If you want the camera to auto‑size from the window, use `camera2DWindow`:

```haskell
let cam2 = camera2DWindow (Vec2 0 0) 1
draw (basic2D cam2) (RectOutline (rgb 0.2 0.8 0.9) (rect 0 0 120 80))
```

### Spirdo inputs builder

If you use Spirdo for WESL shaders, the demo shows how to build inputs with
the new semigroup-based builder and feed them into Slop in `exe/Main.hs`.
It uses `prepareShader` + `inputsFromPrepared` + `uniformSlots` for fewer moving parts.

### Legacy shader helpers

`withShader`/`postProcess` accept `ShaderUniform` and are fragment-only. The draw texture is always bound at sampler slot 0; extra sampler slots start at 0 and map to GPU binding slot 1+.

For safer uniforms, prefer the size-checked helpers:

```haskell
let u = shaderUniformChecked 0 16 params -- Either String ShaderUniform
let u' = shaderUniformBytesChecked 0 16 paramsBytes
```

For WESL/SPIR-V with SDL_gpu, fragment resources are in set 2:

- Draw texture: `@group(2) @binding(0)` (texture) and `@binding(1)` (sampler).
- Extra sampler slot 0: `@group(2) @binding(2)` and `@binding(3)`.

Uniform data is pushed via `ShaderUniform` and maps to fragment uniform buffers in set 3:

- Uniform slot 0: `@group(3) @binding(0) var<uniform> ...`

### Named bindings

Named bindings still work with the legacy fragment helper:

```haskell
let bindings =
      ShaderBindings
        { shaderUniformSlots = Map.fromList [("params", 0)]
        , shaderSamplerSlots = Map.fromList [("noiseTex", 0)]
        , shaderStorageTextureSlots = Map.empty
        }
setShaderBindings shader bindings

uniforms <- resolveNamedUniforms bindings
  [ NamedUniform "params" params
  , NamedSamplerWith "noiseTex" noiseTexture sampler
  ]
```

### Storage textures

Use `fStorageTexture` for pipeline draws, or `ShaderStorageTexture` for the legacy helper.

```haskell
let bindings =
      [ fStorageTexture 0 storageTex
      ]
```

### Vertex/compute stages

Custom pipelines support vertex, fragment, and compute bindings via `Binding`/`ComputeBinding`. The legacy shader helpers remain fragment-only.

## Input (Keycodes)

Input is **keycode-based** (layout-aware), not raw scancodes. Use `KeyA`, `KeyB`, `KeySpace`, etc.

```haskell
when (keyPressed KeyB frame.input) ...
when (keyReleased KeySpace frame.input) ...
```

## Assets

Assets are typed and managed in `WindowM`. Async loads run on a background thread.
GPU-backed assets (textures, GPU text, shaders, pipelines, samplers) are loaded on the main thread even when you call `loadAssetAsync`, since SDL_gpu resource creation is not guaranteed to be thread-safe.

`loadAssetAsync` for `AssetMain` specs enqueues work on the main thread. The built-in `loop` calls `processMainAssets` each frame to service this queue; if you are not using `loop`, call `processMainAssets` manually to progress main-thread loads.

```haskell
texId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")
texture <- awaitAsset texId >>= either (error . ("texture: " <>)) pure

fontId <- loadAssetAsync (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)
font <- awaitAsset fontId >>= either (error . ("font: " <>)) pure

shaderId <- loadAsset (ShaderAsset (shaderSpirv frag) 1 0 0 1) >>= either (error . ("shader: " <>)) pure
shader <- awaitAsset shaderId >>= either (error . ("shader: " <>)) pure
```

Remove assets manually or let the window clean them up:

```haskell
removeAsset texId
removeAllAssets
```

Custom loaders implement `AssetLoader`.

### Hot Reload

Hot reload is enabled by default and automatically reloads file-backed assets (textures, fonts, music, sfx) when the file timestamp changes. You can override the default interval or disable it:

```haskell
enableHotReload 0.5 -- check every 0.5s
disableHotReload
```

Hot reload updates the asset manager entry. If you cache the asset value in a local variable, you should re-fetch it via `getAsset` or `awaitAsset` to pick up changes.

## Audio

Slop wraps SDL3_mixer 3.x. Audio assets load as `Audio` via `MusicAsset` or `ChunkAsset` (both use `MIX_LoadAudio`).

### Pools

- `createTrackPool PoolRoundRobin n` — round-robin pool for SFX.
- `createTrackPool PoolOldest n` — reuse the oldest track.
- `createTrackPool PoolPriority n` — priority-based stealing.
- `createTrackPool PoolBlend 2` — crossfade pool (auto-updated each frame).

Example crossfade:

```haskell
blend <- createTrackPool PoolBlend 2
_ <- runLoop (crossfadeToLoop blend ambience 0)

-- inside loop, no manual update needed (auto-updated)
when (keyPressed KeyB frame.input) $ do
  _ <- crossfadeToLoop blend ambienceAlt 2.0
  pure ()
```

## Example

See `exe/Main.hs` for a full demo: window, pipeline, shaders, text, audio pools, and blend crossfades.
