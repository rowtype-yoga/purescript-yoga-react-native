module Yoga.React.Native.MacOS.CheckMark (checkMark, CheckMarkAttributes) where

import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import checkMarkImpl :: forall props. ReactComponent props

checkMark :: FFINativeComponent_ CheckMarkAttributes
checkMark = createNativeElement_ checkMarkImpl

type CheckMarkAttributes = BaseAttributes
  ( isDouble :: Boolean
  , color :: String
  , strokeWidth :: Number
  )
