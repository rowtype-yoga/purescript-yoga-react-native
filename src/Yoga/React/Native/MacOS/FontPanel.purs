module Yoga.React.Native.MacOS.FontPanel
  ( macosShowFontPanel
  , macosHideFontPanel
  ) where

import Prelude

import Effect (Effect)

foreign import showFontPanelImpl :: Effect Unit
foreign import hideFontPanelImpl :: Effect Unit

macosShowFontPanel :: Effect Unit
macosShowFontPanel = showFontPanelImpl

macosHideFontPanel :: Effect Unit
macosHideFontPanel = hideFontPanelImpl
