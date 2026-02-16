module Yoga.React.Native.MacOS.ComboBox
  ( nativeComboBox
  , NativeComboBoxAttributes
  ) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import comboBoxImpl :: forall props. ReactComponent props

nativeComboBox :: FFINativeComponent_ NativeComboBoxAttributes
nativeComboBox = createNativeElement_ comboBoxImpl

type NativeComboBoxAttributes = BaseAttributes
  ( items :: Array String
  , text :: String
  , placeholder :: String
  , onChangeText :: String -> Effect Unit
  , onSelectItem :: String -> Effect Unit
  )
