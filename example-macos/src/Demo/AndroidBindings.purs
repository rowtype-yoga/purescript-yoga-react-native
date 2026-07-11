module Demo.AndroidBindings
  ( androidDemo
  ) where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks (useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (pressable, scrollView, text, tw)
import Yoga.React.Native.Android.BackHandler as BackHandler
import Yoga.React.Native.Android.Permissions as Permissions
import Yoga.React.Native.Android.Toast as Toast
import Yoga.React.Native.Style as Style

androidDemo :: {} -> JSX
androidDemo = component "AndroidDemo" \_ -> React.do
  status /\ setStatus <- useState' "Ready"
  pure do
    scrollView { style: tw "flex-1" <> Style.style { padding: 16.0, backgroundColor: "#FFFFFF" } }
      [ heading "Android Bindings Test"
      , statusLine status

      , section "Toast"
      , btn "Show Short Toast" (Toast.show "Hello from PureScript!" Toast.short)
      , btn "Show Long Toast" (Toast.show "This is a long toast" Toast.long)
      , btn "Toast with Gravity (Top)" (Toast.showWithGravity "Top toast!" Toast.short Toast.top)
      , btn "Toast with Gravity (Center)" (Toast.showWithGravity "Center toast!" Toast.short Toast.center)
      , btn "Toast with Gravity (Bottom)" (Toast.showWithGravity "Bottom toast!" Toast.short Toast.bottom)

      , section "Permissions"
      , btn "Check Camera Permission" do
          launchAff_ do
            granted <- Permissions.check Permissions.camera
            liftEffect (setStatus ("Camera permission: " <> show granted))
      , btn "Request Camera Permission" do
          launchAff_ do
            result <- Permissions.request Permissions.camera
            let
              s
                | Permissions.isGranted result = "granted"
                | Permissions.isDenied result = "denied"
                | Permissions.isNeverAskAgain result = "never ask again"
                | otherwise = "unknown"
            liftEffect (setStatus ("Camera permission result: " <> s))
      , btn "Request Location Permission" do
          launchAff_ do
            result <- Permissions.request Permissions.accessFineLocation
            let
              s
                | Permissions.isGranted result = "granted"
                | Permissions.isDenied result = "denied"
                | otherwise = "other"
            liftEffect (setStatus ("Location permission result: " <> s))

      , section "BackHandler"
      , btn "Add Back Handler (logs)" do
          _sub <- BackHandler.addEventListener "hardwareBackPress" do
            setStatus "Back button pressed!"
            pure true
          setStatus "Back handler registered"
      ]

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
    , style: Style.style { backgroundColor: "#4CAF50", borderRadius: 8.0, padding: 12.0, marginBottom: 8.0 }
    }
    (text { style: tw "text-sm font-medium" <> Style.style { color: "#FFFFFF", textAlign: "center" } } title)
