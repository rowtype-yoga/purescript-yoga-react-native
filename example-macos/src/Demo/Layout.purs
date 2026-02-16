module Demo.Layout (boxDemo, splitViewDemo, tabViewDemo) where

import Prelude

import Demo.Shared (DemoProps, desc, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.Box (nativeBox)
import Yoga.React.Native.MacOS.SplitView (nativeSplitView)
import Yoga.React.Native.MacOS.TabView (nativeTabView)
import Yoga.React.Native.Style as Style

boxDemo :: DemoProps -> JSX
boxDemo = component "BoxDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Box"
    , desc dp "Native NSBox with title and border"
    , nativeBox
        { boxTitle: "Settings"
        , fillColor2: dp.cardBg
        , borderColor2: dp.dimFg
        , radius: 8.0
        , style: Style.style { height: 100.0 } <> tw "mb-2"
        }
        [ view { style: tw "flex-row items-center p-2" }
            [ text { style: tw "text-sm" <> Style.style { color: dp.fg } } "Content inside a native box" ]
        ]
    ]

splitViewDemo :: DemoProps -> JSX
splitViewDemo = component "SplitViewDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Split View"
    , desc dp "Native NSSplitView with resizable divider"
    , nativeSplitView
        { isVertical: true
        , style: Style.style { height: 150.0 } <> tw "rounded-lg overflow-hidden mb-2"
        }
        [ view { style: tw "flex-1 p-4" <> Style.style { backgroundColor: dp.cardBg } }
            [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } } "Left Pane"
            , text { style: tw "text-xs mt-1" <> Style.style { color: dp.dimFg } } "Drag the divider to resize"
            ]
        , view { style: tw "flex-1 p-4" <> Style.style { backgroundColor: dp.cardBg } }
            [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } } "Right Pane"
            , text { style: tw "text-xs mt-1" <> Style.style { color: dp.dimFg } } "Content fills available space"
            ]
        ]
    ]

tabViewDemo :: DemoProps -> JSX
tabViewDemo = component "TabViewDemo" \dp -> React.do
  selected /\ setSelected <- useState' "general"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Tab View"
      , desc dp "Native segmented tab bar"
      , nativeTabView
          { items:
              [ { id: "general", label: "General" }
              , { id: "advanced", label: "Advanced" }
              , { id: "about", label: "About" }
              ]
          , selectedItem: selected
          , onSelectTab: setSelected
          , style: Style.style { height: 32.0 } <> tw "mb-2"
          }
      ]
