-- | Window configuration, lifecycle, frame iteration, and structured errors.
module Slop.Window
  ( Config(..)
  , ConfigPatch(..)
  , defaultConfig
  , applyConfigPatch
  , Window
  , WindowM
  , runWindow
  , loop
  , Frame(..)
  , Globals(..)
  , globals
  , LoopControl(..)
  , LoopExit(..)
  , logDebug
  , startTextInput
  , stopTextInput
  , Error(..)
  , Result
  , renderError
  , throwError
  ) where

import Slop.Internal
