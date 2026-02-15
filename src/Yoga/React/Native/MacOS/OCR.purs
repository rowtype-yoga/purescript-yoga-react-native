module Yoga.React.Native.MacOS.OCR
  ( macosOCR
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)

foreign import recognizeImpl :: EffectFn2 String (String -> Effect Unit) Unit

macosOCR :: String -> (String -> Effect Unit) -> Effect Unit
macosOCR = runEffectFn2 recognizeImpl
