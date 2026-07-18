-- | The high-level Slop API for windows, input, 2D drawing, resources, audio,
-- and math. Import "Slop.GPU" or a pipeline module for lower-level rendering.
module Slop
  ( module Slop.Window
  , module Slop.Input
  , module Slop.Draw2D
  , module Slop.Resource
  , module Slop.Audio
  , module Slop.Math
  ) where

import Slop.Audio
import Slop.Draw2D
import Slop.Input
import Slop.Math
import Slop.Resource
import Slop.Window
