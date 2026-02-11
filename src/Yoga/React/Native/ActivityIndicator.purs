module Yoga.React.Native.ActivityIndicator (activityIndicator, ActivityIndicatorAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _activityIndicatorImpl :: forall props. ReactComponent props

activityIndicator :: FFINativeComponent_ ActivityIndicatorAttributes
activityIndicator = createNativeElement_ _activityIndicatorImpl

type ActivityIndicatorAttributes = BaseAttributes
  ( animating :: Boolean
  , size :: String
  , color :: String
  )
