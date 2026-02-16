module Yoga.React.Native.MacOS.PathControl
  ( nativePathControl
  , NativePathControlAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (PathControlStyle)

foreign import pathControlImpl :: forall props. ReactComponent props

nativePathControl :: FFINativeComponent_ NativePathControlAttributes
nativePathControl = createNativeElement_ pathControlImpl

type NativePathControlAttributes = BaseAttributes
  ( url :: String
  , pathStyle :: PathControlStyle
  , onSelectPath :: String -> Effect Unit
  )
