module Docs.Pages.FilesAndDragDrop where

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "Files & Drag/Drop" [ D.p_ [ D.text_ "File system access and drag-and-drop support." ] ]
    , filePicker
    , dropZone
    ]

filePicker :: Nut
filePicker = L.componentDoc "nativeFilePicker" "Yoga.React.Native.MacOS.FilePicker (nativeFilePicker)"
  """picked /\ setPicked <- useState' ""

nativeFilePicker
  { mode: T.openFile
  , title: "Open Files"
  , sfSymbol: "doc.badge.plus"
  , allowMultiple: true
  , allowedTypes: [ "public.image", "public.text" ]
  , message: "Select files to open"
  , onPickFiles: \files -> setPicked (joinWith ", " (map _.path files))
  , onCancel: setPicked "Cancelled"
  }"""
  [ propsTable
      [ { name: "mode", type_: "FilePickerMode", description: "openFile or saveFile" }
      , { name: "title", type_: "String", description: "Dialog title" }
      , { name: "sfSymbol", type_: "String", description: "SF Symbol icon for the button" }
      , { name: "message", type_: "String", description: "Dialog message" }
      , { name: "defaultName", type_: "String", description: "Default file name (save mode)" }
      , { name: "allowedTypes", type_: "Array String", description: "Allowed file extensions" }
      , { name: "allowMultiple", type_: "Boolean", description: "Allow selecting multiple files" }
      , { name: "canChooseDirectories", type_: "Boolean", description: "Allow choosing directories" }
      , { name: "onPickFiles", type_: "Array PickedFile -> Effect Unit", description: "Files selected callback ({ path, name })" }
      , { name: "onCancel", type_: "Effect Unit", description: "Cancel callback" }
      ]
  ]

dropZone :: Nut
dropZone = L.componentDoc "nativeDropZone" "Yoga.React.Native.MacOS.DropZone (nativeDropZone)"
  """-- FFINativeComponent: takes props then children
nativeDropZone
  { onFileDrop: \dropped -> setFiles dropped.files
  , onFilesDragEnter: setDragActive
  , onFilesDragExit: clearDragActive
  }
  [ dropTargetContent ]"""
  [ propsTable
      [ { name: "onFileDrop", type_: "DroppedData -> Effect Unit", description: "Drop callback ({ files, strings })" }
      , { name: "onFilesDragEnter", type_: "Effect Unit", description: "Drag enter callback" }
      , { name: "onFilesDragExit", type_: "Effect Unit", description: "Drag exit callback" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "The drop target content is passed as the second argument (IsJSX)." ]
  ]
