module Main where

import Prelude

import Data.Array (mapWithIndex, length, filter, null, (!!))
import Data.Nullable (toNullable)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (take, joinWith)
import Data.Foldable (for_, foldl)
import Data.Traversable (for)
import Effect (Effect)
import Data.Either (Either(..))
import Effect.Aff (launchAff_, try)
import Effect.Class (liftEffect)
import React.Basic (JSX)
import React.Basic.Events (handler, handler_, unsafeEventFn)
import React.Basic.Hooks (useState, useState', useEffect, useRef, readRef, writeRef, (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (nativeEvent, registerComponent, safeAreaView, text, tw, view)
import Yoga.React.Native.Appearance (useColorScheme)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.ColorWell (nativeColorWell)
import Yoga.React.Native.MacOS.DatePicker (nativeDatePicker)
import Yoga.React.Native.MacOS.LevelIndicator (nativeLevelIndicator)
import Yoga.React.Native.MacOS.PopUp (nativePopUp)
import Yoga.React.Native.MacOS.Progress (nativeProgress)
import Yoga.React.Native.MacOS.Slider (nativeSlider)
import Yoga.React.Native.MacOS.Switch (nativeSwitch)
import Yoga.React.Native.MacOS.TextField (nativeTextField)
import Yoga.React.Native.MacOS.TextEditor (nativeTextEditor)
import Yoga.React.Native.MacOS.WebView (nativeWebView)
import Yoga.React.Native.MacOS.ScrollView (nativeScrollView)
import Yoga.React.Native.MacOS.Rive (nativeRiveView_)
import Yoga.React.Native.MacOS.Toolbar (nativeToolbar)
import Yoga.React.Native.MacOS.VisualEffect (nativeVisualEffect)
import Yoga.React.Native.MacOS.Sidebar (sidebarLayout)
import Yoga.React.Native.MacOS.ContextMenu (nativeContextMenu)
import Yoga.React.Native.MacOS.FilePicker (nativeFilePicker)
import Yoga.React.Native.MacOS.VideoPlayer (nativeVideoPlayer)
import Yoga.React.Native.MacOS.AnimatedImage (nativeAnimatedImage)
import Yoga.React.Native.MacOS.PatternBackground (nativePatternBackground)
import Yoga.React.Native.MacOS.SplitView (nativeSplitView)
import Yoga.React.Native.MacOS.TabView (nativeTabView)
import Yoga.React.Native.MacOS.ComboBox (nativeComboBox)
import Yoga.React.Native.MacOS.Stepper (nativeStepper)
import Yoga.React.Native.MacOS.Box (nativeBox)
import Yoga.React.Native.MacOS.Popover (nativePopover)
import Yoga.React.Native.MacOS.Image (nativeImage)
import Yoga.React.Native.MacOS.Alert (macosAlert)
import Yoga.React.Native.MacOS.Checkbox (nativeCheckbox)
import Yoga.React.Native.MacOS.RadioButton (nativeRadioButton)
import Yoga.React.Native.MacOS.SearchField (nativeSearchField)
import Yoga.React.Native.MacOS.TokenField (nativeTokenField)
import Yoga.React.Native.MacOS.Separator (nativeSeparator)
import Yoga.React.Native.MacOS.HelpButton (nativeHelpButton)
import Yoga.React.Native.MacOS.PathControl (nativePathControl)
import Yoga.React.Native.MacOS.Sheet (nativeSheet)
import Yoga.React.Native.MacOS.TableView (nativeTableView)
import Yoga.React.Native.MacOS.Menu (macosShowMenu)
import Yoga.React.Native.MacOS.Pasteboard (copyToClipboard)
import Yoga.React.Native.MacOS.OutlineView (nativeOutlineView, OutlineItem(..))
import Yoga.React.Native.MacOS.ShareService (macosShare)
import Yoga.React.Native.MacOS.UserNotification (macosNotify)
import Yoga.React.Native.MacOS.Sound (macosPlaySound, macosBeep)
import Yoga.React.Native.MacOS.StatusBarItem (macosSetStatusBarItem, macosRemoveStatusBarItem)
import Yoga.React.Native.MacOS.MapView (nativeMapView)
import Yoga.React.Native.MacOS.PDFView (nativePDFView)
import Yoga.React.Native.MacOS.QuickLook (macosQuickLook)
import Yoga.React.Native.MacOS.SpeechSynthesizer (say, stopSpeaking)
import Yoga.React.Native.MacOS.ColorPanel (macosShowColorPanel)
import Yoga.React.Native.MacOS.FontPanel (macosShowFontPanel)
import Yoga.React.Native.MacOS.OCR (recognizeText)
import Yoga.React.Native.MacOS.SpeechRecognition (useSpeechRecognition)
import Yoga.React.Native.MacOS.NaturalLanguage (detectLanguage, analyzeSentiment, tokenize)
import Yoga.React.Native.MacOS.CameraView (nativeCameraView)
import Yoga.React.Native.MacOS.Events as E
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Matrix as Matrix
import Yoga.React.Native.Style as Style

-- Shared props for all leaf demos
type DemoProps =
  { fg :: String
  , dimFg :: String
  , cardBg :: String
  , bg :: String
  , isDark :: Boolean
  }

main :: Effect Unit
main = registerComponent "YogaReactExample" \_ -> app {}

app :: {} -> JSX
app = component "App" \_ -> React.do
  selectedItem /\ setSelectedItem <- useState' "button"
  colorScheme <- useColorScheme
  let isDark = toNullable (Just "dark") == colorScheme
  let fg = if isDark then "#FFFFFF" else "#000000"
  let dimFg = if isDark then "#999999" else "#666666"
  let cardBg = if isDark then "#2A2A2A" else "#F0F0F0"
  let bg = if isDark then "#1E1E1E" else "#FFFFFF"
  let dp = { fg, dimFg, cardBg, bg, isDark } :: DemoProps
  pure do
    nativeVisualEffect
      { materialName: T.windowBackground
      , style: tw "flex-1"
      }
      ( safeAreaView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
          ( view { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
              [ nativeToolbar
                  { items: []
                  , selectedItem: ""
                  , toolbarStyle: T.unified
                  , windowTitle: "PureScript React Native"
                  , onSelectItem: handler_ (pure unit)
                  , style: Style.style { height: 0.0, width: 0.0 }
                  }
              , sidebarLayout
                  { sidebar: outlineSidebar selectedItem setSelectedItem
                  , sidebarWidth: 200.0
                  , content: demoContent dp selectedItem
                  }
              ]
          )
      )

-- Outline tree
outlineTree :: Array OutlineItem
outlineTree =
  let
    leaf id title symbol = OutlineItem { id, title, sfSymbol: symbol, children: [] }
    folder id title symbol children = OutlineItem { id, title, sfSymbol: symbol, children }
  in
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
        [ leaf "rive" "Rive" "play.circle"
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
        ]
    ]

outlineSidebar :: String -> (String -> Effect Unit) -> JSX
outlineSidebar selectedItem setSelectedItem =
  view { style: tw "flex-1 pt-2" }
    [ nativeOutlineView
        { items: outlineTree
        , headerVisible: false
        , onSelectItem: E.onString "id" setSelectedItem
        , style: tw "flex-1"
        }
    ]

-- Content dispatch
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
  "matrix" -> matrixDemo dp
  _ -> placeholder dp

placeholder :: DemoProps -> JSX
placeholder dp =
  view { style: tw "flex-1 items-center justify-center" }
    [ text { style: tw "text-sm" <> Style.style { color: dp.dimFg } } "Select a component from the sidebar" ]

-- Input Controls

buttonDemo :: DemoProps -> JSX
buttonDemo = component "ButtonDemo" \dp -> React.do
  status /\ setStatus <- useState' "Ready"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Button"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeButton
                  { title: "Say Hello"
                  , sfSymbol: "hand.wave"
                  , bezelStyle: T.push
                  , primary: true
                  , onPress: handler_ (setStatus "Hello from PureScript!")
                  , style: Style.style { height: 24.0, width: 140.0 }
                  }
              , nativeButton
                  { title: "Reset"
                  , sfSymbol: "arrow.counterclockwise"
                  , bezelStyle: T.push
                  , onPress: handler_ (setStatus "Ready")
                  , style: Style.style { height: 24.0, width: 100.0, marginLeft: 8.0 }
                  }
              , label dp.dimFg status
              ]
          ]
      ]

switchDemo :: DemoProps -> JSX
switchDemo = component "SwitchDemo" \dp -> React.do
  on /\ setOn <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Switch"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeSwitch
                  { on
                  , onChange: E.onBool "on" setOn
                  , style: Style.style { height: 24.0, width: 48.0 }
                  }
              , label dp.dimFg (if on then "On" else "Off")
              ]
          ]
      ]

sliderDemo :: DemoProps -> JSX
sliderDemo = component "SliderDemo" \dp -> React.do
  value /\ setValue <- useState' 50.0
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Slider + Level Indicator + Progress"
      , card dp.cardBg
          [ nativeSlider
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , numberOfTickMarks: 11
              , onChange: E.onNumber "value" setValue
              , style: Style.style { height: 24.0 }
              }
          , label dp.dimFg ("Value: " <> show (round value) <> " / 100")
          , nativeLevelIndicator
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , warningValue: 70.0
              , criticalValue: 90.0
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          , nativeProgress
              { value
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          ]
      ]

popUpDemo :: DemoProps -> JSX
popUpDemo = component "PopUpDemo" \dp -> React.do
  idx /\ setIdx <- useState' 0
  title /\ setTitle <- useState' "Small"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Pop Up Button"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativePopUp
                  { items: [ "Small", "Medium", "Large", "Extra Large" ]
                  , selectedIndex: idx
                  , onChange: handler
                      ( nativeEvent >>> unsafeEventFn \e ->
                          { idx: E.getFieldInt "selectedIndex" e, title: E.getFieldStr "title" e }
                      )
                      \r -> do
                        setIdx r.idx
                        setTitle r.title
                  , style: Style.style { height: 24.0, width: 160.0 }
                  }
              , label dp.dimFg ("Selected: " <> title)
              ]
          ]
      ]

comboBoxDemo :: DemoProps -> JSX
comboBoxDemo = component "ComboBoxDemo" \dp -> React.do
  txt /\ setTxt <- useState' ""
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Combo Box"
      , desc dp "Editable dropdown with autocomplete"
      , card dp.cardBg
          [ nativeComboBox
              { items: [ "Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape" ]
              , text: txt
              , placeholder: "Type a fruit..."
              , onChangeText: E.onString "text" setTxt
              , onSelectItem: E.onString "text" \t -> do
                  setTxt t
                  setResult ("Selected: " <> t)
              , style: Style.style { height: 28.0 } <> tw "mb-2"
              }
          , if result == "" then mempty
            else label dp.dimFg result
          ]
      ]

stepperDemo :: DemoProps -> JSX
stepperDemo = component "StepperDemo" \dp -> React.do
  value /\ setValue <- useState' 5.0
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Stepper"
      , desc dp "Up/down increment control"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ text { style: tw "text-sm mr-3" <> Style.style { color: dp.fg } } "Quantity:"
              , nativeStepper
                  { value
                  , minValue: 0.0
                  , maxValue: 50.0
                  , increment: 1.0
                  , onChange: E.onNumber "value" setValue
                  , style: Style.style { width: 100.0, height: 24.0 }
                  }
              ]
          ]
      ]

datePickerDemo :: DemoProps -> JSX
datePickerDemo = component "DatePickerDemo" \dp -> React.do
  dateText /\ setDateText <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Date Picker"
      , card dp.cardBg
          [ nativeDatePicker
              { graphical: false
              , onChange: E.onString "date" setDateText
              , style: Style.style { height: 24.0, width: 200.0 }
              }
          , if dateText == "" then mempty
            else label dp.dimFg ("Picked: " <> dateText)
          ]
      ]

colorWellDemo :: DemoProps -> JSX
colorWellDemo = component "ColorWellDemo" \dp -> React.do
  color /\ setColor <- useState' "#FF6600"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Color Well"
      , card dp.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeColorWell
                  { color
                  , minimal: true
                  , onChange: E.onString "color" setColor
                  , style: Style.style { height: 32.0, width: 48.0 }
                  }
              , view
                  { style: tw "ml-3 rounded" <> Style.style
                      { width: 24.0, height: 24.0, backgroundColor: color }
                  }
                  []
              , label dp.dimFg color
              ]
          ]
      ]

checkboxDemo :: DemoProps -> JSX
checkboxDemo = component "CheckboxDemo" \dp -> React.do
  a /\ setA <- useState' true
  b /\ setB <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Checkbox"
      , card dp.cardBg
          [ nativeCheckbox
              { checked: a
              , title: "Enable notifications"
              , enabled: true
              , onChange: E.onBool "checked" setA
              , style: Style.style { height: 24.0 } <> tw "mb-1"
              }
          , nativeCheckbox
              { checked: b
              , title: "Dark mode"
              , enabled: true
              , onChange: E.onBool "checked" setB
              , style: Style.style { height: 24.0 }
              }
          ]
      ]

radioButtonDemo :: DemoProps -> JSX
radioButtonDemo = component "RadioButtonDemo" \dp -> React.do
  choice /\ setChoice <- useState' "option1"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Radio Button"
      , card dp.cardBg
          [ nativeRadioButton
              { selected: choice == "option1"
              , title: "Small"
              , enabled: true
              , onChange: handler_ (setChoice "option1")
              , style: Style.style { height: 24.0 } <> tw "mb-1"
              }
          , nativeRadioButton
              { selected: choice == "option2"
              , title: "Medium"
              , enabled: true
              , onChange: handler_ (setChoice "option2")
              , style: Style.style { height: 24.0 } <> tw "mb-1"
              }
          , nativeRadioButton
              { selected: choice == "option3"
              , title: "Large"
              , enabled: true
              , onChange: handler_ (setChoice "option3")
              , style: Style.style { height: 24.0 }
              }
          , label dp.dimFg ("Selected: " <> choice)
          ]
      ]

searchFieldDemo :: DemoProps -> JSX
searchFieldDemo = component "SearchFieldDemo" \dp -> React.do
  query /\ setQuery <- useState' ""
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Search Field"
      , nativeSearchField
          { text: query
          , placeholder: "Search..."
          , onChangeText: E.onString "text" setQuery
          , onSearch: E.onString "text" \t -> setResult ("Searched: " <> t)
          , style: Style.style { height: 28.0 } <> tw "mb-2"
          }
      , if result == "" then mempty
        else label dp.dimFg result
      ]

tokenFieldDemo :: DemoProps -> JSX
tokenFieldDemo = component "TokenFieldDemo" \dp -> React.do
  tokens /\ setTokens <- useState' ([ "PureScript", "React", "macOS" ] :: Array String)
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Token Field"
      , desc dp "Type text and press Enter to add tokens"
      , nativeTokenField
          { tokens
          , placeholder: "Add tags..."
          , onChangeTokens: E.onStrings "tokens" setTokens
          , style: Style.style { height: 28.0 } <> tw "mb-2"
          }
      ]

-- Text & Editing

textFieldDemo :: DemoProps -> JSX
textFieldDemo = component "TextFieldDemo" \dp -> React.do
  txt /\ setTxt <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Text Field"
      , card dp.cardBg
          [ nativeTextField
              { placeholder: "Type something..."
              , search: true
              , text: txt
              , onChangeText: E.onString "text" setTxt
              , style: Style.style { height: 24.0 }
              }
          , if txt == "" then mempty
            else label dp.dimFg ("You typed: " <> txt)
          ]
      ]

textEditorDemo :: DemoProps -> JSX
textEditorDemo = component "TextEditorDemo" \dp -> React.do
  pure do
    view { style: tw "flex-1 px-4" }
      [ sectionTitle dp.fg "Rich Text Editor"
      , nativeTextEditor
          { text: "Welcome to the PureScript-driven native text editor.\n\nThis uses NSTextView with rich text support and a formatting ruler."
          , richText: true
          , showsRuler: true
          , style: tw "flex-1" <> Style.style { minHeight: 300.0 }
          }
      ]

-- Display

imageDemo :: DemoProps -> JSX
imageDemo = component "ImageDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Image"
      , desc dp "Native NSImageView with URL loading and corner radius"
      , nativeImage
          { source: "https://placedog.net/640/400"
          , contentMode: T.scaleProportionally
          , cornerRadius: 12.0
          , style: Style.style { height: 200.0 } <> tw "mb-2"
          }
      ]

animatedImageDemo :: DemoProps -> JSX
animatedImageDemo = component "AnimatedImageDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Animated Image"
      , desc dp "Native NSImageView with animated GIF support"
      , nativeAnimatedImage
          { source: "https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif"
          , animating: true
          , style: Style.style { height: 200.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
      , nativeAnimatedImage
          { source: "https://media.giphy.com/media/13CoXDiaCcCoyk/giphy.gif"
          , animating: true
          , style: Style.style { height: 200.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
      ]

levelIndicatorDemo :: DemoProps -> JSX
levelIndicatorDemo = component "LevelIndicatorDemo" \dp -> React.do
  value /\ setValue <- useState' 50.0
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Level Indicator"
      , card dp.cardBg
          [ nativeSlider
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , numberOfTickMarks: 11
              , onChange: E.onNumber "value" setValue
              , style: Style.style { height: 24.0 }
              }
          , nativeLevelIndicator
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , warningValue: 70.0
              , criticalValue: 90.0
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          ]
      ]

progressDemo :: DemoProps -> JSX
progressDemo = component "ProgressDemo" \dp -> React.do
  value /\ setValue <- useState' 50.0
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Progress"
      , card dp.cardBg
          [ nativeSlider
              { value
              , minValue: 0.0
              , maxValue: 100.0
              , numberOfTickMarks: 11
              , onChange: E.onNumber "value" setValue
              , style: Style.style { height: 24.0 }
              }
          , nativeProgress
              { value
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          ]
      ]

separatorDemo :: DemoProps -> JSX
separatorDemo = component "SeparatorDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Separator"
      , desc dp "Horizontal and vertical separators"
      , nativeSeparator
          { vertical: false
          , style: Style.style { height: 2.0 } <> tw "my-2"
          }
      , text { style: tw "text-xs mb-2" <> Style.style { color: dp.dimFg } } "Content between separators"
      , nativeSeparator
          { vertical: false
          , style: Style.style { height: 2.0 } <> tw "my-2"
          }
      ]

pathControlDemo :: DemoProps -> JSX
pathControlDemo = component "PathControlDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Path Control"
      , nativePathControl
          { url: "/Users"
          , pathStyle: T.standardPath
          , onSelectPath: E.onString "url" \_ -> pure unit
          , style: Style.style { height: 24.0 } <> tw "mb-2"
          }
      ]

-- Layout & Containers

boxDemo :: DemoProps -> JSX
boxDemo = component "BoxDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Box"
      , desc dp "Native NSBox with title and border"
      , nativeBox
          { boxTitle: "Settings"
          , fillColor2: dp.cardBg
          , borderColor2: dp.dimFg
          , radius: 8.0
          , style: Style.style { height: 100.0 } <> tw "mb-2"
          }
          [ view { style: tw "flex-row items-center p-2" }
              [ text { style: tw "text-sm" <> Style.style { color: dp.fg } } "Content inside a native box" ]
          ]
      ]

splitViewDemo :: DemoProps -> JSX
splitViewDemo = component "SplitViewDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Split View"
      , desc dp "Native NSSplitView with resizable divider"
      , nativeSplitView
          { isVertical: true
          , style: Style.style { height: 150.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
          [ view { style: tw "flex-1 p-4" <> Style.style { backgroundColor: dp.cardBg } }
              [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } } "Left Pane"
              , text { style: tw "text-xs mt-1" <> Style.style { color: dp.dimFg } } "Drag the divider to resize"
              ]
          , view { style: tw "flex-1 p-4" <> Style.style { backgroundColor: dp.cardBg } }
              [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } } "Right Pane"
              , text { style: tw "text-xs mt-1" <> Style.style { color: dp.dimFg } } "Content fills available space"
              ]
          ]
      ]

tabViewDemo :: DemoProps -> JSX
tabViewDemo = component "TabViewDemo" \dp -> React.do
  selected /\ setSelected <- useState' "general"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Tab View"
      , desc dp "Native segmented tab bar"
      , nativeTabView
          { items:
              [ { id: "general", label: "General" }
              , { id: "advanced", label: "Advanced" }
              , { id: "about", label: "About" }
              ]
          , selectedItem: selected
          , onSelectTab: E.onString "tabId" setSelected
          , style: Style.style { height: 32.0 } <> tw "mb-2"
          }
      ]

-- Overlays & Dialogs

alertDemo :: DemoProps -> JSX
alertDemo = component "AlertDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Alert"
      , desc dp "Native alert dialog"
      , nativeButton
          { title: "Show Alert"
          , bezelStyle: T.push
          , onPress: handler_ (macosAlert T.warning "Are you sure?" "This action cannot be undone." [ "Cancel", "OK" ])
          , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-4"
          }
      ]

sheetDemo :: DemoProps -> JSX
sheetDemo = component "SheetDemo" \dp -> React.do
  visible /\ setVisible <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Sheet"
      , desc dp "Modal sheet attached to the window"
      , nativeButton
          { title: "Show Sheet"
          , bezelStyle: T.push
          , onPress: handler_ (setVisible true)
          , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-2"
          }
      , nativeSheet
          { visible
          , onDismiss: handler_ (setVisible false)
          }
          [ view { style: tw "p-6" <> Style.style { width: 400.0, height: 200.0 } }
              [ text { style: tw "text-lg font-semibold mb-2" <> Style.style { color: dp.fg } } "Sheet Content"
              , text { style: tw "text-sm mb-4" <> Style.style { color: dp.dimFg } } "This is a native macOS sheet."
              , nativeButton
                  { title: "Dismiss"
                  , bezelStyle: T.push
                  , onPress: handler_ (setVisible false)
                  , style: Style.style { height: 24.0, width: 100.0 }
                  }
              ]
          ]
      ]

popoverDemo :: DemoProps -> JSX
popoverDemo = component "PopoverDemo" \dp -> React.do
  visible /\ setVisible <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Popover"
      , desc dp "Click button to toggle a popover"
      , nativePopover
          { visible
          , preferredEdge: T.bottom
          , behavior: T.transient
          , onClose: handler_ (setVisible false)
          , style: tw "mb-2"
          }
          [ nativeButton
              { title: if visible then "Hide Popover" else "Show Popover"
              , bezelStyle: T.push
              , onPress: handler_ (setVisible (not visible))
              , style: Style.style { height: 24.0, width: 140.0 }
              }
          , view { style: tw "p-4" <> Style.style { width: 200.0, height: 80.0 } }
              [ text { style: tw "text-sm font-semibold" <> Style.style { color: dp.fg } } "Popover Content"
              , text { style: tw "text-xs mt-1" <> Style.style { color: dp.dimFg } } "Click outside to dismiss"
              ]
          ]
      ]

contextMenuDemo :: DemoProps -> JSX
contextMenuDemo = component "ContextMenuDemo" \dp -> React.do
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Context Menu"
      , desc dp "Right-click the area below to open a context menu"
      , nativeContextMenu
          { items:
              [ { id: "cut", title: "Cut", sfSymbol: "scissors" }
              , { id: "copy", title: "Copy", sfSymbol: "doc.on.doc" }
              , { id: "paste", title: "Paste", sfSymbol: "doc.on.clipboard" }
              , { id: "sep", title: "-", sfSymbol: "" }
              , { id: "delete", title: "Delete", sfSymbol: "trash" }
              , { id: "selectAll", title: "Select All", sfSymbol: "selection.pin.in.out" }
              ]
          , onSelectItem: E.onString "itemId" setResult
          , style: Style.style {}
          }
          ( card dp.cardBg
              [ view { style: tw "items-center justify-center" <> Style.style { minHeight: 80.0 } }
                  [ text { style: tw "text-sm" <> Style.style { color: dp.fg } } "Right-click me!"
                  , if result == "" then mempty
                    else label dp.dimFg ("Selected: " <> result)
                  ]
              ]
          )
      ]

menuDemo :: DemoProps -> JSX
menuDemo = component "MenuDemo" \dp -> React.do
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Menu"
      , desc dp "Imperative popup menu at mouse position"
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeButton
              { title: "Show Menu"
              , bezelStyle: T.push
              , onPress: handler_
                  ( macosShowMenu
                      [ { title: "New File", id: "new" }
                      , { title: "Open...", id: "open" }
                      , { title: "-", id: "sep" }
                      , { title: "Save", id: "save" }
                      , { title: "Save As...", id: "saveAs" }
                      ]
                      \itemId -> setResult ("Menu: " <> itemId)
                  )
              , style: Style.style { height: 24.0, width: 120.0 }
              }
          , if result == "" then mempty
            else text { style: tw "text-xs ml-3" <> Style.style { color: dp.dimFg } } result
          ]
      ]

-- Data Views

tableViewDemo :: DemoProps -> JSX
tableViewDemo = component "TableViewDemo" \dp -> React.do
  selected /\ setSelected <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Table View"
      , desc dp "Native NSTableView with columns and rows"
      , nativeTableView
          { columns:
              [ { id: "name", title: "Name", width: 150.0 }
              , { id: "type", title: "Type", width: 100.0 }
              , { id: "size", title: "Size", width: 80.0 }
              ]
          , rows:
              [ [ "Main.purs", "PureScript", "12 KB" ]
              , [ "App.tsx", "TypeScript", "8 KB" ]
              , [ "style.css", "CSS", "3 KB" ]
              , [ "index.html", "HTML", "1 KB" ]
              , [ "package.json", "JSON", "2 KB" ]
              ]
          , headerVisible: true
          , alternatingRows: true
          , onSelectRow: E.onInt "rowIndex" \i -> setSelected ("Row " <> show i)
          , onDoubleClickRow: E.onInt "rowIndex" \i -> setSelected ("Double-clicked row " <> show i)
          , style: Style.style { height: 180.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
      , if selected == "" then mempty
        else label dp.dimFg selected
      ]

outlineViewDemo :: DemoProps -> JSX
outlineViewDemo = component "OutlineViewDemo" \dp -> React.do
  selection /\ setSelection <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Outline View"
      , desc dp "Hierarchical tree list (NSOutlineView)"
      , nativeOutlineView
          { items:
              let
                file id title = OutlineItem { id, title, sfSymbol: "doc", children: [] }
                folder id title children = OutlineItem { id, title, sfSymbol: "folder", children }
              in
                [ folder "src" "src"
                    [ file "main" "Main.purs"
                    , folder "macos" "MacOS"
                        [ file "btn" "Button.purs"
                        , file "sl" "Slider.purs"
                        , file "sw" "Switch.purs"
                        ]
                    ]
                , folder "test" "test"
                    [ file "t1" "MacOSComponents.test.js"
                    , file "t2" "MacOSSnapshots.test.js"
                    ]
                , OutlineItem { id: "pkg", title: "package.json", sfSymbol: "doc.text", children: [] }
                ]
          , headerVisible: false
          , onSelectItem: E.onString "id" setSelection
          , style: Style.style { height: 200.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
      , if selection == "" then mempty
        else label dp.dimFg ("Selected: " <> selection)
      ]

-- Drag & Drop / Files

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
                  , onPickFiles: handler
                      (nativeEvent >>> unsafeEventFn \e -> getFieldJSON "files" e)
                      setPicked
                  , onCancel: handler_ (setPicked "Cancelled")
                  , style: Style.style { height: 24.0, width: 120.0 }
                  }
              , nativeFilePicker
                  { mode: T.openFile
                  , title: "Choose Folder"
                  , sfSymbol: "folder"
                  , canChooseDirectories: true
                  , message: "Select a folder"
                  , onPickFiles: handler
                      (nativeEvent >>> unsafeEventFn \e -> getFieldJSON "files" e)
                      setPicked
                  , onCancel: handler_ (setPicked "Cancelled")
                  , style: Style.style { height: 24.0, width: 140.0, marginLeft: 8.0 }
                  }
              , nativeFilePicker
                  { mode: T.saveFile
                  , title: "Save As..."
                  , sfSymbol: "square.and.arrow.down"
                  , defaultName: "Untitled.txt"
                  , allowedTypes: [ "public.plain-text" ]
                  , message: "Choose save location"
                  , onPickFiles: handler
                      (nativeEvent >>> unsafeEventFn \e -> getFieldJSON "files" e)
                      setPicked
                  , onCancel: handler_ (setPicked "Cancelled")
                  , style: Style.style { height: 24.0, width: 120.0, marginLeft: 8.0 }
                  }
              ]
          , if picked == "" then mempty
            else label dp.dimFg picked
          ]
      ]

-- Animation

riveDemo :: DemoProps -> JSX
riveDemo = component "RiveDemo" \dp -> React.do
  pure do
    nativeScrollView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
      ( view { style: tw "px-4 pb-4" }
          [ sectionTitle dp.fg "Mouse Tracking"
          , text { style: tw "text-xs mb-2" <> Style.style { color: dp.fg } }
              "Move your cursor over the cat — it follows your mouse!"
          , nativeRiveView_
              { resourceName: "cat_following_mouse"
              , stateMachineName: "State Machine 1"
              , fit: T.contain
              , autoplay: true
              , style: Style.style { height: 300.0 }
              }
          , sectionTitle dp.fg "Cursor Tracking"
          , text { style: tw "text-xs mb-2" <> Style.style { color: dp.fg } }
              "Shapes follow your cursor via Pointer Move listeners"
          , nativeRiveView_
              { resourceName: "cursor_tracking"
              , stateMachineName: "State Machine 1"
              , fit: T.contain
              , autoplay: true
              , style: Style.style { height: 300.0 }
              }
          , sectionTitle dp.fg "Interactive Rive Animations"
          , text { style: tw "text-xs mb-2" <> Style.style { color: dp.fg } }
              "Click the stars to rate! State machine handles interaction."
          , nativeRiveView_
              { resourceName: "rating_animation"
              , stateMachineName: "State Machine 1"
              , fit: T.contain
              , autoplay: true
              , style: Style.style { height: 200.0 }
              }
          , sectionTitle dp.fg "Light Switch"
          , text { style: tw "text-xs mb-2" <> Style.style { color: dp.fg } }
              "Click to toggle"
          , nativeRiveView_
              { resourceName: "switch_event_example"
              , stateMachineName: "State Machine 1"
              , fit: T.contain
              , autoplay: true
              , style: Style.style { height: 200.0 }
              }
          , sectionTitle dp.fg "Windy Tree"
          , nativeRiveView_
              { resourceName: "windy_tree"
              , fit: T.cover
              , autoplay: true
              , style: tw "flex-1" <> Style.style { minHeight: 300.0, backgroundColor: dp.bg }
              }
          ]
      )

-- System Services

clipboardDemo :: DemoProps -> JSX
clipboardDemo = component "ClipboardDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Clipboard"
      , desc dp "Read and write the system clipboard"
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeButton
              { title: "Copy 'Hello'"
              , bezelStyle: T.push
              , onPress: handler_ (copyToClipboard "Hello from PureScript!")
              , style: Style.style { height: 24.0, width: 120.0 }
              }
          ]
      ]

shareDemo :: DemoProps -> JSX
shareDemo = component "ShareDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Share"
      , desc dp "System share picker"
      , nativeButton
          { title: "Share Text"
          , sfSymbol: "square.and.arrow.up"
          , bezelStyle: T.push
          , onPress: handler_ (macosShare [ "Hello from PureScript React Native!" ])
          , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-2"
          }
      ]

notificationsDemo :: DemoProps -> JSX
notificationsDemo = component "NotificationsDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Notifications"
      , desc dp "System notifications (requires permission)"
      , nativeButton
          { title: "Send Notification"
          , sfSymbol: "bell"
          , bezelStyle: T.push
          , onPress: handler_ (macosNotify "PureScript" "Hello from React Native macOS!")
          , style: Style.style { height: 24.0, width: 160.0 } <> tw "mb-2"
          }
      ]

soundDemo :: DemoProps -> JSX
soundDemo = component "SoundDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Sound"
      , desc dp "Play system sounds"
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeButton
              { title: "Glass"
              , bezelStyle: T.push
              , onPress: handler_ (macosPlaySound "Glass")
              , style: Style.style { height: 24.0, width: 80.0 }
              }
          , nativeButton
              { title: "Ping"
              , bezelStyle: T.push
              , onPress: handler_ (macosPlaySound "Ping")
              , style: Style.style { height: 24.0, width: 80.0, marginLeft: 8.0 }
              }
          , nativeButton
              { title: "Beep"
              , bezelStyle: T.push
              , onPress: handler_ macosBeep
              , style: Style.style { height: 24.0, width: 80.0, marginLeft: 8.0 }
              }
          ]
      ]

statusBarDemo :: DemoProps -> JSX
statusBarDemo = component "StatusBarDemo" \dp -> React.do
  active /\ setActive <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Status Bar"
      , desc dp "Menu bar icon with dropdown"
      , view { style: tw "flex-row items-center mb-4" }
          [ nativeButton
              { title: if active then "Remove" else "Add to Menu Bar"
              , sfSymbol: if active then "minus.circle" else "plus.circle"
              , bezelStyle: T.push
              , onPress: handler_
                  ( if active then do
                      macosRemoveStatusBarItem
                      setActive false
                    else do
                      macosSetStatusBarItem
                        { title: ""
                        , sfSymbol: "swift"
                        , menuItems:
                            [ { id: "about", title: "About PureScript RN" }
                            , { id: "sep", title: "-" }
                            , { id: "quit", title: "Quit" }
                            ]
                        }
                      setActive true
                  )
              , style: Style.style { height: 24.0, width: 180.0 }
              }
          ]
      ]

quickLookDemo :: DemoProps -> JSX
quickLookDemo = component "QuickLookDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Quick Look"
      , desc dp "Preview files with QLPreviewPanel"
      , view { style: tw "flex-row items-center mb-4" }
          [ nativeButton
              { title: "Preview /etc/hosts"
              , sfSymbol: "eye"
              , bezelStyle: T.push
              , onPress: handler_ (macosQuickLook "/etc/hosts")
              , style: Style.style { height: 24.0, width: 180.0 }
              }
          ]
      ]

colorPanelDemo :: DemoProps -> JSX
colorPanelDemo = component "ColorPanelDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Color Picker"
      , desc dp "System color panel (NSColorPanel)"
      , view { style: tw "flex-row items-center mb-4" }
          [ nativeButton
              { title: "Show Color Panel"
              , sfSymbol: "paintpalette"
              , bezelStyle: T.push
              , onPress: handler_ macosShowColorPanel
              , style: Style.style { height: 24.0, width: 180.0 }
              }
          ]
      ]

fontPanelDemo :: DemoProps -> JSX
fontPanelDemo = component "FontPanelDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Font Panel"
      , desc dp "System font panel (NSFontPanel)"
      , view { style: tw "flex-row items-center mb-4" }
          [ nativeButton
              { title: "Show Font Panel"
              , sfSymbol: "textformat"
              , bezelStyle: T.push
              , onPress: handler_ macosShowFontPanel
              , style: Style.style { height: 24.0, width: 180.0 }
              }
          ]
      ]

speechDemo :: DemoProps -> JSX
speechDemo = component "SpeechDemo" \dp -> React.do
  txt /\ setTxt <- useState' "Hello from PureScript React Native on macOS!"
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Speech Synthesis"
      , desc dp "Text-to-speech (NSSpeechSynthesizer)"
      , nativeTextField
          { text: txt
          , placeholder: "Text to speak..."
          , onChangeText: E.onString "text" setTxt
          , style: Style.style { height: 24.0 } <> tw "mb-2"
          }
      , view { style: tw "flex-row items-center mb-4" }
          [ nativeButton
              { title: "Speak"
              , sfSymbol: "speaker.wave.2"
              , bezelStyle: T.push
              , onPress: handler_ (say txt)
              , style: Style.style { height: 24.0, width: 100.0 }
              }
          , nativeButton
              { title: "Stop"
              , sfSymbol: "stop.circle"
              , bezelStyle: T.push
              , onPress: handler_ stopSpeaking
              , style: Style.style { height: 24.0, width: 100.0, marginLeft: 8.0 }
              }
          ]
      ]

-- AI & ML

ocrDemo :: DemoProps -> JSX
ocrDemo = component "OCRDemo" \dp -> React.do
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "OCR (Vision)"
      , desc dp "Recognize text in images (VNRecognizeTextRequest)"
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeFilePicker
              { mode: T.openFile
              , allowedTypes: [ "public.image" ]
              , title: "Pick Image"
              , sfSymbol: "photo"
              , onPickFiles: handler
                  (nativeEvent >>> unsafeEventFn \e -> E.getFieldArray "files" e)
                  \paths -> for_ paths \path -> do
                    setResult "Recognizing..."
                    launchAff_ do
                      r <- recognizeText path
                      liftEffect (setResult r)
              , style: Style.style { height: 24.0, width: 140.0 }
              }
          ]
      , if result /= "" then view { style: tw "p-2 rounded mb-4" <> Style.style { backgroundColor: dp.cardBg } }
          [ text { style: tw "text-xs font-mono" <> Style.style { color: dp.fg } } result ]
        else mempty
      ]

speechRecognitionDemo :: DemoProps -> JSX
speechRecognitionDemo = component "SpeechRecognitionDemo" \dp -> React.do
  speech <- useSpeechRecognition
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Speech Recognition"
      , desc dp "Live microphone-to-text (click Start, speak, click Stop)"
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeButton
              { title: if speech.listening then "Listening..." else "Start"
              , sfSymbol: if speech.listening then "mic.fill" else "mic"
              , bezelStyle: T.push
              , onPress: handler_ speech.start
              , style: Style.style { height: 24.0, width: 130.0 }
              }
          , nativeButton
              { title: "Stop"
              , sfSymbol: "stop.circle"
              , bezelStyle: T.push
              , onPress: handler_ speech.stop
              , style: Style.style { height: 24.0, width: 80.0, marginLeft: 8.0 }
              }
          ]
      , if speech.transcript /= "" then view { style: tw "p-2 rounded mb-4" <> Style.style { backgroundColor: dp.cardBg } }
          [ text { style: tw "text-xs font-mono" <> Style.style { color: dp.fg } } speech.transcript ]
        else mempty
      ]

naturalLanguageDemo :: DemoProps -> JSX
naturalLanguageDemo = component "NaturalLanguageDemo" \dp -> React.do
  txt /\ setTxt <- useState' "I love this amazing app! C'est magnifique."
  result /\ setResult <- useState' ""
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Natural Language"
      , desc dp "Language detection, sentiment, tokenization (NaturalLanguage.framework)"
      , nativeTextField
          { text: txt
          , placeholder: "Enter text to analyze..."
          , onChangeText: E.onString "text" setTxt
          , style: Style.style { height: 24.0 } <> tw "mb-2"
          }
      , view { style: tw "flex-row items-center mb-2" }
          [ nativeButton
              { title: "Language"
              , sfSymbol: "globe"
              , bezelStyle: T.push
              , onPress: handler_ $ launchAff_ do
                  lang <- detectLanguage txt
                  liftEffect (setResult ("Language: " <> lang))
              , style: Style.style { height: 24.0, width: 110.0 }
              }
          , nativeButton
              { title: "Sentiment"
              , sfSymbol: "face.smiling"
              , bezelStyle: T.push
              , onPress: handler_ $ launchAff_ do
                  score <- analyzeSentiment txt
                  liftEffect (setResult ("Sentiment: " <> show score))
              , style: Style.style { height: 24.0, width: 110.0, marginLeft: 8.0 }
              }
          , nativeButton
              { title: "Tokenize"
              , sfSymbol: "text.word.spacing"
              , bezelStyle: T.push
              , onPress: handler_ $ launchAff_ do
                  tokens <- tokenize txt
                  liftEffect (setResult ("Tokens: " <> joinWith ", " tokens))
              , style: Style.style { height: 24.0, width: 110.0, marginLeft: 8.0 }
              }
          ]
      , if result /= "" then view { style: tw "p-2 rounded mb-4" <> Style.style { backgroundColor: dp.cardBg } }
          [ text { style: tw "text-xs font-mono" <> Style.style { color: dp.fg } } result ]
        else mempty
      ]

cameraDemo :: DemoProps -> JSX
cameraDemo = component "CameraDemo" \dp -> React.do
  on /\ setOn <- useState' false
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Camera"
      , desc dp "Live camera preview (AVCaptureVideoPreviewLayer)"
      , nativeButton
          { title: if on then "Stop Camera" else "Start Camera"
          , sfSymbol: if on then "video.slash" else "video"
          , bezelStyle: T.push
          , onPress: handler_ (setOn (not on))
          , style: Style.style { height: 24.0, width: 140.0 } <> tw "mb-2"
          }
      , if on then nativeCameraView
          { active: true
          , style: Style.style { height: 240.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
        else mempty
      ]

-- Maps & Documents

mapViewDemo :: DemoProps -> JSX
mapViewDemo = component "MapViewDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Map View"
      , desc dp "Embedded MKMapView (San Francisco)"
      , nativeMapView
          { latitude: 37.7749
          , longitude: -122.4194
          , latitudeDelta: 0.05
          , longitudeDelta: 0.05
          , mapType: T.standardMap
          , showsUserLocation: false
          , annotations:
              [ { latitude: 37.7749, longitude: -122.4194, title: "San Francisco", subtitle: "California" }
              , { latitude: 37.8199, longitude: -122.4783, title: "Golden Gate Bridge", subtitle: "" }
              ]
          , style: Style.style { height: 250.0 }
          }
      ]

pdfViewDemo :: DemoProps -> JSX
pdfViewDemo = component "PDFViewDemo" \dp -> React.do
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "PDF Viewer"
      , desc dp "PDFKit document viewer"
      , nativePDFView
          { source: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
          , autoScales: true
          , displayMode: T.singlePageContinuous
          , style: Style.style { height: 300.0 }
          }
      ]

-- Web Browser

webViewDemo :: DemoProps -> JSX
webViewDemo = component "WebViewDemo" \dp -> React.do
  url /\ setUrl <- useState' "https://pursuit.purescript.org"
  urlBar /\ setUrlBar <- useState' "https://pursuit.purescript.org"
  pure do
    view { style: tw "flex-1 px-4" }
      [ sectionTitle dp.fg "Web Browser"
      , nativeTextField
          { text: urlBar
          , placeholder: "Enter URL..."
          , search: false
          , onChangeText: E.onString "text" setUrlBar
          , onSubmit: E.onString "text" setUrl
          , style: Style.style { height: 24.0, marginBottom: 8.0 }
          }
      , nativeWebView
          { url
          , onFinishLoad: handler
              ( nativeEvent >>> unsafeEventFn \e ->
                  { url: E.getFieldStr "url" e, title: E.getFieldStr "title" e }
              )
              \r -> setUrlBar r.url
          , style: tw "flex-1" <> Style.style { minHeight: 400.0 }
          }
      ]

-- Video Player

videoPlayerDemo :: DemoProps -> JSX
videoPlayerDemo = component "VideoPlayerDemo" \dp -> React.do
  playing /\ setPlaying <- useState' true
  pure do
    scrollWrap dp
      [ sectionTitle dp.fg "Video Player"
      , desc dp "Native AVPlayerView with floating controls"
      , nativeVideoPlayer
          { source: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4"
          , playing
          , looping: true
          , muted: false
          , style: Style.style { height: 240.0 } <> tw "rounded-lg overflow-hidden mb-2"
          }
      , view { style: tw "flex-row mb-2" }
          [ nativeButton
              { title: if playing then "Pause" else "Play"
              , sfSymbol: if playing then "pause.fill" else "play.fill"
              , bezelStyle: T.push
              , onPress: handler_ (setPlaying (not playing))
              , style: Style.style { height: 24.0, width: 100.0 }
              }
          ]
      ]

-- Chat (Matrix)

type Message =
  { sender :: String
  , body :: String
  , kind :: String
  , eventId :: String
  }

type Session =
  { homeserver :: String
  , accessToken :: String
  , userId :: String
  }

type Room =
  { roomId :: String
  , name :: String
  , lastMessage :: String
  }

avatarColors :: Array String
avatarColors = [ "#5856D6", "#FF9500", "#34C759", "#FF2D55", "#5AC8FA", "#FF6B6B", "#4ECDC4", "#45B7D1" ]

avatarColor :: String -> String
avatarColor roomId = fromMaybe "#5856D6" (avatarColors !! (mod (hashCode roomId) (length avatarColors)))
  where
  hashCode s = abs (foldl (\acc c -> acc * 31 + c) 0 (charCodes s))

foreign import charCodes :: String -> Array Int
foreign import abs :: Int -> Int

matrixDemo :: DemoProps -> JSX
matrixDemo = component "MatrixDemo" \dp -> React.do
  session /\ setSession <- useState' (Nothing :: Maybe Session)
  rooms /\ setRooms <- useState' ([] :: Array Room)
  activeRoom /\ setActiveRoom <- useState' (Nothing :: Maybe String)
  messages /\ setMessages <- useState ([] :: Array Message)
  inputText /\ setInputText <- useState' ""
  loginError /\ setLoginError <- useState' ""
  loginServer /\ setLoginServer <- useState' "https://matrix.org"
  loginUser /\ setLoginUser <- useState' ""
  loginPass /\ setLoginPass <- useState' ""
  syncTokenRef <- useRef ""
  activeRoomRef <- useRef (Nothing :: Maybe String)
  sessionRef <- useRef (Nothing :: Maybe Session)
  seenIdsRef <- useRef ([] :: Array String)

  useEffect session do
    case session of
      Nothing -> pure mempty
      Just sess -> do
        writeRef sessionRef (Just sess)
        let
          doSync = launchAff_ do
            token <- readRef syncTokenRef # liftEffect
            result <- try (Matrix.sync sess.homeserver sess.accessToken token 5000)
            case result of
              Left _ -> pure unit
              Right resp -> liftEffect do
                let nextBatch = Matrix.getSyncNextBatch resp
                writeRef syncTokenRef nextBatch
                let roomIds = Matrix.getSyncJoinedRoomIds resp
                currentRoom <- readRef activeRoomRef
                for_ roomIds \rid -> do
                  let events = Matrix.getSyncTimelineEvents resp rid
                  let msgEvents = filter (\ev -> Matrix.getEventType ev == "m.room.message") events
                  case currentRoom of
                    Just cr | cr == rid -> do
                      seen <- readRef seenIdsRef
                      let newMsgs = filter (\ev -> not (Matrix.getEventId ev `elem` seen)) msgEvents
                      let
                        converted = newMsgs <#> \ev ->
                          { sender: Matrix.getEventSender ev
                          , body: Matrix.getEventBody ev
                          , kind: eventKind ev
                          , eventId: Matrix.getEventId ev
                          }
                      if null converted then pure unit
                      else do
                        let newIds = converted <#> _.eventId
                        writeRef seenIdsRef (seen <> newIds)
                        setMessages \msgs -> msgs <> converted
                    _ -> pure unit
        timerId <- setInterval 3000 doSync
        doSync
        pure (clearInterval timerId)

  let
    doLogin = launchAff_ do
      result <- try (Matrix.login loginServer loginUser loginPass)
      case result of
        Left _ -> liftEffect (setLoginError "Login failed. Check credentials.")
        Right resp -> do
          let sess = { homeserver: loginServer, accessToken: resp.access_token, userId: resp.user_id }
          roomIds <- try (Matrix.joinedRooms loginServer resp.access_token)
          case roomIds of
            Left _ -> liftEffect do
              setSession (Just sess)
              setLoginError ""
            Right rids -> do
              names <- for rids \rid -> do
                n <- try (Matrix.roomName loginServer resp.access_token rid)
                let
                  name = case n of
                    Left _ -> rid
                    Right "" -> rid
                    Right nm -> nm
                pure { roomId: rid, name, lastMessage: "" }
              liftEffect do
                setSession (Just sess)
                setRooms names
                setLoginError ""

    selectRoom sess rid = do
      setActiveRoom (Just rid)
      writeRef activeRoomRef (Just rid)
      setMessages (const [])
      writeRef seenIdsRef []
      launchAff_ do
        result <- try (Matrix.sync sess.homeserver sess.accessToken "" 0)
        case result of
          Left _ -> pure unit
          Right resp -> liftEffect do
            let events = Matrix.getSyncTimelineEvents resp rid
            let msgEvents = filter (\ev -> Matrix.getEventType ev == "m.room.message") events
            let
              converted = msgEvents <#> \ev ->
                { sender: Matrix.getEventSender ev
                , body: Matrix.getEventBody ev
                , kind: eventKind ev
                , eventId: Matrix.getEventId ev
                }
            let ids = converted <#> _.eventId
            writeRef seenIdsRef ids
            setMessages (const converted)

    sendMessage sess rid msg = do
      if msg == "" then pure unit
      else do
        setInputText ""
        launchAff_ do
          txnId <- Matrix.genTxnId # liftEffect
          _ <- try (Matrix.sendMessage sess.homeserver sess.accessToken rid txnId msg)
          pure unit

    sentBubbleBg = if dp.isDark then "#65B86A" else "#5CB85C"
    receivedBubbleBg = if dp.isDark then "#3B3B3D" else "#FFFFFF"
    chatBg = if dp.isDark then "#17212B" else "#E8DFD3"

    loginForm = view
      { style: tw "flex-1 items-center justify-center"
          <> Style.style { backgroundColor: chatBg }
      }
      [ view { style: tw "rounded-xl p-6" <> Style.style { backgroundColor: dp.cardBg, width: 340.0 } }
          [ text { style: tw "text-lg font-bold mb-4 text-center" <> Style.style { color: dp.fg } } "Matrix Login"
          , text { style: tw "text-xs mb-1" <> Style.style { color: dp.dimFg } } "Homeserver"
          , nativeTextField
              { text: loginServer
              , placeholder: "https://matrix.org"
              , search: false
              , rounded: true
              , onChangeText: E.onString "text" setLoginServer
              , onSubmit: handler_ (pure unit)
              , style: tw "mb-3" <> Style.style { height: 28.0 }
              }
          , text { style: tw "text-xs mb-1" <> Style.style { color: dp.dimFg } } "Username"
          , nativeTextField
              { text: loginUser
              , placeholder: "username"
              , search: false
              , rounded: true
              , onChangeText: E.onString "text" setLoginUser
              , onSubmit: handler_ (pure unit)
              , style: tw "mb-3" <> Style.style { height: 28.0 }
              }
          , text { style: tw "text-xs mb-1" <> Style.style { color: dp.dimFg } } "Password"
          , nativeTextField
              { text: loginPass
              , placeholder: "password"
              , search: false
              , rounded: true
              , onChangeText: E.onString "text" setLoginPass
              , onSubmit: handler_ doLogin
              , style: tw "mb-4" <> Style.style { height: 28.0 }
              }
          , if loginError /= "" then
              text { style: tw "text-xs mb-2 text-center" <> Style.style { color: "#FF3B30" } } loginError
            else text { style: Style.style { height: 0.0 } } ""
          , nativeButton
              { title: "Sign In"
              , bezelStyle: T.push
              , sfSymbol: "arrow.right.circle.fill"
              , onPress: handler_ doLogin
              , style: Style.style { height: 32.0 }
              }
          ]
      ]

    roomSidebar sess = view { style: tw "pt-2" }
      ( rooms <#> \r ->
          view
            { style: tw "flex-row items-center px-3 py-2 mx-2 rounded-lg"
                <> Style.style
                  { backgroundColor: if activeRoom == Just r.roomId then (if dp.isDark then "#2B5278" else "#419FD9") else "transparent" }
            }
            [ view
                { style: tw "rounded-full items-center justify-center"
                    <> Style.style { width: 32.0, height: 32.0, backgroundColor: avatarColor r.roomId }
                }
                [ text { style: tw "text-xs font-bold" <> Style.style { color: "#FFFFFF" } } (take 1 r.name) ]
            , view { style: tw "ml-2 flex-1" }
                [ text
                    { style: tw "text-sm font-semibold"
                        <> Style.style { color: if activeRoom == Just r.roomId then "#FFFFFF" else dp.fg }
                    }
                    r.name
                , text
                    { style: tw "text-xs"
                        <> Style.style { color: if activeRoom == Just r.roomId then "#FFFFFFCC" else dp.dimFg }
                    }
                    r.lastMessage
                ]
            , nativeButton
                { title: ""
                , bezelStyle: T.toolbar
                , sfSymbol: ""
                , onPress: handler_ (selectRoom sess r.roomId)
                , style: Style.style { position: "absolute", top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, opacity: 0.0 }
                }
            ]
      )

    messageBubble sess _ msg = do
      let
        isMine = case sess of
          Just s -> msg.sender == s.userId
          Nothing -> false
      let align = if isMine then "flex-end" else "flex-start"
      let bigEmoji = msg.kind == "text" && isSingleEmoji msg.body
      let senderLabel = if isMine then "" else msg.sender
      nativeContextMenu
        { items:
            [ { id: "copy", title: "Copy", sfSymbol: "doc.on.doc" }
            , { id: "reply", title: "Reply", sfSymbol: "arrowshape.turn.up.left" }
            , { id: "sep", title: "-", sfSymbol: "" }
            , { id: "delete", title: "Delete", sfSymbol: "trash" }
            ]
        , onSelectItem: handler_ (pure unit)
        , style: tw "px-3 mb-1"
        }
        ( view { style: Style.style { alignSelf: align, maxWidth: 320.0 } }
            [ if senderLabel == "" then text { style: Style.style { height: 0.0 } } ""
              else text { style: tw "text-xs mb-0.5" <> Style.style { color: dp.dimFg } } senderLabel
            , if bigEmoji then
                text
                  { style: Style.style { fontSize: 64.0, lineHeight: 72.0 } }
                  msg.body
              else
                view
                  { style: tw "rounded-2xl px-3 py-2"
                      <> Style.style
                        { backgroundColor: if isMine then sentBubbleBg else receivedBubbleBg }
                  }
                  [ text
                      { style: tw "text-sm"
                          <> Style.style { color: if isMine then "#FFFFFF" else (if dp.isDark then "#FFFFFF" else "#000000") }
                      }
                      msg.body
                  ]
            ]
        )

    activeRoomName = case activeRoom of
      Nothing -> "Select a room"
      Just rid -> fromMaybe rid (map _.name (filter (\r -> r.roomId == rid) rooms !! 0))

    chatView sess = sidebarLayout
      { sidebar: roomSidebar sess
      , sidebarWidth: 220.0
      , content: view { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
          [ view
              { style: tw "px-4 py-2 border-b"
                  <> Style.style { borderBottomWidth: 0.5, borderColor: dp.dimFg, backgroundColor: "transparent" }
              }
              [ text { style: tw "text-base font-semibold" <> Style.style { color: dp.fg } } activeRoomName ]
          , nativePatternBackground
              { patternColor: if dp.isDark then "#FFFFFF" else "#000000"
              , background: chatBg
              , patternOpacity: if dp.isDark then 0.04 else 0.06
              , patternScale: 1.0
              , style: tw "flex-1"
              }
              ( nativeScrollView { scrollToBottom: length messages, style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
                  ( view { style: tw "py-2 pr-3" }
                      (mapWithIndex (messageBubble session) messages)
                  )
              )
          , view
              { style: tw "flex-row items-center px-3 py-2"
                  <> Style.style { borderTopWidth: 0.5, borderColor: dp.dimFg, backgroundColor: "transparent" }
              }
              ( case activeRoom of
                  Nothing ->
                    [ text { style: tw "text-sm" <> Style.style { color: dp.dimFg } } "Select a room to start chatting" ]
                  Just rid ->
                    [ nativeTextField
                        { text: inputText
                        , placeholder: "Message..."
                        , search: false
                        , rounded: true
                        , onChangeText: E.onString "text" setInputText
                        , onSubmit: E.onString "text" \t -> sendMessage sess rid t
                        , style: tw "flex-1" <> Style.style { height: 28.0 }
                        }
                    , nativeButton
                        { title: ""
                        , sfSymbol: "paperplane.fill"
                        , bezelStyle: T.toolbar
                        , onPress: handler_ (sendMessage sess rid inputText)
                        , style: Style.style { height: 28.0, width: 36.0, marginLeft: 8.0 }
                        }
                    ]
              )
          ]
      }

  pure do
    case session of
      Nothing -> loginForm
      Just sess -> chatView sess

eventKind :: Matrix.MatrixEvent -> String
eventKind ev = case Matrix.getEventMsgType ev of
  "m.image" -> "gif"
  _ -> "text"

elem :: forall a. Eq a => a -> Array a -> Boolean
elem x xs = not (null (filter (_ == x) xs))

foreign import setInterval :: Int -> Effect Unit -> Effect Int
foreign import clearInterval :: Int -> Effect Unit

-- UI helpers

scrollWrap :: DemoProps -> Array JSX -> JSX
scrollWrap dp children =
  nativeScrollView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
    (view { style: tw "px-4 pb-4" } children)

sectionTitle :: String -> String -> JSX
sectionTitle color title =
  text { style: tw "text-sm font-semibold mt-4 mb-1" <> Style.style { color } } title

desc :: DemoProps -> String -> JSX
desc dp str =
  text { style: tw "text-xs mb-2" <> Style.style { color: dp.dimFg } } str

card :: String -> Array JSX -> JSX
card bg children =
  view { style: tw "rounded-lg p-3 mb-2" <> Style.style { backgroundColor: bg, overflow: "hidden" } }
    children

label :: String -> String -> JSX
label color str =
  text { style: tw "ml-3 text-sm" <> Style.style { color } } str

round :: Number -> Int
round n = unsafeRound n

foreign import unsafeRound :: Number -> Int
foreign import getFieldJSON :: String -> forall r. r -> String
foreign import isSingleEmoji :: String -> Boolean
