module Yoga.React.Native.IOS.PlatformColor
  ( platformColor
  , dynamicColor
  , DynamicColorSpec
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Foreign (Foreign)

type DynamicColorSpec =
  { light :: String
  , dark :: String
  }

foreign import platformColorImpl :: EffectFn1 (Array String) Foreign
foreign import dynamicColorImpl :: EffectFn2 String String Foreign

platformColor :: Array String -> Effect Foreign
platformColor = runEffectFn1 platformColorImpl

dynamicColor :: String -> String -> Effect Foreign
dynamicColor = runEffectFn2 dynamicColorImpl
