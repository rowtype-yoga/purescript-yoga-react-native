module Yoga.React.Native.MacOS.Popover
  ( nativePopover
  , NativePopoverAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)
import Yoga.React.Native.MacOS.Types (PopoverEdge, PopoverBehavior)

foreign import _popoverImpl :: forall props. ReactComponent props

nativePopover :: FFINativeComponent NativePopoverAttributes
nativePopover = createNativeElement _popoverImpl

type NativePopoverAttributes = BaseAttributes
  ( visible :: Boolean
  , preferredEdge :: PopoverEdge
  , behavior :: PopoverBehavior
  , onClose :: EventHandler
  )
