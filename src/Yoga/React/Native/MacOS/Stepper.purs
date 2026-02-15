module Yoga.React.Native.MacOS.Stepper
  ( nativeStepper
  , NativeStepperAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _stepperImpl :: forall props. ReactComponent props

nativeStepper :: FFINativeComponent_ NativeStepperAttributes
nativeStepper = createNativeElement_ _stepperImpl

type NativeStepperAttributes = BaseAttributes
  ( value :: Number
  , minValue :: Number
  , maxValue :: Number
  , increment :: Number
  , onChange :: EventHandler
  )
