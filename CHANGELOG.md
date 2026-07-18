# Revision history for slop

## 0.1.0.0 -- Unreleased

* Initial release.
* Breaking: `TextStyle.textEffect` renamed to `textShader`; `textEffect`/`patchTextEffect` helpers renamed to `textShader`/`patchTextShader`.
* Breaking: sprite/text override shaders are now `Shader2D`/`Shader2DAsset` (renamed from EffectShader). `SpriteEffect` and `basicUIWith` now take `Shader2D`.
* Added `NoiseSimplex` and `NoiseSimplex2` GPU noise modes.
* Docs: Spirdo combined‑sampler mode now uses the inline pragma `// spirdo:sampler=combined` (no `weslc`).
* Breaking: public failures now use `SlopError`; throwing operations and their `*Result` variants retain SDL, asset, shader, binding, and file evidence.
* Breaking: `WindowM` is the sole application and frame monad; `Loop`, `runLoop`, and `liftLoop` were removed.
* Breaking: the high-level facade was split into focused modules, with positional GPU APIs moved to the opt-in `Slop.GPU` module.
* Added reflected shader layouts and named uniform/compute bindings, including declaration, group, kind, and size validation.
* Directly created GPU, text, and audio resources are released automatically by `runWindow` in reverse acquisition order.
* Added GHC 9.14 support and updated the demo to Spirdo 0.2's compile-time shader API.
* Breaking: `AssetId`, `Positive`, size, and thread-count constructors are now abstract so callers cannot forge invalid values.
* Fixed 3D view/projection matrices to use the CPU matrix representation and SDL_gpu's left-handed `0..1` clip space.
* Hardened asset cleanup, async exception handling, and SDL_ttf draw-data validation.
* Added the shader generator as a checked Cabal component and removed unused template and demo asset files.
* Breaking: removed exact API aliases and the fragment-only `ShaderBinding` layer; use the canonical `getAsset`, `output`, `computePipeline`, `merge`, `defaultTextStyle`, fragment shader, `TrackPool`, and `ShaderUniform` APIs. Pipeline writer and single-path wrapper constructors are now abstract.
* Breaking: removed the mutable uniform-cache API, which did not avoid draw-time uploads; pass `ShaderUniform` values explicitly at the draw or pass boundary.
* Breaking: collapsed the thirteen `As2D` constructors into one composable blend/camera/effect record and removed raw matrix-only variants. Sprite effects now preserve the selected 2D camera and blend mode. The unused right-biased `SpriteEffect`/`TextStyle` semigroups were removed in favor of `TextStylePatch`.
* Fixed depth-target ownership: depth textures are allocated only for passes that need them, replaced safely on resize, and released with their render target or swapchain.
* Hardened partial startup cleanup so SDL, mixer, and TTF initialization failures unwind already-started subsystems in reverse order.
* Prevented asset-manager shutdown hangs when a background worker exits before consuming its stop command.
