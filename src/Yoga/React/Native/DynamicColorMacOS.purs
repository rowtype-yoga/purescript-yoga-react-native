module Yoga.React.Native.DynamicColorMacOS
  ( dynamicColor
  ) where

import Yoga.React.Native.Style (Style)

foreign import dynamicColor :: { light :: String, dark :: String } -> Style
