# Revision history for slop

## 0.1.0.0 -- YYYY-mm-dd

* First version. Released on an unsuspecting world.
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
