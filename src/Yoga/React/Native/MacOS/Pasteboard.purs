module Yoga.React.Native.MacOS.Pasteboard
  ( copyToClipboard
  , readClipboard
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import copyToClipboardImpl :: EffectFn1 String Unit
foreign import readClipboardImpl :: Effect String

copyToClipboard :: String -> Effect Unit
copyToClipboard = runEffectFn1 copyToClipboardImpl

readClipboard :: Effect String
readClipboard = readClipboardImpl
