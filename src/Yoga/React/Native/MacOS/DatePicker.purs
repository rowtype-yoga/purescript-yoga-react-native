module Yoga.React.Native.MacOS.DatePicker (nativeDatePicker, NativeDatePickerAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import datePickerImpl :: forall props. ReactComponent props

nativeDatePicker :: FFINativeComponent_ NativeDatePickerAttributes
nativeDatePicker = createNativeElement_ datePickerImpl

type NativeDatePickerAttributes = BaseAttributes
  ( graphical :: Boolean
  , onChange :: EventHandler
  )
