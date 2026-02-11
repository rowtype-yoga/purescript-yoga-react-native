module Yoga.React.Native.TouchableWithoutFeedback (touchableWithoutFeedback, touchableWithoutFeedback_, TouchableWithoutFeedbackAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _touchableWithoutFeedbackImpl :: forall props. ReactComponent props

touchableWithoutFeedback :: FFINativeComponent TouchableWithoutFeedbackAttributes
touchableWithoutFeedback = createNativeElement _touchableWithoutFeedbackImpl

touchableWithoutFeedback_ :: FFINativeComponent_ TouchableWithoutFeedbackAttributes
touchableWithoutFeedback_ = createNativeElement_ _touchableWithoutFeedbackImpl

type TouchableWithoutFeedbackAttributes = BaseAttributes
  ( onPress :: EventHandler
  , onPressIn :: EventHandler
  , onPressOut :: EventHandler
  , onLongPress :: EventHandler
  , disabled :: Boolean
  , delayPressIn :: Int
  , delayPressOut :: Int
  , delayLongPress :: Int
  )
