module Yoga.React.Native.MacOS.Alert
  ( macosAlert
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn4, runEffectFn4)

foreign import alertImpl :: EffectFn4 String String String (Array String) Unit

macosAlert :: String -> String -> String -> Array String -> Effect Unit
macosAlert = runEffectFn4 alertImpl
