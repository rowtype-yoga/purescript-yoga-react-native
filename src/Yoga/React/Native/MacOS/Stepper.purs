module Yoga.React.Native.MacOS.Stepper
  ( nativeStepper
  , NativeStepperAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import stepperImpl :: forall props. ReactComponent props

nativeStepper :: FFINativeComponent_ NativeStepperAttributes
nativeStepper = createNativeElement_ stepperImpl

type NativeStepperAttributes = BaseAttributes
  ( value :: Number
  , minValue :: Number
  , maxValue :: Number
  , increment :: Number
  , onChange :: Number -> Effect Unit
  )
