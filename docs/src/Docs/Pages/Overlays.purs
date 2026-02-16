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
  """visible /\ setVisible <- useState' false

nativeButton
  { title: "Show Sheet"
  , bezelStyle: T.push
  , onPress: setVisible true
  }
nativeSheet
  { visible
  , onDismiss: setVisible false
  }
  [ nativeButton
      { title: "Dismiss"
      , onPress: setVisible false
      }
  ]"""
  [ propsTable
      [ { name: "visible", type_: "Boolean", description: "Show/hide the sheet" }
      , { name: "onDismiss", type_: "Effect Unit", description: "Dismiss callback" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Sheet content is passed as the second argument (IsJSX)." ]
  ]

popover :: Nut
popover = L.componentDoc "nativePopover" "Yoga.React.Native.MacOS.Popover (nativePopover)"
  """visible /\ setVisible <- useState' false

nativePopover
  { visible
  , preferredEdge: T.bottom
  , behavior: T.transient
  , onClose: setVisible false
  }
  [ nativeButton
      { title: if visible then "Hide" else "Show Popover"
      , onPress: setVisible (not visible)
      }
  ]"""
  [ propsTable
      [ { name: "visible", type_: "Boolean", description: "Show/hide" }
      , { name: "preferredEdge", type_: "PopoverEdge", description: "Preferred edge for popover placement" }
      , { name: "behavior", type_: "PopoverBehavior", description: "Popover behavior" }
      , { name: "onClose", type_: "Effect Unit", description: "Close callback" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Popover content is passed as the second argument (IsJSX)." ]
  ]

contextMenu :: Nut
contextMenu = L.componentDoc "nativeContextMenu" "Yoga.React.Native.MacOS.ContextMenu (nativeContextMenu)"
  """result /\ setResult <- useState' ""

nativeContextMenu
  { items:
      [ { id: "cut", title: "Cut", sfSymbol: "scissors" }
      , { id: "copy", title: "Copy", sfSymbol: "doc.on.doc" }
      , { id: "paste", title: "Paste", sfSymbol: "doc.on.clipboard" }
      , { id: "sep", title: "-", sfSymbol: "" }
      , { id: "delete", title: "Delete", sfSymbol: "trash" }
      ]
  , onSelectItem: setResult
  }
  [ text_ "Right-click me!" ]"""
  [ propsTable
      [ { name: "items", type_: "Array ContextMenuItem", description: "Menu items ({ id, title, sfSymbol })" }
      , { name: "onSelectItem", type_: "String -> Effect Unit", description: "Item selection callback" }
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
