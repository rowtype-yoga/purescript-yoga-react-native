module Yoga.React.Native.MacOS.OutlineView
  ( nativeOutlineView
  , NativeOutlineViewAttributes
  , OutlineItem(..)
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import outlineViewImpl :: forall props. ReactComponent props

nativeOutlineView :: FFINativeComponent_ NativeOutlineViewAttributes
nativeOutlineView = createNativeElement_ outlineViewImpl

newtype OutlineItem = OutlineItem
  { id :: String
  , title :: String
  , sfSymbol :: String
  , children :: Array OutlineItem
  }

type NativeOutlineViewAttributes = BaseAttributes
  ( items :: Array OutlineItem
  , headerVisible :: Boolean
  , onSelectItem :: String -> Effect Unit
  )
