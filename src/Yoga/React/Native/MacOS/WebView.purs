module Yoga.React.Native.MacOS.WebView (nativeWebView, NativeWebViewAttributes) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import webViewImpl :: forall props. ReactComponent props

nativeWebView :: FFINativeComponent_ NativeWebViewAttributes
nativeWebView = createNativeElement_ webViewImpl

type NativeWebViewAttributes = BaseAttributes
  ( url :: String
  , onNavigate :: String -> Effect Unit
  , onFinishLoad :: String -> Effect Unit
  )
