module Yoga.React.Native.TouchableOpacity (touchableOpacity, touchableOpacity_, TouchableOpacityAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _touchableOpacityImpl :: forall props. ReactComponent props

touchableOpacity :: FFINativeComponent TouchableOpacityAttributes
touchableOpacity = createNativeElement _touchableOpacityImpl

touchableOpacity_ :: FFINativeComponent_ TouchableOpacityAttributes
touchableOpacity_ = createNativeElement_ _touchableOpacityImpl

type TouchableOpacityAttributes = BaseAttributes
  ( onPress :: EventHandler
  , onPressIn :: EventHandler
  , onPressOut :: EventHandler
  , onLongPress :: EventHandler
  , activeOpacity :: Number
  , disabled :: Boolean
  , delayPressIn :: Int
  , delayPressOut :: Int
  , delayLongPress :: Int
  )
