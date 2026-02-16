module Docs.Pages.DataViews where

import Deku.Core (Nut)
import Deku.DOM as D
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "Data Views" [ D.p_ [ D.text_ "Structured data display with tables and outlines." ] ]
    , tableView
    , outlineView
    ]

tableView :: Nut
tableView = L.componentDoc "nativeTableView" "Yoga.React.Native.MacOS.TableView (nativeTableView)"
  """selected /\ setSelected <- useState' ""

nativeTableView
  { columns:
      [ { id: "name", title: "Name", width: 150.0 }
      , { id: "type", title: "Type", width: 100.0 }
      , { id: "size", title: "Size", width: 80.0 }
      ]
  , rows:
      [ [ "Main.purs", "PureScript", "12 KB" ]
      , [ "App.tsx", "TypeScript", "8 KB" ]
      , [ "style.css", "CSS", "3 KB" ]
      , [ "index.html", "HTML", "1 KB" ]
      ]
  , headerVisible: true
  , alternatingRows: true
  , onSelectRow: \i -> setSelected ("Row " <> show i)
  , onDoubleClickRow: \i -> setSelected ("Double-clicked row " <> show i)
  }"""
  [ propsTable
      [ { name: "columns", type_: "Array TableColumn", description: "Column definitions ({ id, title, width })" }
      , { name: "rows", type_: "Array (Array String)", description: "Row data as arrays of strings" }
      , { name: "headerVisible", type_: "Boolean", description: "Show column headers" }
      , { name: "alternatingRows", type_: "Boolean", description: "Alternating row backgrounds" }
      , { name: "onSelectRow", type_: "Int -> Effect Unit", description: "Row selection callback" }
      , { name: "onDoubleClickRow", type_: "Int -> Effect Unit", description: "Row double-click callback" }
      ]
  ]

outlineView :: Nut
outlineView = L.componentDoc "nativeOutlineView" "Yoga.React.Native.MacOS.OutlineView (nativeOutlineView)"
  """selection /\ setSelection <- useState' ""
let file id title = OutlineItem { id, title, sfSymbol: "doc", children: [] }
let folder id title children = OutlineItem { id, title, sfSymbol: "folder", children }

nativeOutlineView
  { items:
      [ folder "src" "src"
          [ file "main" "Main.purs"
          , folder "macos" "MacOS"
              [ file "btn" "Button.purs"
              , file "sl" "Slider.purs"
              ]
          ]
      , folder "test" "test"
          [ file "t1" "MacOSComponents.test.js" ]
      ]
  , headerVisible: false
  , onSelectItem: setSelection
  }"""
  [ propsTable
      [ { name: "items", type_: "Array OutlineItem", description: "Hierarchical tree data (newtype with { id, title, sfSymbol, children })" }
      , { name: "headerVisible", type_: "Boolean", description: "Show header" }
      , { name: "onSelectItem", type_: "String -> Effect Unit", description: "Item selection callback" }
      ]
  ]
