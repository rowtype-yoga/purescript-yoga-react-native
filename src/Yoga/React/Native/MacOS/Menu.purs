module Yoga.React.Native.MacOS.Menu
  ( macosShowMenu
  , MenuItem
  , MenuProps
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

type MenuItem =
  { title :: String
  , id :: String
  }

type MenuProps =
  { items :: Array MenuItem
  , onSelectItem :: String -> Effect Unit
  }

foreign import showMenuImpl :: EffectFn1 MenuProps Unit

macosShowMenu :: MenuProps -> Effect Unit
macosShowMenu = runEffectFn1 showMenuImpl
