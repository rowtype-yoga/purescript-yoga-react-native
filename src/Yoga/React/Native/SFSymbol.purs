module Yoga.React.Native.SFSymbol (sfSymbol, SFSymbolAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _sfSymbolImpl :: forall props. ReactComponent props

sfSymbol :: FFINativeComponent_ SFSymbolAttributes
sfSymbol = createNativeElement_ _sfSymbolImpl

type SFSymbolAttributes = BaseAttributes
  ( name :: String
  , size :: Number
  , weight :: Number
  , color :: String
  )
