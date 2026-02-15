module Yoga.React.Native.MacOS.SearchField
  ( nativeSearchField
  , NativeSearchFieldAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _searchFieldImpl :: forall props. ReactComponent props

nativeSearchField :: FFINativeComponent_ NativeSearchFieldAttributes
nativeSearchField = createNativeElement_ _searchFieldImpl

type NativeSearchFieldAttributes = BaseAttributes
  ( text :: String
  , placeholder :: String
  , onChangeText :: EventHandler
  , onSearch :: EventHandler
  )
