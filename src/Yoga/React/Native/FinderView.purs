module Yoga.React.Native.FinderView (finderView, FinderViewAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _finderViewImpl :: forall props. ReactComponent props

finderView :: FFINativeComponent_ FinderViewAttributes
finderView = createNativeElement_ _finderViewImpl

type FinderViewAttributes = BaseAttributes
  ( initialPath :: String
  , onNavigate :: EventHandler
  , onSelectFile :: EventHandler
  )
