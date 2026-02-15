module Yoga.React.Native.MacOS.Checkbox
  ( nativeCheckbox
  , NativeCheckboxAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import checkboxImpl :: forall props. ReactComponent props

nativeCheckbox :: FFINativeComponent_ NativeCheckboxAttributes
nativeCheckbox = createNativeElement_ checkboxImpl

type NativeCheckboxAttributes = BaseAttributes
  ( checked :: Boolean
  , title :: String
  , enabled :: Boolean
  , onChange :: EventHandler
  )
