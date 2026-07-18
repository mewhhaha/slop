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
  , SlopGlobals(..)
  , slopGlobals
  , LoopControl(..)
  , LoopExit(..)
  , logDebug
  , startTextInput
  , stopTextInput
  , SlopError(..)
  , SlopResult
  , renderSlopError
  , throwSlop
  ) where

import Slop.Internal
