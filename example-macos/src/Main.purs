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
import React.Basic.Events (handler_)
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (registerComponent, string, view, text, textInput, pressable, scrollView, image, activityIndicator, flatList, switch, button, touchableOpacity, touchableHighlight, touchableWithoutFeedback, modal, safeAreaView, keyboardAvoidingView, imageBackground, inputAccessoryView, sectionList, refreshControl, statusBar, tw, uri)
import Yoga.React.Native.AccessibilityInfo as AccessibilityInfo
import Yoga.React.Native.ActionSheetIOS as ActionSheetIOS
import Yoga.React.Native.Alert as Alert
import Yoga.React.Native.Animated as Animated
import Yoga.React.Native.Appearance as Appearance
import Yoga.React.Native.AppState as AppState
import Yoga.React.Native.Clipboard as Clipboard
import Yoga.React.Native.ColorWithSystemEffectMacOS as ColorWithSystemEffectMacOS
import Yoga.React.Native.Dimensions as Dimensions
import Yoga.React.Native.DynamicColorMacOS as DynamicColorMacOS
import Yoga.React.Native.Easing as Easing
import Yoga.React.Native.FS as FS
import Yoga.React.Native.I18nManager as I18nManager
import Yoga.React.Native.Keyboard as Keyboard
import Yoga.React.Native.LayoutAnimation as LayoutAnimation
import Yoga.React.Native.Linking as Linking
import Yoga.React.Native.PanResponder as PanResponder
import Yoga.React.Native.PixelRatio as PixelRatio
import Yoga.React.Native.Platform as Platform
import Yoga.React.Native.PlatformColor as PlatformColor
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
  showModal /\ setShowModal <- React.useState false
  switchOn /\ setSwitchOn <- React.useState false
  refreshing /\ setRefreshing <- React.useState false
  showSection /\ setShowSection <- React.useState "components"
  appState /\ setAppState <- React.useState "active"
  clipboardText /\ setClipboardText <- React.useState ""
  fsResult /\ setFsResult <- React.useState ""

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
    bg = if isDark then "bg-gray-900" else "bg-gray-100"
    tc = if isDark then "text-white" else "text-gray-900"
    cardBg = if isDark then "bg-gray-800" else "bg-white"
    dynamicBg = DynamicColorMacOS.dynamicColor { light: "#f3f4f6", dark: "#111827" }
    pressedColor = ColorWithSystemEffectMacOS.colorWithSystemEffect (PlatformColor.platformColor "controlAccentColor") "pressed"

    _ = PanResponder.create {}

    sectionBtn lbl section =
      pressable
        { onPress: handler_ (setShowSection (const section))
        , style: tw $ (if showSection == section then "bg-blue-500" else cardBg) <> " px-4 py-2 rounded-lg"
        }
        [ text { style: tw $ (if showSection == section then "text-white" else tc) <> " font-semibold text-sm" } lbl ]

    heading t = text { style: tw $ "text-xl font-bold mb-4 " <> tc } t

    card kids = view { style: tw $ cardBg <> " rounded-xl p-4 mb-4" } kids

    smallBtn lbl onClick =
      pressable { onPress: handler_ onClick, style: tw "bg-blue-500 px-4 py-2 rounded-lg" }
        [ text { style: tw "text-white text-sm font-semibold" } lbl ]

    componentsSection = fragment
      [ heading "Components"

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Counter"
          , text { style: tw $ "text-lg mb-2 " <> tc } ("Count: " <> show count)
          , view { style: tw "flex-row gap-2" }
              [ smallBtn "+" (setCount (_ + 1))
              , smallBtn "-" (setCount (_ - 1))
              ]
          ]

      , statusBar { barStyle: "dark-content" }

      , card
          [ text { style: tw $ "text-base mb-2 " <> tc } "View & Text"
          , view { style: tw "flex-row gap-2" }
              [ view { style: tw "bg-blue-100 p-2 rounded" } [ string "Nested" ]
              , view { style: tw "bg-green-100 p-2 rounded" } [ string "Views" ]
              ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "TextInput"
          , textInput
              { value: inputText
              , onChangeText: mkEffectFn1 \t -> setInputText (const t)
              , placeholder: "Type here..."
              , style: tw "border border-gray-300 rounded-lg p-3 bg-gray-50"
              }
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Button"
          , button { title: "Native Button", onPress: handler_ (Alert.alert "Hello" "Pressed") }
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Touchables"
          , view { style: tw "gap-2" }
              [ pressable { onPress: handler_ (pure unit), style: tw "bg-blue-500 p-3 rounded-lg" }
                  [ text { style: tw "text-white text-center" } "Pressable" ]
              , touchableOpacity { onPress: handler_ (pure unit), style: tw "bg-green-500 p-3 rounded-lg" }
                  [ text { style: tw "text-white text-center" } "TouchableOpacity" ]
              , touchableHighlight { onPress: handler_ (pure unit), underlayColor: "#ddd", style: tw "bg-yellow-500 p-3 rounded-lg" }
                  [ text { style: tw "text-white text-center" } "TouchableHighlight" ]
              , touchableWithoutFeedback { onPress: handler_ (pure unit) }
                  ( view { style: tw "bg-red-500 p-3 rounded-lg" }
                      [ text { style: tw "text-white text-center" } "TouchableWithoutFeedback" ]
                  )
              ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Switch"
          , view { style: tw "flex-row items-center gap-3" }
              [ switch { value: switchOn, onValueChange: mkEffectFn1 \v -> setSwitchOn (const v) }
              , text { style: tw tc } (if switchOn then "ON" else "OFF")
              ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Image"
          , image { source: uri "https://picsum.photos/200/100", style: tw "w-full h-24 rounded-lg" }
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "ImageBackground"
          , imageBackground
              { source: uri "https://picsum.photos/400/100"
              , style: tw "w-full h-20 rounded-lg overflow-hidden justify-center items-center"
              }
              (text { style: tw "text-white text-lg font-bold" } "Overlay Text")
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "ActivityIndicator"
          , activityIndicator { size: "large", color: "#3b82f6" }
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Modal"
          , smallBtn "Show Modal" (setShowModal (const true))
          , modal { visible: showModal, animationType: "slide" }
              ( safeAreaView {}
                  ( view { style: tw "flex-1 justify-center items-center bg-black/50" }
                      [ view { style: tw "bg-white rounded-2xl p-8 m-5" }
                          [ text { style: tw "text-xl font-bold mb-4" } "Modal Content"
                          , text { style: tw "text-base mb-4" } "This is a modal overlay"
                          , smallBtn "Close" (setShowModal (const false))
                          ]
                      ]
                  )
              )
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "KeyboardAvoidingView"
          , keyboardAvoidingView { behavior: "padding" }
              (text { style: tw $ "text-sm " <> tc } "Content adjusts for keyboard")
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "InputAccessoryView"
          , inputAccessoryView { backgroundColor: "#f0f0f0" }
              (text { style: tw "text-sm p-2" } "Accessory bar content")
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "ScrollView"
          , scrollView { style: tw "h-20 bg-gray-50 rounded-lg" }
              (map (\i -> text { style: tw "p-2 border-b border-gray-200" } ("Scroll item " <> show i)) [ 1, 2, 3, 4, 5 ])
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "FlatList"
          , text { style: tw $ "text-sm italic " <> tc } "(shown in Lists tab to avoid VirtualizedList nesting)"
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "SectionList"
          , text { style: tw $ "text-sm italic " <> tc } "(shown in Lists tab to avoid VirtualizedList nesting)"
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "RefreshControl"
          , scrollView
              { refreshControl: refreshControl
                  { refreshing
                  , onRefresh: handler_ do
                      setRefreshing (const true)
                      launchAff_ (liftEffect $ setRefreshing (const false))
                  }
              , style: tw "h-16 bg-gray-50 rounded-lg"
              }
              [ text { style: tw "p-4 text-center text-gray-500" } "Pull to refresh" ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "SafeAreaView"
          , text { style: tw $ "text-sm " <> tc } "Wrapping app content for safe insets"
          ]
      ]

    apisSection = fragment
      [ heading "APIs"

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Alert"
          , view { style: tw "flex-row gap-2" }
              [ smallBtn "Simple" (Alert.alert "Hello" "Simple alert")
              , smallBtn "With Buttons"
                  ( Alert.alertWithButtons "Choose" "Pick one"
                      [ { text: "Cancel", onPress: pure unit, style: "cancel" }
                      , { text: "OK", onPress: pure unit, style: "default" }
                      ]
                  )
              ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Clipboard"
          , view { style: tw "gap-2" }
              [ smallBtn "Copy 'Hello'" (Clipboard.setString "Hello")
              , smallBtn "Paste"
                  ( launchAff_ do
                      t <- Clipboard.getString
                      liftEffect $ setClipboardText (const t)
                  )
              , text { style: tw $ "text-sm " <> tc } ("Clipboard: " <> clipboardText)
              ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Linking"
          , smallBtn "Open URL" (launchAff_ $ Linking.openURL "https://purescript.org")
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Share"
          , smallBtn "Share" (launchAff_ $ void $ Share.share { message: "Check out PureScript!", title: "PureScript", url: "https://purescript.org" })
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Keyboard"
          , smallBtn "Dismiss Keyboard" Keyboard.dismiss
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "ActionSheetIOS"
          , smallBtn "Show Action Sheet"
              ( ActionSheetIOS.showActionSheet
                  { options: [ "Cancel", "Save", "Delete" ]
                  , cancelButtonIndex: 0
                  , destructiveButtonIndex: 2
                  }
                  (mkEffectFn1 \idx -> Alert.alert "Selected" ("Index: " <> show idx))
              )
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "LayoutAnimation"
          , view { style: tw "flex-row gap-2" }
              [ smallBtn "Add Item" do
                  LayoutAnimation.easeInEaseOut
                  setItems (\arr -> snoc arr ("Item " <> show (1 + unsafeLength arr)))
              ]
          , view { style: tw "mt-2" }
              ( items # mapWithIndex \_ item ->
                  text { style: tw $ "p-1 text-sm " <> tc } item
              )
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "AccessibilityInfo"
          , view { style: tw "gap-2" }
              [ smallBtn "Screen Reader?"
                  ( launchAff_ do
                      enabled <- AccessibilityInfo.isScreenReaderEnabled
                      liftEffect $ Alert.alert "Screen Reader" (if enabled then "Enabled" else "Disabled")
                  )
              , smallBtn "Announce" (AccessibilityInfo.announceForAccessibility "Hello from PureScript")
              ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "FS (react-native-fs)"
          , view { style: tw "gap-2" }
              [ text { style: tw $ "text-xs " <> tc } ("Documents: " <> FS.documentDirectoryPath)
              , text { style: tw $ "text-xs " <> tc } ("Caches: " <> FS.cachesDirectoryPath)
              , text { style: tw $ "text-xs " <> tc } ("Temp: " <> FS.temporaryDirectoryPath)
              , smallBtn "Write & Read File"
                  ( launchAff_ do
                      let path = FS.documentDirectoryPath <> "/test.txt"
                      FS.writeFile path "Hello from PureScript!" "utf8"
                      content <- FS.readFile path "utf8"
                      exists <- FS.exists path
                      liftEffect $ setFsResult (const $ "Read: " <> content <> " (exists: " <> show exists <> ")")
                  )
              , text { style: tw $ "text-sm " <> tc } fsResult
              ]
          ]
      ]

    infoSection = fragment
      [ heading "Platform Info"

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Platform"
          , text { style: tw $ "text-sm " <> tc } ("OS: " <> Platform.os)
          , text { style: tw $ "text-sm " <> tc } ("TV: " <> show Platform.isTV)
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Dimensions (useWindowDimensions)"
          , text { style: tw $ "text-sm " <> tc } (show dims.width <> " x " <> show dims.height)
          , text { style: tw $ "text-sm " <> tc } ("Scale: " <> show dims.scale <> ", FontScale: " <> show dims.fontScale)
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "PixelRatio"
          , text { style: tw $ "text-sm " <> tc } ("Ratio: " <> show PixelRatio.get)
          , text { style: tw $ "text-sm " <> tc } ("FontScale: " <> show PixelRatio.getFontScale)
          , text { style: tw $ "text-sm " <> tc } ("100pt = " <> show (PixelRatio.getPixelSizeForLayoutSize 100.0) <> "px")
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Appearance (useColorScheme)"
          , text { style: tw $ "text-sm " <> tc } ("Color scheme: " <> show colorScheme)
          , text { style: tw $ "text-sm " <> tc } ("Dark mode: " <> show isDark)
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "AppState"
          , text { style: tw $ "text-sm " <> tc } ("State: " <> appState)
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "I18nManager"
          , text { style: tw $ "text-sm " <> tc } ("RTL: " <> show I18nManager.isRTL)
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "StyleSheet"
          , text { style: tw $ "text-sm " <> tc } ("hairlineWidth: " <> show StyleSheet.hairlineWidth)
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "DynamicColorMacOS"
          , view { style: dynamicBg } [ string "Adapts to light/dark" ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "PlatformColor + SystemEffect"
          , text { style: tw $ "text-sm " <> tc } ("Pressed accent: " <> pressedColor)
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Easing"
          , text { style: tw $ "text-sm " <> tc } ("linear(0.5) = " <> show (Easing.linear 0.5))
          , text { style: tw $ "text-sm " <> tc } ("quad(0.5) = " <> show (Easing.quad 0.5))
          , text { style: tw $ "text-sm " <> tc } ("cubic(0.5) = " <> show (Easing.cubic 0.5))
          , text { style: tw $ "text-sm " <> tc } ("bounce(0.5) = " <> show (Easing.bounce 0.5))
          , text { style: tw $ "text-sm " <> tc } ("bezier(.25,.1,.25,1)(0.5) = " <> show (Easing.bezier 0.25 0.1 0.25 1.0 0.5))
          ]
      ]

    animatedSection = fragment
      [ heading "Animated"
      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "Fade & Slide"
          , view { style: tw "flex-row gap-2 mb-3" }
              [ smallBtn "Fade Out" do
                  let anim = Animated.timing fadeAnim { toValue: 0.0, duration: 500, useNativeDriver: true }
                  Animated.start anim
              , smallBtn "Fade In" do
                  let anim = Animated.timing fadeAnim { toValue: 1.0, duration: 500, useNativeDriver: true }
                  Animated.start anim
              , smallBtn "Slide" do
                  let
                    anim = Animated.sequence
                      [ Animated.timing slideAnim { toValue: 100.0, duration: 300, easing: Easing.easeInOut Easing.quad, useNativeDriver: true }
                      , Animated.timing slideAnim { toValue: 0.0, duration: 300, easing: Easing.easeInOut Easing.quad, useNativeDriver: true }
                      ]
                  Animated.start anim
              , smallBtn "Spring" do
                  let anim = Animated.spring slideAnim { toValue: 50.0, useNativeDriver: true }
                  Animated.startWithCallback anim
                    ( mkEffectFn1 \_ -> do
                        let back' = Animated.spring slideAnim { toValue: 0.0, useNativeDriver: true }
                        Animated.start back'
                    )
              ]
          , Animated.animatedView { style: Style.styles [ tw "bg-blue-500 p-4 rounded-lg", Style.style { opacity: fadeAnim, transform: [ { translateX: slideAnim } ] } ] }
              [ Animated.animatedText { style: tw "text-white font-bold text-center" } "Animated Box" ]
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "PanResponder"
          , text { style: tw $ "text-sm " <> tc } "Drag handling via PanResponder.create"
          ]
      ]

    listsSection = fragment
      [ heading "Lists"

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "FlatList"
          , flatList
              { data: [ "Apple", "Banana", "Cherry", "Date" ]
              , renderItem: mkFn1 \{ item } -> text { style: tw "p-2 border-b border-gray-200" } (string item)
              , keyExtractor: mkFn2 \item _ -> item
              , style: tw "h-32 bg-gray-50 rounded-lg"
              }
          ]

      , card
          [ text { style: tw $ "text-base font-semibold mb-2 " <> tc } "SectionList"
          , sectionList
              { sections: [ { title: "Fruits", data: [ "Apple", "Pear" ] }, { title: "Veggies", data: [ "Carrot", "Pea" ] } ]
              , renderItem: mkFn1 \{ item } -> text { style: tw "p-2 pl-4" } (string item)
              , renderSectionHeader: mkFn1 \{ section } -> text { style: tw "p-2 font-bold bg-gray-200" } section.title
              , keyExtractor: mkFn2 \item _ -> item
              , style: tw "h-40 bg-gray-50 rounded-lg"
              }
          ]
      ]

    styledSection = fragment
      [ heading "Styled Helpers"
      , Styled.col "gap-3"
          [ Styled.row "gap-3"
              [ Styled.label ("font-bold " <> tc) "Styled.label"
              , Styled.para tc "Styled.para for paragraphs"
              ]
          , Styled.pressable "bg-purple-500 p-3 rounded-lg" (pure unit)
              [ Styled.label "text-white" "Styled.pressable" ]
          , Styled.scrollable "h-16 bg-gray-50 rounded-lg"
              [ Styled.label "p-2 text-sm" "Styled.scrollable item 1"
              , Styled.label "p-2 text-sm" "Styled.scrollable item 2"
              ]
          , Styled.container "p-4 rounded-lg"
              [ Styled.label tc "Inside Styled.container (SafeAreaView)" ]
          ]
      ]

  pure do
    safeAreaView { style: tw "flex-1" }
      ( view { style: tw $ "flex-1 " <> bg }
          [ view { style: tw "flex-row gap-2 p-4 pb-2" }
              [ sectionBtn "Components" "components"
              , sectionBtn "APIs" "apis"
              , sectionBtn "Info" "info"
              , sectionBtn "Animated" "animated"
              , sectionBtn "Lists" "lists"
              , sectionBtn "Styled" "styled"
              ]
          , case showSection of
              "lists" -> view { style: tw "flex-1 px-4" } [ listsSection ]
              _ -> scrollView { style: tw "flex-1 px-4" }
                [ case showSection of
                    "components" -> componentsSection
                    "apis" -> apisSection
                    "info" -> infoSection
                    "animated" -> animatedSection
                    "styled" -> styledSection
                    _ -> componentsSection
                ]
          ]
      )

foreign import unsafeLength :: forall a. Array a -> Int
