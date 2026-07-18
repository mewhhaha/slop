# Slop Project Notes

Slop is a small SDL3.4 + SDL_gpu rendering + audio toolkit for Haskell. It focuses on textures/sprites, declarative render pipelines, async asset loading, and SDL3_mixer audio pools + crossfades. The demo uses Spirdo (WESL -> SPIR-V).

## Build / Run

- Build: `cabal build`
- Run demo: `cabal run -f demo slop` (demo opt-in; library does not depend on spirdo)
## Config

- `Config.assetWorkers` controls the number of background asset-loading threads (`0` = auto based on GHC capabilities).
- `Config.debugLog` enables `logDebug`.

## Layout

- `slop.cabal` — package metadata (library + demo executable).
- `lib/Slop.hs` — small public facade for windowing, input, 2D drawing, resources, audio, and math.
- `lib/Slop/{Window,Input,Draw2D,Resource,Audio}.hs` — focused high-level public modules.
- `lib/Slop/GPU.hs` — opt-in advanced GPU and shader API.
- `lib/Slop/Internal.hs` — shared implementation; not part of the supported public API.
- `lib/Slop/Math.hs` — vector/matrix types and math helpers.
- `lib/Slop/SDL/Raw.hs` — raw FFI bindings for SDL3 + SDL_gpu + SDL3_image/ttf/mixer.
- `lib/Slop/Pipeline.hs` — explicit render targets + pass-based pipeline helpers.
- `lib/Slop/Pipeline/Graph.hs` — graph-based pipeline DSL (implicit targets).
- `lib/Slop/Storable/Generic.hs` — Generic-based `Storable` helpers for vertex structs.
- `exe/Main.hs` — demo program (pipeline, shaders, audio).
- `tools/spirv-gen.hs` — generates default shader SPIR-V byte lists.
- `assets/` — demo textures, fonts, audio.

## Core Concepts

- `WindowM` is the application and frame monad. `runWindow` sets up SDL, GPU device + swapchain, mixer, and the asset manager.
- SDL, mixer, and TTF initialization is staged so a later startup failure unwinds only the subsystems that initialized successfully.
- `loop :: a -> (Frame -> a -> WindowM (LoopControl a)) -> WindowM (LoopExit a)` is the main driver.
- Use `ConfigPatch` + `applyConfigPatch` to compose config overrides with a `Monoid`.

## Rendering (SDL_gpu)

- Backend uses `SDL_CreateGPUDevice` + `SDL_ClaimWindowForGPUDevice`; commands are recorded and submitted per frame.
- `RenderTarget` is a GPU texture target. Use `createRenderTarget` / `destroyTarget`.
- `createTexture2D` + `TextureDesc` are the high-level path for compute/sample targets in demos.
- `render target (WindowM ())` sets the current render target; `output` blits to the swapchain.
- The Graph DSL (`Slop.Pipeline.Graph`) manages render targets per node and resizes them when the window size changes.
- Custom pipelines use `Pipeline` + `Mesh` + `Binding` via `drawMesh`. `spritePipeline` + `spriteMeshTransient` are the simple path.
- `draw` now takes a context: use `draw (basic2D cam) ...` for built-in shapes/sprites/text, `draw (basicUIWith shader uniforms) ...` for standard pipeline shader swaps, or `draw (asMesh pipe bindings) mesh` (`basicUI`, `basicParticle` are blend-mode variants; `basic3D` is a mesh-only 3D pipeline with `Mesh3D` + model matrix).
- `As2D` stores blend, camera, and optional `SpriteEffect` directly; per-sprite and text effects override only the effect while preserving the context camera and blend.
- `basic2D` requires a camera (use `camera2DScreen` / `camera2DWindow`). `basicUI` stays raw screen space.
- Depth/stencil is enabled for `basic3D` (depth test + write). The renderer allocates a depth target per swapchain/render target as needed.
- 2D camera helpers are CPU-side transforms via `camera2DMatrix`.
- `SpriteEffect` wraps a `Shader2D` for per-sprite shader overrides (2D ABI).
- `SlopGlobals` uniform (slot 0) is auto-bound for fragment shaders with uniform buffers (time, renderSize, dpiScale). Fragment uniforms live in SPIR-V `@group(3)`, samplers/textures in `@group(2)`.
- Declarative pipeline builders: `defaultGraphics`/`graphicsPipeline` and `defaultCompute`/`computePipeline`.
- Compute pipelines use `computePipeline` + `dispatchCompute`, or `compute` steps inside the graph DSL.
- Directly created textures, fonts, shaders, pipelines, meshes, samplers, text, and audio tracks are released by `runWindow` in reverse acquisition order. Explicit destroy functions remain available for shorter lifetimes.

## Bindings

- `Binding`/`ComputeBinding` are stage-aware for custom pipelines (`vUniformBytes`, `fSamplerWith`, `computeStorageTextureRW`, etc).
- Prefer reflected shader layouts and named bindings. Reflection validates descriptor groups, duplicate declarations, missing names, binding kinds, and uniform sizes before GPU submission.
- `ShaderUniform` helpers are fragment-only and auto-bind the draw texture at sampler slot 0.
- Positional `ShaderCounts` and slot-based bindings remain available in `Slop.GPU` for shaders without reflection.

## Text

- Text uses SDL_ttf GPU TextEngine.
- `drawText`/`drawTextWith`/`measureText` use the text cache and prune unused entries each frame.
- Configure text atlas size via `Config.textAtlasSize` to reduce GPU memory if needed.
- Public text APIs take `Data.Text.Text` (`OverloadedStrings` recommended).
- `TextStylePatch` gives compositional style changes (`Monoid`), including `patchTextShader`.

## Input

- Input is keycode-based (layout-aware), not raw scancodes.
- `Frame` includes `quitRequested`, `size` (logical), `renderSize` (drawable), `dpiScale`, and `input` (prev/now for justPressed/justReleased).
- `input.events` provides per-frame `InputEvent` values (text, wheel, quit).

## Assets

- Asset manager runs on a background thread. Use `loadAssetAsync` + `awaitAsset`.
- `loadAsset`, `awaitAsset`, and `awaitAssetUpdate` throw `SlopError`; their `*Result` variants expose recoverable failures without exceptions.
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
- Shader sources in the demo/tools should include `// spirdo:sampler=combined` (combined sampler ABI for Slop).
- The demo (`exe/Main.hs`) converts Spirdo reflection into Slop layouts and resolves bindings by name.

## Notes

- Default shader SPIR-V bytes live in `lib/Slop/Internal.hs` (`defaultVertexSpirv`, `defaultFragmentSpirv`).
- Regenerate them via `cabal run -f demo slop-spirv-gen`.

## Pause Notes (What I Need To Continue)

- None.

## Refactor Phases (Requested)

Phase 1: Add algebraic structure helpers (Semigroup/Monoid where sensible), plus a `ConfigPatch`, and expose `Loop` as a `MonadReader`. (done)

Phase 2: Consolidate duplicate DList definitions and introduce `SpriteEffect` (typed sprite shader) across API + demo. (done)

Phase 3: Make `AssetMain` async via a main-thread queue, add `withRenderTarget` helper, and wire updates in the loop. (done)

Phase 4: Add safer uniform helpers (size-checked or bytes-first) and document new APIs in README/AGENTS. (done)

Phase 5: Update Spirdo to track latest, simplify `exe/Main.hs` with the input builder, and remove boilerplate shader binding code. (done)

Phase 6: Update docs for camera-required `basic2D`/`basic3D`, fix README examples, and clean up AGENTS notes. (done)

## Refactor Phases (Current)

Phase A: Move text-facing API to `Data.Text` (draw/measure/cache/input), update demo + README. (done)

Phase B: Fix render-graph target retention by pruning unused node targets per render. (done)

Phase C: Replace busy-polling in `awaitAsset`/`awaitAssetUpdate` with STM blocking + main-queue servicing. (done)

Phase D: Performance/ergonomics cleanup (strict fields for hot structs, `IntMap` for asset IDs + pipeline targets). (done)
