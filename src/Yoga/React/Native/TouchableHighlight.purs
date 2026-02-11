module Yoga.React.Native.TouchableHighlight (touchableHighlight, touchableHighlight_, TouchableHighlightAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _touchableHighlightImpl :: forall props. ReactComponent props

touchableHighlight :: FFINativeComponent TouchableHighlightAttributes
touchableHighlight = createNativeElement _touchableHighlightImpl

touchableHighlight_ :: FFINativeComponent_ TouchableHighlightAttributes
touchableHighlight_ = createNativeElement_ _touchableHighlightImpl

type TouchableHighlightAttributes = BaseAttributes
  ( onPress :: EventHandler
  , onPressIn :: EventHandler
  , onPressOut :: EventHandler
  , onLongPress :: EventHandler
  , activeOpacity :: Number
  , underlayColor :: String
  , disabled :: Boolean
  , onShowUnderlay :: EventHandler
  , onHideUnderlay :: EventHandler
  )
