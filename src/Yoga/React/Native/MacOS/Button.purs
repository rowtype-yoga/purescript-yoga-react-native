module Yoga.React.Native.MacOS.Button (nativeButton, NativeButtonAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (BezelStyle)

foreign import buttonImpl :: forall props. ReactComponent props

nativeButton :: FFINativeComponent_ NativeButtonAttributes
nativeButton = createNativeElement_ buttonImpl

type NativeButtonAttributes = BaseAttributes
  ( title :: String
  , bezelStyle :: BezelStyle
  , destructive :: Boolean
  , primary :: Boolean
  , buttonEnabled :: Boolean
  , onPress :: EventHandler
  )
