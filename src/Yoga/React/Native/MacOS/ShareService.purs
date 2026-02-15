module Yoga.React.Native.MacOS.ShareService
  ( macosShare
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import shareImpl :: EffectFn1 (Array String) Unit

macosShare :: Array String -> Effect Unit
macosShare = runEffectFn1 shareImpl
