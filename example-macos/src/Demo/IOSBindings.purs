module Demo.IOSBindings
  ( iosDemo
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable (toMaybe)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (pressable, scrollView, text, tw)
import Yoga.React.Native.IOS.ActionSheet as ActionSheet
import Yoga.React.Native.IOS.Appearance as Appearance
import Yoga.React.Native.IOS.Haptics as Haptics
import Yoga.React.Native.IOS.LinkingIOS as LinkingIOS
import Yoga.React.Native.IOS.SafeArea as SafeArea
import Yoga.React.Native.Style as Style

iosDemo :: {} -> JSX
iosDemo = component "IOSDemo" \_ -> React.do
  status /\ setStatus <- useState' "Ready"
  pure do
    SafeArea.safeAreaView { style: tw "flex-1" <> Style.style { backgroundColor: "#FFFFFF" } }
      ( scrollView { style: tw "flex-1" <> Style.style { padding: 16.0 } }
          [ heading "iOS Bindings Test"
          , statusLine status

          , section "ActionSheet"
          , btn "Show Action Sheet" do
              ActionSheet.showActionSheet
                { options: [ "Cancel", "Save", "Delete" ]
                , cancelButtonIndex: 0
                , destructiveButtonIndex: 2
                , title: "Choose Action"
                }
                \idx -> setStatus ("Selected index: " <> show idx)

          , section "Haptics"
          , btn "Vibrate 400ms" (Haptics.vibrate 400)
          , btn "Impact Light" (Haptics.impact Haptics.impactLight)
          , btn "Impact Medium" (Haptics.impact Haptics.impactMedium)
          , btn "Impact Heavy" (Haptics.impact Haptics.impactHeavy)
          , btn "Notification Success" (Haptics.notification Haptics.notificationSuccess)
          , btn "Notification Warning" (Haptics.notification Haptics.notificationWarning)
          , btn "Notification Error" (Haptics.notification Haptics.notificationError)
          , btn "Selection Changed" Haptics.selectionChanged
          , btn "Cancel Vibration" Haptics.cancel

          , section "Appearance"
          , btn "Get Color Scheme" do
              scheme <- Appearance.getColorScheme
              setStatus ("Color scheme: " <> scheme)

          , section "Linking"
          , btn "Can Open https://purescript.org?" do
              launchAff_ do
                can <- LinkingIOS.canOpenURL "https://purescript.org"
                liftEffect (setStatus ("Can open https: " <> show can))
          , btn "Get Initial URL" do
              launchAff_ do
                mUrl <- LinkingIOS.getInitialURL
                let urlStr = case toMaybe mUrl of
                      Nothing -> "none"
                      Just u -> u
                liftEffect (setStatus ("Initial URL: " <> urlStr))
          , btn "Open Settings" do
              launchAff_ LinkingIOS.openSettings

          , section "SafeArea"
          , statusLine "SafeAreaView is wrapping this entire screen - check the notch area"
          ]
      )

heading :: String -> JSX
heading t =
  text { style: tw "text-xl font-bold mb-4" <> Style.style { color: "#000000" } } t

statusLine :: String -> JSX
statusLine s =
  text { style: tw "text-sm mb-4" <> Style.style { color: "#666666" } } s

section :: String -> JSX
section t =
  text { style: tw "text-lg font-semibold mt-4 mb-2" <> Style.style { color: "#000000" } } t

btn :: String -> Effect Unit -> JSX
btn title onPress =
  pressable
    { onPress: handler_ onPress
    , style: Style.style { backgroundColor: "#007AFF", borderRadius: 8.0, padding: 12.0, marginBottom: 8.0 }
    }
    (text { style: tw "text-sm font-medium" <> Style.style { color: "#FFFFFF", textAlign: "center" } } title)
