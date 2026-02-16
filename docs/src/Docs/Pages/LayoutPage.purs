module Docs.Pages.LayoutPage where

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "Layout" [ D.p_ [ D.text_ "Container and layout components for structuring macOS interfaces." ] ]
    , box
    , splitView
    , tabView
    , scrollView
    , sidebarLayout
    , toolbar
    , visualEffect
    , patternBackground
    ]

box :: Nut
box = L.componentDoc "nativeBox" "Yoga.React.Native.MacOS.Box (nativeBox)"
  """-- FFINativeComponent: takes props then children
nativeBox
  { boxTitle: "Settings"
  , fillColor2: "#1a1a2e"
  , radius: 8.0
  }
  [ child1, child2 ]"""
  [ propsTable
      [ { name: "boxTitle", type_: "String", description: "Box title" }
      , { name: "fillColor2", type_: "String", description: "Fill color hex" }
      , { name: "borderColor2", type_: "String", description: "Border color hex" }
      , { name: "radius", type_: "Number", description: "Corner radius" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Children are passed as the second argument (IsJSX: JSX, String, or Array JSX)." ]
  ]

splitView :: Nut
splitView = L.componentDoc "nativeSplitView" "Yoga.React.Native.MacOS.SplitView (nativeSplitView)"
  """-- FFINativeComponent: takes props then children
nativeSplitView
  { isVertical: true
  , dividerThicknessValue: 1.0
  }
  [ leftPanel, rightPanel ]"""
  [ propsTable
      [ { name: "isVertical", type_: "Boolean", description: "Vertical or horizontal split" }
      , { name: "dividerThicknessValue", type_: "Number", description: "Divider thickness in points" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Children are the split panes, passed as the second argument." ]
  ]

tabView :: Nut
tabView = L.componentDoc "nativeTabView" "Yoga.React.Native.MacOS.TabView (nativeTabView)"
  """nativeTabView
  { items:
      [ { id: "general", label: "General" }
      , { id: "advanced", label: "Advanced" }
      ]
  , selectedItem: "general"
  , onSelectTab: setTab
  }"""
  [ propsTable
      [ { name: "items", type_: "Array TabItem", description: "Tab items ({ id :: String, label :: String })" }
      , { name: "selectedItem", type_: "String", description: "Selected tab id" }
      , { name: "onSelectTab", type_: "String -> Effect Unit", description: "Tab selection callback" }
      ]
  ]

scrollView :: Nut
scrollView = L.componentDoc "nativeScrollView" "Yoga.React.Native.MacOS.ScrollView (nativeScrollView)"
  """-- FFINativeComponent: takes props then children
nativeScrollView
  { scrollToBottom: 0
  , scrollToY: 0.0
  }
  [ longContent ]"""
  [ propsTable
      [ { name: "scrollToBottom", type_: "Int", description: "Increment to scroll to bottom" }
      , { name: "scrollToY", type_: "Number", description: "Scroll to Y position" }
      , { name: "scrollToYTrigger", type_: "Int", description: "Increment to trigger scrollToY" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Children are the scrollable content, passed as the second argument." ]
  ]

sidebarLayout :: Nut
sidebarLayout = L.componentDoc "sidebarLayout" "Yoga.React.Native.MacOS.Sidebar (sidebarLayout)"
  """-- Record-based function, not a component
sidebarLayout
  { sidebar: navigationList
  , content: detailView
  , sidebarWidth: 250.0
  }"""
  [ propsTable
      [ { name: "sidebar", type_: "JSX", description: "Sidebar panel content" }
      , { name: "content", type_: "JSX", description: "Main panel content" }
      , { name: "sidebarWidth", type_: "Number", description: "Sidebar width in points" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "This is a plain function { sidebar, content, sidebarWidth } -> JSX, not an FFINativeComponent." ]
  ]

toolbar :: Nut
toolbar = L.componentDoc "nativeToolbar" "Yoga.React.Native.MacOS.Toolbar (nativeToolbar)"
  """nativeToolbar
  { items:
      [ { id: "add", label: "Add", sfSymbol: "plus" }
      , { id: "delete", label: "Delete", sfSymbol: "trash" }
      ]
  , selectedItem: "add"
  , toolbarStyle: T.unified
  , windowTitle: "My App"
  , onSelectItem: setItem
  }"""
  [ propsTable
      [ { name: "items", type_: "Array ToolbarItem", description: "Toolbar items ({ id, label, sfSymbol })" }
      , { name: "selectedItem", type_: "String", description: "Selected item id" }
      , { name: "toolbarStyle", type_: "ToolbarStyle", description: "Toolbar visual style" }
      , { name: "windowTitle", type_: "String", description: "Window title" }
      , { name: "onSelectItem", type_: "String -> Effect Unit", description: "Item selection callback" }
      ]
  ]

visualEffect :: Nut
visualEffect = L.componentDoc "nativeVisualEffect" "Yoga.React.Native.MacOS.VisualEffect (nativeVisualEffect)"
  """-- FFINativeComponent: takes props then children
nativeVisualEffect
  { materialName: T.sidebar
  , blendingModeName: T.behindWindow
  , stateName: T.active
  }
  [ content ]"""
  [ propsTable
      [ { name: "materialName", type_: "VisualEffectMaterial", description: "Material type (sidebar, headerView, titlebar, hudWindow, menu, popover, sheet, ...)" }
      , { name: "blendingModeName", type_: "BlendingMode", description: "behindWindow or withinWindow" }
      , { name: "stateName", type_: "VisualEffectState", description: "Visual effect state" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Children receive the vibrancy effect, passed as the second argument." ]
  ]

patternBackground :: Nut
patternBackground = L.componentDoc "nativePatternBackground" "Yoga.React.Native.MacOS.PatternBackground (nativePatternBackground)"
  """-- FFINativeComponent: takes props then children
nativePatternBackground
  { patternColor: "#ffffff"
  , background: "#000000"
  , patternOpacity: 0.1
  , patternScale: 1.0
  }
  [ content ]"""
  [ propsTable
      [ { name: "patternColor", type_: "String", description: "Pattern color hex" }
      , { name: "background", type_: "String", description: "Background color hex" }
      , { name: "patternOpacity", type_: "Number", description: "Pattern opacity (0.0\x20131.0)" }
      , { name: "patternScale", type_: "Number", description: "Pattern scale factor" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Children are rendered over the pattern, passed as the second argument." ]
  ]
