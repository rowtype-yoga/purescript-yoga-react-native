module Yoga.React.Native.Switch (switch, SwitchAttributes) where

import Prelude

import Effect.Uncurried (EffectFn1)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _switchImpl :: forall props. ReactComponent props

switch :: FFINativeComponent_ SwitchAttributes
switch = createNativeElement_ _switchImpl

type SwitchAttributes = BaseAttributes
  ( value :: Boolean
  , onValueChange :: EffectFn1 Boolean Unit
  , disabled :: Boolean
  , trackColor :: { false :: String, true :: String }
  , thumbColor :: String
  )
