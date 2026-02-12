module Yoga.React.Native.I18nManager
  ( isRTL
  , allowRTL
  , forceRTL
  , swapLeftAndRightInRTL
  ) where

import Prelude

import Effect (Effect)

foreign import isRTL :: Boolean
foreign import allowRTL :: Boolean -> Effect Unit
foreign import forceRTL :: Boolean -> Effect Unit
foreign import swapLeftAndRightInRTL :: Boolean -> Effect Unit
