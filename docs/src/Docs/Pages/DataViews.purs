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
  """nativeTableView
  { columns:
      [ { id: "name", title: "Name", width: 200.0 }
      , { id: "size", title: "Size", width: 100.0 }
      ]
  , rows: [ ["file.txt", "4 KB"], ["image.png", "1.2 MB"] ]
  , headerVisible: true
  , alternatingRows: true
  , onSelectRow: setSelected
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
  """nativeOutlineView
  { items:
      [ OutlineItem
          { id: "docs"
          , title: "Documents"
          , sfSymbol: "folder"
          , children:
              [ OutlineItem { id: "report", title: "report.pdf", sfSymbol: "doc", children: [] }
              , OutlineItem { id: "notes", title: "notes.txt", sfSymbol: "doc.text", children: [] }
              ]
          }
      ]
  , headerVisible: true
  , onSelectItem: setSelected
  }"""
  [ propsTable
      [ { name: "items", type_: "Array OutlineItem", description: "Hierarchical tree data (newtype with { id, title, sfSymbol, children })" }
      , { name: "headerVisible", type_: "Boolean", description: "Show header" }
      , { name: "onSelectItem", type_: "String -> Effect Unit", description: "Item selection callback" }
      ]
  ]
