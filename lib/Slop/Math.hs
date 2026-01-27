{-# LANGUAGE NoFieldSelectors #-}

module Slop.Math
  ( V2(..)
  , V3(..)
  , V4(..)
  , M44(..)
  , v2
  , v3
  , v4
  , v3Cross
  , m44MulV4
  , Vector(..)
  , Matrix4(..)
  ) where

import Foreign.C.Types (CFloat)
import Foreign.Storable (Storable(..))

data V2 a = V2 !a !a deriving (Eq, Show)

data V3 a = V3 !a !a !a deriving (Eq, Show)

data V4 a = V4 !a !a !a !a deriving (Eq, Show)

data M44 a
  = M44 !a !a !a !a
         !a !a !a !a
         !a !a !a !a
         !a !a !a !a
  deriving (Eq, Show)

v2 :: (a, a) -> V2 a
v2 (x, y) = V2 x y

v3 :: (a, a, a) -> V3 a
v3 (x, y, z) = V3 x y z

v4 :: (a, a, a, a) -> V4 a
v4 (x, y, z, w) = V4 x y z w

class Vector v where
  dot :: Num a => v a -> v a -> a
  len :: Floating a => v a -> a
  normalize :: (Eq a, Floating a) => v a -> v a

instance Num a => Num (V2 a) where
  (+) (V2 ax ay) (V2 bx by) = V2 (ax + bx) (ay + by)
  (-) (V2 ax ay) (V2 bx by) = V2 (ax - bx) (ay - by)
  (*) (V2 ax ay) (V2 bx by) = V2 (ax * bx) (ay * by)
  negate (V2 x y) = V2 (negate x) (negate y)
  abs (V2 x y) = V2 (abs x) (abs y)
  signum (V2 x y) = V2 (signum x) (signum y)
  fromInteger n =
    let a = fromInteger n
    in V2 a a

instance Fractional a => Fractional (V2 a) where
  (/) (V2 ax ay) (V2 bx by) = V2 (ax / bx) (ay / by)
  recip (V2 x y) = V2 (recip x) (recip y)
  fromRational r =
    let a = fromRational r
    in V2 a a

instance Vector V2 where
  dot (V2 ax ay) (V2 bx by) = ax * bx + ay * by
  len v = sqrt (dot v v)
  normalize v@(V2 x y) =
    let l = len v
        inv = if l == 0 then 1 else 1 / l
    in V2 (x * inv) (y * inv)

instance Num a => Num (V3 a) where
  (+) (V3 ax ay az) (V3 bx by bz) = V3 (ax + bx) (ay + by) (az + bz)
  (-) (V3 ax ay az) (V3 bx by bz) = V3 (ax - bx) (ay - by) (az - bz)
  (*) (V3 ax ay az) (V3 bx by bz) = V3 (ax * bx) (ay * by) (az * bz)
  negate (V3 x y z) = V3 (negate x) (negate y) (negate z)
  abs (V3 x y z) = V3 (abs x) (abs y) (abs z)
  signum (V3 x y z) = V3 (signum x) (signum y) (signum z)
  fromInteger n =
    let a = fromInteger n
    in V3 a a a

instance Fractional a => Fractional (V3 a) where
  (/) (V3 ax ay az) (V3 bx by bz) = V3 (ax / bx) (ay / by) (az / bz)
  recip (V3 x y z) = V3 (recip x) (recip y) (recip z)
  fromRational r =
    let a = fromRational r
    in V3 a a a

instance Vector V3 where
  dot (V3 ax ay az) (V3 bx by bz) = ax*bx + ay*by + az*bz
  len v = sqrt (dot v v)
  normalize v@(V3 x y z) =
    let l = len v
        inv = if l == 0 then 1 else 1 / l
    in V3 (x*inv) (y*inv) (z*inv)

instance Num a => Num (V4 a) where
  (+) (V4 ax ay az aw) (V4 bx by bz bw) = V4 (ax + bx) (ay + by) (az + bz) (aw + bw)
  (-) (V4 ax ay az aw) (V4 bx by bz bw) = V4 (ax - bx) (ay - by) (az - bz) (aw - bw)
  (*) (V4 ax ay az aw) (V4 bx by bz bw) = V4 (ax * bx) (ay * by) (az * bz) (aw * bw)
  negate (V4 x y z w) = V4 (negate x) (negate y) (negate z) (negate w)
  abs (V4 x y z w) = V4 (abs x) (abs y) (abs z) (abs w)
  signum (V4 x y z w) = V4 (signum x) (signum y) (signum z) (signum w)
  fromInteger n =
    let a = fromInteger n
    in V4 a a a a

instance Fractional a => Fractional (V4 a) where
  (/) (V4 ax ay az aw) (V4 bx by bz bw) = V4 (ax / bx) (ay / by) (az / bz) (aw / bw)
  recip (V4 x y z w) = V4 (recip x) (recip y) (recip z) (recip w)
  fromRational r =
    let a = fromRational r
    in V4 a a a a

instance Vector V4 where
  dot (V4 ax ay az aw) (V4 bx by bz bw) = ax*bx + ay*by + az*bz + aw*bw
  len v = sqrt (dot v v)
  normalize v@(V4 x y z w) =
    let l = len v
        inv = if l == 0 then 1 else 1 / l
    in V4 (x*inv) (y*inv) (z*inv) (w*inv)

v3Cross :: Num a => V3 a -> V3 a -> V3 a
v3Cross (V3 ax ay az) (V3 bx by bz) =
  V3 (ay*bz - az*by) (az*bx - ax*bz) (ax*by - ay*bx)

class Matrix4 m where
  identity :: m Float
  transpose :: m Float -> m Float
  transformPoint :: m Float -> V3 Float -> V3 Float
  transformDir :: m Float -> V3 Float -> V3 Float
  ortho :: Float -> Float -> Float -> Float -> Float -> Float -> m Float
  perspective :: Float -> Float -> Float -> Float -> m Float
  lookAt :: V3 Float -> V3 Float -> V3 Float -> m Float

m44MulV4 :: M44 Float -> V4 Float -> V4 Float
m44MulV4 (M44 m00 m01 m02 m03
                   m10 m11 m12 m13
                   m20 m21 m22 m23
                   m30 m31 m32 m33)
            (V4 x y z w) =
  V4
    (m00*x + m01*y + m02*z + m03*w)
    (m10*x + m11*y + m12*z + m13*w)
    (m20*x + m21*y + m22*z + m23*w)
    (m30*x + m31*y + m32*z + m33*w)

instance Matrix4 M44 where
  identity = fromInteger 1
  transpose (M44 m00 m01 m02 m03
                   m10 m11 m12 m13
                   m20 m21 m22 m23
                   m30 m31 m32 m33) =
    M44 m00 m10 m20 m30
         m01 m11 m21 m31
         m02 m12 m22 m32
         m03 m13 m23 m33
  transformPoint mat (V3 x y z) =
    let V4 tx ty tz tw = m44MulV4 mat (V4 x y z 1)
        inv = if tw == 0 then 1 else 1 / tw
    in V3 (tx * inv) (ty * inv) (tz * inv)
  transformDir mat (V3 x y z) =
    let V4 tx ty tz _ = m44MulV4 mat (V4 x y z 0)
    in V3 tx ty tz
  ortho l r b t n f =
    let rl = r - l
        tb = t - b
        fn = f - n
    in M44
        (2 / rl) 0 0 (-(r + l) / rl)
        0 (2 / tb) 0 (-(t + b) / tb)
        0 0 (1 / fn) (-n / fn)
        0 0 0 1
  perspective fovY aspect n f =
    let t = 1 / tan (fovY / 2)
        fn = f - n
    in M44
        (t / aspect) 0 0 0
        0 t 0 0
        0 0 (f / fn) 1
        0 0 ((-n * f) / fn) 0
  lookAt eye target up =
    let f = normalize (target - eye)
        s = normalize (v3Cross f up)
        u = v3Cross s f
        V3 sx sy sz = s
        V3 ux uy uz = u
        V3 fx fy fz = f
    in M44
        sx ux (-fx) 0
        sy uy (-fy) 0
        sz uz (-fz) 0
        (-dot s eye) (-dot u eye) (dot f eye) 1

instance Num a => Num (M44 a) where
  (+) (M44 a00 a01 a02 a03
            a10 a11 a12 a13
            a20 a21 a22 a23
            a30 a31 a32 a33)
      (M44 b00 b01 b02 b03
            b10 b11 b12 b13
            b20 b21 b22 b23
            b30 b31 b32 b33) =
    M44 (a00 + b00) (a01 + b01) (a02 + b02) (a03 + b03)
         (a10 + b10) (a11 + b11) (a12 + b12) (a13 + b13)
         (a20 + b20) (a21 + b21) (a22 + b22) (a23 + b23)
         (a30 + b30) (a31 + b31) (a32 + b32) (a33 + b33)
  (-) (M44 a00 a01 a02 a03
            a10 a11 a12 a13
            a20 a21 a22 a23
            a30 a31 a32 a33)
      (M44 b00 b01 b02 b03
            b10 b11 b12 b13
            b20 b21 b22 b23
            b30 b31 b32 b33) =
    M44 (a00 - b00) (a01 - b01) (a02 - b02) (a03 - b03)
         (a10 - b10) (a11 - b11) (a12 - b12) (a13 - b13)
         (a20 - b20) (a21 - b21) (a22 - b22) (a23 - b23)
         (a30 - b30) (a31 - b31) (a32 - b32) (a33 - b33)
  (*) (M44 a00 a01 a02 a03
            a10 a11 a12 a13
            a20 a21 a22 a23
            a30 a31 a32 a33)
      (M44 b00 b01 b02 b03
            b10 b11 b12 b13
            b20 b21 b22 b23
            b30 b31 b32 b33) =
    M44
      (a00*b00 + a01*b10 + a02*b20 + a03*b30)
      (a00*b01 + a01*b11 + a02*b21 + a03*b31)
      (a00*b02 + a01*b12 + a02*b22 + a03*b32)
      (a00*b03 + a01*b13 + a02*b23 + a03*b33)
      (a10*b00 + a11*b10 + a12*b20 + a13*b30)
      (a10*b01 + a11*b11 + a12*b21 + a13*b31)
      (a10*b02 + a11*b12 + a12*b22 + a13*b32)
      (a10*b03 + a11*b13 + a12*b23 + a13*b33)
      (a20*b00 + a21*b10 + a22*b20 + a23*b30)
      (a20*b01 + a21*b11 + a22*b21 + a23*b31)
      (a20*b02 + a21*b12 + a22*b22 + a23*b32)
      (a20*b03 + a21*b13 + a22*b23 + a23*b33)
      (a30*b00 + a31*b10 + a32*b20 + a33*b30)
      (a30*b01 + a31*b11 + a32*b21 + a33*b31)
      (a30*b02 + a31*b12 + a32*b22 + a33*b32)
      (a30*b03 + a31*b13 + a32*b23 + a33*b33)
  negate (M44 a00 a01 a02 a03
               a10 a11 a12 a13
               a20 a21 a22 a23
               a30 a31 a32 a33) =
    M44 (negate a00) (negate a01) (negate a02) (negate a03)
         (negate a10) (negate a11) (negate a12) (negate a13)
         (negate a20) (negate a21) (negate a22) (negate a23)
         (negate a30) (negate a31) (negate a32) (negate a33)
  abs (M44 a00 a01 a02 a03
            a10 a11 a12 a13
            a20 a21 a22 a23
            a30 a31 a32 a33) =
    M44 (abs a00) (abs a01) (abs a02) (abs a03)
         (abs a10) (abs a11) (abs a12) (abs a13)
         (abs a20) (abs a21) (abs a22) (abs a23)
         (abs a30) (abs a31) (abs a32) (abs a33)
  signum (M44 a00 a01 a02 a03
               a10 a11 a12 a13
               a20 a21 a22 a23
               a30 a31 a32 a33) =
    M44 (signum a00) (signum a01) (signum a02) (signum a03)
         (signum a10) (signum a11) (signum a12) (signum a13)
         (signum a20) (signum a21) (signum a22) (signum a23)
         (signum a30) (signum a31) (signum a32) (signum a33)
  fromInteger n =
    let a = fromInteger n
    in M44 a 0 0 0
           0 a 0 0
           0 0 a 0
           0 0 0 a

instance Fractional a => Fractional (M44 a) where
  (/) (M44 a00 a01 a02 a03
            a10 a11 a12 a13
            a20 a21 a22 a23
            a30 a31 a32 a33)
      (M44 b00 b01 b02 b03
            b10 b11 b12 b13
            b20 b21 b22 b23
            b30 b31 b32 b33) =
    M44 (a00 / b00) (a01 / b01) (a02 / b02) (a03 / b03)
         (a10 / b10) (a11 / b11) (a12 / b12) (a13 / b13)
         (a20 / b20) (a21 / b21) (a22 / b22) (a23 / b23)
         (a30 / b30) (a31 / b31) (a32 / b32) (a33 / b33)
  recip (M44 a00 a01 a02 a03
              a10 a11 a12 a13
              a20 a21 a22 a23
              a30 a31 a32 a33) =
    M44 (recip a00) (recip a01) (recip a02) (recip a03)
         (recip a10) (recip a11) (recip a12) (recip a13)
         (recip a20) (recip a21) (recip a22) (recip a23)
         (recip a30) (recip a31) (recip a32) (recip a33)
  fromRational r =
    let a = fromRational r
    in M44 a 0 0 0
           0 a 0 0
           0 0 a 0
           0 0 0 a

instance Semigroup (M44 Float) where
  (<>) = (*)

instance Monoid (M44 Float) where
  mempty = identity

instance Storable (V2 Float) where
  sizeOf _ = 2 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    x <- peekByteOff ptr 0 :: IO CFloat
    y <- peekByteOff ptr (sizeOf (undefined :: CFloat)) :: IO CFloat
    pure (V2 (realToFrac x) (realToFrac y))
  poke ptr (V2 x y) = do
    pokeByteOff ptr 0 (realToFrac x :: CFloat)
    pokeByteOff ptr (sizeOf (undefined :: CFloat)) (realToFrac y :: CFloat)

instance Storable (V4 Float) where
  sizeOf _ = 4 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
    x <- peekByteOff ptr 0 :: IO CFloat
    y <- peekByteOff ptr step :: IO CFloat
    z <- peekByteOff ptr (2 * step) :: IO CFloat
    w <- peekByteOff ptr (3 * step) :: IO CFloat
    pure (V4 (realToFrac x) (realToFrac y) (realToFrac z) (realToFrac w))
  poke ptr (V4 x y z w) = do
    let step = sizeOf (undefined :: CFloat)
    pokeByteOff ptr 0 (realToFrac x :: CFloat)
    pokeByteOff ptr step (realToFrac y :: CFloat)
    pokeByteOff ptr (2 * step) (realToFrac z :: CFloat)
    pokeByteOff ptr (3 * step) (realToFrac w :: CFloat)

instance Storable (M44 Float) where
  sizeOf _ = 16 * sizeOf (undefined :: CFloat)
  alignment _ = alignment (undefined :: CFloat)
  peek ptr = do
    let step = sizeOf (undefined :: CFloat)
        at n = realToFrac <$> (peekByteOff ptr (n * step) :: IO CFloat)
    M44
      <$> at 0 <*> at 1 <*> at 2 <*> at 3
      <*> at 4 <*> at 5 <*> at 6 <*> at 7
      <*> at 8 <*> at 9 <*> at 10 <*> at 11
      <*> at 12 <*> at 13 <*> at 14 <*> at 15
  poke ptr (M44 m00 m01 m02 m03 m10 m11 m12 m13 m20 m21 m22 m23 m30 m31 m32 m33) = do
    let step = sizeOf (undefined :: CFloat)
        pokeAt n value = pokeByteOff ptr (n * step) (realToFrac value :: CFloat)
    pokeAt 0 m00
    pokeAt 1 m01
    pokeAt 2 m02
    pokeAt 3 m03
    pokeAt 4 m10
    pokeAt 5 m11
    pokeAt 6 m12
    pokeAt 7 m13
    pokeAt 8 m20
    pokeAt 9 m21
    pokeAt 10 m22
    pokeAt 11 m23
    pokeAt 12 m30
    pokeAt 13 m31
    pokeAt 14 m32
    pokeAt 15 m33
