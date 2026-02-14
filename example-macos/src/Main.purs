module Main where

import Prelude

import Data.Nullable (toNullable)
import Data.Maybe (Maybe(..))
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
                    else riveTab { fg, bg }
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
