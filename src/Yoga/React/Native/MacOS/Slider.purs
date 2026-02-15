module Yoga.React.Native.MacOS.Slider (nativeSlider, NativeSliderAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
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
  , onChange :: EventHandler
  )
