module Yoga.React.Native.Image (image, ImageAttributes, ImageSource, uri) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import data ImageSource :: Type

foreign import uri :: String -> ImageSource

foreign import _imageImpl :: forall props. ReactComponent props

image :: FFINativeComponent_ ImageAttributes
image = createNativeElement_ _imageImpl

type ImageAttributes = BaseAttributes
  ( source :: ImageSource
  , resizeMode :: String
  , onLoad :: EventHandler
  , onLoadStart :: EventHandler
  , onLoadEnd :: EventHandler
  , onError :: EventHandler
  )
