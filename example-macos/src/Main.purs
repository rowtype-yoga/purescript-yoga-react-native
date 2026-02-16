module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable (toNullable)
import Demo.Navigation (demoContent, outlineSidebar)
import Demo.Shared (DemoProps)
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (registerComponent, safeAreaView, tw, view)
import Yoga.React.Native.Appearance (useColorScheme)
import Yoga.React.Native.MacOS.Sidebar (sidebarLayout)
import Yoga.React.Native.MacOS.Toolbar (nativeToolbar)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.MacOS.VisualEffect (nativeVisualEffect)
import Yoga.React.Native.Style as Style

main :: Effect Unit
main = registerComponent "YogaReactExample" \_ -> app {}

app :: {} -> JSX
app = component "App" \_ -> React.do
  selectedItem /\ setSelectedItem <- useState' "button"
  colorScheme <- useColorScheme
  let isDark = toNullable (Just "dark") == colorScheme
  let fg = if isDark then "#FFFFFF" else "#000000"
  let dimFg = if isDark then "#999999" else "#666666"
  let cardBg = if isDark then "#2A2A2A" else "#F0F0F0"
  let bg = if isDark then "#1E1E1E" else "#FFFFFF"
  let dp = { fg, dimFg, cardBg, bg, isDark } :: DemoProps
  pure do
    nativeVisualEffect
      { materialName: T.windowBackground
      , style: tw "flex-1"
      }
      ( safeAreaView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
          ( view { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
              [ nativeToolbar
                  { items: []
                  , selectedItem: ""
                  , toolbarStyle: T.unified
                  , windowTitle: "PureScript React Native"
                  , onSelectItem: \_ -> pure unit
                  , style: Style.style { height: 0.0, width: 0.0 }
                  }
              , sidebarLayout
                  { sidebar: outlineSidebar selectedItem setSelectedItem
                  , sidebarWidth: 200.0
                  , content: demoContent dp selectedItem
                  }
              ]
          )
      )
