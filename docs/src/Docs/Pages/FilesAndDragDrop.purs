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
  """nativeFilePicker
  { mode: T.open
  , title: "Choose files"
  , sfSymbol: "doc.badge.plus"
  , message: "Select one or more files"
  , allowedTypes: ["pdf", "txt", "png"]
  , allowMultiple: true
  , canChooseDirectories: false
  , onPickFiles: E.onStrings "files" setFiles
  , onCancel: handler_ (pure unit)
  }"""
  [ propsTable
      [ { name: "mode", type_: "FilePickerMode", description: "open or save" }
      , { name: "title", type_: "String", description: "Dialog title" }
      , { name: "sfSymbol", type_: "String", description: "SF Symbol icon for the button" }
      , { name: "message", type_: "String", description: "Dialog message" }
      , { name: "defaultName", type_: "String", description: "Default file name (save mode)" }
      , { name: "allowedTypes", type_: "Array String", description: "Allowed file extensions" }
      , { name: "allowMultiple", type_: "Boolean", description: "Allow selecting multiple files" }
      , { name: "canChooseDirectories", type_: "Boolean", description: "Allow choosing directories" }
      , { name: "onPickFiles", type_: "EventHandler", description: "Files selected callback" }
      , { name: "onCancel", type_: "EventHandler", description: "Cancel callback" }
      ]
  ]

dropZone :: Nut
dropZone = L.componentDoc "nativeDropZone" "Yoga.React.Native.MacOS.DropZone (nativeDropZone)"
  """-- FFINativeComponent: takes props then children
nativeDropZone
  { onFileDrop: E.onStrings "files" setFiles
  , onFilesDragEnter: handler_ setDragActive
  , onFilesDragExit: handler_ clearDragActive
  }
  [ dropTargetContent ]"""
  [ propsTable
      [ { name: "onFileDrop", type_: "EventHandler", description: "Drop callback with file paths" }
      , { name: "onFilesDragEnter", type_: "EventHandler", description: "Drag enter callback" }
      , { name: "onFilesDragExit", type_: "EventHandler", description: "Drag exit callback" }
      ]
  , D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "The drop target content is passed as the second argument (IsJSX)." ]
  ]
