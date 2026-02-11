module Yoga.React.Native.Attributes where

import React.Basic.Events (EventHandler)
import Yoga.React.Native.Style (Style)

type BaseAttributes r =
  ( style :: Style
  , testID :: String
  , nativeID :: String
  , accessible :: Boolean
  , accessibilityLabel :: String
  , accessibilityHint :: String
  , accessibilityRole :: String
  , onLayout :: EventHandler
  | r
  )
