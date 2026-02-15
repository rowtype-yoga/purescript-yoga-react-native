module Yoga.React.Native.MacOS.OutlineView
  ( nativeOutlineView
  , NativeOutlineViewAttributes
  ) where

import Foreign (Foreign)
import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _outlineViewImpl :: forall props. ReactComponent props

nativeOutlineView :: FFINativeComponent_ NativeOutlineViewAttributes
nativeOutlineView = createNativeElement_ _outlineViewImpl

type NativeOutlineViewAttributes = BaseAttributes
  ( items :: Foreign
  , headerVisible :: Boolean
  , onSelectItem :: EventHandler
  )
