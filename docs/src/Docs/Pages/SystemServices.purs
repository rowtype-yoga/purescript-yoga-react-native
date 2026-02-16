module Docs.Pages.SystemServices where

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Docs.Components.Layout as L
import Docs.Components.PropsTable (propsTable)

page :: Nut
page =
  D.div_
    [ L.section "System Services" [ D.p_ [ D.text_ "macOS system service APIs for clipboard, sharing, notifications, sound, and more." ] ]
    , clipboard
    , share
    , notification
    , sound
    , speechSynthesizer
    , speechRecognition
    , statusBarItem
    , quickLook
    , colorPanel
    , fontPanel
    ]

clipboard :: Nut
clipboard = L.componentDoc "copyToClipboard / readClipboard" "Yoga.React.Native.MacOS.Pasteboard (copyToClipboard, readClipboard)"
  """copyToClipboard "Hello, world!" # liftEffect

text <- readClipboard # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "copyToClipboard :: String -> Effect Unit" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "readClipboard :: Effect String" ]
  ]

share :: Nut
share = L.componentDoc "macosShare" "Yoga.React.Native.MacOS.ShareService (macosShare)"
  """-- Takes an Array String of items to share
macosShare ["Check out this library!", "https://github.com/rowtype-yoga/purescript-yoga-react-native"]
  # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Signature: Array String -> Effect Unit" ]
  ]

notification :: Nut
notification = L.componentDoc "macosNotify" "Yoga.React.Native.MacOS.UserNotification (macosNotify)"
  """-- Takes 2 positional String args: title and body
macosNotify "Build Complete" "Your project compiled successfully."
  # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Signature: String -> String -> Effect Unit" ]
  ]

sound :: Nut
sound = L.componentDoc "macosPlaySound / macosBeep" "Yoga.React.Native.MacOS.Sound (macosPlaySound, macosBeep)"
  """macosPlaySound "Glass" # liftEffect

macosBeep # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "macosPlaySound :: String -> Effect Unit" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "macosBeep :: Effect Unit" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "Sound names: Basso, Blow, Bottle, Frog, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink" ]
  ]

speechSynthesizer :: Nut
speechSynthesizer = L.componentDoc "say / sayWithVoice / stopSpeaking" "Yoga.React.Native.MacOS.SpeechSynthesizer (say, sayWithVoice, stopSpeaking)"
  """say "Hello from PureScript!" # liftEffect

sayWithVoice "Bonjour" T.french # liftEffect

stopSpeaking # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "say :: String -> Effect Unit" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "sayWithVoice :: String -> VoiceIdentifier -> Effect Unit" ]
  , D.p [ DA.klass_ "text-sm text-gray-400" ]
      [ D.text_ "stopSpeaking :: Effect Unit" ]
  ]

speechRecognition :: Nut
speechRecognition = L.componentDoc "useSpeechRecognition" "Yoga.React.Native.MacOS.SpeechRecognition (useSpeechRecognition)"
  """-- React hook returning a record
{ listening, transcript, start, stop } <- useSpeechRecognition"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Hook UseSpeechRecognition SpeechRecognition" ]
  , propsTable
      [ { name: "listening", type_: "Boolean", description: "Whether recognition is active" }
      , { name: "transcript", type_: "String", description: "Live transcription text" }
      , { name: "start", type_: "Effect Unit", description: "Start recognition" }
      , { name: "stop", type_: "Effect Unit", description: "Stop recognition" }
      ]
  ]

statusBarItem :: Nut
statusBarItem = L.componentDoc "macosSetStatusBarItem / macosRemoveStatusBarItem" "Yoga.React.Native.MacOS.StatusBarItem (macosSetStatusBarItem, macosRemoveStatusBarItem)"
  """macosSetStatusBarItem
  { title: "MyApp"
  , sfSymbol: "gear"
  , menuItems: [ { id: "prefs", title: "Preferences..." } ]
  }
  # liftEffect

macosRemoveStatusBarItem # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "macosSetStatusBarItem :: StatusBarConfig -> Effect Unit" ]
  , propsTable
      [ { name: "title", type_: "String", description: "Status bar title text" }
      , { name: "sfSymbol", type_: "String", description: "SF Symbol icon name" }
      , { name: "menuItems", type_: "Array StatusBarMenuItem", description: "Dropdown items ({ id, title })" }
      ]
  ]

quickLook :: Nut
quickLook = L.componentDoc "macosQuickLook" "Yoga.React.Native.MacOS.QuickLook (macosQuickLook)"
  """macosQuickLook "/path/to/file.pdf" # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Signature: String -> Effect Unit" ]
  ]

colorPanel :: Nut
colorPanel = L.componentDoc "macosShowColorPanel / macosHideColorPanel" "Yoga.React.Native.MacOS.ColorPanel (macosShowColorPanel, macosHideColorPanel)"
  """macosShowColorPanel # liftEffect

macosHideColorPanel # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Both are Effect Unit \x2014 no arguments." ]
  ]

fontPanel :: Nut
fontPanel = L.componentDoc "macosShowFontPanel / macosHideFontPanel" "Yoga.React.Native.MacOS.FontPanel (macosShowFontPanel, macosHideFontPanel)"
  """macosShowFontPanel # liftEffect

macosHideFontPanel # liftEffect"""
  [ D.p [ DA.klass_ "text-sm text-gray-400 mt-2" ]
      [ D.text_ "Both are Effect Unit \x2014 no arguments." ]
  ]
