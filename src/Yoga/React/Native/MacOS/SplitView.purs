module Yoga.React.Native.MacOS.SplitView
  ( nativeSplitView
  , NativeSplitViewAttributes
  ) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import _splitViewImpl :: forall props. ReactComponent props

nativeSplitView :: FFINativeComponent NativeSplitViewAttributes
nativeSplitView = createNativeElement _splitViewImpl

type NativeSplitViewAttributes = BaseAttributes
  ( isVertical :: Boolean
  , dividerThicknessValue :: Number
  )
