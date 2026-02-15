module Yoga.React.Native.MacOS.TextEditor (nativeTextEditor, NativeTextEditorAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent_, createNativeElement_)

foreign import textEditorImpl :: forall props. ReactComponent props

nativeTextEditor :: FFINativeComponent_ NativeTextEditorAttributes
nativeTextEditor = createNativeElement_ textEditorImpl

type NativeTextEditorAttributes = BaseAttributes
  ( text :: String
  , richText :: Boolean
  , showsRuler :: Boolean
  , onChangeText :: EventHandler
  )
