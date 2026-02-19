module Yoga.React.Native.MacOS.Popover
  ( nativePopover
  , NativePopoverAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)
import Yoga.React.Native.MacOS.Types (PopoverEdge, PopoverBehavior)

foreign import popoverImpl :: forall props. ReactComponent props

nativePopover :: FFINativeComponent NativePopoverAttributes
nativePopover = createNativeElement popoverImpl

type NativePopoverAttributes = BaseAttributes
  ( visible :: Boolean
  , preferredEdge :: PopoverEdge
  , behavior :: PopoverBehavior
  , popoverWidth :: Number
  , popoverHeight :: Number
  , popoverPadding :: Number
  , onClose :: Effect Unit
  )
