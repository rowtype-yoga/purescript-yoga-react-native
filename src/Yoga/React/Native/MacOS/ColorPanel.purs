module Yoga.React.Native.MacOS.ColorPanel
  ( macosShowColorPanel
  , macosHideColorPanel
  ) where

import Prelude

import Effect (Effect)

foreign import showColorPanelImpl :: Effect Unit
foreign import hideColorPanelImpl :: Effect Unit

macosShowColorPanel :: Effect Unit
macosShowColorPanel = showColorPanelImpl

macosHideColorPanel :: Effect Unit
macosHideColorPanel = hideColorPanelImpl
