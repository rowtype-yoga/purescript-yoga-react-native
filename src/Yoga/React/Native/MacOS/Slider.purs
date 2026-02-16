module Yoga.React.Native.MacOS.Slider (nativeSlider, NativeSliderAttributes) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import sliderImpl :: forall props. ReactComponent props

nativeSlider :: FFINativeComponent_ NativeSliderAttributes
nativeSlider = createNativeElement_ sliderImpl

type NativeSliderAttributes = BaseAttributes
  ( value :: Number
  , minValue :: Number
  , maxValue :: Number
  , numberOfTickMarks :: Int
  , allowsTickMarkValuesOnly :: Boolean
  , onChange :: Number -> Effect Unit
  )
