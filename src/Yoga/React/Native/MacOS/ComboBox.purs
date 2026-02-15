module Yoga.React.Native.MacOS.ComboBox
  ( nativeComboBox
  , NativeComboBoxAttributes
  ) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import _comboBoxImpl :: forall props. ReactComponent props

nativeComboBox :: FFINativeComponent_ NativeComboBoxAttributes
nativeComboBox = createNativeElement_ _comboBoxImpl

type NativeComboBoxAttributes = BaseAttributes
  ( items :: Array String
  , text :: String
  , placeholder :: String
  , onChangeText :: EventHandler
  , onSelectItem :: EventHandler
  )
