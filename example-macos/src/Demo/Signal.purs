module Demo.Signal (signalDemo) where

import Prelude

import Data.Maybe (Maybe(..))
import Demo.Shared (DemoProps)
import Effect (Effect)
import Effect.Uncurried (EffectFn5, runEffectFn5)
import React.Basic (JSX)
import React.Basic.Hooks (useEffect, useState', (/\))
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.Style as Style

foreign import data WebSocket :: Type
foreign import createWebSocketImpl :: EffectFn5 String (Effect Unit) (String -> Effect Unit) (Effect Unit) (String -> Effect Unit) WebSocket
foreign import closeWebSocket :: WebSocket -> Effect Unit

createWebSocket :: String -> Effect Unit -> (String -> Effect Unit) -> Effect Unit -> (String -> Effect Unit) -> Effect WebSocket
createWebSocket url onOpen onMessage onClose onError =
  runEffectFn5 createWebSocketImpl url onOpen onMessage onClose onError

signalDemo :: DemoProps -> JSX
signalDemo dp = signalComponent { dp }
  where
  signalComponent = component "SignalDemo" \{ dp: dp' } -> React.do
    status /\ setStatus <- useState' "Connecting to backend..."
    qrUrl /\ setQrUrl <- useState' (Nothing :: Maybe String)
    useEffect unit do
      ws <- createWebSocket "ws://127.0.0.1:8765"
        (setStatus "Connected, waiting for QR code...")
        (\msg -> do
            setQrUrl (Just msg)
            setStatus "QR code ready - scan with Signal on your phone"
        )
        (setStatus "Disconnected from backend")
        (\err -> setStatus $ "Error: " <> err)
      pure (closeWebSocket ws)

    pure do
      view { style: tw "flex-1 p-6" <> Style.style { backgroundColor: dp'.bg } }
        [ text
            { style: tw "text-2xl font-bold mb-4" <> Style.style { color: dp'.fg } }
            "Signal Device Linking"
        , text
            { style: tw "text-sm mb-4" <> Style.style { color: dp'.dimFg } }
            status
        , case qrUrl of
            Nothing ->
              view { style: tw "items-center justify-center p-8" }
                [ text
                    { style: tw "text-sm" <> Style.style { color: dp'.dimFg } }
                    "Waiting for provisioning URL..."
                ]
            Just url ->
              view { style: tw "rounded-lg p-4" <> Style.style { backgroundColor: dp'.cardBg } }
                [ text
                    { style: tw "text-sm font-semibold mb-2" <> Style.style { color: dp'.fg } }
                    "Provisioning URL:"
                , text
                    { style: tw "text-xs font-mono" <> Style.style { color: dp'.dimFg } }
                    url
                , text
                    { style: tw "text-xs mt-4" <> Style.style { color: dp'.dimFg } }
                    "Open Signal on your phone > Settings > Linked Devices > Link New Device"
                ]
        ]
