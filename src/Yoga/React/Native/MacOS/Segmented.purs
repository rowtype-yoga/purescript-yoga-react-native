module Yoga.React.Native.MacOS.Segmented (nativeSegmented, NativeSegmentedAttributes) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import segmentedImpl :: forall props. ReactComponent props

nativeSegmented :: FFINativeComponent_ NativeSegmentedAttributes
nativeSegmented = createNativeElement_ segmentedImpl

type NativeSegmentedAttributes = BaseAttributes
  ( labels :: Array String
  , sfSymbols :: Array String
  , selectedIndex :: Int
  , onChange :: Int -> Effect Unit
  )
