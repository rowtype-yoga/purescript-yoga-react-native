module Yoga.React.Native.ColorWithSystemEffectMacOS
  ( colorWithSystemEffect
  ) where

import Yoga.React.Native.PlatformColor (ColorValue)

foreign import colorWithSystemEffect :: ColorValue -> String -> ColorValue
