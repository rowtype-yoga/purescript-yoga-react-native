module Yoga.React.Native.MacOS.ColorWell (nativeColorWell, NativeColorWellAttributes) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import colorWellImpl :: forall props. ReactComponent props

nativeColorWell :: FFINativeComponent_ NativeColorWellAttributes
nativeColorWell = createNativeElement_ colorWellImpl

type NativeColorWellAttributes = BaseAttributes
  ( color :: String
  , minimal :: Boolean
  , onChange :: String -> Effect Unit
  )
