module Yoga.React.Native.MacOS.Menu
  ( macosShowMenu
  , MenuItem
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)

type MenuItem =
  { title :: String
  , id :: String
  }

foreign import showMenuImpl :: EffectFn2 (Array MenuItem) (String -> Effect Unit) Unit

macosShowMenu :: Array MenuItem -> (String -> Effect Unit) -> Effect Unit
macosShowMenu = runEffectFn2 showMenuImpl
