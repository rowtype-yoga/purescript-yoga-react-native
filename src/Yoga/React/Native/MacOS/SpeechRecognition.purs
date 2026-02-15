module Yoga.React.Native.MacOS.SpeechRecognition
  ( useSpeechRecognition
  , UseSpeechRecognition
  , SpeechRecognition
  ) where

import Prelude

import Data.Newtype (class Newtype)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import React.Basic.Hooks (Hook, UseEffect, UseState, useState', useEffect)
import React.Basic.Hooks as React
import React.Basic.Hooks.Internal (coerceHook)

foreign import startImpl :: Effect Unit
foreign import stopImpl :: EffectFn1 (String -> Effect Unit) Unit
foreign import pollTranscriptImpl :: EffectFn1 (String -> Effect Unit) Unit
foreign import setIntervalImpl :: EffectFn2 Int (Effect Unit) Int
foreign import clearIntervalImpl :: EffectFn1 Int Unit

type SpeechRecognition =
  { listening :: Boolean
  , transcript :: String
  , start :: Effect Unit
  , stop :: Effect Unit
  }

newtype UseSpeechRecognition hooks = UseSpeechRecognition
  (UseEffect Boolean (UseState String (UseState Boolean hooks)))

derive instance Newtype (UseSpeechRecognition hooks) _

useSpeechRecognition :: Hook UseSpeechRecognition SpeechRecognition
useSpeechRecognition = coerceHook React.do
  listening /\ setListening <- useState' false
  transcript /\ setTranscript <- useState' ""
  useEffect listening do
    if listening then do
      timerId <- runEffectFn2 setIntervalImpl 500 do
        runEffectFn1 pollTranscriptImpl \t -> setTranscript t
      pure (runEffectFn1 clearIntervalImpl timerId)
    else
      pure (pure unit)
  pure
    { listening
    , transcript
    , start: do
        setListening true
        setTranscript ""
        startImpl
    , stop: do
        setListening false
        runEffectFn1 stopImpl \finalText -> setTranscript finalText
    }
