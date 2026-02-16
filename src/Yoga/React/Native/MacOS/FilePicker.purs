module Yoga.React.Native.MacOS.FilePicker (nativeFilePicker, NativeFilePickerAttributes, PickedFile) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (FilePickerMode)

foreign import filePickerImpl :: forall props. ReactComponent props

nativeFilePicker :: FFINativeComponent_ NativeFilePickerAttributes
nativeFilePicker = createNativeElement_ filePickerImpl

type PickedFile =
  { path :: String
  , name :: String
  }

type NativeFilePickerAttributes = BaseAttributes
  ( mode :: FilePickerMode
  , title :: String
  , sfSymbol :: String
  , message :: String
  , defaultName :: String
  , allowedTypes :: Array String
  , allowMultiple :: Boolean
  , canChooseDirectories :: Boolean
  , onPickFiles :: Array PickedFile -> Effect Unit
  , onCancel :: Effect Unit
  )
