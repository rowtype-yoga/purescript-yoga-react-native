module Yoga.React.Native.MacOS.ContextMenu (nativeContextMenu, NativeContextMenuAttributes, ContextMenuItem) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import _contextMenuImpl :: forall props. ReactComponent props

nativeContextMenu :: FFINativeComponent NativeContextMenuAttributes
nativeContextMenu = createNativeElement _contextMenuImpl

type ContextMenuItem =
  { id :: String
  , title :: String
  , sfSymbol :: String
  }

type NativeContextMenuAttributes = BaseAttributes
  ( items :: Array ContextMenuItem
  , onSelectItem :: EventHandler
  )
