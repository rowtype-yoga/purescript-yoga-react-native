module Yoga.React.Native.View (view, view_, ViewAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, FFINativeComponent_, createNativeElement, createNativeElement_)

foreign import _viewImpl :: forall props. ReactComponent props

view :: FFINativeComponent ViewAttributes
view = createNativeElement _viewImpl

view_ :: FFINativeComponent_ ViewAttributes
view_ = createNativeElement_ _viewImpl

type ViewAttributes = BaseAttributes
  ( pointerEvents :: String
  , onStartShouldSetResponder :: EventHandler
  , onMoveShouldSetResponder :: EventHandler
  , onResponderGrant :: EventHandler
  , onResponderMove :: EventHandler
  , onResponderRelease :: EventHandler
  , onResponderTerminate :: EventHandler
  , onResponderTerminationRequest :: EventHandler
  )
