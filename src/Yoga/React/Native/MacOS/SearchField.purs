module Yoga.React.Native.MacOS.SearchField
  ( nativeSearchField
  , NativeSearchFieldAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import searchFieldImpl :: forall props. ReactComponent props

nativeSearchField :: FFINativeComponent_ NativeSearchFieldAttributes
nativeSearchField = createNativeElement_ searchFieldImpl

type NativeSearchFieldAttributes = BaseAttributes
  ( text :: String
  , placeholder :: String
  , onChangeText :: String -> Effect Unit
  , onSearch :: String -> Effect Unit
  )
