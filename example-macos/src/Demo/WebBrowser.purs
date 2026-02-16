module Demo.WebBrowser (webViewDemo) where

import Prelude

import Demo.Shared (DemoProps, sectionTitle)
import React.Basic (JSX)
import React.Basic.Events (handler, unsafeEventFn)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (nativeEvent, tw, view)
import Yoga.React.Native.MacOS.Events as E
import Yoga.React.Native.MacOS.TextField (nativeTextField)
import Yoga.React.Native.MacOS.WebView (nativeWebView)
import Yoga.React.Native.Style as Style

webViewDemo :: DemoProps -> JSX
webViewDemo = component "WebViewDemo" \dp -> React.do
  url /\ setUrl <- useState' "https://pursuit.purescript.org"
  urlBar /\ setUrlBar <- useState' "https://pursuit.purescript.org"
  pure do
    view { style: tw "flex-1 px-4" }
      [ sectionTitle dp.fg "Web Browser"
      , nativeTextField
          { text: urlBar
          , placeholder: "Enter URL..."
          , search: false
          , onChangeText: E.onString "text" setUrlBar
          , onSubmit: E.onString "text" setUrl
          , style: Style.style { height: 24.0, marginBottom: 8.0 }
          }
      , nativeWebView
          { url
          , onFinishLoad: handler
              ( nativeEvent >>> unsafeEventFn \e ->
                  { url: E.getFieldStr "url" e, title: E.getFieldStr "title" e }
              )
              \r -> setUrlBar r.url
          , style: tw "flex-1" <> Style.style { minHeight: 400.0 }
          }
      ]
