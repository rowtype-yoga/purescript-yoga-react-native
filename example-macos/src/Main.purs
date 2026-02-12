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

  pure do
    safeAreaView { style: tw "flex-1" }
      ( scrollView { style: tw "flex-1 p-4" }
          [ text { style: tw "text-2xl font-bold mb-4" } "Bisect Test - All Imports + State"
          , text { style: tw "text-lg mb-2" } (show count)
          , view { style: tw "flex-row gap-2" }
              [ pressable
                  { onPress: handler_ (setCount (_ + 1))
                  , style: Style.styles
                      [ tw "px-4 py-2 rounded-lg"
                      , Style.style { backgroundColor: "#007AFF" }
                      ]
                  }
                  [ text { style: tw "text-white font-semibold" } "Press me" ]
              ]
          ]
      )

foreign import unsafeLength :: forall a. Array a -> Int
foreign import unsafeStringify :: forall a. a -> String
