module Yoga.React.Native.MacOS.DropZone (nativeDropZone, NativeDropZoneAttributes, DroppedData) where

import Prelude
import Effect (Effect)
import React.Basic (ReactComponent)
import Yoga.React.Native.Attributes (BaseAttributes)
import Yoga.React.Native.Internal (FFINativeComponent, createNativeElement)

foreign import dropZoneImpl :: forall props. ReactComponent props

nativeDropZone :: FFINativeComponent NativeDropZoneAttributes
nativeDropZone = createNativeElement dropZoneImpl

type DroppedData =
  { files :: Array { path :: String, name :: String }
  , strings :: Array String
  }

type NativeDropZoneAttributes = BaseAttributes
  ( onFileDrop :: DroppedData -> Effect Unit
  , onFilesDragEnter :: Effect Unit
  , onFilesDragExit :: Effect Unit
  )
