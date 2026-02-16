module Yoga.React.Native.MacOS.TabView
  ( nativeTabView
  , NativeTabViewAttributes
  , TabItem
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import tabViewImpl :: forall props. ReactComponent props

nativeTabView :: FFINativeComponent_ NativeTabViewAttributes
nativeTabView = createNativeElement_ tabViewImpl

type TabItem =
  { id :: String
  , label :: String
  }

type NativeTabViewAttributes = BaseAttributes
  ( items :: Array TabItem
  , selectedItem :: String
  , onSelectTab :: String -> Effect Unit
  )
