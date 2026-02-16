module Yoga.React.Native.MacOS.RadioButton
  ( nativeRadioButton
  , NativeRadioButtonAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import radioButtonImpl :: forall props. ReactComponent props

nativeRadioButton :: FFINativeComponent_ NativeRadioButtonAttributes
nativeRadioButton = createNativeElement_ radioButtonImpl

type NativeRadioButtonAttributes = BaseAttributes
  ( selected :: Boolean
  , title :: String
  , enabled :: Boolean
  , onChange :: Boolean -> Effect Unit
  )
