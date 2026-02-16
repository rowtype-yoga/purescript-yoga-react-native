module Yoga.React.Native.MacOS.ContextMenu (nativeContextMenu, NativeContextMenuAttributes, ContextMenuItem) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import contextMenuImpl :: forall props. ReactComponent props

nativeContextMenu :: FFINativeComponent NativeContextMenuAttributes
nativeContextMenu = createNativeElement contextMenuImpl

type ContextMenuItem =
  { id :: String
  , title :: String
  , sfSymbol :: String
  }

type NativeContextMenuAttributes = BaseAttributes
  ( items :: Array ContextMenuItem
  , onSelectItem :: String -> Effect Unit
  )
