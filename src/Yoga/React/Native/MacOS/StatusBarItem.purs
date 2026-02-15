module Yoga.React.Native.MacOS.StatusBarItem
  ( macosSetStatusBarItem
  , macosRemoveStatusBarItem
  , StatusBarConfig
  , StatusBarMenuItem
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import setStatusBarItemImpl :: EffectFn1 StatusBarConfig Unit
foreign import removeStatusBarItemImpl :: Effect Unit

type StatusBarMenuItem =
  { id :: String
  , title :: String
  }

type StatusBarConfig =
  { title :: String
  , sfSymbol :: String
  , menuItems :: Array StatusBarMenuItem
  }

macosSetStatusBarItem :: StatusBarConfig -> Effect Unit
macosSetStatusBarItem = runEffectFn1 setStatusBarItemImpl

macosRemoveStatusBarItem :: Effect Unit
macosRemoveStatusBarItem = removeStatusBarItemImpl
