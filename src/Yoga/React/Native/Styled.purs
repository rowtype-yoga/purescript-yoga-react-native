module Yoga.React.Native.Styled
  ( row
  , col
  , label
  , para
  , pressable
  , scrollable
  , container
  ) where

import Prelude

import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import Yoga.React.Native.Internal (class IsJSX)
import Yoga.React.Native.Style (tw)
import Yoga.React.Native.View as View
import Yoga.React.Native.Text as Text
import Yoga.React.Native.Pressable as Pressable
import Yoga.React.Native.ScrollView as ScrollView
import Yoga.React.Native.SafeAreaView as SafeAreaView

row :: forall kids. IsJSX kids => String -> kids -> JSX
row classes = View.view { style: tw ("flex-row " <> classes) }

col :: forall kids. IsJSX kids => String -> kids -> JSX
col classes = View.view { style: tw classes }

label :: String -> String -> JSX
label classes = Text.text { style: tw classes }

para :: forall kids. IsJSX kids => String -> kids -> JSX
para classes = Text.text { style: tw classes }

pressable :: String -> Effect Unit -> Array JSX -> JSX
pressable classes onClick = Pressable.pressable { onPress: handler_ onClick, style: tw classes }

scrollable :: forall kids. IsJSX kids => String -> kids -> JSX
scrollable classes = ScrollView.scrollView { style: tw classes }

container :: forall kids. IsJSX kids => String -> kids -> JSX
container classes = SafeAreaView.safeAreaView { style: tw classes }
