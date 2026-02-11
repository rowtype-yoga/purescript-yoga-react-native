module Yoga.React.Native.Style
  ( Style
  , style
  , styles
  , tw
  ) where

import Prelude
import Unsafe.Coerce (unsafeCoerce)

foreign import data Style :: Type

foreign import stylesImpl :: Array Style -> Style

style :: forall r. { | r } -> Style
style = unsafeCoerce

styles :: Array Style -> Style
styles = stylesImpl

foreign import tw :: String -> Style

instance Semigroup Style where
  append a b = stylesImpl [ a, b ]

instance Monoid Style where
  mempty = unsafeCoerce {}
