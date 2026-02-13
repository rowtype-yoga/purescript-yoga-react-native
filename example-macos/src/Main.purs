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

    -- Colors (hex fallbacks — platformColor crashes on macOS 0.81)
    windowBg = if isDark then "#1d1d1f" else "#f5f5f7"
    controlBg = if isDark then "#2c2c2e" else "#f2f2f7"
    controlClr = if isDark then "#3a3a3c" else "#e5e5ea"
    accentClr = "#007AFF"
    separatorClr = if isDark then "#3a3a3c" else "#c6c6c8"
    textBgClr = if isDark then "#1c1c1e" else "#ffffff"

    cardBg = if isDark then "#2c2c2e" else "#ffffff"
    cardBorder = if isDark then "#3a3a3c" else "#d1d1d6"
    subtleBg = if isDark then "#3a3a3c" else "#e5e5ea"

    card kids = view
      { style: Style.styles
          [ tw "rounded-xl p-4 mb-3"
          , Style.style
              { backgroundColor: cardBg
              , borderWidth: StyleSheet.hairlineWidth
              , borderColor: cardBorder
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
            , Style.style { backgroundColor: accentClr }
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
                { backgroundColor: controlClr
                , borderWidth: StyleSheet.hairlineWidth
                , borderColor: cardBorder
                }
            ]
        , cursor: "pointer"
        , tooltip: lbl
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
                  { style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: subtleBg } ]
                  , tooltip: "A nested view"
                  }
                  [ text { style: tw $ "text-sm " <> tc } "Nested" ]
              , view
                  { style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: subtleBg } ]
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
                  , style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: "#34C759" } ]
                  }
                  [ text { style: tw "text-white text-center" } "TouchableOpacity" ]
              , touchableHighlight
                  { onPress: handler_ (pure unit)
                  , underlayColor: "#ddd"
                  , style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: "#FF9500" } ]
                  }
                  [ text { style: tw "text-white text-center" } "TouchableHighlight" ]
              , touchableWithoutFeedback { onPress: handler_ (pure unit) }
                  ( view
                      { style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: "#FF3B30" } ] }
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
          [ label' "Modal"
          , caption "(disabled — crashes on macOS)"
          ]

      , card
          [ label' "KeyboardAvoidingView"
          , keyboardAvoidingView { behavior: "padding" }
              (bodyText "Content adjusts for keyboard")
          ]

      , card
          [ label' "InputAccessoryView"
          , caption "(iOS only)"
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
          [ label' "FlatList"
          , caption "(shown in Lists tab to avoid VirtualizedList nesting)"
          ]

      , card
          [ label' "SectionList"
          , caption "(shown in Lists tab to avoid VirtualizedList nesting)"
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

      , card
          [ label' "SafeAreaView"
          , bodyText "Wrapping app content for safe insets"
          ]
      ]

    apisSection = fragment
      [ heading "APIs"

      , card
          [ label' "Alert"
          , view { style: tw "flex-row gap-2" }
              [ accentBtn "Simple" (Alert.alert "Hello" "Simple alert")
              , secondaryBtn "With Buttons"
                  ( Alert.alertWithButtons "Choose" "Pick one"
                      [ { text: "Cancel", onPress: pure unit, style: "cancel" }
                      , { text: "OK", onPress: pure unit, style: "default" }
                      ]
                  )
              ]
          ]

      , card
          [ label' "Clipboard"
          , view { style: tw "gap-2" }
              [ accentBtn "Copy 'Hello'" (Clipboard.setString "Hello")
              , secondaryBtn "Paste"
                  ( launchAff_ do
                      t <- Clipboard.getString
                      liftEffect $ setClipboardText (const t)
                  )
              , bodyText ("Clipboard: " <> clipboardText)
              ]
          ]

      , card
          [ label' "Linking"
          , accentBtn "Open URL" (launchAff_ $ Linking.openURL "https://purescript.org")
          ]

      , card
          [ label' "Share"
          , caption "(iOS only)"
          ]

      , card
          [ label' "Keyboard"
          , secondaryBtn "Dismiss Keyboard" Keyboard.dismiss
          ]

      , card
          [ label' "ActionSheetIOS"
          , accentBtn "Show Action Sheet"
              ( ActionSheetIOS.showActionSheet
                  { options: [ "Cancel", "Save", "Delete" ]
                  , cancelButtonIndex: 0
                  , destructiveButtonIndex: 2
                  }
                  (mkEffectFn1 \idx -> Alert.alert "Selected" ("Index: " <> show idx))
              )
          ]

      , card
          [ label' "LayoutAnimation"
          , view { style: tw "flex-row gap-2" }
              [ accentBtn "Add Item" do
                  LayoutAnimation.easeInEaseOut
                  setItems (\arr -> snoc arr ("Item " <> show (1 + unsafeLength arr)))
              ]
          , view { style: tw "mt-2" }
              ( items # mapWithIndex \_ item ->
                  text { style: tw $ "p-1 text-sm " <> tc } item
              )
          ]

      , card
          [ label' "AccessibilityInfo"
          , view { style: tw "gap-2" }
              [ accentBtn "Screen Reader?"
                  ( launchAff_ do
                      enabled <- AccessibilityInfo.isScreenReaderEnabled
                      liftEffect $ Alert.alert "Screen Reader" (if enabled then "Enabled" else "Disabled")
                  )
              , secondaryBtn "Announce" (AccessibilityInfo.announceForAccessibility "Hello from PureScript")
              ]
          ]

      , card
          [ label' "FS (react-native-fs)"
          , view { style: tw "gap-2" }
              [ caption ("Documents: " <> FS.documentDirectoryPath)
              , caption ("Caches: " <> FS.cachesDirectoryPath)
              , caption ("Temp: " <> FS.temporaryDirectoryPath)
              , accentBtn "Write & Read File"
                  ( launchAff_ do
                      let path = FS.documentDirectoryPath <> "/test.txt"
                      FS.writeFile path "Hello from PureScript!" "utf8"
                      content <- FS.readFile path "utf8"
                      exists <- FS.exists path
                      liftEffect $ setFsResult (const $ "Read: " <> content <> " (exists: " <> show exists <> ")")
                  )
              , bodyText fsResult
              ]
          ]
      ]

    infoSection = fragment
      [ heading "Platform Info"

      , card
          [ label' "Platform"
          , bodyText ("OS: " <> Platform.os)
          , bodyText ("TV: " <> show Platform.isTV)
          ]

      , card
          [ label' "Dimensions"
          , bodyText (show dims.width <> " x " <> show dims.height)
          , bodyText ("Scale: " <> show dims.scale <> ", FontScale: " <> show dims.fontScale)
          ]

      , card
          [ label' "PixelRatio"
          , bodyText ("Ratio: " <> show PixelRatio.get)
          , bodyText ("FontScale: " <> show PixelRatio.getFontScale)
          , bodyText ("100pt = " <> show (PixelRatio.getPixelSizeForLayoutSize 100.0) <> "px")
          ]

      , card
          [ label' "Appearance"
          , bodyText ("Color scheme: " <> show colorScheme)
          , bodyText ("Dark mode: " <> show isDark)
          ]

      , card
          [ label' "AppState"
          , bodyText ("State: " <> appState)
          ]

      , card
          [ label' "I18nManager"
          , bodyText ("RTL: " <> show I18nManager.isRTL)
          ]

      , card
          [ label' "StyleSheet"
          , bodyText ("hairlineWidth: " <> show StyleSheet.hairlineWidth)
          ]

      , card
          [ label' "Easing"
          , bodyText ("linear(0.5) = " <> show (Easing.linear 0.5))
          , bodyText ("quad(0.5) = " <> show (Easing.quad 0.5))
          , bodyText ("cubic(0.5) = " <> show (Easing.cubic 0.5))
          , bodyText ("bounce(0.5) = " <> show (Easing.bounce 0.5))
          , bodyText ("bezier(.25,.1,.25,1)(0.5) = " <> show (Easing.bezier 0.25 0.1 0.25 1.0 0.5))
          ]

      , card
          [ label' "System Colors"
          , caption "(platformColor crashes in styles on macOS 0.81 — showing hex fallbacks)"
          , view { style: tw "gap-1 mt-2" }
              [ colorSwatch "#007AFF" "accent (blue)"
              , colorSwatch "#34C759" "green"
              , colorSwatch "#FF9500" "orange"
              , colorSwatch "#FF3B30" "red"
              , colorSwatch "#AF52DE" "purple"
              , colorSwatch "#FF2D55" "pink"
              , colorSwatch "#FFCC00" "yellow"
              , colorSwatch "#A2845E" "brown"
              , colorSwatch "#8E8E93" "gray"
              ]
          ]
      ]

    colorSwatch color lbl = view { style: tw "flex-row items-center gap-2" }
      [ view
          { style: Style.styles
              [ tw "w-5 h-5 rounded"
              , Style.style
                  { backgroundColor: color
                  , borderWidth: StyleSheet.hairlineWidth
                  , borderColor: separatorClr
                  }
              ]
          , tooltip: lbl
          }
          []
      , caption lbl
      ]

    animatedSection = fragment
      [ heading "Animated"
      , card
          [ label' "Fade & Slide"
          , view { style: tw "flex-row gap-2 mb-3 flex-wrap" }
              [ accentBtn "Fade Out" do
                  let anim = Animated.timing fadeAnim { toValue: 0.0, duration: 500, useNativeDriver: false }
                  Animated.start anim
              , accentBtn "Fade In" do
                  let anim = Animated.timing fadeAnim { toValue: 1.0, duration: 500, useNativeDriver: false }
                  Animated.start anim
              , secondaryBtn "Slide" do
                  let
                    anim = Animated.sequence
                      [ Animated.timing slideAnim { toValue: 100.0, duration: 300, easing: Easing.easeInOut Easing.quad, useNativeDriver: false }
                      , Animated.timing slideAnim { toValue: 0.0, duration: 300, easing: Easing.easeInOut Easing.quad, useNativeDriver: false }
                      ]
                  Animated.start anim
              , secondaryBtn "Spring" do
                  let anim = Animated.spring slideAnim { toValue: 50.0, useNativeDriver: false }
                  Animated.startWithCallback anim
                    ( mkEffectFn1 \_ -> do
                        let back' = Animated.spring slideAnim { toValue: 0.0, useNativeDriver: false }
                        Animated.start back'
                    )
              ]
          , Animated.animatedView
              { style: Style.styles
                  [ tw "p-4 rounded-lg"
                  , Style.style
                      { opacity: fadeAnim
                      , transform: [ { translateX: slideAnim } ]
                      , backgroundColor: accentClr
                      }
                  ]
              }
              [ Animated.animatedText { style: tw "text-white font-bold text-center" } "Animated Box" ]
          ]

      , card
          [ label' "PanResponder"
          , bodyText "Drag handling via PanResponder.create"
          ]
      ]

    listsSection = fragment
      [ heading "Lists"

      , card
          [ label' "FlatList"
          , flatList
              { data: [ "Apple", "Banana", "Cherry", "Date" ]
              , renderItem: mkFn1 \{ item } ->
                  text
                    { style: Style.styles
                        [ tw "p-2"
                        , Style.style { borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: separatorClr }
                        ]
                    }
                    (string item)
              , keyExtractor: mkFn2 \item _ -> item
              , style: Style.styles [ tw "h-32 rounded-lg", Style.style { backgroundColor: controlBg } ]
              }
          ]

      , card
          [ label' "SectionList"
          , sectionList
              { sections: [ { title: "Fruits", data: [ "Apple", "Pear" ] }, { title: "Veggies", data: [ "Carrot", "Pea" ] } ]
              , renderItem: mkFn1 \{ item } ->
                  text { style: tw $ "p-2 pl-4 " <> tc } (string item)
              , renderSectionHeader: mkFn1 \{ section } ->
                  text
                    { style: Style.styles
                        [ tw "p-2 font-bold"
                        , Style.style { backgroundColor: subtleBg }
                        ]
                    }
                    section.title
              , keyExtractor: mkFn2 \item _ -> item
              , style: Style.styles [ tw "h-40 rounded-lg", Style.style { backgroundColor: controlBg } ]
              }
          ]
      ]

    macosSection = fragment
      [ heading "macOS"

      , card
          [ label' "Tooltip"
          , view
              { tooltip: "Hello from PureScript!"
              , style: Style.styles
                  [ tw "rounded-lg p-4 items-center"
                  , Style.style
                      { backgroundColor: controlBg
                      , borderWidth: StyleSheet.hairlineWidth
                      , borderColor: separatorClr
                      }
                  ]
              }
              [ text { style: tw $ "text-sm " <> tc2 }
                  "Hover over me for a tooltip"
              ]
          ]

      , card
          [ label' "Cursor"
          , view { style: tw "flex-row gap-2 flex-wrap" }
              [ cursorDemo "pointer" "#007AFF"
              , cursorDemo "grab" "#34C759"
              , cursorDemo "crosshair" "#AF52DE"
              , cursorDemo "not-allowed" "#FF3B30"
              , cursorDemo "text" "#FF9500"
              , cursorDemo "zoom-in" "#FF2D55"
              , cursorDemo "context-menu" "#A2845E"
              , cursorDemo "help" "#8E8E93"
              ]
          ]

      , card
          [ label' "Hover (onMouseEnter / onMouseLeave)"
          , view
              { onMouseEnter: handler_ (setHovered (const true))
              , onMouseLeave: handler_ (setHovered (const false))
              , cursor: "pointer"
              , style: Style.styles
                  [ tw "rounded-lg p-4 items-center"
                  , Style.style
                      { backgroundColor: if hovered then accentClr else controlBg
                      , borderWidth: if hovered then 0.0 else StyleSheet.hairlineWidth
                      , borderColor: separatorClr
                      }
                  ]
              }
              [ text
                  { style: Style.styles
                      [ tw "font-medium"
                      , tw $ if hovered then "text-white" else tc
                      ]
                  }
                  (if hovered then "Mouse is inside!" else "Hover over me")
              ]
          ]

      , card
          [ label' "Keyboard (onKeyDown)"
          , textInput
              { value: if lastKey == "" then "" else "Key: " <> lastKey
              , placeholder: "Click here and press a key"
              , onKeyDown: handler nativeEvent \(e :: { key :: String }) -> setLastKey (const e.key)
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
          [ label' "Drag & Drop"
          , view
              { draggedTypes: [ "fileUrl" ]
              , onDrop: handler nativeEvent \e -> setDroppedFile (const (unsafeStringify e))
              , onDragEnter: handler_ (pure unit)
              , onDragLeave: handler_ (pure unit)
              , style: Style.styles
                  [ tw "border-2 border-dashed rounded-lg p-6 items-center"
                  , Style.style { borderColor: separatorClr, backgroundColor: controlBg }
                  ]
              }
              [ bodyText "Drop a file here"
              , caption (if droppedFile == "" then "" else "Dropped: " <> droppedFile)
              ]
          ]

      , card
          [ label' "Vibrancy"
          , view
              { allowsVibrancy: true
              , style: Style.styles [ tw "rounded-lg p-4 items-center", Style.style { backgroundColor: subtleBg } ]
              }
              [ bodyText "allowsVibrancy: true" ]
          ]

      , card
          [ label' "acceptsFirstMouse"
          , pressable
              { acceptsFirstMouse: true
              , onPress: handler_ (Alert.alert "Click" "Received even when window was in background")
              , style: Style.styles [ tw "p-3 rounded-lg", Style.style { backgroundColor: accentClr } ]
              , cursor: "pointer"
              }
              [ text { style: tw "text-white text-center font-medium" } "Click me even when unfocused" ]
          ]
      ]

    cursorDemo cur color = view
      { cursor: cur
      , tooltip: cur
      , style: Style.styles
          [ tw "p-3 rounded-lg"
          , Style.style { backgroundColor: color }
          ]
      }
      [ text { style: tw "text-white text-xs font-medium" } cur ]

    styledSection = fragment
      [ heading "Styled Helpers"
      , Styled.col "gap-3"
          [ Styled.row "gap-3"
              [ Styled.label "font-bold text-blue-600" "Styled.label"
              , Styled.para "text-gray-500" "Styled.para for paragraphs"
              ]
          , Styled.pressable "bg-purple-500 p-3 rounded-lg" (pure unit)
              [ Styled.label "text-white" "Styled.pressable" ]
          , Styled.scrollable "h-16 bg-gray-50 rounded-lg"
              [ Styled.label "p-2 text-sm" "Styled.scrollable item 1"
              , Styled.label "p-2 text-sm" "Styled.scrollable item 2"
              ]
          , Styled.container "p-4 rounded-lg"
              [ Styled.label "text-gray-700" "Inside Styled.container (SafeAreaView)" ]
          ]
      ]

  pure do
    safeAreaView { style: tw "flex-1" }
      ( view { style: Style.styles [ tw "flex-1", Style.style { backgroundColor: windowBg } ] }
          [ view
              { style: Style.styles
                  [ tw "flex-row gap-2 p-4 pb-3"
                  , Style.style { borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: separatorClr }
                  ]
              }
              [ sectionBtn "Components" "components"
              , sectionBtn "APIs" "apis"
              , sectionBtn "Info" "info"
              , sectionBtn "Animated" "animated"
              , sectionBtn "Lists" "lists"
              , sectionBtn "macOS" "macos"
              , sectionBtn "Styled" "styled"
              ]
          , case showSection of
              "lists" -> view { style: tw "flex-1 px-4 pt-3" } [ listsSection ]
              _ -> scrollView { style: tw "flex-1 px-4 pt-3" }
                [ case showSection of
                    "components" -> componentsSection
                    "apis" -> apisSection
                    "info" -> infoSection
                    "animated" -> animatedSection
                    "macos" -> macosSection
                    "styled" -> styledSection
                    _ -> componentsSection
                , view { style: tw "h-4" } []
                ]
          ]
      )

foreign import unsafeLength :: forall a. Array a -> Int
foreign import unsafeStringify :: forall a. a -> String
