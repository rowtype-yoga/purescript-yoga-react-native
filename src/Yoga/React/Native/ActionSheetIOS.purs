module Yoga.React.Native.ActionSheetIOS
  ( showActionSheet
  , dismissActionSheet
  , ActionSheetOptions
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2, EffectFn1)

type ActionSheetOptions =
  { options :: Array String
  , cancelButtonIndex :: Int
  , destructiveButtonIndex :: Int
  , title :: String
  , message :: String
  }

foreign import showActionSheetImpl :: forall r. EffectFn2 { | r } (EffectFn1 Int Unit) Unit

showActionSheet :: forall r. { | r } -> (EffectFn1 Int Unit) -> Effect Unit
showActionSheet = runEffectFn2 showActionSheetImpl

foreign import dismissActionSheet :: Effect Unit
