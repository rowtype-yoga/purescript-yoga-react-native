module Yoga.React.Native.MacOS.SpeechSynthesizer
  ( say
  , sayWithVoice
  , stopSpeaking
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Yoga.React.Native.MacOS.Types (VoiceIdentifier(..))

say :: String -> Effect Unit
say = runEffectFn1 sayImpl

foreign import sayImpl :: EffectFn1 String Unit

sayWithVoice :: String -> VoiceIdentifier -> Effect Unit
sayWithVoice text (VoiceIdentifier voice) = runEffectFn2 sayWithVoiceImpl text voice

foreign import sayWithVoiceImpl :: EffectFn2 String String Unit

stopSpeaking :: Effect Unit
stopSpeaking = stopSpeakingImpl

foreign import stopSpeakingImpl :: Effect Unit
