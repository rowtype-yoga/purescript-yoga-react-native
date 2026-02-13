module Yoga.React.Native.MacOS.LevelIndicator (nativeLevelIndicator, NativeLevelIndicatorAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _levelIndicatorImpl :: forall props. ReactComponent props

nativeLevelIndicator :: FFINativeComponent_ NativeLevelIndicatorAttributes
nativeLevelIndicator = createNativeElement_ _levelIndicatorImpl

type NativeLevelIndicatorAttributes = BaseAttributes
  ( value :: Number
  , minValue :: Number
  , maxValue :: Number
  , warningValue :: Number
  , criticalValue :: Number
  )
