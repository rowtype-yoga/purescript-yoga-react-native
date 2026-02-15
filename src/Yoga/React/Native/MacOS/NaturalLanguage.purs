module Yoga.React.Native.MacOS.NaturalLanguage
  ( detectLanguage
  , analyzeSentiment
  , tokenize
  ) where

import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

foreign import detectLanguageImpl :: String -> EffectFnAff String

detectLanguage :: String -> Aff String
detectLanguage text = fromEffectFnAff (detectLanguageImpl text)

foreign import analyzeSentimentImpl :: String -> EffectFnAff Number

analyzeSentiment :: String -> Aff Number
analyzeSentiment text = fromEffectFnAff (analyzeSentimentImpl text)

foreign import tokenizeImpl :: String -> EffectFnAff (Array String)

tokenize :: String -> Aff (Array String)
tokenize text = fromEffectFnAff (tokenizeImpl text)
