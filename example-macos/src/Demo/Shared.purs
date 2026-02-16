module Demo.Shared
  ( DemoProps
  , scrollWrap
  , sectionTitle
  , desc
  , card
  , label
  , round
  , getFieldJSON
  ) where

import Prelude

import React.Basic (JSX)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.ScrollView (nativeScrollView)
import Yoga.React.Native.Style as Style

type DemoProps =
  { fg :: String
  , dimFg :: String
  , cardBg :: String
  , bg :: String
  , isDark :: Boolean
  }

scrollWrap :: DemoProps -> Array JSX -> JSX
scrollWrap _ children =
  nativeScrollView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
    (view { style: tw "px-4 pb-4" } children)

sectionTitle :: String -> String -> JSX
sectionTitle color title =
  text { style: tw "text-sm font-semibold mt-4 mb-1" <> Style.style { color } } title

desc :: DemoProps -> String -> JSX
desc dp str =
  text { style: tw "text-xs mb-2" <> Style.style { color: dp.dimFg } } str

card :: String -> Array JSX -> JSX
card bg children =
  view { style: tw "rounded-lg p-3 mb-2" <> Style.style { backgroundColor: bg, overflow: "hidden" } }
    children

label :: String -> String -> JSX
label color str =
  text { style: tw "ml-3 text-sm" <> Style.style { color } } str

round :: Number -> Int
round n = unsafeRound n

foreign import unsafeRound :: Number -> Int
foreign import getFieldJSON :: String -> forall r. r -> String
