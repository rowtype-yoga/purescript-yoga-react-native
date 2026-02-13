module Yoga.React.Native.MacOS.Button (nativeButton, NativeButtonAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _buttonImpl :: forall props. ReactComponent props

nativeButton :: FFINativeComponent_ NativeButtonAttributes
nativeButton = createNativeElement_ _buttonImpl

type NativeButtonAttributes = BaseAttributes
  ( title :: String
  , sfSymbol :: String
  , bezelStyle :: String
  , destructive :: Boolean
  , primary :: Boolean
  , buttonEnabled :: Boolean
  , onPress :: EventHandler
  )
