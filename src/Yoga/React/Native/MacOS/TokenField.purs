module Yoga.React.Native.MacOS.TokenField
  ( nativeTokenField
  , NativeTokenFieldAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _tokenFieldImpl :: forall props. ReactComponent props

nativeTokenField :: FFINativeComponent_ NativeTokenFieldAttributes
nativeTokenField = createNativeElement_ _tokenFieldImpl

type NativeTokenFieldAttributes = BaseAttributes
  ( tokens :: Array String
  , placeholder :: String
  , onChangeTokens :: EventHandler
  )
