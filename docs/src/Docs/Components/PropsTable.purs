module Docs.Components.PropsTable where

import Prelude

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

type Prop =
  { name :: String
  , type_ :: String
  , description :: String
  }

propsTable :: Array Prop -> Nut
propsTable props =
  D.table [ DA.klass_ "w-full text-sm border-collapse" ]
    [ D.thead_
        [ D.tr_
            [ D.th [ DA.klass_ "text-left px-3 py-2 border-b-2 border-gray-800 text-gray-500 font-semibold text-xs uppercase tracking-wide" ] [ D.text_ "Prop" ]
            , D.th [ DA.klass_ "text-left px-3 py-2 border-b-2 border-gray-800 text-gray-500 font-semibold text-xs uppercase tracking-wide" ] [ D.text_ "Type" ]
            , D.th [ DA.klass_ "text-left px-3 py-2 border-b-2 border-gray-800 text-gray-500 font-semibold text-xs uppercase tracking-wide" ] [ D.text_ "Description" ]
            ]
        ]
    , D.tbody_ (map propRow props)
    ]
  where
  propRow p =
    D.tr_
      [ D.td [ DA.klass_ "px-3 py-2 border-b border-gray-800 align-top" ] [ D.code [ DA.klass_ "font-mono text-xs text-brand" ] [ D.text_ p.name ] ]
      , D.td [ DA.klass_ "px-3 py-2 border-b border-gray-800 align-top" ] [ D.code [ DA.klass_ "font-mono text-xs text-gray-400" ] [ D.text_ p.type_ ] ]
      , D.td [ DA.klass_ "px-3 py-2 border-b border-gray-800 align-top text-gray-400" ] [ D.text_ p.description ]
      ]
