module Yoga.React.Native.MacOS.SpeechRecognition
  ( macosStartListening
  , macosStopListening
  , macosGetTranscript
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import startListeningImpl :: Effect Unit
foreign import stopListeningImpl :: EffectFn1 (String -> Effect Unit) Unit
foreign import getTranscriptImpl :: EffectFn1 (String -> Effect Unit) Unit

macosStartListening :: Effect Unit
macosStartListening = startListeningImpl

macosStopListening :: (String -> Effect Unit) -> Effect Unit
macosStopListening = runEffectFn1 stopListeningImpl

macosGetTranscript :: (String -> Effect Unit) -> Effect Unit
macosGetTranscript = runEffectFn1 getTranscriptImpl
