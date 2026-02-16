module Yoga.React.Native.MacOS.TokenField
  ( nativeTokenField
  , NativeTokenFieldAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import tokenFieldImpl :: forall props. ReactComponent props

nativeTokenField :: FFINativeComponent_ NativeTokenFieldAttributes
nativeTokenField = createNativeElement_ tokenFieldImpl

type NativeTokenFieldAttributes = BaseAttributes
  ( tokens :: Array String
  , placeholder :: String
  , onChangeTokens :: Array String -> Effect Unit
  )
