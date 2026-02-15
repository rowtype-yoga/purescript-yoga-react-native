module Yoga.React.Native.MacOS.SpeechSynthesizer
  ( macosSay
  , macosSayWithVoice
  , macosStopSpeaking
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)

foreign import sayImpl :: EffectFn1 String Unit
foreign import sayWithVoiceImpl :: EffectFn2 String String Unit
foreign import stopSpeakingImpl :: Effect Unit

macosSay :: String -> Effect Unit
macosSay = runEffectFn1 sayImpl

macosSayWithVoice :: String -> String -> Effect Unit
macosSayWithVoice = runEffectFn2 sayWithVoiceImpl

macosStopSpeaking :: Effect Unit
macosStopSpeaking = stopSpeakingImpl
