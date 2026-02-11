module Yoga.React.Native.Linking
  ( openURL
  , canOpenURL
  , getInitialURL
  , openSettings
  ) where

import Prelude

import Data.Nullable (Nullable)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

foreign import openURLImpl :: String -> EffectFnAff Unit

openURL :: String -> Aff Unit
openURL = fromEffectFnAff <<< openURLImpl

foreign import canOpenURLImpl :: String -> EffectFnAff Boolean

canOpenURL :: String -> Aff Boolean
canOpenURL = fromEffectFnAff <<< canOpenURLImpl

foreign import getInitialURLImpl :: EffectFnAff (Nullable String)

getInitialURL :: Aff (Nullable String)
getInitialURL = fromEffectFnAff getInitialURLImpl

foreign import openSettingsImpl :: EffectFnAff Unit

openSettings :: Aff Unit
openSettings = fromEffectFnAff openSettingsImpl
