module Yoga.React.Native.Keyboard
  ( dismiss
  , isVisible
  ) where

import Prelude

import Effect (Effect)

foreign import dismiss :: Effect Unit

foreign import isVisible :: Effect Boolean
