module Yoga.React.Native.IOS.Appearance
  ( getColorScheme
  , setColorScheme
  , addChangeListener
  , removeChangeListener
  , ColorScheme
  , light
  , dark
  , AppearanceSubscription
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import data ColorScheme :: Type
foreign import data AppearanceSubscription :: Type

foreign import light :: ColorScheme
foreign import dark :: ColorScheme

foreign import getColorSchemeImpl :: Effect String
foreign import setColorSchemeImpl :: EffectFn1 String Unit
foreign import addChangeListenerImpl :: EffectFn1 (String -> Effect Unit) AppearanceSubscription
foreign import removeChangeListenerImpl :: EffectFn1 AppearanceSubscription Unit

getColorScheme :: Effect String
getColorScheme = getColorSchemeImpl

setColorScheme :: String -> Effect Unit
setColorScheme = runEffectFn1 setColorSchemeImpl

addChangeListener :: (String -> Effect Unit) -> Effect AppearanceSubscription
addChangeListener = runEffectFn1 addChangeListenerImpl

removeChangeListener :: AppearanceSubscription -> Effect Unit
removeChangeListener = runEffectFn1 removeChangeListenerImpl
