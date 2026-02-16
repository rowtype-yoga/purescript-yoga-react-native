module Docs.Pages.TextEditing where

import Deku.Core (Nut)
import Deku.DOM as D
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "Text" [ D.p_ [ D.text_ "Native macOS text input components." ] ]
    , textField
    , textEditor
    ]

textField :: Nut
textField = L.componentDoc "nativeTextField" "Yoga.React.Native.MacOS.TextField (nativeTextField)"
  """nativeTextField
  { text: "Hello"
  , placeholder: "Enter text..."
  , secure: false
  , onChangeText: E.onString "text" setText
  , onSubmit: handler_ doSubmit
  }"""
  [ propsTable
      [ { name: "text", type_: "String", description: "Current text value" }
      , { name: "placeholder", type_: "String", description: "Placeholder text" }
      , { name: "secure", type_: "Boolean", description: "Password field (hides input)" }
      , { name: "search", type_: "Boolean", description: "Search field style" }
      , { name: "rounded", type_: "Boolean", description: "Rounded bezel style" }
      , { name: "onChangeText", type_: "EventHandler", description: "Text change callback" }
      , { name: "onSubmit", type_: "EventHandler", description: "Submit callback (Enter key)" }
      ]
  ]

textEditor :: Nut
textEditor = L.componentDoc "nativeTextEditor" "Yoga.React.Native.MacOS.TextEditor (nativeTextEditor)"
  """nativeTextEditor
  { text: "Rich text content..."
  , richText: true
  , showsRuler: false
  , onChangeText: E.onString "text" setText
  }"""
  [ propsTable
      [ { name: "text", type_: "String", description: "Current text content" }
      , { name: "richText", type_: "Boolean", description: "Enable rich text formatting" }
      , { name: "showsRuler", type_: "Boolean", description: "Show the formatting ruler" }
      , { name: "onChangeText", type_: "EventHandler", description: "Text change callback" }
      ]
  ]
