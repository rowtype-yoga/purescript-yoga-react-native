module Yoga.React.Native.MacOS.TextField (nativeTextField, NativeTextFieldAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _textFieldImpl :: forall props. ReactComponent props

nativeTextField :: FFINativeComponent_ NativeTextFieldAttributes
nativeTextField = createNativeElement_ _textFieldImpl

type NativeTextFieldAttributes = BaseAttributes
  ( text :: String
  , placeholder :: String
  , secure :: Boolean
  , search :: Boolean
  , rounded :: Boolean
  , onChangeText :: EventHandler
  , onSubmit :: EventHandler
  )
