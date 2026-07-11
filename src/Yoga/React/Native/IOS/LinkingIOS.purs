module Yoga.React.Native.IOS.LinkingIOS
  ( openSettings
  , canOpenURL
  , openURL
  , getInitialURL
  , addEventListener
  , LinkingSubscription
  ) where

import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Uncurried (EffectFn2, runEffectFn2)

foreign import data LinkingSubscription :: Type

foreign import openSettingsImpl :: EffectFnAff Unit
foreign import canOpenURLImpl :: String -> EffectFnAff Boolean
foreign import openURLImpl :: String -> EffectFnAff Unit
foreign import getInitialURLImpl :: EffectFnAff (Nullable String)
foreign import addEventListenerImpl :: EffectFn2 String (String -> Effect Unit) LinkingSubscription

openSettings :: Aff Unit
openSettings = fromEffectFnAff openSettingsImpl

canOpenURL :: String -> Aff Boolean
canOpenURL = canOpenURLImpl >>> fromEffectFnAff

openURL :: String -> Aff Unit
openURL = openURLImpl >>> fromEffectFnAff

getInitialURL :: Aff (Nullable String)
getInitialURL = fromEffectFnAff getInitialURLImpl

addEventListener :: String -> (String -> Effect Unit) -> Effect LinkingSubscription
addEventListener = runEffectFn2 addEventListenerImpl
