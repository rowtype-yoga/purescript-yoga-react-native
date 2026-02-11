module Yoga.React.Native.AppState
  ( currentState
  , addEventListener
  , Subscription
  , removeSubscription
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn2)

foreign import data Subscription :: Type

foreign import currentState :: Effect String

foreign import addEventListenerImpl :: EffectFn2 String (EffectFn1 String Unit) Subscription

addEventListener :: String -> (EffectFn1 String Unit) -> Effect Subscription
addEventListener = runEffectFn2 addEventListenerImpl

foreign import removeSubscription :: Subscription -> Effect Unit
