module Yoga.React.Native.MacOS.VisualEffect (nativeVisualEffect, NativeVisualEffectAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import _visualEffectImpl :: forall props. ReactComponent props

nativeVisualEffect :: FFINativeComponent NativeVisualEffectAttributes
nativeVisualEffect = createNativeElement _visualEffectImpl

type NativeVisualEffectAttributes = BaseAttributes
  ( materialName :: String
  , blendingModeName :: String
  , stateName :: String
  )
