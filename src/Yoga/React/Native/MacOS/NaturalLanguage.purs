module Yoga.React.Native.MacOS.NaturalLanguage
  ( macosDetectLanguage
  , macosAnalyzeSentiment
  , macosTokenize
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)

foreign import detectLanguageImpl :: EffectFn2 String (String -> Effect Unit) Unit
foreign import sentimentImpl :: EffectFn2 String (Number -> Effect Unit) Unit
foreign import tokenizeImpl :: EffectFn2 String (Array String -> Effect Unit) Unit

macosDetectLanguage :: String -> (String -> Effect Unit) -> Effect Unit
macosDetectLanguage = runEffectFn2 detectLanguageImpl

macosAnalyzeSentiment :: String -> (Number -> Effect Unit) -> Effect Unit
macosAnalyzeSentiment = runEffectFn2 sentimentImpl

macosTokenize :: String -> (Array String -> Effect Unit) -> Effect Unit
macosTokenize = runEffectFn2 tokenizeImpl
