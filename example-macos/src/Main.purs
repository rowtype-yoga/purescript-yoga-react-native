module Main where

import Prelude

import Data.Array (snoc, mapWithIndex, length, filter, null)
import Data.Nullable (toNullable)
import Data.Maybe (Maybe(..))
import Data.String (contains, Pattern(..))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Events (EventHandler, handler, handler_, unsafeEventFn)
import React.Basic.Hooks (useState', (/\))
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
      { materialName: "windowBackground"
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
                  , toolbarStyle: "unified"
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
    , bezelStyle: "toolbar"
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
                  , bezelStyle: "rounded"
                  , primary: true
                  , onPress: handler_ (p.setButtonStatus "Hello from PureScript!")
                  , style: Style.style { height: 24.0, width: 140.0 }
                  }
              , nativeButton
                  { title: "Reset"
                  , sfSymbol: "arrow.counterclockwise"
                  , bezelStyle: "rounded"
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
              , fit: "contain"
              , autoplay: true
              , style: Style.style { height: 300.0 }
              }
          , sectionTitle p.fg "Cursor Tracking"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.fg } }
              "Shapes follow your cursor via Pointer Move listeners"
          , nativeRiveView_
              { resourceName: "cursor_tracking"
              , stateMachineName: "State Machine 1"
              , fit: "contain"
              , autoplay: true
              , style: Style.style { height: 300.0 }
              }
          , sectionTitle p.fg "Interactive Rive Animations"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.fg } }
              "Click the stars to rate! State machine handles interaction."
          , nativeRiveView_
              { resourceName: "rating_animation"
              , stateMachineName: "State Machine 1"
              , fit: "contain"
              , autoplay: true
              , style: Style.style { height: 200.0 }
              }
          , sectionTitle p.fg "Light Switch"
          , text { style: tw "text-xs mb-2" <> Style.style { color: p.fg } }
              "Click to toggle"
          , nativeRiveView_
              { resourceName: "switch_event_example"
              , stateMachineName: "State Machine 1"
              , fit: "contain"
              , autoplay: true
              , style: Style.style { height: 200.0 }
              }
          , sectionTitle p.fg "Windy Tree"
          , nativeRiveView_
              { resourceName: "windy_tree"
              , fit: "cover"
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
                      { mode: "open"
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
                      { mode: "open"
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
                      { mode: "save"
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
          ]
      )

-- Tab 5: Chat (Telegram-style)
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
  , isSticker :: Boolean
  }

type Contact =
  { name :: String
  , initials :: String
  , color :: String
  , preview :: String
  }

contacts :: Array Contact
contacts =
  [ { name: "Alice", initials: "A", color: "#5856D6", preview: "Check out this sticker!" }
  , { name: "Bob", initials: "B", color: "#FF9500", preview: "Hey, how's the app going?" }
  , { name: "Carol", initials: "C", color: "#34C759", preview: "Love the new UI" }
  ]

initialMessages :: String -> Array Message
initialMessages name = case name of
  "Alice" ->
    [ { sender: "Alice", body: "Hey! Have you seen the new Rive stickers?", isSticker: false }
    , { sender: "You", body: "Not yet, show me!", isSticker: false }
    , { sender: "Alice", body: "cat_following_mouse", isSticker: true }
    , { sender: "You", body: "That's amazing! The cat follows your mouse!", isSticker: false }
    , { sender: "You", body: "😍", isSticker: false }
    , { sender: "Alice", body: "Right? Check out this one too", isSticker: false }
    , { sender: "Alice", body: "rating_animation", isSticker: true }
    ]
  "Bob" ->
    [ { sender: "Bob", body: "Hey, how's the app going?", isSticker: false }
    , { sender: "You", body: "Great! Just added native macOS controls", isSticker: false }
    , { sender: "Bob", body: "Nice! Toolbar, sidebar, the works?", isSticker: false }
    , { sender: "You", body: "Yep, plus visual effects and context menus", isSticker: false }
    , { sender: "Bob", body: "🔥", isSticker: false }
    , { sender: "Bob", body: "switch_event_example", isSticker: true }
    ]
  "Carol" ->
    [ { sender: "Carol", body: "Love the new UI", isSticker: false }
    , { sender: "You", body: "Thanks! It's all PureScript + native macOS views", isSticker: false }
    , { sender: "Carol", body: "The frosted glass sidebar is chef's kiss", isSticker: false }
    , { sender: "Carol", body: "windy_tree", isSticker: true }
    ]
  _ -> []

chatTab :: ChatProps -> JSX
chatTab = component "ChatTab" \p -> React.do
  activeContact /\ setActiveContact <- useState' "Alice"
  messages /\ setMessages <- useState' (initialMessages "Alice")
  inputText /\ setInputText <- useState' ""
  let
    sendMessage msg = do
      if msg == "" then pure unit
      else do
        setMessages (snoc messages { sender: "You", body: msg, isSticker: false })
        setInputText ""
    switchContact name = do
      setActiveContact name
      setMessages (initialMessages name)
      setInputText ""
    sendSticker stickerName = do
      setMessages (snoc messages { sender: "You", body: stickerName, isSticker: true })
      setInputText ""
    allStickers = [ "cat_following_mouse", "rating_animation", "switch_event_example", "windy_tree" ]
    query = colonQuery inputText
    matchingStickers = if query == "" then [] else filter (contains (Pattern query)) allStickers
    sentBubbleBg = if p.isDark then "#0A84FF" else "#007AFF"
    receivedBubbleBg = p.cardBg
    sidebar = view { style: tw "pt-2" }
      ( contacts <#> \c ->
          view
            { style: tw "flex-row items-center px-3 py-2 mx-2 rounded-lg"
                <> Style.style
                  { backgroundColor: if activeContact == c.name then sentBubbleBg else "transparent" }
            }
            [ view
                { style: tw "rounded-full items-center justify-center"
                    <> Style.style { width: 32.0, height: 32.0, backgroundColor: c.color }
                }
                [ text { style: tw "text-xs font-bold" <> Style.style { color: "#FFFFFF" } } c.initials ]
            , view { style: tw "ml-2 flex-1" }
                [ text { style: tw "text-sm font-semibold" <> Style.style { color: if activeContact == c.name then "#FFFFFF" else p.fg } } c.name
                , text
                    { style: tw "text-xs"
                        <> Style.style { color: if activeContact == c.name then "#FFFFFFCC" else p.dimFg }
                    }
                    c.preview
                ]
            , nativeButton
                { title: ""
                , bezelStyle: "toolbar"
                , sfSymbol: ""
                , onPress: handler_ (switchContact c.name)
                , style: Style.style { position: "absolute", top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, opacity: 0.0 }
                }
            ]
      )
    messageBubble _ msg = do
      let isMine = msg.sender == "You"
      let align = if isMine then "flex-end" else "flex-start"
      let bigEmoji = isSingleEmoji msg.body
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
        ( if msg.isSticker then
            view
              { style: Style.style { alignSelf: align, width: 120.0, height: 120.0 } }
              [ nativeRiveView_
                  { resourceName: msg.body
                  , fit: "contain"
                  , autoplay: true
                  , style: Style.style { width: 120.0, height: 120.0 }
                  }
              ]
          else if bigEmoji then
            text
              { style: Style.style { alignSelf: align, fontSize: 64.0, lineHeight: 72.0 } }
              msg.body
          else
            view
              { style: tw "rounded-2xl px-3 py-2"
                  <> Style.style
                    { alignSelf: align
                    , backgroundColor: if isMine then sentBubbleBg else receivedBubbleBg
                    , maxWidth: 320.0
                    }
              }
              [ text
                  { style: tw "text-sm"
                      <> Style.style { color: if isMine then "#FFFFFF" else p.fg }
                  }
                  msg.body
              ]
        )
    stickerBar = view { style: tw "flex-row px-3 py-1" <> Style.style { backgroundColor: "transparent" } }
      [ stickerButton "cat_following_mouse"
      , stickerButton "rating_animation"
      , stickerButton "switch_event_example"
      , stickerButton "windy_tree"
      ]
    stickerButton name = view
      { style: tw "mr-2 rounded-lg overflow-hidden" <> Style.style { backgroundColor: p.cardBg } }
      [ nativeRiveView_
          { resourceName: name
          , fit: "contain"
          , autoplay: true
          , style: Style.style { width: 40.0, height: 40.0 }
          }
      , nativeButton
          { title: ""
          , bezelStyle: "toolbar"
          , sfSymbol: ""
          , onPress: handler_ (sendSticker name)
          , style: Style.style { position: "absolute", top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, opacity: 0.0 }
          }
      ]
    stickerPicker stickers = view
      { style: tw "flex-row px-3 py-2"
          <> Style.style { backgroundColor: p.cardBg, borderTopWidth: 0.5, borderColor: p.dimFg }
      }
      ( stickers <#> \name ->
          view
            { style: tw "mr-2 rounded-lg overflow-hidden items-center"
                <> Style.style { backgroundColor: if p.isDark then "#3A3A3A" else "#E0E0E0" }
            }
            [ nativeRiveView_
                { resourceName: name
                , fit: "contain"
                , autoplay: true
                , style: Style.style { width: 56.0, height: 56.0 }
                }
            , text { style: tw "text-xs pb-1" <> Style.style { color: p.dimFg } } (":" <> name)
            , nativeButton
                { title: ""
                , bezelStyle: "toolbar"
                , sfSymbol: ""
                , onPress: handler_ (sendSticker name)
                , style: Style.style { position: "absolute", top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, opacity: 0.0 }
                }
            ]
      )
  pure do
    sidebarLayout
      { sidebar
      , sidebarWidth: 200.0
      , content: view { style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
          [ view
              { style: tw "px-4 py-2 border-b"
                  <> Style.style { borderBottomWidth: 0.5, borderColor: p.dimFg, backgroundColor: "transparent" }
              }
              [ text { style: tw "text-base font-semibold" <> Style.style { color: p.fg } } activeContact ]
          , nativeScrollView { scrollToBottom: length messages, style: tw "flex-1" <> Style.style { backgroundColor: "transparent" } }
              ( view { style: tw "py-2" }
                  (mapWithIndex messageBubble messages)
              )
          , if null matchingStickers then stickerBar
            else stickerPicker matchingStickers
          , view
              { style: tw "flex-row items-center px-3 py-2"
                  <> Style.style { borderTopWidth: 0.5, borderColor: p.dimFg, backgroundColor: "transparent" }
              }
              [ nativeTextField
                  { text: inputText
                  , placeholder: "Message..."
                  , search: false
                  , rounded: true
                  , onChangeText: extractString "text" setInputText
                  , onSubmit: extractString "text" \t -> sendMessage t
                  , style: tw "flex-1" <> Style.style { height: 28.0 }
                  }
              , nativeButton
                  { title: ""
                  , sfSymbol: "paperplane.fill"
                  , bezelStyle: "toolbar"
                  , onPress: handler_ (sendMessage inputText)
                  , style: Style.style { height: 28.0, width: 36.0, marginLeft: 8.0 }
                  }
              ]
          ]
      }

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
foreign import colonQuery :: String -> String
