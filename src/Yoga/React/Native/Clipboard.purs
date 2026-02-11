module Yoga.React.Native.Clipboard
  ( getString
  , setString
  ) where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

foreign import getStringImpl :: EffectFnAff String

getString :: Aff String
getString = fromEffectFnAff getStringImpl

foreign import setString :: String -> Effect Unit
