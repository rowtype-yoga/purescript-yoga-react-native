module Yoga.React.Native.MacOS.Image
  ( nativeImage
  , NativeImageAttributes
  ) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (ImageContentMode)

foreign import imageImpl :: forall props. ReactComponent props

nativeImage :: FFINativeComponent_ NativeImageAttributes
nativeImage = createNativeElement_ imageImpl

type NativeImageAttributes = BaseAttributes
  ( source :: String
  , contentMode :: ImageContentMode
  , cornerRadius :: Number
  )
