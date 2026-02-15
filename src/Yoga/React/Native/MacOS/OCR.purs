module Yoga.React.Native.MacOS.OCR
  ( recognizeText
  ) where

import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

foreign import recognizeTextImpl :: String -> EffectFnAff String

recognizeText :: String -> Aff String
recognizeText path = fromEffectFnAff (recognizeTextImpl path)
