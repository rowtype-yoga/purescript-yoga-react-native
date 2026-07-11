module Yoga.React.Native.Android.Alert
  ( androidAlert
  , AlertButton
  , AlertOptions
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

type AlertButton =
  { text :: String
  , onPress :: Effect Unit
  , style :: String
  }

type AlertOptions =
  ( title :: String
  , message :: String
  , buttons :: Array AlertButton
  , cancelable :: Boolean
  , onDismiss :: Effect Unit
  )

foreign import alertImpl :: EffectFn1 (Record AlertOptions) Unit

androidAlert
  :: forall given missing
   . Union given missing AlertOptions
  => { | given }
  -> Effect Unit
androidAlert r = runEffectFn1 alertImpl (unsafeCoerce r)
