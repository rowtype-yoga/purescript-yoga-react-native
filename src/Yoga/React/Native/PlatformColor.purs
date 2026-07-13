module Yoga.React.Native.PlatformColor
  ( ColorValue
  , PlatformColorName(..)
  , ColorLiteral(..)
  , literalColor
  , platformColor
  , dynamicColor
  ) where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Newtype (class Newtype)

foreign import data ColorValue :: Type

newtype PlatformColorName = PlatformColorName String

derive instance Newtype PlatformColorName _
derive newtype instance Eq PlatformColorName
derive newtype instance Ord PlatformColorName
derive newtype instance Show PlatformColorName

newtype ColorLiteral = ColorLiteral String

derive instance Newtype ColorLiteral _
derive newtype instance Eq ColorLiteral
derive newtype instance Ord ColorLiteral
derive newtype instance Show ColorLiteral

foreign import literalColorImpl :: String -> ColorValue

literalColor :: ColorLiteral -> ColorValue
literalColor (ColorLiteral color) = literalColorImpl color

foreign import platformColorImpl :: Array String -> ColorValue

platformColor :: NonEmptyArray PlatformColorName -> ColorValue
platformColor names =
  platformColorImpl (map (\(PlatformColorName name) -> name) (NonEmptyArray.toArray names))

foreign import dynamicColorImpl :: { light :: ColorValue, dark :: ColorValue } -> ColorValue

dynamicColor :: { light :: ColorValue, dark :: ColorValue } -> ColorValue
dynamicColor = dynamicColorImpl
