module Yoga.React.Native.MacOS.OutlineView
  ( nativeOutlineView
  , NativeOutlineViewAttributes
  , outlineItem
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Foreign (Foreign, unsafeToForeign)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _outlineViewImpl :: forall props. ReactComponent props

nativeOutlineView :: FFINativeComponent_ NativeOutlineViewAttributes
nativeOutlineView = createNativeElement_ _outlineViewImpl

outlineItem :: String -> String -> String -> Array Foreign -> Foreign
outlineItem id title sfSymbol children = unsafeToForeign { id, title, sfSymbol, children }

type NativeOutlineViewAttributes = BaseAttributes
  ( items :: Array Foreign
  , headerVisible :: Boolean
  , onSelectItem :: EventHandler
  )
