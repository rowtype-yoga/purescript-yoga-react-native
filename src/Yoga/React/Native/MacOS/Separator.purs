module Yoga.React.Native.MacOS.Separator
  ( nativeSeparator
  , NativeSeparatorAttributes
  ) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _separatorImpl :: forall props. ReactComponent props

nativeSeparator :: FFINativeComponent_ NativeSeparatorAttributes
nativeSeparator = createNativeElement_ _separatorImpl

type NativeSeparatorAttributes = BaseAttributes
  ( vertical :: Boolean
  )
