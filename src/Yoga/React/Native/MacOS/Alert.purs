module Yoga.React.Native.MacOS.Alert
  ( macosAlert
  , AlertProps
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)
import Yoga.React.Native.MacOS.Types (AlertStyle)

type AlertProps =
  ( style :: AlertStyle
  , title :: String
  , message :: String
  , buttons :: Array String
  )

foreign import alertImpl :: EffectFn1 (Record AlertProps) Unit

macosAlert
  :: forall given missing
   . Union given missing AlertProps
  => { | given }
  -> Effect Unit
macosAlert r = runEffectFn1 alertImpl (unsafeCoerce r)
