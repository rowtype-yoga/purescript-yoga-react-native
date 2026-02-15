module Yoga.React.Native.MacOS.Popover
  ( nativePopover
  , NativePopoverAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import _popoverImpl :: forall props. ReactComponent props

nativePopover :: FFINativeComponent NativePopoverAttributes
nativePopover = createNativeElement _popoverImpl

type NativePopoverAttributes = BaseAttributes
  ( visible :: Boolean
  , preferredEdge :: String
  , behavior :: String
  , onClose :: EventHandler
  )
