module Yoga.React.Native.MacOS.UserNotification
  ( macosNotify
  , NotifyProps
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row (class Union)

type NotifyProps =
  ( title :: String
  , body :: String
  )

foreign import notifyImpl :: EffectFn1 (Record NotifyProps) Unit

macosNotify
  :: forall given missing
   . Union given missing NotifyProps
  => { | given }
  -> Effect Unit
macosNotify = runEffectFn1 notifyImpl
