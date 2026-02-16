module Demo.TextEditing (textFieldDemo, textEditorDemo) where

import Prelude

import Demo.Shared (DemoProps, card, label, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (tw, view)
import Yoga.React.Native.MacOS.TextField (nativeTextField)
import Yoga.React.Native.MacOS.TextEditor (nativeTextEditor)
import Yoga.React.Native.Style as Style

textFieldDemo :: DemoProps -> JSX
textFieldDemo = component "TextFieldDemo" \dp -> React.do
  txt /\ setTxt <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Text Field"
      , card dp.cardBg
          [ nativeTextField
              { placeholder: "Type something..."
              , search: true
              , text: txt
              , onChangeText: setTxt
              , style: Style.style { height: 24.0 }
              }
          , if txt == "" then mempty
            else label dp.dimFg ("You typed: " <> txt)
          ]
      ]

textEditorDemo :: DemoProps -> JSX
textEditorDemo = component "TextEditorDemo" \dp -> pure do
  view { style: tw "flex-1 px-4" }
    [ sectionTitle dp.fg "Rich Text Editor"
    , nativeTextEditor
        { text: "Welcome to the PureScript-driven native text editor.\n\nThis uses NSTextView with rich text support and a formatting ruler."
        , richText: true
        , showsRuler: true
        , style: tw "flex-1" <> Style.style { minHeight: 300.0 }
        }
    ]
