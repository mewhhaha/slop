{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

-- | Derive C-like 'Storable' layout operations for single-constructor product
-- types. Every field must be 'Storable'; sum types are intentionally excluded.
module Slop.Storable.Generic
  ( GStorable(..)
  , alignUp
  , genericSizeOf
  , genericAlignment
  , genericPeek
  , genericPoke
  ) where

import Data.Proxy (Proxy(..))
import Foreign
import GHC.Generics (Generic, (:*:)(..), K1(..), M1(..), Rep, U1(..), from, to)

-- | 'Storable' operations over a 'Generic' representation.
class GStorable f where
  gSizeOf :: Proxy f -> Int
  gAlignment :: Proxy f -> Int
  gPeek :: Ptr () -> IO (f p)
  gPoke :: Ptr () -> f p -> IO ()

instance GStorable U1 where
  gSizeOf _ = 0
  gAlignment _ = 1
  gPeek _ = pure U1
  gPoke _ U1 = pure ()

instance (GStorable a, GStorable b) => GStorable (a :*: b) where
  gSizeOf _ =
    let sizeA = gSizeOf (Proxy @a)
        alignB = gAlignment (Proxy @b)
        offB = alignUp sizeA alignB
    in offB + gSizeOf (Proxy @b)
  gAlignment _ = max (gAlignment (Proxy @a)) (gAlignment (Proxy @b))
  gPeek ptr = do
    a <- gPeek ptr
    let offB = alignUp (gSizeOf (Proxy @a)) (gAlignment (Proxy @b))
    b <- gPeek (ptr `plusPtr` offB)
    pure (a :*: b)
  gPoke ptr (a :*: b) = do
    gPoke ptr a
    let offB = alignUp (gSizeOf (Proxy @a)) (gAlignment (Proxy @b))
    gPoke (ptr `plusPtr` offB) b

instance GStorable a => GStorable (M1 i c a) where
  gSizeOf _ = gSizeOf (Proxy @a)
  gAlignment _ = gAlignment (Proxy @a)
  gPeek ptr = M1 <$> gPeek ptr
  gPoke ptr (M1 a) = gPoke ptr a

instance Storable a => GStorable (K1 i a) where
  gSizeOf _ = sizeOf (undefined :: a)
  gAlignment _ = alignment (undefined :: a)
  gPeek ptr = K1 <$> peek (castPtr ptr)
  gPoke ptr (K1 a) = poke (castPtr ptr) a

-- | Round a byte size up to the next multiple of a positive alignment.
alignUp :: Int -> Int -> Int
alignUp size align =
  ((size + align - 1) `div` align) * align

-- | Calculate the padded size of a product type from its generic fields.
genericSizeOf :: forall a. (Generic a, GStorable (Rep a)) => Proxy a -> Int
genericSizeOf _ =
  let size = gSizeOf (Proxy @(Rep a))
      align = gAlignment (Proxy @(Rep a))
  in alignUp size align

-- | Calculate the strictest field alignment in a product type.
genericAlignment :: forall a. (Generic a, GStorable (Rep a)) => Proxy a -> Int
genericAlignment _ = gAlignment (Proxy @(Rep a))

-- | Read a product value using its generically calculated field offsets.
genericPeek :: forall a. (Generic a, GStorable (Rep a)) => Ptr a -> IO a
genericPeek ptr = to <$> gPeek (castPtr ptr)

-- | Write a product value using its generically calculated field offsets.
genericPoke :: forall a. (Generic a, GStorable (Rep a)) => Ptr a -> a -> IO ()
genericPoke ptr value = gPoke (castPtr ptr) (from value)
