module Demo.DataViews (tableViewDemo, outlineViewDemo) where

import Prelude

import Demo.Shared (DemoProps, desc, label, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (tw)
import Yoga.React.Native.MacOS.Events as E
import Yoga.React.Native.MacOS.OutlineView (OutlineItem(..), nativeOutlineView)
import Yoga.React.Native.MacOS.TableView (nativeTableView)
import Yoga.React.Native.Style as Style

tableViewDemo :: DemoProps -> JSX
tableViewDemo = component "TableViewDemo" \dp -> React.do
  selected /\ setSelected <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Table View"
      , desc dp "Native NSTableView with columns and rows"
      , nativeTableView
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
              , [ "package.json", "JSON", "2 KB" ]
              ]
          , headerVisible: true
          , alternatingRows: true
          , onSelectRow: E.onInt "rowIndex" \i -> setSelected ("Row " <> show i)
          , onDoubleClickRow: E.onInt "rowIndex" \i -> setSelected ("Double-clicked row " <> show i)
          , style: Style.style { height: 180.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
      , if selected == "" then mempty
        else label dp.dimFg selected
      ]

outlineViewDemo :: DemoProps -> JSX
outlineViewDemo = component "OutlineViewDemo" \dp -> React.do
  selection /\ setSelection <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Outline View"
      , desc dp "Hierarchical tree list (NSOutlineView)"
      , nativeOutlineView
          { items: do
              let file id title = OutlineItem { id, title, sfSymbol: "doc", children: [] }
              let folder id title children = OutlineItem { id, title, sfSymbol: "folder", children }
              [ folder "src" "src"
                  [ file "main" "Main.purs"
                  , folder "macos" "MacOS"
                      [ file "btn" "Button.purs"
                      , file "sl" "Slider.purs"
                      , file "sw" "Switch.purs"
                      ]
                  ]
              , folder "test" "test"
                  [ file "t1" "MacOSComponents.test.js"
                  , file "t2" "MacOSSnapshots.test.js"
                  ]
              , OutlineItem { id: "pkg", title: "package.json", sfSymbol: "doc.text", children: [] }
              ]
          , headerVisible: false
          , onSelectItem: setSelection
          , style: Style.style { height: 200.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
      , if selection == "" then mempty
        else label dp.dimFg ("Selected: " <> selection)
      ]
