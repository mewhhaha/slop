# Seedl

Seedl is a small SDL3.4-based rendering wrapper for Haskell with a focus on textures, sprites, and an ergonomic render pipeline.

## Build / Run

```sh
cabal build
cabal run seedl
```

## Render Pipeline (Graph DSL)

The render pipeline is modeled as a graph of passes without explicit render targets. You build a pipeline, then call `render` with the current window size.

```haskell
import Seedl hiding (clear, draw, output, pass, postProcess, render, withShader)
import Seedl.Pipeline.Graph

-- inside loop
let (winWInt, winHInt) = frame.size
let winRect = rect 0 0 (fromIntegral winWInt) (fromIntegral winHInt)
let pipeline = do
      scene <- pass $ do
        clear (rgb 0.06 0.07 0.1)
        draw (Sprite texture Nothing (rect 80 320 160 160) Nothing)
        draw (text font "Seedl + SDL3.4" 80 40)
      post <- postProcess scene shader uniforms Nothing winRect
      output post Nothing winRect
render (winWInt, winHInt) pipeline
```

This matches the current example in `exe/Main.hs`.

## Asset Management

Seedl includes a built-in asset manager that runs inside `WindowM`. Assets are typed via `AssetId a`, and can be loaded synchronously or asynchronously.

### Loading

```haskell
-- synchronous (loads immediately on the calling thread)
texIdE <- loadAsset (TextureAsset "assets/sprite.bmp")

-- asynchronous (queues work on the asset worker thread)
texId <- loadAssetAsync (TextureAsset "assets/sprite.bmp")

-- wait until ready
texture <- awaitAsset texId
```

`awaitAsset` blocks until the asset finishes loading, and returns `Either String a` for errors.

### Querying and unloading

```haskell
status <- getAssetStatus texId
maybeTex <- getAsset texId

_ <- removeAsset texId
removeAssets_ [AnyAssetId texId]
removeAllAssets
```

### Reloading

```haskell
update <- reloadAssetAsync texId (TextureAsset "assets/sprite.bmp")
_ <- awaitAssetUpdate update
```

### Custom loaders

Define a spec type and implement `AssetLoader`. The `AssetType` associated type is what you get back from `awaitAsset`.

```haskell
data MeshAsset = MeshAsset FilePath

instance AssetLoader MeshAsset where
  type AssetType MeshAsset = Mesh
  loadAssetIO _ (MeshAsset path) = loadMeshFromDisk path
  unloadAssetIO _ _ mesh = destroyMesh mesh
  assetLabel (MeshAsset path) = path

-- usage
meshId <- loadAssetAsync (MeshAsset "assets/mesh.bin")
mesh <- awaitAsset meshId
```

Assets are owned by the window; `runWindow` automatically cleans up remaining assets when it exits. You can call `removeAllAssets` to clear them earlier.
