module Yoga.React.Native.IOS.Settings
  ( SettingsKey
  , SettingsWatch
  , SettingsError(..)
  , stringSetting
  , booleanSetting
  , numberSetting
  , get
  , set
  , watch
  , disposeSettingsWatch
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Effect.Uncurried
  ( EffectFn1
  , EffectFn2
  , mkEffectFn1
  , runEffectFn1
  , runEffectFn2
  )
import Foreign (Foreign)
import Yoga.React.Native.Types
  ( Availability(..)
  , AvailabilityReason(..)
  )

data SettingsKey a = SettingsKey String (Foreign -> Either SettingsError a) (a -> Foreign)

foreign import data SettingsWatch :: Type

data SettingsError
  = SettingsUnavailable AvailabilityReason
  | WrongSettingType String

derive instance Eq SettingsError
derive instance Ord SettingsError
instance Show SettingsError where
  show (SettingsUnavailable reason) = "(SettingsUnavailable " <> show reason <> ")"
  show (WrongSettingType key) = "(WrongSettingType " <> show key <> ")"

stringSetting :: String -> SettingsKey String
stringSetting key = SettingsKey key (decodeString key) stringToForeign

booleanSetting :: String -> SettingsKey Boolean
booleanSetting key = SettingsKey key (decodeBoolean key) booleanToForeign

numberSetting :: String -> SettingsKey Number
numberSetting key = SettingsKey key (decodeNumber key) numberToForeign

type GetResult =
  { status :: Int
  , present :: Boolean
  , value :: Foreign
  }

foreign import getImpl :: EffectFn1 String GetResult

get :: forall a. SettingsKey a -> Effect (Either SettingsError (Maybe a))
get (SettingsKey key decode _) = do
  result <- runEffectFn1 getImpl key
  pure
    if result.status == availableStatus then
      if result.present then map Just (decode result.value)
      else Right Nothing
    else Left (SettingsUnavailable (statusReason result.status))

foreign import setImpl :: EffectFn2 String Foreign Int

set :: forall a. SettingsKey a -> a -> Effect (Availability Unit)
set (SettingsKey key _ encode) value = do
  status <- runEffectFn2 setImpl key (encode value)
  pure
    if status == availableStatus then Available unit
    else Unavailable (statusReason status)

type WatchResult =
  { status :: Int
  , watch :: Nullable SettingsWatch
  }

foreign import watchImpl :: EffectFn2 String (EffectFn1 Unit Unit) WatchResult

watch
  :: forall a
   . SettingsKey a
  -> (Either SettingsError (Maybe a) -> Effect Unit)
  -> Effect (Availability SettingsWatch)
watch key@(SettingsKey keyName _ _) callback = do
  result <- runEffectFn2 watchImpl keyName (mkEffectFn1 (\_ -> get key >>= callback))
  pure case result.status, toMaybe result.watch of
    status, Just settingsWatch | status == availableStatus -> Available settingsWatch
    status, _ -> Unavailable (statusReason status)

foreign import disposeSettingsWatchImpl :: EffectFn1 SettingsWatch Unit

disposeSettingsWatch :: SettingsWatch -> Effect Unit
disposeSettingsWatch = runEffectFn1 disposeSettingsWatchImpl

availableStatus :: Int
availableStatus = 0

statusReason :: Int -> AvailabilityReason
statusReason 1 = UnsupportedPlatform
statusReason _ = MissingNativeModule

foreign import readStringImpl :: Foreign -> Nullable String
foreign import readBooleanImpl :: Foreign -> Nullable Boolean
foreign import readNumberImpl :: Foreign -> Nullable Number
foreign import stringToForeign :: String -> Foreign
foreign import booleanToForeign :: Boolean -> Foreign
foreign import numberToForeign :: Number -> Foreign

decodeString :: String -> Foreign -> Either SettingsError String
decodeString key value = case toMaybe (readStringImpl value) of
  Just decoded -> Right decoded
  Nothing -> Left (WrongSettingType key)

decodeBoolean :: String -> Foreign -> Either SettingsError Boolean
decodeBoolean key value = case toMaybe (readBooleanImpl value) of
  Just decoded -> Right decoded
  Nothing -> Left (WrongSettingType key)

decodeNumber :: String -> Foreign -> Either SettingsError Number
decodeNumber key value = case toMaybe (readNumberImpl value) of
  Just decoded -> Right decoded
  Nothing -> Left (WrongSettingType key)
