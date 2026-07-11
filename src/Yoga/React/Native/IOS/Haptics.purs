module Yoga.React.Native.IOS.Haptics
  ( vibrate
  , vibrateWithPattern
  , cancel
  , ImpactStyle
  , NotificationType
  , impactLight
  , impactMedium
  , impactHeavy
  , notificationSuccess
  , notificationWarning
  , notificationError
  , selectionChanged
  , impact
  , notification
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)

foreign import data ImpactStyle :: Type
foreign import data NotificationType :: Type

foreign import impactLight :: ImpactStyle
foreign import impactMedium :: ImpactStyle
foreign import impactHeavy :: ImpactStyle

foreign import notificationSuccess :: NotificationType
foreign import notificationWarning :: NotificationType
foreign import notificationError :: NotificationType

foreign import vibrateImpl :: EffectFn1 Int Unit
foreign import vibrateWithPatternImpl :: EffectFn2 (Array Int) Boolean Unit
foreign import cancelImpl :: Effect Unit
foreign import selectionChangedImpl :: Effect Unit
foreign import impactImpl :: EffectFn1 ImpactStyle Unit
foreign import notificationImpl :: EffectFn1 NotificationType Unit

vibrate :: Int -> Effect Unit
vibrate = runEffectFn1 vibrateImpl

vibrateWithPattern :: Array Int -> Boolean -> Effect Unit
vibrateWithPattern = runEffectFn2 vibrateWithPatternImpl

cancel :: Effect Unit
cancel = cancelImpl

selectionChanged :: Effect Unit
selectionChanged = selectionChangedImpl

impact :: ImpactStyle -> Effect Unit
impact = runEffectFn1 impactImpl

notification :: NotificationType -> Effect Unit
notification = runEffectFn1 notificationImpl
