module Yoga.React.Native.MacOS.DatePicker (nativeDatePicker, NativeDatePickerAttributes) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import datePickerImpl :: forall props. ReactComponent props

nativeDatePicker :: FFINativeComponent_ NativeDatePickerAttributes
nativeDatePicker = createNativeElement_ datePickerImpl

type NativeDatePickerAttributes = BaseAttributes
  ( graphical :: Boolean
  , onChange :: String -> Effect Unit
  )
