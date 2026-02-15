module Yoga.React.Native.MacOS.Sound
  ( macosPlaySound
  , macosBeep
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import playSoundImpl :: EffectFn1 String Unit
foreign import beepImpl :: Effect Unit

macosPlaySound :: String -> Effect Unit
macosPlaySound = runEffectFn1 playSoundImpl

macosBeep :: Effect Unit
macosBeep = beepImpl
