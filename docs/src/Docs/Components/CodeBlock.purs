module Docs.Components.CodeBlock where

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

codeBlock :: String -> Nut
codeBlock code =
  D.pre [ DA.klass_ "bg-gray-950 border border-gray-800 rounded-md p-4 overflow-x-auto mb-4" ]
    [ D.code [ DA.klass_ "font-mono text-sm text-gray-200 whitespace-pre" ]
        [ D.text_ code ]
    ]
