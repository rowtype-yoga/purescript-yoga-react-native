module Yoga.React.Native.MacOS.Image
  ( nativeImage
  , NativeImageAttributes
  ) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _imageImpl :: forall props. ReactComponent props

nativeImage :: FFINativeComponent_ NativeImageAttributes
nativeImage = createNativeElement_ _imageImpl

type NativeImageAttributes = BaseAttributes
  ( source :: String
  , contentMode :: String
  , cornerRadius :: Number
  )
