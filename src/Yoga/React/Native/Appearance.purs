module Yoga.React.Native.Appearance
  ( AppearanceSubscription
  , getColorScheme
  , setColorScheme
  , useColorScheme
  , UseColorScheme
  , addChangeListener
  , disposeAppearanceSubscription
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe, toNullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1, runEffectFn1)
import React.Basic.Hooks (Hook, unsafeHook)
import Yoga.React.Native.Types (ColorScheme, colorSchemeFromString, colorSchemeToString)

foreign import data AppearanceSubscription :: Type

foreign import getColorSchemeImpl :: Effect (Nullable String)

getColorScheme :: Effect (Maybe ColorScheme)
getColorScheme = decodeColorScheme <$> getColorSchemeImpl

foreign import setColorSchemeImpl :: EffectFn1 (Nullable String) Unit

setColorScheme :: Maybe ColorScheme -> Effect Unit
setColorScheme = runEffectFn1 setColorSchemeImpl <<< toNullable <<< map colorSchemeToString

foreign import useColorSchemeImpl :: Effect (Nullable String)

foreign import data UseColorScheme :: Type -> Type

useColorScheme :: Hook UseColorScheme (Maybe ColorScheme)
useColorScheme = unsafeHook (decodeColorScheme <$> useColorSchemeImpl)

foreign import addChangeListenerImpl :: EffectFn1 (EffectFn1 (Nullable String) Unit) AppearanceSubscription

addChangeListener :: (Maybe ColorScheme -> Effect Unit) -> Effect AppearanceSubscription
addChangeListener callback =
  runEffectFn1 addChangeListenerImpl (mkEffectFn1 (callback <<< decodeColorScheme))

foreign import disposeAppearanceSubscriptionImpl :: EffectFn1 AppearanceSubscription Unit

disposeAppearanceSubscription :: AppearanceSubscription -> Effect Unit
disposeAppearanceSubscription = runEffectFn1 disposeAppearanceSubscriptionImpl

decodeColorScheme :: Nullable String -> Maybe ColorScheme
decodeColorScheme nullable = case toMaybe nullable of
  Nothing -> Nothing
  Just scheme -> colorSchemeFromString scheme
