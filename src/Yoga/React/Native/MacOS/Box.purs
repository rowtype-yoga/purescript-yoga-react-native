module Yoga.React.Native.MacOS.Box
  ( nativeBox
  , NativeBoxAttributes
  ) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import _boxImpl :: forall props. ReactComponent props

nativeBox :: FFINativeComponent NativeBoxAttributes
nativeBox = createNativeElement _boxImpl

type NativeBoxAttributes = BaseAttributes
  ( boxTitle :: String
  , fillColor :: String
  , borderColorStr :: String
  , cornerRadiusValue :: Number
  )
