module Docs.Pages.Overview where

import Prelude

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

page :: Nut
page =
  D.div_
    [ hero
    , featureGrid
    ]

hero :: Nut
hero =
  D.div [ DA.klass_ "mb-12" ]
    [ D.h1 [ DA.klass_ "text-4xl font-bold text-gray-100 font-mono mb-3" ]
        [ D.text_ "purescript-yoga-react-native" ]
    , D.p [ DA.klass_ "text-lg text-gray-400 max-w-xl mb-5" ]
        [ D.text_ "55+ native AppKit components for React Native macOS, wrapped in PureScript's type system." ]
    , D.div [ DA.klass_ "flex gap-3 flex-wrap" ]
        [ badge "PureScript" "0.15+"
        , badge "macOS" "14+"
        , badge "React Native" "0.81"
        ]
    ]
  where
  badge label value =
    D.span [ DA.klass_ "bg-gray-800 border border-gray-700 rounded-md px-3 py-1 text-sm text-gray-400" ]
      [ D.strong [ DA.klass_ "text-brand" ] [ D.text_ label ]
      , D.text_ (" " <> value)
      ]

featureGrid :: Nut
featureGrid =
  D.div [ DA.klass_ "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4" ]
    [ feature "Input Controls" "13" "Buttons, sliders, steppers, checkboxes, radio buttons, segmented controls, combo boxes, and more."
    , feature "Text" "2" "Native text fields and rich text editors with full AppKit integration."
    , feature "Display" "7" "Images, animated GIFs, video players, level indicators, progress bars, separators, and path controls."
    , feature "Layout" "8" "Split views, tab views, scroll views, sidebars, toolbars, visual effects, and pattern backgrounds."
    , feature "Overlays" "5" "Alerts, sheets, popovers, context menus, and programmatic menus."
    , feature "Data Views" "2" "Table views and outline views for structured data."
    , feature "Files & Drag/Drop" "2" "Native file pickers and drop zones."
    , feature "Rich Media" "5" "Maps, PDFs, web views, camera, and Rive animations."
    , feature "System Services" "10" "Clipboard, sharing, notifications, sounds, speech synthesis, status bar, Quick Look, color and font panels."
    , feature "AI & ML" "5" "OCR, speech recognition, language detection, sentiment analysis, and tokenization."
    ]
  where
  feature title count description =
    D.div [ DA.klass_ "bg-gray-900 border border-gray-800 rounded-lg p-5" ]
      [ D.div [ DA.klass_ "flex justify-between items-baseline mb-2" ]
          [ D.h3 [ DA.klass_ "text-sm font-semibold text-gray-100" ] [ D.text_ title ]
          , D.span [ DA.klass_ "bg-brand-dim text-white text-xs font-semibold px-2 py-0.5 rounded-full" ] [ D.text_ count ]
          ]
      , D.p [ DA.klass_ "text-xs text-gray-500 leading-relaxed" ] [ D.text_ description ]
      ]
