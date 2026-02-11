module Yoga.React.Native.TextInput (textInput, TextInputAttributes) where

import Prelude

import Effect.Uncurried (EffectFn1)
import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _textInputImpl :: forall props. ReactComponent props

textInput :: FFINativeComponent_ TextInputAttributes
textInput = createNativeElement_ _textInputImpl

type TextInputAttributes = BaseAttributes
  ( value :: String
  , onChangeText :: EffectFn1 String Unit
  , placeholder :: String
  , placeholderTextColor :: String
  , editable :: Boolean
  , maxLength :: Int
  , multiline :: Boolean
  , numberOfLines :: Int
  , secureTextEntry :: Boolean
  , keyboardType :: String
  , autoCapitalize :: String
  , autoCorrect :: Boolean
  , autoFocus :: Boolean
  , onSubmitEditing :: EventHandler
  , onFocus :: EventHandler
  , onBlur :: EventHandler
  )
