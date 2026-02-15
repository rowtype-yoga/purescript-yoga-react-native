module Yoga.React.Native.MacOS.Box
  ( nativeBox
  , NativeBoxAttributes
  ) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import boxImpl :: forall props. ReactComponent props

nativeBox :: FFINativeComponent NativeBoxAttributes
nativeBox = createNativeElement boxImpl

type NativeBoxAttributes = BaseAttributes
  ( boxTitle :: String
  , fillColor2 :: String
  , borderColor2 :: String
  , radius :: Number
  )
