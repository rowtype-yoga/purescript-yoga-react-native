module Yoga.React.Native.SafeAreaView (safeAreaView, safeAreaView_, SafeAreaViewAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _safeAreaViewImpl :: forall props. ReactComponent props

safeAreaView :: FFINativeComponent SafeAreaViewAttributes
safeAreaView = createNativeElement _safeAreaViewImpl

safeAreaView_ :: FFINativeComponent_ SafeAreaViewAttributes
safeAreaView_ = createNativeElement_ _safeAreaViewImpl

type SafeAreaViewAttributes = BaseAttributes ()
