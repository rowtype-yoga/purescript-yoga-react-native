module Main where

import Prelude

import Data.Array (mapWithIndex, length, filter, null, (!!))
import Data.Nullable (toNullable)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (take)
import Data.Foldable (for_, foldl)
import Data.Traversable (for)
import Effect (Effect)
import Data.Either (Either(..))
import Effect.Aff (launchAff_, try)
import Effect.Class (liftEffect)
import React.Basic (JSX)
import React.Basic.Events (EventHandler, handler, handler_, unsafeEventFn)
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
import Foreign (unsafeToForeign)
import Yoga.React.Native.MacOS.OutlineView (nativeOutlineView)
import Yoga.React.Native.MacOS.ShareService (macosShare)
import Yoga.React.Native.MacOS.UserNotification (macosNotify)
import Yoga.React.Native.MacOS.Sound (macosPlaySound, macosBeep)
import Yoga.React.Native.MacOS.StatusBarItem (macosSetStatusBarItem, macosRemoveStatusBarItem)
import Yoga.React.Native.MacOS.MapView (nativeMapView)
import Yoga.React.Native.MacOS.PDFView (nativePDFView)
import Yoga.React.Native.MacOS.QuickLook (macosQuickLook)
import Yoga.React.Native.MacOS.SpeechSynthesizer (macosSay, macosStopSpeaking)
import Yoga.React.Native.MacOS.ColorPanel (macosShowColorPanel)
import Yoga.React.Native.MacOS.FontPanel (macosShowFontPanel)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.Matrix as Matrix
import Yoga.React.Native.Style as Style

main :: Effect Unit
main = registerComponent "YogaReactExample" \_ -> app {}

app :: {} -> JSX
app = component "App" \_ -> React.do
  activeTab /\ setActiveTab <- useState' "controls"
  sliderValue /\ setSliderValue <- useState' 50.0
  switchOn /\ setSwitchOn <- useState' false
  selectedColor /\ setSelectedColor <- useState' "#FF6600"
  popUpIndex /\ setPopUpIndex <- useState' 0
  popUpTitle /\ setPopUpTitle <- useState' "Small"
  searchText /\ setSearchText <- useState' ""
  buttonStatus /\ setButtonStatus <- useState' "Ready"
  dateText /\ setDateText <- useState' ""
  browserUrl /\ setBrowserUrl <- useState' "https://pursuit.purescript.org"
  urlBarText /\ setUrlBarText <- useState' "https://pursuit.purescript.org"
  colorScheme <- useColorScheme
  let isDark = toNullable (Just "dark") == colorScheme
  let fg = if isDark then "#FFFFFF" else "#000000"
  let dimFg = if isDark then "#999999" else "#666666"
  let cardBg = if isDark then "#2A2A2A" else "#F0F0F0"
  let bg = if isDark then "#1E1E1E" else "#FFFFFF"
  pure do
    nativeVisualEffect
      { materialName: T.windowBackground
      , style: tw "flex-1"
      }
      ( safeAreaView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
          ( view { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
              [ nativeToolbar
                  { items:
                      [ { id: "controls", label: "Controls", sfSymbol: "slider.horizontal.3" }
                      , { id: "editor", label: "Editor", sfSymbol: "doc.richtext" }
                      , { id: "browser", label: "Browser", sfSymbol: "globe" }
                      , { id: "rive", label: "Rive", sfSymbol: "play.circle" }
                      , { id: "system", label: "System", sfSymbol: "gearshape.2" }
                      , { id: "chat", label: "Chat", sfSymbol: "bubble.left.and.bubble.right" }
                      ]
                  , selectedItem: activeTab
                  , toolbarStyle: T.unified
                  , windowTitle: "PureScript React Native"
                  , onSelectItem: extractString "itemId" setActiveTab
                  , style: Style.style { height: 0.0, width: 0.0 }
                  }
              , view { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
                  [ if activeTab == "controls" then controlsTab
                      { sliderValue
                      , setSliderValue
                      , switchOn
                      , setSwitchOn
                      , selectedColor
                      , setSelectedColor
                      , popUpIndex
                      , setPopUpIndex
                      , popUpTitle
                      , setPopUpTitle
                      , searchText
                      , setSearchText
                      , buttonStatus
                      , setButtonStatus
                      , dateText
                      , setDateText
                      , fg
                      , dimFg
                      , cardBg
                      }
                    else if activeTab == "editor" then editorTab { fg }
                    else if activeTab == "browser" then browserTab
                      { browserUrl
                      , setBrowserUrl
                      , urlBarText
                      , setUrlBarText
                      , fg
                      , dimFg
                      }
                    else if activeTab == "rive" then riveTab { fg, bg }
                    else if activeTab == "system" then systemTab { fg, dimFg, cardBg, bg }
                    else chatTab { fg, dimFg, cardBg, bg, isDark }
                  ]
              ]
          )
      )

-- Helpers for extracting native event values
extractNumber :: String -> (Number -> Effect Unit) -> EventHandler
extractNumber key cb = handler (nativeEvent >>> unsafeEventFn \e -> getField key e) cb

extractInt :: String -> (Int -> Effect Unit) -> EventHandler
extractInt key cb = handler (nativeEvent >>> unsafeEventFn \e -> getFieldInt key e) cb

extractString :: String -> (String -> Effect Unit) -> EventHandler
extractString key cb = handler (nativeEvent >>> unsafeEventFn \e -> getFieldStr key e) cb

extractBool :: String -> (Boolean -> Effect Unit) -> EventHandler
extractBool key cb = handler (nativeEvent >>> unsafeEventFn \e -> getFieldBool key e) cb

foreign import getField :: String -> forall r. r -> Number
foreign import getFieldInt :: String -> forall r. r -> Int
foreign import getFieldStr :: String -> forall r. r -> String
foreign import getFieldBool :: String -> forall r. r -> Boolean
foreign import getFieldArray :: String -> forall r. r -> Array String

-- Tab 0: Controls
type ControlsProps =
  { sliderValue :: Number
  , setSliderValue :: Number -> Effect Unit
  , switchOn :: Boolean
  , setSwitchOn :: Boolean -> Effect Unit
  , selectedColor :: String
  , setSelectedColor :: String -> Effect Unit
  , popUpIndex :: Int
  , setPopUpIndex :: Int -> Effect Unit
  , popUpTitle :: String
  , setPopUpTitle :: String -> Effect Unit
  , searchText :: String
  , setSearchText :: String -> Effect Unit
  , buttonStatus :: String
  , setButtonStatus :: String -> Effect Unit
  , dateText :: String
  , setDateText :: String -> Effect Unit
  , fg :: String
  , dimFg :: String
  , cardBg :: String
  }

sidebarItem :: String -> String -> String -> Boolean -> (String -> Effect Unit) -> JSX
sidebarItem _ sfSymbolName title selected setCategory =
  nativeButton
    { title
    , sfSymbol: sfSymbolName
    , bezelStyle: T.toolbar
    , primary: selected
    , onPress: handler_ (setCategory title)
    , style: Style.style { height: 28.0, marginHorizontal: 8.0, marginVertical: 1.0 }
    }

controlsTab :: ControlsProps -> JSX
controlsTab = component "ControlsTab" \p -> React.do
  category /\ setCategory <- useState' "All"
  let categories = [ "All", "Button", "Switch", "Slider", "Pop Up", "Color", "Date", "Text" ]
  let
    sidebar = view { style: tw "pt-2" }
      (categories <#> \cat -> sidebarItem p.fg "" cat (category == cat) setCategory)
  let show' name = category == "All" || category == name
  let
    buttonSection =
      [ sectionTitle p.fg "Button"
      , card p.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeButton
                  { title: "Say Hello"
                  , sfSymbol: "hand.wave"
                  , bezelStyle: T.push
                  , primary: true
                  , onPress: handler_ (p.setButtonStatus "Hello from PureScript!")
                  , style: Style.style { height: 24.0, width: 140.0 }
                  }
              , nativeButton
                  { title: "Reset"
                  , sfSymbol: "arrow.counterclockwise"
                  , bezelStyle: T.push
                  , onPress: handler_ (p.setButtonStatus "Ready")
                  , style: Style.style { height: 24.0, width: 100.0, marginLeft: 8.0 }
                  }
              , label p.dimFg p.buttonStatus
              ]
          ]
      ]
  let
    switchSection =
      [ sectionTitle p.fg "Switch"
      , card p.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeSwitch
                  { on: p.switchOn
                  , onChange: extractBool "on" p.setSwitchOn
                  , style: Style.style { height: 24.0, width: 48.0 }
                  }
              , label p.dimFg (if p.switchOn then "On" else "Off")
              ]
          ]
      ]
  let
    sliderSection =
      [ sectionTitle p.fg "Slider + Level Indicator + Progress"
      , card p.cardBg
          [ nativeSlider
              { value: p.sliderValue
              , minValue: 0.0
              , maxValue: 100.0
              , numberOfTickMarks: 11
              , onChange: extractNumber "value" p.setSliderValue
              , style: Style.style { height: 24.0 }
              }
          , label p.dimFg ("Value: " <> show (round p.sliderValue) <> " / 100")
          , nativeLevelIndicator
              { value: p.sliderValue
              , minValue: 0.0
              , maxValue: 100.0
              , warningValue: 70.0
              , criticalValue: 90.0
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          , nativeProgress
              { value: p.sliderValue
              , style: Style.style { height: 18.0, marginTop: 8.0 }
              }
          ]
      ]
  let
    popUpSection =
      [ sectionTitle p.fg "Pop Up Button"
      , card p.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativePopUp
                  { items: [ "Small", "Medium", "Large", "Extra Large" ]
                  , selectedIndex: p.popUpIndex
                  , onChange: handler
                      ( nativeEvent >>> unsafeEventFn \e ->
                          { idx: (getFieldInt "selectedIndex" e), title: (getFieldStr "title" e) }
                      )
                      \r -> do
                        p.setPopUpIndex r.idx
                        p.setPopUpTitle r.title
                  , style: Style.style { height: 24.0, width: 160.0 }
                  }
              , label p.dimFg ("Selected: " <> p.popUpTitle)
              ]
          ]
      ]
  let
    colorSection =
      [ sectionTitle p.fg "Color Well"
      , card p.cardBg
          [ view { style: tw "flex-row items-center" }
              [ nativeColorWell
                  { color: p.selectedColor
                  , minimal: true
                  , onChange: extractString "color" p.setSelectedColor
                  , style: Style.style { height: 32.0, width: 48.0 }
                  }
              , view
                  { style: tw "ml-3 rounded" <> Style.style
                      { width: 24.0, height: 24.0, backgroundColor: p.selectedColor }
                  }
                  []
              , label p.dimFg p.selectedColor
              ]
          ]
      ]
  let
    dateSection =
      [ sectionTitle p.fg "Date Picker"
      , card p.cardBg
          [ nativeDatePicker
              { graphical: false
              , onChange: extractString "date" p.setDateText
              , style: Style.style { height: 24.0, width: 200.0 }
              }
          , if p.dateText == "" then mempty
            else label p.dimFg ("Picked: " <> p.dateText)
          ]
      ]
  let
    textSection =
      [ sectionTitle p.fg "Text Field"
      , card p.cardBg
          [ nativeTextField
              { placeholder: "Type something..."
              , search: true
              , text: p.searchText
              , onChangeText: extractString "text" p.setSearchText
              , style: Style.style { height: 24.0 }
              }
          , if p.searchText == "" then mempty
            else label p.dimFg ("You typed: " <> p.searchText)
          ]
      ]
  let
    sections = join
      [ if show' "Button" then buttonSection else []
      , if show' "Switch" then switchSection else []
      , if show' "Slider" then sliderSection else []
      , if show' "Pop Up" then popUpSection else []
      , if show' "Color" then colorSection else []
      , if show' "Date" then dateSection else []
      , if show' "Text" then textSection else []
      ]
  pure do
    sidebarLayout
      { sidebar
      , sidebarWidth: 140.0
      , content: nativeScrollView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
          (view { style: tw "px-4 pb-4" } sections)
      }

-- Tab 1: Editor
editorTab :: { fg :: String } -> JSX
editorTab = component "EditorTab" \p -> React.do
  pure do
    view { style: tw "flex-1 px-4" }
      [ sectionTitle p.fg "Rich Text Editor"
      , nativeTextEditor
          { text: "Welcome to the PureScript-driven native text editor.\n\nThis uses NSTextView with rich text support and a formatting ruler."
          , richText: true
          , showsRuler: true
          , style: tw "flex-1" <> Style.style { minHeight: 300.0 }
          }
      ]

-- Tab 2: Browser
type BrowserProps =
  { browserUrl :: String
  , setBrowserUrl :: String -> Effect Unit
  , urlBarText :: String
  , setUrlBarText :: String -> Effect Unit
  , fg :: String
  , dimFg :: String
  }

browserTab :: BrowserProps -> JSX
browserTab = component "BrowserTab" \p -> React.do
  pure do
    view { style: tw "flex-1 px-4" }
      [ sectionTitle p.fg "Web Browser"
      , nativeTextField
          { text: p.urlBarText
          , placeholder: "Enter URL..."
          , search: false
          , onChangeText: extractString "text" p.setUrlBarText
          , onSubmit: extractString "text" p.setBrowserUrl
          , style: Style.style { height: 24.0, marginBottom: 8.0 }
          }
      , nativeWebView
          { url: p.browserUrl
          , onFinishLoad: handler
              ( nativeEvent >>> unsafeEventFn \e ->
                  { url: getFieldStr "url" e, title: getFieldStr "title" e }
              )
              \r -> p.setUrlBarText r.url
          , style: tw "flex-1" <> Style.style { minHeight: 400.0 }
          }
      ]

-- Tab 3: Rive Animation
riveTab :: { fg :: String, bg :: String } -> JSX
riveTab = component "RiveTab" \p -> React.do
  pure do
    nativeScrollView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
      ( view { style: tw "px-4 pb-4" }
          [ sectionTitle p.fg "Mouse Tracking"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.fg } }
              "Move your cursor over the cat — it follows your mouse!"
          , nativeRiveView_
              { resourceName: "cat_following_mouse"
              , stateMachineName: "State Machine 1"
              , fit: T.contain
              , autoplay: true
              , style: Style.style { height: 300.0 }
              }
          , sectionTitle p.fg "Cursor Tracking"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.fg } }
              "Shapes follow your cursor via Pointer Move listeners"
          , nativeRiveView_
              { resourceName: "cursor_tracking"
              , stateMachineName: "State Machine 1"
              , fit: T.contain
              , autoplay: true
              , style: Style.style { height: 300.0 }
              }
          , sectionTitle p.fg "Interactive Rive Animations"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.fg } }
              "Click the stars to rate! State machine handles interaction."
          , nativeRiveView_
              { resourceName: "rating_animation"
              , stateMachineName: "State Machine 1"
              , fit: T.contain
              , autoplay: true
              , style: Style.style { height: 200.0 }
              }
          , sectionTitle p.fg "Light Switch"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.fg } }
              "Click to toggle"
          , nativeRiveView_
              { resourceName: "switch_event_example"
              , stateMachineName: "State Machine 1"
              , fit: T.contain
              , autoplay: true
              , style: Style.style { height: 200.0 }
              }
          , sectionTitle p.fg "Windy Tree"
          , nativeRiveView_
              { resourceName: "windy_tree"
              , fit: T.cover
              , autoplay: true
              , style: tw "flex-1" <> Style.style { minHeight: 300.0, backgroundColor: p.bg }
              }
          ]
      )

-- Tab 4: System (Context Menu, Drop Zone, File Picker)
type SystemProps =
  { fg :: String
  , dimFg :: String
  , cardBg :: String
  , bg :: String
  }

systemTab :: SystemProps -> JSX
systemTab = component "SystemTab" \p -> React.do
  menuResult /\ setMenuResult <- useState' ""
  dropStatus /\ setDropStatus <- useState' "Drop files here"
  droppedFiles /\ setDroppedFiles <- useState' ""
  isDragging /\ setIsDragging <- useState' false
  pickedFiles /\ setPickedFiles <- useState' ""
  videoPlaying /\ setVideoPlaying <- useState' true
  comboText /\ setComboText <- useState' ""
  comboResult /\ setComboResult <- useState' ""
  stepperValue /\ setStepperValue <- useState' 5.0
  popoverVisible /\ setPopoverVisible <- useState' false
  checkboxA /\ setCheckboxA <- useState' true
  checkboxB /\ setCheckboxB <- useState' false
  radioChoice /\ setRadioChoice <- useState' "option1"
  searchQuery /\ setSearchQuery <- useState' ""
  searchResult /\ setSearchResult <- useState' ""
  tagTokens /\ setTagTokens <- useState' ([ "PureScript", "React", "macOS" ] :: Array String)
  sheetVisible /\ setSheetVisible <- useState' false
  menuResult2 /\ setMenuResult2 <- useState' ""
  selectedRow /\ setSelectedRow <- useState' ""
  outlineSelection /\ setOutlineSelection <- useState' ""
  statusBarActive /\ setStatusBarActive <- useState' false
  speechText /\ setSpeechText <- useState' "Hello from PureScript React Native on macOS!"
  let
    accentBorder = if isDragging then "#007AFF" else p.dimFg
  pure do
    nativeScrollView { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
      ( view { style: tw "px-4 pb-4" }
          [ sectionTitle p.fg "Context Menu"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Right-click the area below to open a context menu"
          , nativeContextMenu
              { items:
                  [ { id: "cut", title: "Cut", sfSymbol: "scissors" }
                  , { id: "copy", title: "Copy", sfSymbol: "doc.on.doc" }
                  , { id: "paste", title: "Paste", sfSymbol: "doc.on.clipboard" }
                  , { id: "sep", title: "-", sfSymbol: "" }
                  , { id: "delete", title: "Delete", sfSymbol: "trash" }
                  , { id: "selectAll", title: "Select All", sfSymbol: "selection.pin.in.out" }
                  ]
              , onSelectItem: extractString "itemId" setMenuResult
              , style: Style.style {}
              }
              ( card p.cardBg
                  [ view { style: tw "items-center justify-center" <> Style.style { minHeight: 80.0 } }
                      [ text { style: tw "text-sm" <> Style.style { color: p.fg } }
                          "Right-click me!"
                      , if menuResult == "" then mempty
                        else label p.dimFg ("Selected: " <> menuResult)
                      ]
                  ]
              )
          , sectionTitle p.fg "Drop Zone"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Drag files from Finder into the area below"
          , view
              { draggedTypes: [ "NSFilenamesPboardType" ]
              , onDrop: handler
                  (nativeEvent >>> unsafeEventFn \e -> getFieldJSON "dataTransfer" e)
                  \r -> do
                    setDroppedFiles r
                    setDropStatus "Drop files here"
                    setIsDragging false
              , onDragEnter: handler_ do
                  setDropStatus "Release to drop!"
                  setIsDragging true
              , onDragLeave: handler_ do
                  setDropStatus "Drop files here"
                  setIsDragging false
              , style: tw "rounded-lg items-center justify-center mb-2"
                  <> Style.style
                    { minHeight: 100.0
                    , borderWidth: 2.0
                    , borderColor: accentBorder
                    , backgroundColor: p.cardBg
                    }
              }
              [ text { style: tw "text-sm" <> Style.style { color: p.fg } } dropStatus
              , if droppedFiles == "" then mempty
                else text { style: tw "text-xs mt-2 px-4" <> Style.style { color: p.dimFg } }
                  ("Dropped: " <> droppedFiles)
              ]
          , sectionTitle p.fg "File Picker"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Click buttons to open native file panels"
          , card p.cardBg
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
                          setPickedFiles
                      , onCancel: handler_ (setPickedFiles "Cancelled")
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
                          setPickedFiles
                      , onCancel: handler_ (setPickedFiles "Cancelled")
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
                          setPickedFiles
                      , onCancel: handler_ (setPickedFiles "Cancelled")
                      , style: Style.style { height: 24.0, width: 120.0, marginLeft: 8.0 }
                      }
                  ]
              , if pickedFiles == "" then mempty
                else label p.dimFg pickedFiles
              ]
          , sectionTitle p.fg "Video Player"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Native AVPlayerView with floating controls"
          , nativeVideoPlayer
              { source: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4"
              , playing: videoPlaying
              , looping: true
              , muted: false
              , style: Style.style { height: 240.0 } <> tw "rounded-lg overflow-hidden mb-2"
              }
          , view { style: tw "flex-row mb-2" }
              [ nativeButton
                  { title: if videoPlaying then "Pause" else "Play"
                  , sfSymbol: if videoPlaying then "pause.fill" else "play.fill"
                  , bezelStyle: T.push
                  , onPress: handler_ (setVideoPlaying (not videoPlaying))
                  , style: Style.style { height: 24.0, width: 100.0 }
                  }
              ]
          , sectionTitle p.fg "Animated Image"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Native NSImageView with animated GIF support"
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

          -- New components
          , sectionTitle p.fg "Split View"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Native NSSplitView with resizable divider"
          , nativeSplitView
              { isVertical: true
              , style: Style.style { height: 150.0 } <> tw "rounded-lg overflow-hidden mb-2"
              }
              [ view { style: tw "flex-1 p-4" <> Style.style { backgroundColor: p.cardBg } }
                  [ text { style: tw "text-sm font-semibold" <> Style.style { color: p.fg } } "Left Pane"
                  , text { style: tw "text-xs mt-1" <> Style.style { color: p.dimFg } } "Drag the divider to resize"
                  ]
              , view { style: tw "flex-1 p-4" <> Style.style { backgroundColor: p.cardBg } }
                  [ text { style: tw "text-sm font-semibold" <> Style.style { color: p.fg } } "Right Pane"
                  , text { style: tw "text-xs mt-1" <> Style.style { color: p.dimFg } } "Content fills available space"
                  ]
              ]

          , sectionTitle p.fg "Tab View"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Native segmented tab bar"
          , nativeTabView
              { items:
                  [ { id: "general", label: "General" }
                  , { id: "advanced", label: "Advanced" }
                  , { id: "about", label: "About" }
                  ]
              , selectedItem: "general"
              , onSelectTab: extractString "tabId" \_ -> pure unit
              , style: Style.style { height: 32.0 } <> tw "mb-2"
              }

          , sectionTitle p.fg "Combo Box"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Editable dropdown with autocomplete"
          , card p.cardBg
              [ nativeComboBox
                  { items: [ "Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape" ]
                  , text: comboText
                  , placeholder: "Type a fruit..."
                  , onChangeText: extractString "text" setComboText
                  , onSelectItem: extractString "text" \t -> do
                      setComboText t
                      setComboResult ("Selected: " <> t)
                  , style: Style.style { height: 28.0 } <> tw "mb-2"
                  }
              , if comboResult == "" then mempty
                else label p.dimFg comboResult
              ]

          , sectionTitle p.fg "Stepper"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Up/down increment control with label"
          , card p.cardBg
              [ view { style: tw "flex-row items-center" }
                  [ text { style: tw "text-sm mr-3" <> Style.style { color: p.fg } } "Quantity:"
                  , nativeStepper
                      { value: stepperValue
                      , minValue: 0.0
                      , maxValue: 50.0
                      , increment: 1.0
                      , onChange: extractNumber "value" setStepperValue
                      , style: Style.style { width: 100.0, height: 24.0 }
                      }
                  ]
              ]

          , sectionTitle p.fg "Box"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Native NSBox with title and border"
          , nativeBox
              { boxTitle: "Settings"
              , fillColorStr: p.cardBg
              , borderColorStr: p.dimFg
              , cornerRadiusValue: 8.0
              , style: Style.style { height: 100.0 } <> tw "mb-2"
              }
              [ view { style: tw "flex-row items-center p-2" }
                  [ text { style: tw "text-sm" <> Style.style { color: p.fg } } "Content inside a native box" ]
              ]

          , sectionTitle p.fg "Popover"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Click button to toggle a popover"
          , nativePopover
              { visible: popoverVisible
              , preferredEdge: T.bottom
              , behavior: T.transient
              , onClose: handler_ (setPopoverVisible false)
              , style: tw "mb-2"
              }
              [ nativeButton
                  { title: if popoverVisible then "Hide Popover" else "Show Popover"
                  , bezelStyle: T.push
                  , onPress: handler_ (setPopoverVisible (not popoverVisible))
                  , style: Style.style { height: 24.0, width: 140.0 }
                  }
              , view { style: tw "p-4" <> Style.style { width: 200.0, height: 80.0 } }
                  [ text { style: tw "text-sm font-semibold" <> Style.style { color: p.fg } } "Popover Content"
                  , text { style: tw "text-xs mt-1" <> Style.style { color: p.dimFg } } "Click outside to dismiss"
                  ]
              ]

          , sectionTitle p.fg "Image"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Native NSImageView with URL loading and corner radius"
          , nativeImage
              { source: "https://placedog.net/640/400"
              , contentMode: T.scaleProportionally
              , cornerRadius: 12.0
              , style: Style.style { height: 200.0 } <> tw "mb-2"
              }

          , sectionTitle p.fg "Checkbox"
          , card p.cardBg
              [ nativeCheckbox
                  { checked: checkboxA
                  , title: "Enable notifications"
                  , enabled: true
                  , onChange: extractBool "checked" setCheckboxA
                  , style: Style.style { height: 24.0 } <> tw "mb-1"
                  }
              , nativeCheckbox
                  { checked: checkboxB
                  , title: "Dark mode"
                  , enabled: true
                  , onChange: extractBool "checked" setCheckboxB
                  , style: Style.style { height: 24.0 }
                  }
              ]

          , sectionTitle p.fg "Radio Button"
          , card p.cardBg
              [ nativeRadioButton
                  { selected: radioChoice == "option1"
                  , title: "Small"
                  , enabled: true
                  , onChange: handler_ (setRadioChoice "option1")
                  , style: Style.style { height: 24.0 } <> tw "mb-1"
                  }
              , nativeRadioButton
                  { selected: radioChoice == "option2"
                  , title: "Medium"
                  , enabled: true
                  , onChange: handler_ (setRadioChoice "option2")
                  , style: Style.style { height: 24.0 } <> tw "mb-1"
                  }
              , nativeRadioButton
                  { selected: radioChoice == "option3"
                  , title: "Large"
                  , enabled: true
                  , onChange: handler_ (setRadioChoice "option3")
                  , style: Style.style { height: 24.0 }
                  }
              , label p.dimFg ("Selected: " <> radioChoice)
              ]

          , sectionTitle p.fg "Search Field"
          , nativeSearchField
              { text: searchQuery
              , placeholder: "Search..."
              , onChangeText: extractString "text" setSearchQuery
              , onSearch: extractString "text" \t -> setSearchResult ("Searched: " <> t)
              , style: Style.style { height: 28.0 } <> tw "mb-2"
              }
          , if searchResult == "" then mempty
            else label p.dimFg searchResult

          , sectionTitle p.fg "Token Field"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Type text and press Enter to add tokens"
          , nativeTokenField
              { tokens: tagTokens
              , placeholder: "Add tags..."
              , onChangeTokens: handler
                  (nativeEvent >>> unsafeEventFn \e -> getFieldArray "tokens" e)
                  setTagTokens
              , style: Style.style { height: 28.0 } <> tw "mb-2"
              }

          , sectionTitle p.fg "Separator"
          , nativeSeparator
              { vertical: false
              , style: Style.style { height: 2.0 } <> tw "my-2"
              }

          , sectionTitle p.fg "Help Button"
          , view { style: tw "flex-row items-center mb-2" }
              [ nativeHelpButton
                  { onPress: handler_ (macosAlert T.informational "Help" "This is the help button. It opens contextual help." [ "OK" ])
                  , style: Style.style { width: 24.0, height: 24.0 }
                  }
              , text { style: tw "text-xs ml-2" <> Style.style { color: p.dimFg } } "Click for help"
              ]

          , sectionTitle p.fg "Path Control"
          , nativePathControl
              { url: "/Users"
              , pathStyle: T.standardPath
              , onSelectPath: extractString "url" \_ -> pure unit
              , style: Style.style { height: 24.0 } <> tw "mb-2"
              }

          , sectionTitle p.fg "Sheet"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Modal sheet attached to the window"
          , nativeButton
              { title: "Show Sheet"
              , bezelStyle: T.push
              , onPress: handler_ (setSheetVisible true)
              , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-2"
              }
          , nativeSheet
              { visible: sheetVisible
              , onDismiss: handler_ (setSheetVisible false)
              }
              [ view { style: tw "p-6" <> Style.style { width: 400.0, height: 200.0 } }
                  [ text { style: tw "text-lg font-semibold mb-2" <> Style.style { color: p.fg } } "Sheet Content"
                  , text { style: tw "text-sm mb-4" <> Style.style { color: p.dimFg } } "This is a native macOS sheet."
                  , nativeButton
                      { title: "Dismiss"
                      , bezelStyle: T.push
                      , onPress: handler_ (setSheetVisible false)
                      , style: Style.style { height: 24.0, width: 100.0 }
                      }
                  ]
              ]

          , sectionTitle p.fg "Menu"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Imperative popup menu at mouse position"
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
                          \itemId -> setMenuResult2 ("Menu: " <> itemId)
                      )
                  , style: Style.style { height: 24.0, width: 120.0 }
                  }
              , if menuResult2 == "" then mempty
                else text { style: tw "text-xs ml-3" <> Style.style { color: p.dimFg } } menuResult2
              ]

          , sectionTitle p.fg "Table View"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Native NSTableView with columns and rows"
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
              , onSelectRow: extractInt "rowIndex" \i -> setSelectedRow ("Row " <> show i)
              , onDoubleClickRow: extractInt "rowIndex" \i -> setSelectedRow ("Double-clicked row " <> show i)
              , style: Style.style { height: 180.0 } <> tw "rounded-lg overflow-hidden mb-2"
              }
          , if selectedRow == "" then mempty
            else label p.dimFg selectedRow

          , sectionTitle p.fg "Clipboard"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Read and write the system clipboard"
          , view { style: tw "flex-row items-center mb-2" }
              [ nativeButton
                  { title: "Copy 'Hello'"
                  , bezelStyle: T.push
                  , onPress: handler_ (copyToClipboard "Hello from PureScript!")
                  , style: Style.style { height: 24.0, width: 120.0 }
                  }
              ]

          , sectionTitle p.fg "Alert"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Native alert dialog"
          , nativeButton
              { title: "Show Alert"
              , bezelStyle: T.push
              , onPress: handler_ (macosAlert T.warning "Are you sure?" "This action cannot be undone." [ "Cancel", "OK" ])
              , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-4"
              }

          , sectionTitle p.fg "Outline View"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Hierarchical tree list (NSOutlineView)"
          , nativeOutlineView
              { items: unsafeToForeign
                  [ { id: "src"
                    , title: "src"
                    , sfSymbol: "folder"
                    , children:
                        [ { id: "main", title: "Main.purs", sfSymbol: "doc", children: [] }
                        , { id: "macos"
                          , title: "MacOS"
                          , sfSymbol: "folder"
                          , children:
                              [ { id: "btn", title: "Button.purs", sfSymbol: "doc", children: [] }
                              , { id: "sl", title: "Slider.purs", sfSymbol: "doc", children: [] }
                              , { id: "sw", title: "Switch.purs", sfSymbol: "doc", children: [] }
                              ]
                          }
                        ]
                    }
                  , { id: "test"
                    , title: "test"
                    , sfSymbol: "folder"
                    , children:
                        [ { id: "t1", title: "MacOSComponents.test.js", sfSymbol: "doc", children: [] }
                        , { id: "t2", title: "MacOSSnapshots.test.js", sfSymbol: "doc", children: [] }
                        ]
                    }
                  , { id: "pkg", title: "package.json", sfSymbol: "doc.text", children: [] }
                  ]
              , headerVisible: false
              , onSelectItem: extractString "id" setOutlineSelection
              , style: Style.style { height: 200.0 } <> tw "rounded-lg overflow-hidden mb-2"
              }
          , if outlineSelection == "" then mempty
            else label p.dimFg ("Selected: " <> outlineSelection)

          , sectionTitle p.fg "Share"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "System share picker"
          , nativeButton
              { title: "Share Text"
              , sfSymbol: "square.and.arrow.up"
              , bezelStyle: T.push
              , onPress: handler_ (macosShare [ "Hello from PureScript React Native!" ])
              , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-2"
              }

          , sectionTitle p.fg "Notifications"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "System notifications (requires permission)"
          , nativeButton
              { title: "Send Notification"
              , sfSymbol: "bell"
              , bezelStyle: T.push
              , onPress: handler_ (macosNotify "PureScript" "Hello from React Native macOS!")
              , style: Style.style { height: 24.0, width: 160.0 } <> tw "mb-2"
              }

          , sectionTitle p.fg "Sound"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Play system sounds"
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

          , sectionTitle p.fg "Status Bar"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Menu bar icon with dropdown"
          , view { style: tw "flex-row items-center mb-4" }
              [ nativeButton
                  { title: if statusBarActive then "Remove" else "Add to Menu Bar"
                  , sfSymbol: if statusBarActive then "minus.circle" else "plus.circle"
                  , bezelStyle: T.push
                  , onPress: handler_
                      ( if statusBarActive then do
                          macosRemoveStatusBarItem
                          setStatusBarActive false
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
                          setStatusBarActive true
                      )
                  , style: Style.style { height: 24.0, width: 180.0 }
                  }
              ]
          , sectionTitle p.fg "Map"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Embedded MKMapView (San Francisco)"
          , nativeMapView
              { latitude: 37.7749
              , longitude: -122.4194
              , latitudeDelta: 0.05
              , longitudeDelta: 0.05
              , mapType: "standard"
              , showsUserLocation: false
              , annotations: unsafeToForeign
                  [ { latitude: 37.7749, longitude: -122.4194, title: "San Francisco", subtitle: "California" }
                  , { latitude: 37.8199, longitude: -122.4783, title: "Golden Gate Bridge", subtitle: "" }
                  ]
              , onRegionChange: handler_ (pure unit)
              , onSelectAnnotation: handler_ (pure unit)
              , style: Style.style { height: 250.0 }
              }
          , sectionTitle p.fg "PDF Viewer"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "PDFKit document viewer"
          , nativePDFView
              { source: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
              , autoScales: true
              , displayMode: "singlePageContinuous"
              , onPageChange: handler_ (pure unit)
              , style: Style.style { height: 300.0 }
              }
          , sectionTitle p.fg "Quick Look"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Preview files with QLPreviewPanel"
          , view { style: tw "flex-row items-center mb-4" }
              [ nativeButton
                  { title: "Preview /etc/hosts"
                  , sfSymbol: "eye"
                  , bezelStyle: T.push
                  , onPress: handler_ (macosQuickLook "/etc/hosts")
                  , style: Style.style { height: 24.0, width: 180.0 }
                  }
              ]
          , sectionTitle p.fg "Speech"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "Text-to-speech (NSSpeechSynthesizer)"
          , nativeTextField
              { text: speechText
              , placeholder: "Text to speak..."
              , onChangeText: extractString "text" setSpeechText
              , style: Style.style { height: 24.0 } <> tw "mb-2"
              }
          , view { style: tw "flex-row items-center mb-4" }
              [ nativeButton
                  { title: "Speak"
                  , sfSymbol: "speaker.wave.2"
                  , bezelStyle: T.push
                  , onPress: handler_ (macosSay speechText)
                  , style: Style.style { height: 24.0, width: 100.0 }
                  }
              , nativeButton
                  { title: "Stop"
                  , sfSymbol: "stop.circle"
                  , bezelStyle: T.push
                  , onPress: handler_ macosStopSpeaking
                  , style: Style.style { height: 24.0, width: 100.0, marginLeft: 8.0 }
                  }
              ]
          , sectionTitle p.fg "Color Picker"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "System color panel (NSColorPanel)"
          , view { style: tw "flex-row items-center mb-4" }
              [ nativeButton
                  { title: "Show Color Panel"
                  , sfSymbol: "paintpalette"
                  , bezelStyle: T.push
                  , onPress: handler_ macosShowColorPanel
                  , style: Style.style { height: 24.0, width: 180.0 }
                  }
              ]
          , sectionTitle p.fg "Font Panel"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.dimFg } }
              "System font panel (NSFontPanel)"
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
      )

-- Tab 5: Chat (Matrix)
type ChatProps =
  { fg :: String
  , dimFg :: String
  , cardBg :: String
  , bg :: String
  , isDark :: Boolean
  }

type Message =
  { sender :: String
  , body :: String
  , kind :: String -- "text" | "sticker" | "gif" | "video"
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

chatTab :: ChatProps -> JSX
chatTab = component "ChatTab" \p -> React.do
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

  -- Sync polling effect
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

    sentBubbleBg = if p.isDark then "#65B86A" else "#5CB85C"
    receivedBubbleBg = if p.isDark then "#3B3B3D" else "#FFFFFF"
    chatBg = if p.isDark then "#17212B" else "#E8DFD3"

    loginForm = view
      { style: tw "flex-1 items-center justify-center"
          <> Style.style { backgroundColor: chatBg }
      }
      [ view { style: tw "rounded-xl p-6" <> Style.style { backgroundColor: p.cardBg, width: 340.0 } }
          [ text { style: tw "text-lg font-bold mb-4 text-center" <> Style.style { color: p.fg } } "Matrix Login"
          , text { style: tw "text-xs mb-1" <> Style.style { color: p.dimFg } } "Homeserver"
          , nativeTextField
              { text: loginServer
              , placeholder: "https://matrix.org"
              , search: false
              , rounded: true
              , onChangeText: extractString "text" setLoginServer
              , onSubmit: handler_ (pure unit)
              , style: tw "mb-3" <> Style.style { height: 28.0 }
              }
          , text { style: tw "text-xs mb-1" <> Style.style { color: p.dimFg } } "Username"
          , nativeTextField
              { text: loginUser
              , placeholder: "username"
              , search: false
              , rounded: true
              , onChangeText: extractString "text" setLoginUser
              , onSubmit: handler_ (pure unit)
              , style: tw "mb-3" <> Style.style { height: 28.0 }
              }
          , text { style: tw "text-xs mb-1" <> Style.style { color: p.dimFg } } "Password"
          , nativeTextField
              { text: loginPass
              , placeholder: "password"
              , search: false
              , rounded: true
              , onChangeText: extractString "text" setLoginPass
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
                  { backgroundColor: if activeRoom == Just r.roomId then (if p.isDark then "#2B5278" else "#419FD9") else "transparent" }
            }
            [ view
                { style: tw "rounded-full items-center justify-center"
                    <> Style.style { width: 32.0, height: 32.0, backgroundColor: avatarColor r.roomId }
                }
                [ text { style: tw "text-xs font-bold" <> Style.style { color: "#FFFFFF" } } (take 1 r.name) ]
            , view { style: tw "ml-2 flex-1" }
                [ text
                    { style: tw "text-sm font-semibold"
                        <> Style.style { color: if activeRoom == Just r.roomId then "#FFFFFF" else p.fg }
                    }
                    r.name
                , text
                    { style: tw "text-xs"
                        <> Style.style { color: if activeRoom == Just r.roomId then "#FFFFFFCC" else p.dimFg }
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
              else text { style: tw "text-xs mb-0.5" <> Style.style { color: p.dimFg } } senderLabel
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
                          <> Style.style { color: if isMine then "#FFFFFF" else (if p.isDark then "#FFFFFF" else "#000000") }
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
                  <> Style.style { borderBottomWidth: 0.5, borderColor: p.dimFg, backgroundColor: "transparent" }
              }
              [ text { style: tw "text-base font-semibold" <> Style.style { color: p.fg } } activeRoomName ]
          , nativePatternBackground
              { patternColor: if p.isDark then "#FFFFFF" else "#000000"
              , backgroundColor2: chatBg
              , patternOpacity: if p.isDark then 0.04 else 0.06
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
                  <> Style.style { borderTopWidth: 0.5, borderColor: p.dimFg, backgroundColor: "transparent" }
              }
              ( case activeRoom of
                  Nothing ->
                    [ text { style: tw "text-sm" <> Style.style { color: p.dimFg } } "Select a room to start chatting" ]
                  Just rid ->
                    [ nativeTextField
                        { text: inputText
                        , placeholder: "Message..."
                        , search: false
                        , rounded: true
                        , onChangeText: extractString "text" setInputText
                        , onSubmit: extractString "text" \t -> sendMessage sess rid t
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
sectionTitle :: String -> String -> JSX
sectionTitle color title =
  text { style: tw "text-sm font-semibold mt-4 mb-1" <> Style.style { color } } title

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
