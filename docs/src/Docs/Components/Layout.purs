module Docs.Components.Layout where

import Prelude

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

pageShell :: Nut -> Nut -> Nut
pageShell sidebar content =
  D.div [ DA.klass_ "flex flex-col min-h-screen" ]
    [ header
    , D.div [ DA.klass_ "flex flex-1" ]
        [ D.aside [ DA.klass_ "w-64 min-w-[16rem] bg-gray-900 border-r border-gray-800 sticky top-14 h-[calc(100vh-3.5rem)] overflow-y-auto" ]
            [ sidebar ]
        , D.main [ DA.klass_ "flex-1 max-w-4xl p-8 overflow-y-auto" ]
            [ content ]
        ]
    ]

header :: Nut
header =
  D.header [ DA.klass_ "sticky top-0 z-50 bg-gray-900 border-b border-gray-800 px-6 py-3" ]
    [ D.div [ DA.klass_ "flex items-baseline gap-4 max-w-7xl mx-auto" ]
        [ D.h1 [ DA.klass_ "text-lg font-semibold text-gray-100 font-mono" ]
            [ D.text_ "purescript-yoga-react-native" ]
        , D.span [ DA.klass_ "text-sm text-gray-500" ]
            [ D.text_ "PureScript bindings for React Native macOS" ]
        ]
    ]

section :: String -> Array Nut -> Nut
section title children =
  D.section [ DA.klass_ "mb-10" ]
    ( [ D.h2 [ DA.klass_ "text-2xl font-semibold text-gray-100 mb-4 pb-2 border-b border-gray-800" ]
          [ D.text_ title ]
      ] <> children
    )

componentDoc :: String -> String -> String -> Array Nut -> Nut
componentDoc name importPath example children =
  D.div [ DA.klass_ "mb-8 bg-gray-900 border border-gray-800 rounded-lg p-6" ]
    [ D.h3 [ DA.klass_ "text-lg font-semibold text-brand font-mono mb-2" ]
        [ D.text_ name ]
    , D.p [ DA.klass_ "mb-3" ]
        [ D.code [ DA.klass_ "text-xs text-gray-500 font-mono" ]
            [ D.text_ ("import " <> importPath) ]
        ]
    , D.pre [ DA.klass_ "bg-gray-950 border border-gray-800 rounded-md p-4 overflow-x-auto mb-4" ]
        [ D.code [ DA.klass_ "font-mono text-sm text-gray-200 whitespace-pre" ]
            [ D.text_ example ]
        ]
    , D.div_ children
    ]
