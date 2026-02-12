module Yoga.React.Native.Attributes where

import React.Basic.Events (EventHandler)
import Yoga.React.Native.Style (Style)

type KeyEvent =
  { key :: String
  , altKey :: Boolean
  , ctrlKey :: Boolean
  , metaKey :: Boolean
  , shiftKey :: Boolean
  }

type BaseAttributes r =
  ( style :: Style
  , testID :: String
  , nativeID :: String
  , accessible :: Boolean
  , accessibilityLabel :: String
  , accessibilityHint :: String
  , accessibilityRole :: String
  , onLayout :: EventHandler
  -- macOS
  , tooltip :: String
  , cursor :: String
  , acceptsFirstMouse :: Boolean
  , mouseDownCanMoveWindow :: Boolean
  , allowsVibrancy :: Boolean
  , enableFocusRing :: Boolean
  , focusable :: Boolean
  , draggedTypes :: Array String
  , onMouseEnter :: EventHandler
  , onMouseLeave :: EventHandler
  , onDoubleClick :: EventHandler
  , onDragEnter :: EventHandler
  , onDragLeave :: EventHandler
  , onDrop :: EventHandler
  , onKeyDown :: EventHandler
  , onKeyUp :: EventHandler
  , keyDownEvents :: Array KeyEvent
  , keyUpEvents :: Array KeyEvent
  | r
  )
