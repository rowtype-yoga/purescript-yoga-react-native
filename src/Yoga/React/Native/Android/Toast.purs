module Yoga.React.Native.Android.Toast
  ( show
  , showWithGravity
  , showWithGravityAndOffset
  , Duration
  , Gravity
  , short
  , long
  , top
  , bottom
  , center
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, EffectFn3, EffectFn5, runEffectFn2, runEffectFn3, runEffectFn5)

foreign import data Duration :: Type
foreign import data Gravity :: Type

foreign import short :: Duration
foreign import long :: Duration
foreign import top :: Gravity
foreign import bottom :: Gravity
foreign import center :: Gravity

foreign import showImpl :: EffectFn2 String Duration Unit

show :: String -> Duration -> Effect Unit
show = runEffectFn2 showImpl

foreign import showWithGravityImpl :: EffectFn3 String Duration Gravity Unit

showWithGravity :: String -> Duration -> Gravity -> Effect Unit
showWithGravity = runEffectFn3 showWithGravityImpl

foreign import showWithGravityAndOffsetImpl :: EffectFn5 String Duration Gravity Int Int Unit

showWithGravityAndOffset :: String -> Duration -> Gravity -> Int -> Int -> Effect Unit
showWithGravityAndOffset = runEffectFn5 showWithGravityAndOffsetImpl
