module Yoga.React.Native.MacOS.HoverView (nativeHoverView, NativeHoverViewAttributes) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import hoverViewImpl :: forall props. ReactComponent props

nativeHoverView :: FFINativeComponent NativeHoverViewAttributes
nativeHoverView = createNativeElement hoverViewImpl

type NativeHoverViewAttributes = BaseAttributes
  ( onHoverChange :: Boolean -> Effect Unit
  )
