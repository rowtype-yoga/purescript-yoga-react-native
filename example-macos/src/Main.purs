module Main where

import Prelude

import Effect (Effect)
import React.Basic (JSX)
import Yoga.React (component)
import Yoga.React.Native (registerComponent, safeAreaView, tw)
import Yoga.React.Native.NativeShowcase (nativeShowcase)
import Yoga.React.Native.Style as Style

main :: Effect Unit
main = registerComponent "YogaReactExample" \_ -> app {}

app :: {} -> JSX
app = component "App" \_ -> do
  pure do
    safeAreaView { style: tw "flex-1" }
      (nativeShowcase { style: Style.style { flex: 1.0 } })
