module Yoga.React.Native.Button (button, ButtonAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _buttonImpl :: forall props. ReactComponent props

button :: FFINativeComponent_ ButtonAttributes
button = createNativeElement_ _buttonImpl

type ButtonAttributes =
  ( title :: String
  , onPress :: EventHandler
  , color :: String
  , disabled :: Boolean
  , testID :: String
  , accessibilityLabel :: String
  )
