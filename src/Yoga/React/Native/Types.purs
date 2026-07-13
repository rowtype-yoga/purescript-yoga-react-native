module Yoga.React.Native.Types
  ( URL(..)
  , ItemId(..)
  , ControlState(..)
  , controlStateToBoolean
  , RefreshState(..)
  , refreshStateToBoolean
  , AvailabilityReason(..)
  , Availability(..)
  , ColorScheme(..)
  , colorSchemeToString
  , colorSchemeFromString
  , UserInterfaceStyle(..)
  , userInterfaceStyleToString
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)

newtype URL = URL String

derive instance Newtype URL _
derive newtype instance Eq URL
derive newtype instance Ord URL
derive newtype instance Show URL

newtype ItemId = ItemId String

derive instance Newtype ItemId _
derive newtype instance Eq ItemId
derive newtype instance Ord ItemId
derive newtype instance Show ItemId

data ControlState
  = Enabled
  | Disabled

derive instance Eq ControlState
derive instance Ord ControlState
instance Show ControlState where
  show Enabled = "Enabled"
  show Disabled = "Disabled"

controlStateToBoolean :: ControlState -> Boolean
controlStateToBoolean = case _ of
  Enabled -> true
  Disabled -> false

data RefreshState
  = RefreshIdle
  | Refreshing

derive instance Eq RefreshState
derive instance Ord RefreshState
instance Show RefreshState where
  show RefreshIdle = "RefreshIdle"
  show Refreshing = "Refreshing"

refreshStateToBoolean :: RefreshState -> Boolean
refreshStateToBoolean = case _ of
  RefreshIdle -> false
  Refreshing -> true

data AvailabilityReason
  = UnsupportedPlatform
  | MissingNativeModule

derive instance Eq AvailabilityReason
derive instance Ord AvailabilityReason
instance Show AvailabilityReason where
  show UnsupportedPlatform = "UnsupportedPlatform"
  show MissingNativeModule = "MissingNativeModule"

data Availability a
  = Available a
  | Unavailable AvailabilityReason

derive instance Eq a => Eq (Availability a)
derive instance Ord a => Ord (Availability a)
instance Show a => Show (Availability a) where
  show (Available value) = "(Available " <> show value <> ")"
  show (Unavailable reason) = "(Unavailable " <> show reason <> ")"

data ColorScheme
  = Light
  | Dark

derive instance Eq ColorScheme
derive instance Ord ColorScheme
instance Show ColorScheme where
  show Light = "Light"
  show Dark = "Dark"

colorSchemeToString :: ColorScheme -> String
colorSchemeToString = case _ of
  Light -> "light"
  Dark -> "dark"

colorSchemeFromString :: String -> Maybe ColorScheme
colorSchemeFromString = case _ of
  "light" -> Just Light
  "dark" -> Just Dark
  _ -> Nothing

data UserInterfaceStyle
  = Automatic
  | LightInterface
  | DarkInterface

derive instance Eq UserInterfaceStyle
derive instance Ord UserInterfaceStyle
instance Show UserInterfaceStyle where
  show Automatic = "Automatic"
  show LightInterface = "LightInterface"
  show DarkInterface = "DarkInterface"

userInterfaceStyleToString :: UserInterfaceStyle -> String
userInterfaceStyleToString = case _ of
  Automatic -> "automatic"
  LightInterface -> "light"
  DarkInterface -> "dark"
