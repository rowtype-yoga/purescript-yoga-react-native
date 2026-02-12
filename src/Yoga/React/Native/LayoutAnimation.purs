module Yoga.React.Native.LayoutAnimation
  ( configureNext
  , easeInEaseOut
  , linear
  , spring
  , LayoutAnimationConfig
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

type LayoutAnimationConfig =
  { duration :: Int
  , create :: { type :: String, property :: String }
  , update :: { type :: String }
  , delete :: { type :: String, property :: String }
  }

foreign import configureNextImpl :: EffectFn1 LayoutAnimationConfig Unit

configureNext :: LayoutAnimationConfig -> Effect Unit
configureNext = runEffectFn1 configureNextImpl

foreign import easeInEaseOut :: Effect Unit
foreign import linear :: Effect Unit
foreign import spring :: Effect Unit
