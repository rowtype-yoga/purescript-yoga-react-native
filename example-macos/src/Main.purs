module Main where

import Prelude

import Data.Array (mapWithIndex, snoc)
import Data.Maybe (Maybe(..))
import Data.Nullable (toNullable)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Data.Function.Uncurried (mkFn1, mkFn2)
import Effect.Uncurried (mkEffectFn1)
import React.Basic (JSX, fragment)
import React.Basic.Events (handler, handler_)
import Yoga.React.Native.Events (nativeEvent)
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (registerComponent, string, view, text, textInput, pressable, scrollView, image, activityIndicator, flatList, switch, button, touchableOpacity, touchableHighlight, touchableWithoutFeedback, safeAreaView, keyboardAvoidingView, imageBackground, sectionList, refreshControl, statusBar, tw, uri)
import Yoga.React.Native.AccessibilityInfo as AccessibilityInfo
import Yoga.React.Native.ActionSheetIOS as ActionSheetIOS
import Yoga.React.Native.Alert as Alert
import Yoga.React.Native.Animated as Animated
import Yoga.React.Native.Appearance as Appearance
import Yoga.React.Native.AppState as AppState
import Yoga.React.Native.Clipboard as Clipboard
import Yoga.React.Native.Dimensions as Dimensions
import Yoga.React.Native.Easing as Easing
import Yoga.React.Native.FS as FS
import Yoga.React.Native.I18nManager as I18nManager
import Yoga.React.Native.Keyboard as Keyboard
import Yoga.React.Native.LayoutAnimation as LayoutAnimation
import Yoga.React.Native.Linking as Linking
import Yoga.React.Native.PanResponder as PanResponder
import Yoga.React.Native.PixelRatio as PixelRatio
import Yoga.React.Native.Platform as Platform
import Yoga.React.Native.PlatformColor (platformColor)
import Yoga.React.Native.Share as Share
import Yoga.React.Native.Style as Style
import Yoga.React.Native.Styled as Styled
import Yoga.React.Native.StyleSheet as StyleSheet

main :: Effect Unit
main = registerComponent "YogaReactExample" \_ -> app {}

app :: {} -> JSX
app = component "App" \_ -> React.do
  count /\ setCount <- React.useState 0
  inputText /\ setInputText <- React.useState ""
  items /\ setItems <- React.useState ([] :: Array String)
  switchOn /\ setSwitchOn <- React.useState false
  refreshing /\ setRefreshing <- React.useState false
  showSection /\ setShowSection <- React.useState "components"
  appState /\ setAppState <- React.useState "active"
  clipboardText /\ setClipboardText <- React.useState ""
  fsResult /\ setFsResult <- React.useState ""
  hovered /\ setHovered <- React.useState false
  lastKey /\ setLastKey <- React.useState ""
  droppedFile /\ setDroppedFile <- React.useState ""

  fadeAnim <- Animated.useAnimatedValue 1.0
  slideAnim <- Animated.useAnimatedValue 0.0

  dims <- Dimensions.useWindowDimensions
  colorScheme <- Appearance.useColorScheme

  React.useEffectOnce do
    sub <- AppState.addEventListener "change" $ mkEffectFn1 \s -> setAppState (const s)
    log $ "Platform: " <> Platform.os <> " (TV: " <> show Platform.isTV <> ")"
    log $ "PixelRatio: " <> show PixelRatio.get <> ", FontScale: " <> show PixelRatio.getFontScale
    log $ "RTL: " <> show I18nManager.isRTL
    log $ "Hairline: " <> show StyleSheet.hairlineWidth
    log $ "DocumentDir: " <> FS.documentDirectoryPath
    pure (AppState.removeSubscription sub)

  let
    isDark = colorScheme == toNullable (Just "dark")
    _ = PanResponder.create {}

    labelClr = platformColor "labelColor"
    secondaryLabel = platformColor "secondaryLabelColor"
    tertiaryLabel = platformColor "tertiaryLabelColor"
    windowBg = platformColor "windowBackgroundColor"
    controlBg = platformColor "controlBackgroundColor"
    controlClr = platformColor "controlColor"
    accentClr = platformColor "controlAccentColor"
    separatorClr = platformColor "separatorColor"
    textBgClr = platformColor "textBackgroundColor"

    dynamicBg = Style.style { backgroundColor: if isDark then "#1d1d1f" else "#f5f5f7" }
    dynamicCardBg = if isDark then "#2c2c2e" else "#ffffff"
    dynamicCardBorder = if isDark then "#3a3a3c" else "#d1d1d6"
    dynamicSubtle = if isDark then "#3a3a3c" else "#e5e5ea"

    card kids = view
      { style: Style.styles
          [ tw "rounded-xl p-4 mb-3"
          , Style.style
              { backgroundColor: dynamicCardBg
              , borderWidth: StyleSheet.hairlineWidth
              , borderColor: dynamicCardBorder
              }
          ]
      }
      kids

    tc = if isDark then "text-white" else "text-gray-900"
    tc2 = if isDark then "text-gray-400" else "text-gray-500"
    tc3 = if isDark then "text-gray-500" else "text-gray-400"

    heading t = text { style: tw $ "text-xl font-bold mb-4 " <> tc } t
    bodyText t = text { style: tw $ "text-sm " <> tc2 } t

    caption :: String -> JSX
    caption t = text { style: tw $ "text-xs " <> tc3 } t
    label' t = text { style: tw $ "text-base font-semibold mb-2 " <> tc } t

    accentBtn lbl onClick =
      pressable
        { onPress: handler_ onClick
        , style: Style.styles
            [ tw "px-4 py-2 rounded-lg"
            , Style.style { backgroundColor: "#007AFF" }
            ]
        , cursor: "pointer"
        , tooltip: lbl
        }
        [ text { style: tw "text-white text-sm font-semibold text-center" } lbl ]

    secondaryBtn lbl onClick =
      pressable
        { onPress: handler_ onClick
        , style: Style.styles
            [ tw "px-4 py-2 rounded-lg"
            , Style.style
                { backgroundColor: "#e5e5ea"
                , borderWidth: StyleSheet.hairlineWidth
                , borderColor: dynamicCardBorder
                }
            ]
        }
        [ text { style: tw $ "text-sm font-medium " <> tc } lbl ]

    sectionBtn lbl section =
      pressable
        { onPress: handler_ (setShowSection (const section))
        , style: Style.styles
            [ tw "px-4 py-2 rounded-lg"
            , Style.style { backgroundColor: if showSection == section then accentClr else controlClr }
            ]
        , cursor: "pointer"
        , tooltip: lbl
        }
        [ text
            { style: tw $ "font-semibold text-sm " <> if showSection == section then "text-white" else tc }
            lbl
        ]

    componentsSection = fragment
      [ heading "Components"

      , card
          [ label' "Counter"
          , text { style: tw "text-2xl font-bold mb-3 text-blue-500" }
              (show count)
          , view { style: tw "flex-row gap-2" }
              [ accentBtn "+" (setCount (_ + 1))
              , secondaryBtn "-" (setCount (_ - 1))
              ]
          ]

      , statusBar { barStyle: "dark-content" }

      , card
          [ label' "View & Text"
          , view { style: tw "flex-row gap-2" }
              [ view
                  { style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: dynamicSubtle } ]
                  , tooltip: "A nested view"
                  }
                  [ text { style: tw $ "text-sm " <> tc } "Nested" ]
              , view
                  { style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: dynamicSubtle } ]
                  , tooltip: "Another nested view"
                  }
                  [ text { style: tw $ "text-sm " <> tc } "Views" ]
              ]
          ]

      , card
          [ label' "TextInput"
          , textInput
              { value: inputText
              , onChangeText: mkEffectFn1 \t -> setInputText (const t)
              , placeholder: "Type here..."
              , style: Style.styles
                  [ tw "rounded-lg p-3"
                  , Style.style
                      { backgroundColor: textBgClr
                      , borderWidth: StyleSheet.hairlineWidth
                      , borderColor: separatorClr
                      }
                  ]
              }
          ]

      , card
          [ label' "Button"
          , button { title: "Native Button", onPress: handler_ (Alert.alert "Hello" "Pressed") }
          ]

      , card
          [ label' "Touchables"
          , view { style: tw "gap-2" }
              [ accentBtn "Pressable" (pure unit)
              , touchableOpacity
                  { onPress: handler_ (pure unit)
                  , style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: platformColor "systemGreenColor" } ]
                  }
                  [ text { style: tw "text-white text-center" } "TouchableOpacity" ]
              , touchableHighlight
                  { onPress: handler_ (pure unit)
                  , underlayColor: "#ddd"
                  , style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: platformColor "systemOrangeColor" } ]
                  }
                  [ text { style: tw "text-white text-center" } "TouchableHighlight" ]
              , touchableWithoutFeedback { onPress: handler_ (pure unit) }
                  ( view
                      { style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: platformColor "systemRedColor" } ] }
                      [ text { style: tw "text-white text-center" } "TouchableWithoutFeedback" ]
                  )
              ]
          ]

      , card
          [ label' "Switch"
          , view { style: tw "flex-row items-center gap-3" }
              [ switch { value: switchOn, onValueChange: mkEffectFn1 \v -> setSwitchOn (const v) }
              , text { style: tw $ "font-medium " <> if switchOn then "text-blue-500" else tc2 }
                  (if switchOn then "ON" else "OFF")
              ]
          ]

      , card
          [ label' "Image"
          , image
              { source: uri "https://picsum.photos/200/100"
              , style: tw "w-full h-24 rounded-lg"
              }
          ]

      , card
          [ label' "ImageBackground"
          , imageBackground
              { source: uri "https://picsum.photos/400/100"
              , style: tw "w-full h-20 rounded-lg overflow-hidden justify-center items-center"
              }
              (text { style: tw "text-white text-lg font-bold" } "Overlay Text")
          ]

      , card
          [ label' "ActivityIndicator"
          , activityIndicator { size: "large", color: "#007AFF" }
          ]

      , card
          [ label' "KeyboardAvoidingView"
          , keyboardAvoidingView { behavior: "padding" }
              (bodyText "Content adjusts for keyboard")
          ]

      , card
          [ label' "ScrollView"
          , scrollView
              { style: Style.styles
                  [ tw "h-20 rounded-lg"
                  , Style.style { backgroundColor: controlBg }
                  ]
              }
              ( map
                  ( \i -> text
                      { style: Style.styles
                          [ tw "p-2"
                          , Style.style { borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: separatorClr }
                          ]
                      }
                      ("Scroll item " <> show i)
                  )
                  [ 1, 2, 3, 4, 5 ]
              )
          ]

      , card
          [ label' "RefreshControl"
          , scrollView
              { refreshControl: refreshControl
                  { refreshing
                  , onRefresh: handler_ do
                      setRefreshing (const true)
                      launchAff_ (liftEffect $ setRefreshing (const false))
                  }
              , style: Style.styles [ tw "h-16 rounded-lg", Style.style { backgroundColor: controlBg } ]
              }
              [ text { style: tw $ "p-4 text-center " <> tc3 } "Pull to refresh" ]
          ]
      ]

  pure do
    safeAreaView { style: tw "flex-1" }
      ( scrollView { style: tw "flex-1 p-4" }
          [ text { style: tw "text-2xl font-bold mb-4" } "Let bindings test"
          , text { style: tw "text-lg mb-2" } (show count)
          , accentBtn "+" (setCount (_ + 1))
          , secondaryBtn "-" (setCount (_ - 1))
          , heading "Heading helper"
          , bodyText "Body text helper"
          , caption "Caption helper"
          , card [ label' "Inside a card" ]
          ]
      )

foreign import unsafeLength :: forall a. Array a -> Int
foreign import unsafeStringify :: forall a. a -> String
