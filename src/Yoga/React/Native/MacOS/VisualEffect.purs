module Yoga.React.Native.MacOS.VisualEffect (nativeVisualEffect, NativeVisualEffectAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)
import Yoga.React.Native.MacOS.Types (VisualEffectMaterial, BlendingMode, VisualEffectState)

foreign import visualEffectImpl :: forall props. ReactComponent props

nativeVisualEffect :: FFINativeComponent NativeVisualEffectAttributes
nativeVisualEffect = createNativeElement visualEffectImpl

type NativeVisualEffectAttributes = BaseAttributes
  ( materialName :: VisualEffectMaterial
  , blendingModeName :: BlendingMode
  , stateName :: VisualEffectState
  )
