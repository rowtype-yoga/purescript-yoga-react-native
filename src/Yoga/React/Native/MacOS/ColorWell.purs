module Yoga.React.Native.MacOS.ColorWell (nativeColorWell, NativeColorWellAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _colorWellImpl :: forall props. ReactComponent props

nativeColorWell :: FFINativeComponent_ NativeColorWellAttributes
nativeColorWell = createNativeElement_ _colorWellImpl

type NativeColorWellAttributes = BaseAttributes
  ( color :: String
  , minimal :: Boolean
  , onChange :: EventHandler
  )
