module Yoga.React.Native.MacOS.QuickLook
  ( macosQuickLook
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import previewImpl :: EffectFn1 String Unit

macosQuickLook :: String -> Effect Unit
macosQuickLook = runEffectFn1 previewImpl
