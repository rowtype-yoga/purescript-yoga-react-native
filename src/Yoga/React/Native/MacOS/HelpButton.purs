module Yoga.React.Native.MacOS.HelpButton
  ( nativeHelpButton
  , NativeHelpButtonAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import helpButtonImpl :: forall props. ReactComponent props

nativeHelpButton :: FFINativeComponent_ NativeHelpButtonAttributes
nativeHelpButton = createNativeElement_ helpButtonImpl

type NativeHelpButtonAttributes = BaseAttributes
  ( onPress :: EventHandler
  )
