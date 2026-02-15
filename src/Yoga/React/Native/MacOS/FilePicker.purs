module Yoga.React.Native.MacOS.FilePicker (nativeFilePicker, NativeFilePickerAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)
import Yoga.React.Native.MacOS.Types (FilePickerMode)

foreign import _filePickerImpl :: forall props. ReactComponent props

nativeFilePicker :: FFINativeComponent_ NativeFilePickerAttributes
nativeFilePicker = createNativeElement_ _filePickerImpl

type NativeFilePickerAttributes = BaseAttributes
  ( mode :: FilePickerMode
  , title :: String
  , sfSymbol :: String
  , message :: String
  , defaultName :: String
  , allowedTypes :: Array String
  , allowMultiple :: Boolean
  , canChooseDirectories :: Boolean
  , onPickFiles :: EventHandler
  , onCancel :: EventHandler
  )
