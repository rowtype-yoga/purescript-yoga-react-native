module Yoga.React.Native
  ( module Yoga.React.Native.View
  , module Yoga.React.Native.Text
  , module Yoga.React.Native.TextInput
  , module Yoga.React.Native.ScrollView
  , module Yoga.React.Native.Pressable
  , module Yoga.React.Native.Image
  , module Yoga.React.Native.ActivityIndicator
  , module Yoga.React.Native.FlatList
  , module Yoga.React.Native.Switch
  , module Yoga.React.Native.Button
  , module Yoga.React.Native.TouchableOpacity
  , module Yoga.React.Native.TouchableHighlight
  , module Yoga.React.Native.TouchableWithoutFeedback
  , module Yoga.React.Native.Modal
  , module Yoga.React.Native.SafeAreaView
  , module Yoga.React.Native.KeyboardAvoidingView
  , module Yoga.React.Native.ImageBackground
  , module Yoga.React.Native.SectionList
  , module Yoga.React.Native.RefreshControl
  , module Yoga.React.Native.StatusBar
  , module Yoga.React.Native.InputAccessoryView
  , module Yoga.React.Native.Style
  , module Yoga.React.Native.Internal
  , module Yoga.React.Native.Events
  , module Yoga.React.Native.DynamicColorMacOS
  , module Yoga.React.Native.ColorWithSystemEffectMacOS
  , string
  , registerComponent
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import React.Basic (JSX)
import Yoga.React.Native.ActivityIndicator (activityIndicator, ActivityIndicatorAttributes)
import Yoga.React.Native.Button (button, ButtonAttributes)
import Yoga.React.Native.ColorWithSystemEffectMacOS (colorWithSystemEffect)
import Yoga.React.Native.DynamicColorMacOS (dynamicColor)
import Yoga.React.Native.Events (nativeEvent)
import Yoga.React.Native.FlatList (flatList, FlatListAttributes)
import Yoga.React.Native.Image (image, ImageAttributes, ImageSource, uri)
import Yoga.React.Native.ImageBackground (imageBackground, imageBackground_, ImageBackgroundAttributes)
import Yoga.React.Native.InputAccessoryView (inputAccessoryView, inputAccessoryView_, InputAccessoryViewAttributes)
import Yoga.React.Native.Internal (class IsJSX, FFINativeComponent, FFINativeComponent_)
import Yoga.React.Native.KeyboardAvoidingView (keyboardAvoidingView, keyboardAvoidingView_, KeyboardAvoidingViewAttributes)
import Yoga.React.Native.Modal (modal, modal_, ModalAttributes)
import Yoga.React.Native.Pressable (pressable, pressable_, PressableAttributes)
import Yoga.React.Native.RefreshControl (refreshControl, RefreshControlAttributes)
import Yoga.React.Native.SafeAreaView (safeAreaView, safeAreaView_, SafeAreaViewAttributes)
import Yoga.React.Native.ScrollView (scrollView, scrollView_, ScrollViewAttributes)
import Yoga.React.Native.SectionList (sectionList, SectionListAttributes, SectionData)
import Yoga.React.Native.StatusBar (statusBar, StatusBarAttributes)
import Yoga.React.Native.Style (Style, style, styles, tw)
import Yoga.React.Native.Switch (switch, SwitchAttributes)
import Yoga.React.Native.Text (text, text_, TextAttributes)
import Yoga.React.Native.TextInput (textInput, TextInputAttributes)
import Yoga.React.Native.TouchableHighlight (touchableHighlight, touchableHighlight_, TouchableHighlightAttributes)
import Yoga.React.Native.TouchableOpacity (touchableOpacity, touchableOpacity_, TouchableOpacityAttributes)
import Yoga.React.Native.TouchableWithoutFeedback (touchableWithoutFeedback, touchableWithoutFeedback_, TouchableWithoutFeedbackAttributes)
import Yoga.React.Native.View (view, view_, ViewAttributes)

foreign import stringImpl :: String -> JSX

string :: String -> JSX
string = stringImpl

foreign import registerComponentImpl :: EffectFn2 String (Unit -> JSX) Unit

registerComponent :: String -> (Unit -> JSX) -> Effect Unit
registerComponent = runEffectFn2 registerComponentImpl
