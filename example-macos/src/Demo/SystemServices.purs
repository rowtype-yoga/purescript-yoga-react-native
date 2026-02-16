module Demo.SystemServices
  ( clipboardDemo
  , shareDemo
  , notificationsDemo
  , soundDemo
  , statusBarDemo
  , quickLookDemo
  , colorPanelDemo
  , fontPanelDemo
  , speechDemo
  ) where

import Prelude

import Demo.Shared (DemoProps, desc, scrollWrap, sectionTitle)
import React.Basic (JSX)

import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (tw, view)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.ColorPanel (macosShowColorPanel)
import Yoga.React.Native.MacOS.FontPanel (macosShowFontPanel)
import Yoga.React.Native.MacOS.Pasteboard (copyToClipboard)
import Yoga.React.Native.MacOS.QuickLook (macosQuickLook)
import Yoga.React.Native.MacOS.ShareService (macosShare)
import Yoga.React.Native.MacOS.Sound (macosBeep, macosPlaySound)
import Yoga.React.Native.MacOS.SpeechSynthesizer (say, stopSpeaking)
import Yoga.React.Native.MacOS.StatusBarItem (macosRemoveStatusBarItem, macosSetStatusBarItem)
import Yoga.React.Native.MacOS.TextField (nativeTextField)
import Yoga.React.Native.MacOS.Types as T
import Yoga.React.Native.MacOS.UserNotification (macosNotify)
import Yoga.React.Native.Style as Style

clipboardDemo :: DemoProps -> JSX
clipboardDemo = component "ClipboardDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Clipboard"
    , desc dp "Read and write the system clipboard"
    , view { style: tw "flex-row items-center mb-2" }
        [ nativeButton
            { title: "Copy 'Hello'"
            , bezelStyle: T.push
            , onPress: copyToClipboard "Hello from PureScript!"
            , style: Style.style { height: 24.0, width: 120.0 }
            }
        ]
    ]

shareDemo :: DemoProps -> JSX
shareDemo = component "ShareDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Share"
    , desc dp "System share picker"
    , nativeButton
        { title: "Share Text"
        , bezelStyle: T.push
        , onPress: macosShare [ "Hello from PureScript React Native!" ]
        , style: Style.style { height: 24.0, width: 120.0 } <> tw "mb-2"
        }
    ]

notificationsDemo :: DemoProps -> JSX
notificationsDemo = component "NotificationsDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Notifications"
    , desc dp "System notifications (requires permission)"
    , nativeButton
        { title: "Send Notification"
        , bezelStyle: T.push
        , onPress: macosNotify { title: "PureScript", body: "Hello from React Native macOS!" }
        , style: Style.style { height: 24.0, width: 160.0 } <> tw "mb-2"
        }
    ]

soundDemo :: DemoProps -> JSX
soundDemo = component "SoundDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Sound"
    , desc dp "Play system sounds"
    , view { style: tw "flex-row items-center mb-2" }
        [ nativeButton
            { title: "Glass"
            , bezelStyle: T.push
            , onPress: macosPlaySound "Glass"
            , style: Style.style { height: 24.0, width: 80.0 }
            }
        , nativeButton
            { title: "Ping"
            , bezelStyle: T.push
            , onPress: macosPlaySound "Ping"
            , style: Style.style { height: 24.0, width: 80.0, marginLeft: 8.0 }
            }
        , nativeButton
            { title: "Beep"
            , bezelStyle: T.push
            , onPress: macosBeep
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
              , bezelStyle: T.push
              , onPress:
                  if active then do
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
              , style: Style.style { height: 24.0, width: 180.0 }
              }
          ]
      ]

quickLookDemo :: DemoProps -> JSX
quickLookDemo = component "QuickLookDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Quick Look"
    , desc dp "Preview files with QLPreviewPanel"
    , view { style: tw "flex-row items-center mb-4" }
        [ nativeButton
            { title: "Preview /etc/hosts"
            , bezelStyle: T.push
            , onPress: macosQuickLook "/etc/hosts"
            , style: Style.style { height: 24.0, width: 180.0 }
            }
        ]
    ]

colorPanelDemo :: DemoProps -> JSX
colorPanelDemo = component "ColorPanelDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Color Picker"
    , desc dp "System color panel (NSColorPanel)"
    , view { style: tw "flex-row items-center mb-4" }
        [ nativeButton
            { title: "Show Color Panel"
            , bezelStyle: T.push
            , onPress: macosShowColorPanel
            , style: Style.style { height: 24.0, width: 180.0 }
            }
        ]
    ]

fontPanelDemo :: DemoProps -> JSX
fontPanelDemo = component "FontPanelDemo" \dp -> pure do
  scrollWrap dp
    [ sectionTitle dp.fg "Font Panel"
    , desc dp "System font panel (NSFontPanel)"
    , view { style: tw "flex-row items-center mb-4" }
        [ nativeButton
            { title: "Show Font Panel"
            , bezelStyle: T.push
            , onPress: macosShowFontPanel
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
          , onChangeText: setTxt
          , style: Style.style { height: 24.0 } <> tw "mb-2"
          }
      , view { style: tw "flex-row items-center mb-4" }
          [ nativeButton
              { title: "Speak"
              , bezelStyle: T.push
              , onPress: say txt
              , style: Style.style { height: 24.0, width: 100.0 }
              }
          , nativeButton
              { title: "Stop"
              , bezelStyle: T.push
              , onPress: stopSpeaking
              , style: Style.style { height: 24.0, width: 100.0, marginLeft: 8.0 }
              }
          ]
      ]
