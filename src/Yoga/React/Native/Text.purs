module Yoga.React.Native.Text (text, text_, TextAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _textImpl :: forall props. ReactComponent props

text :: FFINativeComponent TextAttributes
text = createNativeElement _textImpl

text_ :: FFINativeComponent_ TextAttributes
text_ = createNativeElement_ _textImpl

type TextAttributes = BaseAttributes
  ( numberOfLines :: Int
  , onPress :: EventHandler
  , onLongPress :: EventHandler
  , selectable :: Boolean
  , ellipsizeMode :: String
  , adjustsFontSizeToFit :: Boolean
  , allowFontScaling :: Boolean
  )
