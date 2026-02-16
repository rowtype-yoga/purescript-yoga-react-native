module Docs.Pages.Overlays where

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "Overlays" [ D.p_ [ D.text_ "Modal overlays, sheets, popovers, and context menus." ] ]
    , alert
    , sheet
    , popover
    , contextMenu
    , menu
    ]

alert :: Nut
alert = L.componentDoc "macosAlert" "Yoga.React.Native.MacOS.Alert (macosAlert)"
  """macosAlert
  { style: T.critical
  , title: "Delete file?"
  , message: "This cannot be undone."
  , buttons: ["Delete", "Cancel"]
  }"""
  [ propsTable
      [ { name: "style", type_: "AlertStyle", description: "informational | warning | critical" }
      , { name: "title", type_: "String", description: "Alert title" }
      , { name: "message", type_: "String", description: "Alert message body" }
      , { name: "buttons", type_: "Array String", description: "Button labels (default: [\"OK\"])" }
      ]
  ]

sheet :: Nut
sheet = L.componentDoc "nativeSheet" "Yoga.React.Native.MacOS.Sheet (nativeSheet)"
  """-- FFINativeComponent: takes props then children
nativeSheet
  { visible: true
  , onDismiss: handler_ hideSheet
  }
  [ sheetContent ]"""
  [ propsTable
      [ { name: "visible", type_: "Boolean", description: "Show/hide the sheet" }
      , { name: "onDismiss", type_: "EventHandler", description: "Dismiss callback" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Sheet content is passed as the second argument (IsJSX)." ]
  ]

popover :: Nut
popover = L.componentDoc "nativePopover" "Yoga.React.Native.MacOS.Popover (nativePopover)"
  """-- FFINativeComponent: takes props then children
nativePopover
  { visible: true
  , preferredEdge: T.maxY
  , behavior: T.transient
  , onClose: handler_ hidePopover
  }
  [ popoverContent ]"""
  [ propsTable
      [ { name: "visible", type_: "Boolean", description: "Show/hide" }
      , { name: "preferredEdge", type_: "PopoverEdge", description: "Preferred edge for popover placement" }
      , { name: "behavior", type_: "PopoverBehavior", description: "Popover behavior" }
      , { name: "onClose", type_: "EventHandler", description: "Close callback" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Popover content is passed as the second argument (IsJSX)." ]
  ]

contextMenu :: Nut
contextMenu = L.componentDoc "nativeContextMenu" "Yoga.React.Native.MacOS.ContextMenu (nativeContextMenu)"
  """-- FFINativeComponent: takes props then children
nativeContextMenu
  { items:
      [ { id: "copy", title: "Copy", sfSymbol: "doc.on.doc" }
      , { id: "paste", title: "Paste", sfSymbol: "doc.on.clipboard" }
      ]
  , onSelectItem: handler (syntheticEvent >>> \e -> ...)
  }
  [ rightClickTarget ]"""
  [ propsTable
      [ { name: "items", type_: "Array ContextMenuItem", description: "Menu items ({ id, title, sfSymbol })" }
      , { name: "onSelectItem", type_: "EventHandler", description: "Item selection callback" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "The right-click target element is passed as the second argument (IsJSX)." ]
  ]

menu :: Nut
menu = L.componentDoc "macosShowMenu" "Yoga.React.Native.MacOS.Menu (macosShowMenu)"
  """macosShowMenu
  { items:
      [ { title: "New", id: "new" }
      , { title: "Open", id: "open" }
      ]
  , onSelectItem: \selectedId -> log selectedId
  }"""
  [ propsTable
      [ { name: "items", type_: "Array MenuItem", description: "Menu items ({ title, id })" }
      , { name: "onSelectItem", type_: "String -> Effect Unit", description: "Callback receiving the selected item id" }
      ]
  ]
