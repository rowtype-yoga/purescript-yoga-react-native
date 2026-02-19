module Yoga.React.Native.MacOS.ScrollView (nativeScrollView, NativeScrollViewAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import nativeScrollViewImpl :: forall props. ReactComponent props

nativeScrollView :: FFINativeComponent NativeScrollViewAttributes
nativeScrollView = createNativeElement nativeScrollViewImpl

type NativeScrollViewAttributes = BaseAttributes
  ( scrollToBottom :: Int
  , scrollToY :: Number
  , scrollToYTrigger :: Int
  , maintainScrollPosition :: Boolean
  )
