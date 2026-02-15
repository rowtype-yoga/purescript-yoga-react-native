module Yoga.React.Native.MacOS.Sidebar (sidebarLayout) where

import Prelude
import React.Basic (JSX)
import Yoga.React.Native (tw, view)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.MacOS.VisualEffect (nativeVisualEffect)
import Yoga.React.Native.Style as Style

sidebarLayout :: { sidebar :: JSX, content :: JSX, sidebarWidth :: Number } -> JSX
sidebarLayout { sidebar, content, sidebarWidth } = do
  view { style: tw "flex-1 flex-row" <> Style.style { backgroundColor: "transparent" } }
    [ nativeVisualEffect
        { materialName: T.sidebar
        , blendingModeName: T.behindWindow
        , style: Style.style { width: sidebarWidth } <> tw "h-full"
        }
        sidebar
    , view { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
        [ content ]
    ]
