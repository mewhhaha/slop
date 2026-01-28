# Revision history for slop

## 0.1.0.0 -- YYYY-mm-dd

* First version. Released on an unsuspecting world.
* Breaking: `TextStyle.textEffect` renamed to `textShader`; `textEffect`/`patchTextEffect` helpers renamed to `textShader`/`patchTextShader`.
* Breaking: sprite/text override shaders are now `Shader2D`/`Shader2DAsset` (renamed from EffectShader). `SpriteEffect` and `basicUIWith` now take `Shader2D`.
* Added `NoiseSimplex` and `NoiseSimplex2` GPU noise modes.
* Docs: Spirdo combined‑sampler mode now uses the inline pragma `// spirdo:sampler=combined` (no `weslc`).
