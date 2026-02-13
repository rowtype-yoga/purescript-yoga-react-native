module Yoga.React.Native.MacOS.Progress (nativeProgress, NativeProgressAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _progressImpl :: forall props. ReactComponent props

nativeProgress :: FFINativeComponent_ NativeProgressAttributes
nativeProgress = createNativeElement_ _progressImpl

type NativeProgressAttributes = BaseAttributes
  ( value :: Number
  , indeterminate :: Boolean
  , spinning :: Boolean
  )
