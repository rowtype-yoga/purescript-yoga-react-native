module Yoga.React.Native.MacOS.Alert
  ( macosAlert
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn4, runEffectFn4)
import Yoga.React.Native.MacOS.Types (AlertStyle)

foreign import alertImpl :: EffectFn4 AlertStyle String String (Array String) Unit

macosAlert :: AlertStyle -> String -> String -> Array String -> Effect Unit
macosAlert = runEffectFn4 alertImpl
