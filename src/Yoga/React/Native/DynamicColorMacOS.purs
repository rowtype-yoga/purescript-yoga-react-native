module Yoga.React.Native.DynamicColorMacOS
  ( dynamicColor
  ) where

import Yoga.React.Native.PlatformColor (ColorValue)

foreign import dynamicColor :: { light :: String, dark :: String } -> ColorValue
