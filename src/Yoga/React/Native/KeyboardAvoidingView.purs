module Yoga.React.Native.KeyboardAvoidingView (keyboardAvoidingView, keyboardAvoidingView_, KeyboardAvoidingViewAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)
import Yoga.React.Native.Style (Style)

foreign import _keyboardAvoidingViewImpl :: forall props. ReactComponent props

keyboardAvoidingView :: FFINativeComponent KeyboardAvoidingViewAttributes
keyboardAvoidingView = createNativeElement _keyboardAvoidingViewImpl

keyboardAvoidingView_ :: FFINativeComponent_ KeyboardAvoidingViewAttributes
keyboardAvoidingView_ = createNativeElement_ _keyboardAvoidingViewImpl

type KeyboardAvoidingViewAttributes = BaseAttributes
  ( behavior :: String
  , contentContainerStyle :: Style
  , keyboardVerticalOffset :: Number
  , enabled :: Boolean
  )
