module Yoga.React.Native.MacOS.WebView (nativeWebView, NativeWebViewAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _webViewImpl :: forall props. ReactComponent props

nativeWebView :: FFINativeComponent_ NativeWebViewAttributes
nativeWebView = createNativeElement_ _webViewImpl

type NativeWebViewAttributes = BaseAttributes
  ( url :: String
  , onNavigate :: EventHandler
  , onFinishLoad :: EventHandler
  )
