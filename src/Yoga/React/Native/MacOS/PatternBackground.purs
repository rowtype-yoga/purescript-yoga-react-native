module Yoga.React.Native.MacOS.PatternBackground (nativePatternBackground, NativePatternBackgroundAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import patternBackgroundImpl :: forall props. ReactComponent props

nativePatternBackground :: FFINativeComponent NativePatternBackgroundAttributes
nativePatternBackground = createNativeElement patternBackgroundImpl

type NativePatternBackgroundAttributes = BaseAttributes
  ( patternColor :: String
  , background :: String
  , patternOpacity :: Number
  , patternScale :: Number
  )
