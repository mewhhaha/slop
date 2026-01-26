# Slop Project Notes

Slop is a small SDL3.4 + SDL_gpu rendering + audio toolkit for Haskell. It focuses on textures/sprites, declarative render pipelines, async asset loading, and SDL3_mixer audio pools + crossfades. The demo uses Spirdo (WESL -> SPIR-V).

## Build / Run

- Build: `cabal build`
- Run demo: `cabal run -f demo slop` (demo opt-in; library does not depend on spirdo)
## Config

- `Config.assetWorkers` controls the number of background asset-loading threads (`0` = auto based on GHC capabilities).

## Layout

- `slop.cabal` — package metadata (library + demo executable).
- `lib/Slop.hs` — public API (window/loop, rendering, assets, audio pools).
- `lib/Slop/SDL/Raw.hs` — raw FFI bindings for SDL3 + SDL_gpu + SDL3_image/ttf/mixer.
- `lib/Slop/Pipeline.hs` — explicit render targets + pass-based pipeline helpers.
- `lib/Slop/Pipeline/Graph.hs` — graph-based pipeline DSL (implicit targets).
- `lib/Slop/Storable/Generic.hs` — Generic-based `Storable` helpers for vertex structs.
- `exe/Main.hs` — demo program (pipeline, shaders, audio).
- `tools/spirv-gen.hs` — generates default shader SPIR-V byte lists.
- `assets/` — demo textures, fonts, audio.

## Core Concepts

- `WindowM` is the main application monad. `runWindow` sets up SDL, GPU device + swapchain, mixer, and the asset manager.
- `Loop` is the rendering monad used inside the frame loop.
- `loop :: a -> (Frame -> a -> Loop (LoopControl a)) -> WindowM (LoopExit a)` is the main driver.
- `runLoop :: Loop a -> WindowM a` runs Loop actions inside WindowM (useful for asset setup).
- Use `ConfigPatch` + `applyConfigPatch` to compose config overrides with a `Monoid`.

## Rendering (SDL_gpu)

- Backend uses `SDL_CreateGPUDevice` + `SDL_ClaimWindowForGPUDevice`; commands are recorded and submitted per frame.
- `RenderTarget` is a GPU texture target. Use `createRenderTarget` / `destroyTarget`.
- `createTexture2D` + `TextureDesc` are the high-level path for compute/sample targets in demos.
- `render target (Loop ())` sets the current render target; `output` blits to the swapchain.
- The Graph DSL (`Slop.Pipeline.Graph`) manages render targets per node and resizes them when the window size changes.
- Custom pipelines use `Pipeline` + `Mesh` + `Binding` via `drawMesh`. `spritePipeline` + `spriteMeshTransient` are the simple path.
- `draw` now takes a context: use `draw (basic2D cam) ...` for built-in shapes/sprites/text, `draw (basicUIWith shader uniforms) ...` for standard pipeline shader swaps, or `draw (asMesh pipe bindings) mesh` (`basicUI`, `basicParticle` are blend-mode variants; `basic3D` is a mesh-only 3D pipeline with `Mesh3D` + model matrix).
- `basic2D` requires a camera (use `camera2DScreen` / `camera2DWindow`). `basicUI` stays raw screen space.
- Depth/stencil is enabled for `basic3D` (depth test + write). The renderer allocates a depth target per swapchain/render target as needed.
- 2D camera helpers are CPU-side transforms via `camera2DMatrix`.
- `SpriteEffect` is a typed wrapper for per-sprite shader overrides.
- Declarative pipeline builders: `defaultGraphics`/`graphicsPipeline` and `defaultCompute`/`computePipeline`.
- Compute pipelines use `computePipeline` + `dispatchCompute`, or `compute` steps inside the graph DSL.

## Bindings

- `Binding`/`ComputeBinding` are stage-aware for custom pipelines (`vUniformBytes`, `fSamplerWith`, `computeStorageTextureRW`, etc).
- Legacy `ShaderUniform` helpers are fragment-only and auto-bind the draw texture at sampler slot 0.
- `ShaderBindings`/`NamedUniform` still resolve for the legacy fragment helper.

## Text

- Text uses SDL_ttf GPU TextEngine.
- `drawTextCached` caches text per frame and prunes unused entries each frame.
- Configure text atlas size via `Config.textAtlasSize` to reduce GPU memory if needed.

## Input

- Input is keycode-based (layout-aware), not raw scancodes.
- `Frame` includes `quitRequested`, `size`, `input` (prev/now for justPressed/justReleased).

## Assets

- Asset manager runs on a background thread. Use `loadAssetAsync` + `awaitAsset`.
- GPU-backed assets (textures, GPU text, shaders, pipelines, samplers) are loaded on the main thread even when using `loadAssetAsync`.
- `loadAssetAsync` for main-thread assets queues work; `loop` calls `processMainAssets` each frame to service it.
- Shader/pipeline asset specs: `ShaderAsset`, `VertexShaderAsset`, `ComputePipelineAsset`, `PipelineAsset`, `SamplerAsset`.
- Remove assets via `removeAsset` / `removeAssets` / `removeAllAssets`.
- Hot reload is enabled by default (`enableHotReload` / `disableHotReload`).

## Audio (SDL3_mixer)

- Audio assets load via `MusicAsset` / `ChunkAsset`.
- Track pools: `PoolRoundRobin`, `PoolOldest`, `PoolPriority`, `PoolBlend` (crossfade).
- Blend pools are registered in the window and auto-updated each frame.

## Spirdo

- Spirdo is used only by the demo/tools. `cabal.project` pins the git revision.
- The demo (`exe/Main.hs`) contains the Spirdo adapter helpers (binding conversions + shader counts).

## Notes

- Default shader SPIR-V bytes live in `lib/Slop.hs` (`defaultVertexSpirv`, `defaultFragmentSpirv`).
- Regenerate them via `tools/spirv-gen.hs`.

## Pause Notes (What I Need To Continue)

- None.

## Refactor Phases (Requested)

Phase 1: Add algebraic structure helpers (Semigroup/Monoid where sensible), plus a `ConfigPatch`, and expose `Loop` as a `MonadReader`. (done)

Phase 2: Consolidate duplicate DList definitions and introduce `SpriteEffect` (typed sprite shader) across API + demo. (done)

Phase 3: Make `AssetMain` async via a main-thread queue, add `withRenderTarget` helper, and wire updates in the loop. (done)

Phase 4: Add safer uniform helpers (size-checked or bytes-first) and document new APIs in README/AGENTS. (done)

Phase 5: Update Spirdo to track latest, simplify `exe/Main.hs` with the input builder, and remove boilerplate shader binding code. (done)

Phase 6: Update docs for camera-required `basic2D`/`basic3D`, fix README examples, and clean up AGENTS notes. (done)
