module Yoga.React.Native.Alert
  ( alert
  , alertWithButtons
  , AlertButton
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn3, runEffectFn3)

type AlertButton =
  { text :: String
  , onPress :: Effect Unit
  , style :: String
  }

foreign import alertImpl :: EffectFn3 String String (Array AlertButton) Unit

alert :: String -> String -> Effect Unit
alert title message = runEffectFn3 alertImpl title message []

alertWithButtons :: String -> String -> Array AlertButton -> Effect Unit
alertWithButtons = runEffectFn3 alertImpl
