module Yoga.React.Native.Android.PlatformColor
  ( platformColor
  , selectableBackground
  , selectableBackgroundBorderless
  , ripple
  , RippleConfig
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn3, runEffectFn1, runEffectFn3)
import Foreign (Foreign)

type RippleConfig =
  { color :: String
  , borderless :: Boolean
  , radius :: Number
  }

foreign import platformColorImpl :: EffectFn1 (Array String) Foreign
foreign import selectableBackgroundImpl :: Effect Foreign
foreign import selectableBackgroundBorderlessImpl :: Effect Foreign
foreign import rippleImpl :: EffectFn3 String Boolean Number Foreign

platformColor :: Array String -> Effect Foreign
platformColor = runEffectFn1 platformColorImpl

selectableBackground :: Effect Foreign
selectableBackground = selectableBackgroundImpl

selectableBackgroundBorderless :: Effect Foreign
selectableBackgroundBorderless = selectableBackgroundBorderlessImpl

ripple :: String -> Boolean -> Number -> Effect Foreign
ripple = runEffectFn3 rippleImpl
