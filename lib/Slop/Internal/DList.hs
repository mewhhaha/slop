module Slop.Internal.DList
  ( DList(..)
  , singleton
  , toList
  ) where

newtype DList a = DList ([a] -> [a])

instance Semigroup (DList a) where
  DList f <> DList g = DList (f . g)

instance Monoid (DList a) where
  mempty = DList id

singleton :: a -> DList a
singleton x = DList (x :)

toList :: DList a -> [a]
toList (DList f) = f []
