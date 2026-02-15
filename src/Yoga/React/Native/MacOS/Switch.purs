module Yoga.React.Native.MacOS.Switch (nativeSwitch, NativeSwitchAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import switchImpl :: forall props. ReactComponent props

nativeSwitch :: FFINativeComponent_ NativeSwitchAttributes
nativeSwitch = createNativeElement_ switchImpl

type NativeSwitchAttributes = BaseAttributes
  ( on :: Boolean
  , onChange :: EventHandler
  )
