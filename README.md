# Slop

Slop is a small SDL3.4-based rendering + audio toolkit for Haskell. It focuses on textures/sprites, a declarative render pipeline, async asset loading, and SDL3_mixer audio with track pools and crossfades.

## Features

- SDL3.4 GPU renderer backend (`SDL_CreateGPURenderer`) with texture-first rendering.
- Declarative render pipelines (graph DSL or explicit targets).
- SDL_ttf TextEngine support + optional SDF fonts.
- Keycode-based input with just-pressed/just-released helpers.
- Async asset manager with background loading + typed asset IDs.
- SDL3_mixer audio pools (round-robin, oldest, priority, blend/crossfade).
- Spirdo shader integration (WESL -> SPIR-V).

## Requirements

- SDL3 >= 3.4
- SDL3_image
- SDL3_ttf
- SDL3_mixer

`cabal.project` pins `spirdo` as a git dependency for shader compilation.

## Build / Run

```sh
cabal build
cabal run -f demo slop
```

If you only need the library (e.g. as a dependency), the demo executable stays disabled by default.

## Modules

- `Slop` — public API, window/loop, rendering helpers, assets, audio pools.
- `Slop.SDL.Raw` — raw SDL3 / SDL3_image / SDL3_ttf / SDL3_mixer FFI bindings.
- `Slop.Pipeline` — explicit render targets + pass-based pipeline helpers.
- `Slop.Pipeline.Graph` — graph-based pipeline DSL (implicit targets).

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
    clear (rgb 0.06 0.07 0.1)
    draw (Sprite texture Nothing (rect 80 320 160 160) Nothing)
    pure (Continue ())
```

`Frame` includes time, delta, window size, quitRequested, and `InputFrame` with key/mouse state.

## Render Pipeline (Graph DSL)

Build a pipeline graph and render it each frame. The graph automatically manages render targets per node and resizes them when the window size changes.

```haskell
import Slop hiding (clear, draw, output, pass, postProcess, render, withShader)
import Slop.Pipeline.Graph

let (winWInt, winHInt) = frame.size
let winRect = rect 0 0 (fromIntegral winWInt) (fromIntegral winHInt)
let pipeline = do
      scene <- pass $ do
        clear (rgb 0.06 0.07 0.1)
        draw (Sprite texture Nothing (rect 80 320 160 160) Nothing)
        draw (text font "Slop + SDL3.4" 80 40)
      post <- postProcess scene shader uniforms Nothing winRect
      output post Nothing winRect
render (winWInt, winHInt) pipeline
```

If you want explicit targets instead, use `Slop.Pipeline` or `createRenderTarget` + `render`.

## Shaders + Extra Samplers

`ShaderUniform` now also supports extra sampler bindings. You can use the default sampler or create a custom one:

```haskell
sampler <- createSampler defaultSamplerDesc
  { samplerAddressU = SamplerRepeat
  , samplerAddressV = SamplerRepeat
  }

let bindings =
      [ ShaderUniform 0 params
      , ShaderSamplerWith 0 noiseTexture sampler
      ]
```

Additional samplers are bound in order. For WESL/SPIR-V, the first extra sampler uses `@group(2) @binding(2)` for the texture and `@binding(3)` for the sampler (the main render texture is at bindings 0/1).

### Named bindings

If you prefer names over slots, register a binding table and resolve per-frame:

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

### Vertex/compute stages

The renderer backend only supports fragment bindings today. The stage-aware API (`withShaderBindingsStage` / `ShaderBinding`) will throw if you try to bind vertex or compute stages.

## Input (Keycodes)

Input is **keycode-based** (layout-aware), not raw scancodes. Use `KeyA`, `KeyB`, `KeySpace`, etc.

```haskell
when (keyPressed KeyB frame.input) ...
when (keyReleased KeySpace frame.input) ...
```

## Assets

Assets are typed and managed in `WindowM`. Async loads run on a background thread.

```haskell
texId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")
texture <- awaitAsset texId >>= either (error . ("texture: " <>)) pure

fontId <- loadAssetAsync (FontAsset "assets/Inter/Inter-VariableFont_opsz,wght.ttf" 28)
font <- awaitAsset fontId >>= either (error . ("font: " <>)) pure
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
