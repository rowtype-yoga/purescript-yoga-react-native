module Yoga.React.Native.MacOS.TextField (nativeTextField, NativeTextFieldAttributes) where

import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import textFieldImpl :: forall props. ReactComponent props

nativeTextField :: FFINativeComponent_ NativeTextFieldAttributes
nativeTextField = createNativeElement_ textFieldImpl

type NativeTextFieldAttributes = BaseAttributes
  ( text :: String
  , placeholder :: String
  , secure :: Boolean
  , search :: Boolean
  , rounded :: Boolean
  , onChangeText :: String -> Effect Unit
  , onSubmit :: String -> Effect Unit
  )
