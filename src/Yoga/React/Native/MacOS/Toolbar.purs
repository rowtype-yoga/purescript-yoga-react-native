module Yoga.React.Native.MacOS.Toolbar (nativeToolbar, NativeToolbarAttributes, ToolbarItem) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (ToolbarStyle)

foreign import _toolbarImpl :: forall props. ReactComponent props

nativeToolbar :: FFINativeComponent_ NativeToolbarAttributes
nativeToolbar = createNativeElement_ _toolbarImpl

type ToolbarItem =
  { id :: String
  , label :: String
  , sfSymbol :: String
  }

type NativeToolbarAttributes = BaseAttributes
  ( items :: Array ToolbarItem
  , selectedItem :: String
  , toolbarStyle :: ToolbarStyle
  , windowTitle :: String
  , onSelectItem :: EventHandler
  )
