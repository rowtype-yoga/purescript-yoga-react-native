module Yoga.React.Native.IOS.ActionSheet
  ( showActionSheet
  , showShareActionSheet
  , dismissActionSheet
  , ActionSheetOptions
  , ShareOptions
  , ShareResult
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

type ActionSheetOptions =
  ( options :: Array String
  , cancelButtonIndex :: Int
  , destructiveButtonIndex :: Int
  , title :: String
  , message :: String
  , anchor :: Int
  , tintColor :: String
  , cancelButtonTintColor :: String
  , userInterfaceStyle :: String
  , disabledButtonIndices :: Array Int
  )

type ShareOptions =
  ( message :: String
  , url :: String
  , subject :: String
  , excludedActivityTypes :: Array String
  )

type ShareResult =
  { action :: String
  , activityType :: String
  }

foreign import showActionSheetImpl :: EffectFn2 (Record ActionSheetOptions) (Int -> Effect Unit) Unit
foreign import showShareActionSheetImpl :: EffectFn2 (Record ShareOptions) (ShareResult -> Effect Unit) Unit
foreign import dismissActionSheet :: Effect Unit

showActionSheet
  :: forall given missing
   . Union given missing ActionSheetOptions
  => { | given }
  -> (Int -> Effect Unit)
  -> Effect Unit
showActionSheet opts = runEffectFn2 showActionSheetImpl (unsafeCoerce opts)

showShareActionSheet
  :: forall given missing
   . Union given missing ShareOptions
  => { | given }
  -> (ShareResult -> Effect Unit)
  -> Effect Unit
showShareActionSheet opts = runEffectFn2 showShareActionSheetImpl (unsafeCoerce opts)
