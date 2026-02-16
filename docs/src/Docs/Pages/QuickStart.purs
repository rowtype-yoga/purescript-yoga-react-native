module Docs.Pages.QuickStart where

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Docs.Components.CodeBlock (codeBlock)
import Docs.Components.Layout as L

page :: Nut
page =
  D.div_
    [ L.section "Installation"
        [ D.p [ DA.klass_ "text-gray-400 mb-3" ] [ D.text_ "Add to your spago.yaml:" ]
        , codeBlock installYaml
        ]
    , L.section "Basic Usage"
        [ D.p [ DA.klass_ "text-gray-400 mb-3" ] [ D.text_ "Import and use components:" ]
        , codeBlock basicUsage
        ]
    , L.section "Running the Example App"
        [ D.p [ DA.klass_ "text-gray-400 mb-3" ] [ D.text_ "Clone and build the example macOS app:" ]
        , codeBlock exampleSteps
        ]
    , L.section "Prerequisites"
        [ D.ul [ DA.klass_ "space-y-1.5" ]
            [ prereq "macOS 14+"
            , prereq "Xcode 16+"
            , prereq "Node.js 20+ / Bun"
            , prereq "PureScript 0.15+ and Spago"
            , prereq "CocoaPods"
            ]
        ]
    ]
  where
  prereq t =
    D.li [ DA.klass_ "flex items-center gap-2 text-gray-300" ]
      [ D.span [ DA.klass_ "text-brand" ] [ D.text_ "\x2713" ]
      , D.text_ t
      ]

installYaml :: String
installYaml =
  """extraPackages:
  yoga-react-native:
    git: https://github.com/rowtype-yoga/purescript-yoga-react-native.git
    ref: main
  yoga-react:
    git: https://github.com/rowtype-yoga/purescript-yoga-react.git
    ref: main"""

basicUsage :: String
basicUsage =
  """import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.Types as T

myButton = nativeButton
  { title: "Click me"
  , bezelStyle: T.push
  , sfSymbol: "star"
  , onPress: handler_ doSomething
  , style: Style.style { height: 24.0 }
  }"""

exampleSteps :: String
exampleSteps =
  """git clone https://github.com/rowtype-yoga/purescript-yoga-react-native.git
cd purescript-yoga-react-native
bun install
cd example-macos && bun install && cd ..
cd example-macos/macos && bundle exec pod install && cd ../..
cd example-macos && bunx spago build && cd ..
cd example-macos && npx react-native run-macos"""
