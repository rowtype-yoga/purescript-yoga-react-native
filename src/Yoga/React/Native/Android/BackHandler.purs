module Yoga.React.Native.Android.BackHandler
  ( addEventListener
  , exitApp
  , removeEventListener
  , BackHandlerSubscription
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)

foreign import data BackHandlerSubscription :: Type

foreign import addEventListenerImpl :: EffectFn2 String (Effect Boolean) BackHandlerSubscription
foreign import removeEventListenerImpl :: EffectFn1 BackHandlerSubscription Unit
foreign import exitAppImpl :: Effect Unit

addEventListener :: String -> Effect Boolean -> Effect BackHandlerSubscription
addEventListener = runEffectFn2 addEventListenerImpl

removeEventListener :: BackHandlerSubscription -> Effect Unit
removeEventListener = runEffectFn1 removeEventListenerImpl

exitApp :: Effect Unit
exitApp = exitAppImpl
