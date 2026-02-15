module Yoga.React.Native.MacOS.TabView
  ( nativeTabView
  , NativeTabViewAttributes
  , TabItem
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _tabViewImpl :: forall props. ReactComponent props

nativeTabView :: FFINativeComponent_ NativeTabViewAttributes
nativeTabView = createNativeElement_ _tabViewImpl

type TabItem =
  { id :: String
  , label :: String
  }

type NativeTabViewAttributes = BaseAttributes
  ( items :: Array TabItem
  , selectedItem :: String
  , onSelectTab :: EventHandler
  )
