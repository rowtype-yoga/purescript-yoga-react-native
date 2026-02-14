module Yoga.React.Native.MacOS.ScrollView (nativeScrollView, NativeScrollViewAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import _nativeScrollViewImpl :: forall props. ReactComponent props

nativeScrollView :: FFINativeComponent NativeScrollViewAttributes
nativeScrollView = createNativeElement _nativeScrollViewImpl

type NativeScrollViewAttributes = BaseAttributes
  ( scrollToBottom :: Int
  )
