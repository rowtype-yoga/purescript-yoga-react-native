module Yoga.React.Native.MacOS.UserNotification
  ( macosNotify
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)

foreign import notifyImpl :: EffectFn2 String String Unit

macosNotify :: String -> String -> Effect Unit
macosNotify = runEffectFn2 notifyImpl
