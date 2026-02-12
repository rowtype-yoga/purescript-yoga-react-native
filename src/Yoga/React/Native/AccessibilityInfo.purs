module Yoga.React.Native.AccessibilityInfo
  ( isScreenReaderEnabled
  , isReduceMotionEnabled
  , isBoldTextEnabled
  , isGrayscaleEnabled
  , isInvertColorsEnabled
  , isReduceTransparencyEnabled
  , announceForAccessibility
  ) where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

foreign import isScreenReaderEnabledImpl :: EffectFnAff Boolean

isScreenReaderEnabled :: Aff Boolean
isScreenReaderEnabled = fromEffectFnAff isScreenReaderEnabledImpl

foreign import isReduceMotionEnabledImpl :: EffectFnAff Boolean

isReduceMotionEnabled :: Aff Boolean
isReduceMotionEnabled = fromEffectFnAff isReduceMotionEnabledImpl

foreign import isBoldTextEnabledImpl :: EffectFnAff Boolean

isBoldTextEnabled :: Aff Boolean
isBoldTextEnabled = fromEffectFnAff isBoldTextEnabledImpl

foreign import isGrayscaleEnabledImpl :: EffectFnAff Boolean

isGrayscaleEnabled :: Aff Boolean
isGrayscaleEnabled = fromEffectFnAff isGrayscaleEnabledImpl

foreign import isInvertColorsEnabledImpl :: EffectFnAff Boolean

isInvertColorsEnabled :: Aff Boolean
isInvertColorsEnabled = fromEffectFnAff isInvertColorsEnabledImpl

foreign import isReduceTransparencyEnabledImpl :: EffectFnAff Boolean

isReduceTransparencyEnabled :: Aff Boolean
isReduceTransparencyEnabled = fromEffectFnAff isReduceTransparencyEnabledImpl

foreign import announceForAccessibility :: String -> Effect Unit
