module Yoga.React.Native.IOS.Settings
  ( get
  , set
  , watchKeys
  , clearWatch
  , SettingsWatch
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Foreign (Foreign)

foreign import data SettingsWatch :: Type

foreign import getImpl :: EffectFn1 String Foreign
foreign import setImpl :: EffectFn1 Foreign Unit
foreign import watchKeysImpl :: EffectFn2 (Array String) (Effect Unit) SettingsWatch
foreign import clearWatchImpl :: EffectFn1 SettingsWatch Unit

get :: String -> Effect Foreign
get = runEffectFn1 getImpl

set :: Foreign -> Effect Unit
set = runEffectFn1 setImpl

watchKeys :: Array String -> Effect Unit -> Effect SettingsWatch
watchKeys = runEffectFn2 watchKeysImpl

clearWatch :: SettingsWatch -> Effect Unit
clearWatch = runEffectFn1 clearWatchImpl
