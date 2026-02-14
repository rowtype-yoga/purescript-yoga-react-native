module Yoga.React.Native.MacOS.AnimatedImage (nativeAnimatedImage, NativeAnimatedImageAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _animatedImageImpl :: forall props. ReactComponent props

nativeAnimatedImage :: FFINativeComponent_ NativeAnimatedImageAttributes
nativeAnimatedImage = createNativeElement_ _animatedImageImpl

type NativeAnimatedImageAttributes = BaseAttributes
  ( source :: String
  , animating :: Boolean
  )
