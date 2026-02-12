module Yoga.React.Native.InputAccessoryView (inputAccessoryView, inputAccessoryView_, InputAccessoryViewAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _inputAccessoryViewImpl :: forall props. ReactComponent props

inputAccessoryView :: FFINativeComponent InputAccessoryViewAttributes
inputAccessoryView = createNativeElement _inputAccessoryViewImpl

inputAccessoryView_ :: FFINativeComponent_ InputAccessoryViewAttributes
inputAccessoryView_ = createNativeElement_ _inputAccessoryViewImpl

type InputAccessoryViewAttributes = BaseAttributes
  ( backgroundColor :: String
  )
