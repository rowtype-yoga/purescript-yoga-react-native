module Yoga.React.Native.MacOS.DropZone (nativeDropZone, NativeDropZoneAttributes) where

import React.Basic (ReactComponent)
import React.Basic.Events (EventHandler)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import _dropZoneImpl :: forall props. ReactComponent props

nativeDropZone :: FFINativeComponent NativeDropZoneAttributes
nativeDropZone = createNativeElement _dropZoneImpl

type NativeDropZoneAttributes = BaseAttributes
  ( onFileDrop :: EventHandler
  , onFilesDragEnter :: EventHandler
  , onFilesDragExit :: EventHandler
  )
