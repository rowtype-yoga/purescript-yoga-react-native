module Demo.Navigation (outlineSidebar, demoContent) where

import Prelude

import Data.Array (concatMap, null)
import Data.String (toLower, contains, Pattern(..))
import Demo.AiMl (cameraDemo, naturalLanguageDemo, ocrDemo, speechRecognitionDemo)
import Demo.Animation (riveDemo)
import Demo.SpringAnimation (springDemo)
import Demo.Chat (chatDemo)
import Demo.Signal (signalDemo)
import Demo.DataViews (outlineViewDemo, tableViewDemo)
import Demo.Display (animatedImageDemo, imageDemo, levelIndicatorDemo, pathControlDemo, progressDemo, separatorDemo, videoPlayerDemo)
import Demo.DragDropFiles (dropZoneDemo, filePickerDemo)
import Demo.InputControls (buttonDemo, checkboxDemo, colorWellDemo, comboBoxDemo, datePickerDemo, popUpDemo, radioButtonDemo, searchFieldDemo, sliderDemo, stepperDemo, switchDemo, tokenFieldDemo)
import Demo.Layout (boxDemo, splitViewDemo, tabViewDemo)
import Demo.MapsDocs (mapViewDemo, pdfViewDemo)
import Demo.Overlays (alertDemo, contextMenuDemo, menuDemo, popoverDemo, sheetDemo)
import Demo.Shared (DemoProps)
import Demo.SystemServices (clipboardDemo, colorPanelDemo, fontPanelDemo, notificationsDemo, quickLookDemo, shareDemo, soundDemo, speechDemo, statusBarDemo)
import Demo.Terminal (terminalDemo)
import Demo.TextEditing (textEditorDemo, textFieldDemo)
import Demo.WebBrowser (webViewDemo)
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.OutlineView (OutlineItem(..), nativeOutlineView)
import Yoga.React.Native.MacOS.SearchField (nativeSearchField)
import Yoga.React.Native.Style as Style

outlineTree :: Array OutlineItem
outlineTree = do
  let leaf id title symbol = OutlineItem { id, title, sfSymbol: symbol, children: [] }
  let folder id title symbol children = OutlineItem { id, title, sfSymbol: symbol, children }
  [ folder "input" "Input Controls" "slider.horizontal.3"
      [ leaf "button" "Button" "button.horizontal"
      , leaf "switch" "Switch" "switch.2"
      , leaf "slider" "Slider" "slider.horizontal.below.rectangle"
      , leaf "popup" "Pop Up" "chevron.up.chevron.down"
      , leaf "combobox" "Combo Box" "rectangle.and.pencil.and.ellipsis"
      , leaf "stepper" "Stepper" "plus.forwardslash.minus"
      , leaf "datepicker" "Date Picker" "calendar"
      , leaf "colorwell" "Color Well" "paintpalette"
      , leaf "checkbox" "Checkbox" "checkmark.square"
      , leaf "radiobutton" "Radio Button" "circle.inset.filled"
      , leaf "searchfield" "Search Field" "magnifyingglass"
      , leaf "tokenfield" "Token Field" "tag"
      ]
  , folder "text" "Text & Editing" "doc.richtext"
      [ leaf "textfield" "Text Field" "character.cursor.ibeam"
      , leaf "texteditor" "Text Editor" "doc.richtext"
      ]
  , folder "display" "Display" "photo"
      [ leaf "image" "Image" "photo"
      , leaf "animatedimage" "Animated Image" "photo.on.rectangle.angled"
      , leaf "videoplayer" "Video Player" "play.rectangle"
      , leaf "levelindicator" "Level Indicator" "gauge.with.dots.needle.33percent"
      , leaf "progress" "Progress" "chart.bar.fill"
      , leaf "separator" "Separator" "minus"
      , leaf "pathcontrol" "Path Control" "chevron.compact.right"
      ]
  , folder "layout" "Layout & Containers" "rectangle.split.3x1"
      [ leaf "box" "Box" "square.dashed"
      , leaf "splitview" "Split View" "rectangle.split.2x1"
      , leaf "tabview" "Tab View" "rectangle.topthird.inset.filled"
      ]
  , folder "overlays" "Overlays & Dialogs" "rectangle.on.rectangle"
      [ leaf "alert" "Alert" "exclamationmark.triangle"
      , leaf "sheet" "Sheet" "rectangle.bottomhalf.inset.filled"
      , leaf "popover" "Popover" "text.bubble"
      , leaf "contextmenu" "Context Menu" "contextualmenu.and.cursorarrow"
      , leaf "menu" "Menu" "list.bullet"
      ]
  , folder "dataviews" "Data Views" "tablecells"
      [ leaf "tableview" "Table View" "tablecells"
      , leaf "outlineview" "Outline View" "list.bullet.indent"
      ]
  , folder "dragdrop" "Drag & Drop / Files" "doc.badge.plus"
      [ leaf "dropzone" "Drop Zone" "square.and.arrow.down"
      , leaf "filepicker" "File Picker" "folder"
      ]
  , folder "animation" "Animation" "play.circle"
      [ leaf "springs" "Spring Physics" "sparkles"
      , leaf "rive" "Rive" "play.circle"
      ]
  , folder "system" "System Services" "gearshape.2"
      [ leaf "clipboard" "Clipboard" "doc.on.clipboard"
      , leaf "share" "Share" "square.and.arrow.up"
      , leaf "notifications" "Notifications" "bell"
      , leaf "sound" "Sound" "speaker.wave.2"
      , leaf "statusbar" "Status Bar" "menubar.rectangle"
      , leaf "quicklook" "Quick Look" "eye"
      , leaf "colorpanel" "Color Panel" "paintpalette"
      , leaf "fontpanel" "Font Panel" "textformat"
      , leaf "speech" "Speech Synthesis" "speaker.wave.2"
      ]
  , folder "aiml" "AI & ML" "brain"
      [ leaf "ocr" "OCR" "doc.text.viewfinder"
      , leaf "speechrecognition" "Speech Recognition" "mic"
      , leaf "naturallanguage" "Natural Language" "text.magnifyingglass"
      , leaf "camera" "Camera" "video"
      ]
  , folder "mapsdocs" "Maps & Documents" "map"
      [ leaf "mapview" "Map View" "map"
      , leaf "pdfview" "PDF View" "doc.richtext"
      ]
  , folder "webbrowser" "Web Browser" "globe"
      [ leaf "webview" "Web View" "globe"
      ]
  , folder "chat" "Chat" "bubble.left.and.bubble.right"
      [ leaf "matrix" "Matrix" "bubble.left.and.bubble.right"
      , leaf "signal" "Signal" "lock.shield"
      ]
  , folder "terminal" "Terminal" "terminal"
      [ leaf "ghostty" "Ghostty Terminal" "terminal"
      ]
  ]

filterTree :: String -> Array OutlineItem -> Array OutlineItem
filterTree query items = do
  let q = toLower query
  let matchesLeaf (OutlineItem r) = contains (Pattern q) (toLower r.title)
  let
    go (OutlineItem r) = case r.children of
      [] -> if matchesLeaf (OutlineItem r) then [ OutlineItem r ] else []
      kids -> do
        let matched = concatMap go kids
        if null matched then [] else [ OutlineItem (r { children = matched }) ]
  concatMap go items

outlineSidebar :: String -> (String -> Effect Unit) -> JSX
outlineSidebar _ setSelectedItem = sidebarComponent { setSelectedItem }
  where
  sidebarComponent = component "OutlineSidebar" \props -> React.do
    search /\ setSearch <- useState' ""
    let items = if search == "" then outlineTree else filterTree search outlineTree
    pure do
      view { style: tw "flex-1 pt-2" }
        [ nativeSearchField
            { text: search
            , placeholder: "Filter..."
            , onChangeText: setSearch
            , style: Style.style { height: 24.0, marginLeft: 8.0, marginRight: 8.0, marginBottom: 4.0 }
            }
        , nativeOutlineView
            { items
            , headerVisible: false
            , onSelectItem: props.setSelectedItem
            , style: tw "flex-1"
            }
        ]

demoContent :: DemoProps -> String -> JSX
demoContent dp = case _ of
  "button" -> buttonDemo dp
  "switch" -> switchDemo dp
  "slider" -> sliderDemo dp
  "popup" -> popUpDemo dp
  "combobox" -> comboBoxDemo dp
  "stepper" -> stepperDemo dp
  "datepicker" -> datePickerDemo dp
  "colorwell" -> colorWellDemo dp
  "checkbox" -> checkboxDemo dp
  "radiobutton" -> radioButtonDemo dp
  "searchfield" -> searchFieldDemo dp
  "tokenfield" -> tokenFieldDemo dp
  "textfield" -> textFieldDemo dp
  "texteditor" -> textEditorDemo dp
  "image" -> imageDemo dp
  "animatedimage" -> animatedImageDemo dp
  "videoplayer" -> videoPlayerDemo dp
  "levelindicator" -> levelIndicatorDemo dp
  "progress" -> progressDemo dp
  "separator" -> separatorDemo dp
  "pathcontrol" -> pathControlDemo dp
  "box" -> boxDemo dp
  "splitview" -> splitViewDemo dp
  "tabview" -> tabViewDemo dp
  "alert" -> alertDemo dp
  "sheet" -> sheetDemo dp
  "popover" -> popoverDemo dp
  "contextmenu" -> contextMenuDemo dp
  "menu" -> menuDemo dp
  "tableview" -> tableViewDemo dp
  "outlineview" -> outlineViewDemo dp
  "dropzone" -> dropZoneDemo dp
  "filepicker" -> filePickerDemo dp
  "springs" -> springDemo dp
  "rive" -> riveDemo dp
  "clipboard" -> clipboardDemo dp
  "share" -> shareDemo dp
  "notifications" -> notificationsDemo dp
  "sound" -> soundDemo dp
  "statusbar" -> statusBarDemo dp
  "quicklook" -> quickLookDemo dp
  "colorpanel" -> colorPanelDemo dp
  "fontpanel" -> fontPanelDemo dp
  "speech" -> speechDemo dp
  "ocr" -> ocrDemo dp
  "speechrecognition" -> speechRecognitionDemo dp
  "naturallanguage" -> naturalLanguageDemo dp
  "camera" -> cameraDemo dp
  "mapview" -> mapViewDemo dp
  "pdfview" -> pdfViewDemo dp
  "webview" -> webViewDemo dp
  "matrix" -> chatDemo dp
  "signal" -> signalDemo dp
  "ghostty" -> terminalDemo dp
  _ -> placeholder dp

placeholder :: DemoProps -> JSX
placeholder dp =
  view { style: tw "flex-1 items-center justify-center" }
    [ text { style: tw "text-sm" <> Style.style { color: dp.dimFg } } "Select a component from the sidebar" ]
