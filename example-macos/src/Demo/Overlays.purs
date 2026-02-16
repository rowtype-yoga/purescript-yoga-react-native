module Demo.Overlays
  ( alertDemo
  , sheetDemo
  , popoverDemo
  , contextMenuDemo
  , menuDemo
  ) where

import Prelude

import Demo.Shared (DemoProps, card, desc, label, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.Alert (macosAlert)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.ContextMenu (nativeContextMenu)
import Yoga.React.Native.MacOS.Events as E
import Yoga.React.Native.MacOS.Menu (macosShowMenu)
import Yoga.React.Native.MacOS.Popover (nativePopover)
import Yoga.React.Native.MacOS.Sheet (nativeSheet)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Style as Style

alertDemo :: DemoProps -> JSX
alertDemo = component "AlertDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Alert"
    , desc dp "Native alert dialog"
    , nativeButton
        { title: "Show Alert"
        , bezelStyle: T.push
        , onPress: handler_ (macosAlert T.warning "Are you sure?" "This action cannot be undone." [ "Cancel", "OK" ])
        , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-4"
        }
    ]

sheetDemo :: DemoProps -> JSX
sheetDemo = component "SheetDemo" \dp -> React.do
  visible /\ setVisible <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Sheet"
      , desc dp "Modal sheet attached to the window"
      , nativeButton
          { title: "Show Sheet"
          , bezelStyle: T.push
          , onPress: handler_ (setVisible true)
          , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-2"
          }
      , nativeSheet
          { visible
          , onDismiss: handler_ (setVisible false)
          }
          [ view { style: tw "p-6" <> Style.style { width: 400.0, height: 200.0 } }
              [ text { style: tw "text-lg font-semibold mb-2" <> Style.style { color: dp.fg } } "Sheet Content"
              , text { style: tw "text-sm mb-4" <> Style.style { color: dp.dimFg } } "This is a native macOS sheet."
              , nativeButton
                  { title: "Dismiss"
                  , bezelStyle: T.push
                  , onPress: handler_ (setVisible false)
                  , style: Style.style { height: 24.0, width: 100.0 }
                  }
              ]
          ]
      ]

popoverDemo :: DemoProps -> JSX
popoverDemo = component "PopoverDemo" \dp -> React.do
  visible /\ setVisible <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Popover"
      , desc dp "Click button to toggle a popover"
      , nativePopover
          { visible
          , preferredEdge: T.bottom
          , behavior: T.transient
          , onClose: handler_ (setVisible false)
          , style: tw "mb-2"
          }
          [ nativeButton
              { title: if visible then "Hide Popover" else "Show Popover"
              , bezelStyle: T.push
              , onPress: handler_ (setVisible (not visible))
              , style: Style.style { height: 24.0, width: 140.0 }
              }
          , view { style: tw "p-4" <> Style.style { width: 200.0, height: 80.0 } }
              [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } } "Popover Content"
              , text { style: tw "text-xs mt-1" <> Style.style { color: dp.dimFg } } "Click outside to dismiss"
              ]
          ]
      ]

contextMenuDemo :: DemoProps -> JSX
contextMenuDemo = component "ContextMenuDemo" \dp -> React.do
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Context Menu"
      , desc dp "Right-click the area below to open a context menu"
      , nativeContextMenu
          { items:
              [ { id: "cut", title: "Cut", sfSymbol: "scissors" }
              , { id: "copy", title: "Copy", sfSymbol: "doc.on.doc" }
              , { id: "paste", title: "Paste", sfSymbol: "doc.on.clipboard" }
              , { id: "sep", title: "-", sfSymbol: "" }
              , { id: "delete", title: "Delete", sfSymbol: "trash" }
              , { id: "selectAll", title: "Select All", sfSymbol: "selection.pin.in.out" }
              ]
          , onSelectItem: E.onString "itemId" setResult
          , style: Style.style {}
          }
          ( card dp.cardBg
              [ view { style: tw "items-center justify-center" <> Style.style { minHeight: 80.0 } }
                  [ text { style: tw "text-sm" <> Style.style { color: dp.fg } } "Right-click me!"
                  , if result == "" then mempty
                    else label dp.dimFg ("Selected: " <> result)
                  ]
              ]
          )
      ]

menuDemo :: DemoProps -> JSX
menuDemo = component "MenuDemo" \dp -> React.do
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Menu"
      , desc dp "Imperative popup menu at mouse position"
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeButton
              { title: "Show Menu"
              , bezelStyle: T.push
              , onPress: handler_
                  ( macosShowMenu
                      [ { title: "New File", id: "new" }
                      , { title: "Open...", id: "open" }
                      , { title: "-", id: "sep" }
                      , { title: "Save", id: "save" }
                      , { title: "Save As...", id: "saveAs" }
                      ]
                      \itemId -> setResult ("Menu: " <> itemId)
                  )
              , style: Style.style { height: 24.0, width: 120.0 }
              }
          , if result == "" then mempty
            else text { style: tw "text-xs ml-3" <> Style.style { color: dp.dimFg } } result
          ]
      ]
