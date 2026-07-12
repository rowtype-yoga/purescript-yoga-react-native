module Yoga.React.Native.IOS.DatePicker
  ( datePicker
  , DatePickerAttributes
  , DatePickerMode
  , date
  , time
  , dateTime
  ) where

import Prelude

import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import data DatePickerMode :: Type

foreign import date :: DatePickerMode
foreign import time :: DatePickerMode
foreign import dateTime :: DatePickerMode

type DatePickerAttributes = BaseAttributes
  ( value :: String
  , mode :: DatePickerMode
  , min :: String
  , max :: String
  , enabled :: Boolean
  , onChange :: String -> Effect Unit
  )

foreign import datePickerImpl :: forall props. ReactComponent props

datePicker :: FFINativeComponent_ DatePickerAttributes
datePicker = createNativeElement_ datePickerImpl
