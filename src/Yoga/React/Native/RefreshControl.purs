module Yoga.React.Native.RefreshControl (refreshControl, RefreshControlAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _refreshControlImpl :: forall props. ReactComponent props

refreshControl :: FFINativeComponent_ RefreshControlAttributes
refreshControl = createNativeElement_ _refreshControlImpl

type RefreshControlAttributes = BaseAttributes
  ( refreshing :: Boolean
  , onRefresh :: EventHandler
  , tintColor :: String
  , title :: String
  , titleColor :: String
  , colors :: Array String
  , enabled :: Boolean
  , progressBackgroundColor :: String
  , progressViewOffset :: Number
  )
