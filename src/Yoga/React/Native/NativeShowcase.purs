module Yoga.React.Native.NativeShowcase (nativeShowcase, NativeShowcaseAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _nativeShowcaseImpl :: forall props. ReactComponent props

nativeShowcase :: FFINativeComponent_ NativeShowcaseAttributes
nativeShowcase = createNativeElement_ _nativeShowcaseImpl

type NativeShowcaseAttributes = BaseAttributes ()
