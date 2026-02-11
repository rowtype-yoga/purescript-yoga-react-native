module Yoga.React.Native.ImageBackground (imageBackground, imageBackground_, ImageBackgroundAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Image (ImageSource)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)
import Yoga.React.Native.Style (Style)

foreign import _imageBackgroundImpl :: forall props. ReactComponent props

imageBackground :: FFINativeComponent ImageBackgroundAttributes
imageBackground = createNativeElement _imageBackgroundImpl

imageBackground_ :: FFINativeComponent_ ImageBackgroundAttributes
imageBackground_ = createNativeElement_ _imageBackgroundImpl

type ImageBackgroundAttributes = BaseAttributes
  ( source :: ImageSource
  , resizeMode :: String
  , imageStyle :: Style
  , onLoad :: EventHandler
  , onLoadStart :: EventHandler
  , onLoadEnd :: EventHandler
  , onError :: EventHandler
  )
