module Yoga.React.Native.StyleSheet
  ( create
  , hairlineWidth
  , absoluteFill
  ) where

import Yoga.React.Native.Style (Style)

foreign import create :: forall r. { | r } -> { | r }
foreign import hairlineWidth :: Number
foreign import absoluteFill :: Style
