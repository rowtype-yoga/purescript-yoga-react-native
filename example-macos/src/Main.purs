module Main where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (registerComponent, string, view, text, textInput, pressable, scrollView, tw)

main :: Effect Unit
main = registerComponent "YogaReactExample" \_ -> app {}

app :: {} -> JSX
app = component "App" \_ -> React.do
  count /\ setCount <- React.useState 0
  inputText /\ setInputText <- React.useState ""
  items /\ setItems <- React.useState ([] :: Array String)
  pure do
    view { style: tw "flex-1 p-10 bg-gray-100" }
      [ text { style: tw "text-2xl font-bold mb-5" } "Yoga React Native macOS"
      , text { style: tw "text-lg mb-3" } ("Count: " <> show count)
      , view { style: tw "flex-row gap-3 mb-5" }
          [ button "+" (setCount (_ + 1))
          , button "-" (setCount (_ - 1))
          ]
      , textInput
          { value: inputText
          , onChangeText: mkEffectFn1 \t -> setInputText (const t)
          , placeholder: "Add an item..."
          , style: tw "border border-gray-300 rounded-lg p-3 mb-3 bg-white"
          }
      , button "Add" do
          setItems (_ <> [ inputText ])
          setInputText (const "")
      , scrollView { style: tw "flex-1" }
          (items <#> \item -> text { style: tw "text-base py-2 border-b border-gray-200" } (string item))
      ]

button :: String -> Effect Unit -> JSX
button label onClick =
  pressable { onPress: handler_ onClick, style: tw "bg-blue-500 px-5 py-3 rounded-lg" }
    [ text { style: tw "text-white text-base font-semibold" } label ]
