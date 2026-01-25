# Slop Project Notes

This repo is a small SDL3.4-based rendering + audio toolkit for Haskell. It wraps the SDL3 GPU renderer, SDL3_ttf TextEngine, SDL3_image, and SDL3_mixer. It also integrates Spirdo for WESL->SPIR-V shader compilation.

## Build / Run

- Build: `cabal build`
- Run demo: `cabal run slop`

## Layout

- `slop.cabal` — package metadata (library + demo executable).
- `lib/Slop.hs` — main public API (window/loop, rendering, assets, audio pools).
- `lib/Slop/SDL/Raw.hs` — raw FFI bindings to SDL3, SDL3_image, SDL3_ttf, SDL3_mixer.
- `lib/Slop/Pipeline.hs` — explicit target pipeline helpers.
- `lib/Slop/Pipeline/Graph.hs` — graph-based pipeline DSL (implicit targets).
- `exe/Main.hs` — demo program (window, shaders, pipeline, audio).
- `assets/` — demo textures, fonts, audio.

## Core Concepts

- `WindowM` is the main application monad. `runWindow` sets up SDL, renderer, mixer, and asset manager.
- `Loop` is the rendering monad used inside the frame loop.
- `loop :: a -> (Frame -> a -> Loop (LoopControl a)) -> WindowM (LoopExit a)` is the main driver.
- `runLoop :: Loop a -> WindowM a` runs Loop actions inside WindowM (useful for asset setup).

## Rendering

- The backend uses `SDL_CreateGPURenderer`.
- `RenderTarget` is a texture target. Use `createRenderTarget` / `destroyTarget`.
- `render target (Loop ())` sets the current render target; `output` draws the target to the window.
- The Graph DSL (`Slop.Pipeline.Graph`) builds a declarative render pipeline. It manages render targets per node and resizes them automatically when the window size changes.
- Shader uniforms are applied via `ShaderUniform` values and cached per-frame in the render state.

## Text

- Text is rendered via SDL_ttf TextEngine.
- `TextDraw` and `drawTextCached` cache text per-frame and are pruned after each frame.
- Optional SDF fonts via `loadFontSDF` / `setFontSDF`.

## Input

- Input is **keycode-based** (layout-aware), not raw scancodes.
- `InputFrame` carries `prev` and `now` snapshots for `keyPressed` / `keyReleased`.
- `Frame` includes `delta`, `time`, `ticks`, `size`, `quitRequested`, and `input`.

## Assets

- Asset manager runs on a background thread. Use `loadAssetAsync` + `awaitAsset`.
- Assets are typed and tracked via `AssetId`. You can `removeAsset` / `removeAllAssets`.
- Implement custom loaders by defining `AssetLoader` for a spec type.
- Hot reload can be enabled via `enableHotReload intervalSeconds` and will auto-reload file-backed assets when timestamps change.

## Audio (SDL3_mixer)

- Audio assets load via `MusicAsset` / `ChunkAsset`.
- Track pools:
  - `PoolRoundRobin`, `PoolOldest`, `PoolPriority` for SFX.
  - `PoolBlend` for crossfades (auto-updated each frame).
- Blend pools are registered in the window and updated automatically inside `loop`.

## Spirdo

- Shaders are authored in WESL and compiled via Spirdo (pinned in `cabal.project`).
- See `exe/Main.hs` for the demo shader and pipeline usage.
