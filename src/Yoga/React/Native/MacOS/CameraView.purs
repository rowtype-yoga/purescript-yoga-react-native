module Yoga.React.Native.MacOS.CameraView
  ( nativeCameraView
  , NativeCameraViewAttributes
  ) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import cameraViewImpl :: forall props. ReactComponent props

nativeCameraView :: FFINativeComponent_ NativeCameraViewAttributes
nativeCameraView = createNativeElement_ cameraViewImpl

type NativeCameraViewAttributes = BaseAttributes
  ( active :: Boolean
  )
