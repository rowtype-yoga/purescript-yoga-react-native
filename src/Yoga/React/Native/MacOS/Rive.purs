module Yoga.React.Native.MacOS.Rive (nativeRiveView, nativeRiveView_, NativeRiveViewAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _nativeRiveViewImpl :: forall props. ReactComponent props

nativeRiveView :: FFINativeComponent NativeRiveViewAttributes
nativeRiveView = createNativeElement _nativeRiveViewImpl

nativeRiveView_ :: FFINativeComponent_ NativeRiveViewAttributes
nativeRiveView_ = createNativeElement_ _nativeRiveViewImpl

type NativeRiveViewAttributes = BaseAttributes
  ( resourceName :: String
  , url :: String
  , artboardName :: String
  , stateMachineName :: String
  , autoplay :: Boolean
  )
