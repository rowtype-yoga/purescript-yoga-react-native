module Yoga.React.Native.StatusBar (statusBar, StatusBarAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _statusBarImpl :: forall props. ReactComponent props

statusBar :: FFINativeComponent_ StatusBarAttributes
statusBar = createNativeElement_ _statusBarImpl

type StatusBarAttributes =
  ( animated :: Boolean
  , barStyle :: String
  , hidden :: Boolean
  , backgroundColor :: String
  , translucent :: Boolean
  , networkActivityIndicatorVisible :: Boolean
  , showHideTransition :: String
  )
