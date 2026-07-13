module Yoga.React.Native.IOS.Haptics
  ( ImpactStyle(..)
  , NotificationType(..)
  , VibrationRepeat(..)
  , VibrationDuration
  , vibrationDuration
  , vibrationPattern
  , vibrate
  , vibrateWithPattern
  , cancel
  , selectionChanged
  , impact
  , notification
  ) where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Maybe (Maybe(..))
import Data.Number as Number
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Yoga.React.Native.Types (Availability(..), AvailabilityReason(..))

data ImpactStyle
  = ImpactLight
  | ImpactMedium
  | ImpactHeavy

derive instance Eq ImpactStyle
derive instance Ord ImpactStyle
instance Show ImpactStyle where
  show ImpactLight = "ImpactLight"
  show ImpactMedium = "ImpactMedium"
  show ImpactHeavy = "ImpactHeavy"

data NotificationType
  = NotificationSuccess
  | NotificationWarning
  | NotificationError

derive instance Eq NotificationType
derive instance Ord NotificationType
instance Show NotificationType where
  show NotificationSuccess = "NotificationSuccess"
  show NotificationWarning = "NotificationWarning"
  show NotificationError = "NotificationError"

data VibrationRepeat
  = VibrateOnce
  | RepeatVibration

derive instance Eq VibrationRepeat
derive instance Ord VibrationRepeat
instance Show VibrationRepeat where
  show VibrateOnce = "VibrateOnce"
  show RepeatVibration = "RepeatVibration"

newtype VibrationDuration = VibrationDuration Milliseconds

derive newtype instance Eq VibrationDuration
derive newtype instance Ord VibrationDuration
derive newtype instance Show VibrationDuration

vibrationDuration :: Number -> Maybe VibrationDuration
vibrationDuration duration
  | Number.isFinite duration && duration >= 0.0 =
      Just (VibrationDuration (Milliseconds duration))
  | otherwise = Nothing

vibrationPattern
  :: NonEmptyArray VibrationDuration
  -> NonEmptyArray VibrationDuration
vibrationPattern = identity

vibrate :: VibrationDuration -> Effect Unit
vibrate = runEffectFn1 vibrateImpl

foreign import vibrateImpl :: EffectFn1 VibrationDuration Unit

vibrateWithPattern
  :: NonEmptyArray VibrationDuration
  -> VibrationRepeat
  -> Effect Unit
vibrateWithPattern pattern repeat =
  runEffectFn2 vibrateWithPatternImpl
    (NonEmptyArray.toArray pattern)
    (vibrationRepeatToBoolean repeat)

foreign import vibrateWithPatternImpl
  :: EffectFn2 (Array VibrationDuration) Boolean Unit

vibrationRepeatToBoolean :: VibrationRepeat -> Boolean
vibrationRepeatToBoolean = case _ of
  VibrateOnce -> false
  RepeatVibration -> true

cancel :: Effect Unit
cancel = cancelImpl

foreign import cancelImpl :: Effect Unit

selectionChanged :: Effect (Availability Unit)
selectionChanged = availabilityFromStatus <$> selectionChangedImpl

foreign import selectionChangedImpl :: Effect Int

impact :: ImpactStyle -> Effect (Availability Unit)
impact style =
  availabilityFromStatus <$>
    runEffectFn1 impactImpl (impactStyleToString style)

foreign import impactImpl :: EffectFn1 String Int

impactStyleToString :: ImpactStyle -> String
impactStyleToString = case _ of
  ImpactLight -> "light"
  ImpactMedium -> "medium"
  ImpactHeavy -> "heavy"

notification :: NotificationType -> Effect (Availability Unit)
notification notificationType =
  availabilityFromStatus <$>
    runEffectFn1 notificationImpl (notificationTypeToString notificationType)

foreign import notificationImpl :: EffectFn1 String Int

notificationTypeToString :: NotificationType -> String
notificationTypeToString = case _ of
  NotificationSuccess -> "success"
  NotificationWarning -> "warning"
  NotificationError -> "error"

availabilityFromStatus :: Int -> Availability Unit
availabilityFromStatus = case _ of
  0 -> Available unit
  1 -> Unavailable UnsupportedPlatform
  _ -> Unavailable MissingNativeModule
