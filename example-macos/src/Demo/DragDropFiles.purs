module Demo.DragDropFiles (dropZoneDemo, filePickerDemo) where

import Prelude

import Data.String (joinWith)
import Demo.Shared (DemoProps, card, desc, getFieldJSON, label, scrollWrap, sectionTitle)
import React.Basic (JSX)
import React.Basic.Events (handler, handler_, unsafeEventFn)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (nativeEvent, text, tw, view)
import Yoga.React.Native.MacOS.FilePicker (nativeFilePicker)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Style as Style

dropZoneDemo :: DemoProps -> JSX
dropZoneDemo = component "DropZoneDemo" \dp -> React.do
  status /\ setStatus <- useState' "Drop files here"
  dropped /\ setDropped <- useState' ""
  dragging /\ setDragging <- useState' false
  pure do
    let accentBorder = if dragging then "#007AFF" else dp.dimFg
    scrollWrap dp
      [ sectionTitle dp.fg "Drop Zone"
      , desc dp "Drag files from Finder into the area below"
      , view
          { draggedTypes: [ "NSFilenamesPboardType" ]
          , onDrop: handler
              (nativeEvent >>> unsafeEventFn \e -> getFieldJSON "dataTransfer" e)
              \r -> do
                setDropped r
                setStatus "Drop files here"
                setDragging false
          , onDragEnter: handler_ do
              setStatus "Release to drop!"
              setDragging true
          , onDragLeave: handler_ do
              setStatus "Drop files here"
              setDragging false
          , style: tw "rounded-lg items-center justify-center mb-2"
              <> Style.style
                { minHeight: 100.0
                , borderWidth: 2.0
                , borderColor: accentBorder
                , backgroundColor: dp.cardBg
                }
          }
          [ text { style: tw "text-sm" <> Style.style { color: dp.fg } } status
          , if dropped == "" then mempty
            else text { style: tw "text-xs mt-2 px-4" <> Style.style { color: dp.dimFg } }
              ("Dropped: " <> dropped)
          ]
      ]

filePickerDemo :: DemoProps -> JSX
filePickerDemo = component "FilePickerDemo" \dp -> React.do
  picked /\ setPicked <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "File Picker"
      , desc dp "Click buttons to open native file panels"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeFilePicker
                  { mode: T.openFile
                  , title: "Open Files"
                  , sfSymbol: "doc.badge.plus"
                  , allowMultiple: true
                  , allowedTypes: [ "public.image", "public.text" ]
                  , message: "Select files to open"
                  , onPickFiles: \files -> setPicked (joinWith ", " (map _.path files))
                  , onCancel: setPicked "Cancelled"
                  , style: Style.style { height: 24.0, width: 120.0 }
                  }
              , nativeFilePicker
                  { mode: T.openFile
                  , title: "Choose Folder"
                  , sfSymbol: "folder"
                  , canChooseDirectories: true
                  , message: "Select a folder"
                  , onPickFiles: \files -> setPicked (joinWith ", " (map _.path files))
                  , onCancel: setPicked "Cancelled"
                  , style: Style.style { height: 24.0, width: 140.0, marginLeft: 8.0 }
                  }
              , nativeFilePicker
                  { mode: T.saveFile
                  , title: "Save As..."
                  , sfSymbol: "square.and.arrow.down"
                  , defaultName: "Untitled.txt"
                  , allowedTypes: [ "public.plain-text" ]
                  , message: "Choose save location"
                  , onPickFiles: \files -> setPicked (joinWith ", " (map _.path files))
                  , onCancel: setPicked "Cancelled"
                  , style: Style.style { height: 24.0, width: 120.0, marginLeft: 8.0 }
                  }
              ]
          , if picked == "" then mempty
            else label dp.dimFg picked
          ]
      ]
