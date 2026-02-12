module Yoga.React.Native.PlatformColor
  ( ColorValue
  , platformColor
  ) where

foreign import data ColorValue :: Type

foreign import platformColor :: String -> ColorValue
