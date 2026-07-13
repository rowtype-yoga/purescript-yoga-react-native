module Yoga.React.Native.IOS.LinkingIOS
  ( LinkingSubscription
  , openSettings
  , canOpenURL
  , openURL
  , getInitialURL
  , addURLListener
  , disposeLinkingSubscription
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, mkEffectFn1, runEffectFn1)
import Promise (Promise)
import Promise.Aff (toAffE)
import Yoga.React.Native.Types (URL(..))

foreign import data LinkingSubscription :: Type

foreign import openSettingsImpl :: Effect (Promise Unit)

openSettings :: Aff Unit
openSettings = toAffE openSettingsImpl

foreign import canOpenURLImpl :: EffectFn1 String (Promise Boolean)

canOpenURL :: URL -> Aff Boolean
canOpenURL (URL url) = toAffE (runEffectFn1 canOpenURLImpl url)

foreign import openURLImpl :: EffectFn1 String (Promise Unit)

openURL :: URL -> Aff Unit
openURL (URL url) = toAffE (runEffectFn1 openURLImpl url)

foreign import getInitialURLImpl :: Effect (Promise (Nullable String))

getInitialURL :: Aff (Maybe URL)
getInitialURL = map (map URL <<< toMaybe) (toAffE getInitialURLImpl)

foreign import addURLListenerImpl :: EffectFn1 (EffectFn1 String Unit) LinkingSubscription

addURLListener :: (URL -> Effect Unit) -> Effect LinkingSubscription
addURLListener callback =
  runEffectFn1 addURLListenerImpl (mkEffectFn1 (callback <<< URL))

foreign import disposeLinkingSubscriptionImpl :: EffectFn1 LinkingSubscription Unit

disposeLinkingSubscription :: LinkingSubscription -> Effect Unit
disposeLinkingSubscription = runEffectFn1 disposeLinkingSubscriptionImpl
