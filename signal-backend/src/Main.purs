module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console as Console
import Effect.Ref as Ref
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn1, mkEffectFn2, runEffectFn1)
import Foreign (Foreign)
import Signal.Net as Net
import Signal.Provisioning as Provisioning

foreign import sendToWs :: Foreign -> String -> Effect Unit
foreign import serveWithWsImpl :: EffectFn1
  { port :: Int
  , host :: String
  , wsOpen :: EffectFn1 Foreign Unit
  , wsMessage :: EffectFn2 Foreign Foreign Unit
  , wsClose :: EffectFn2 Foreign Foreign Unit
  }
  Unit

main :: Effect Unit
main = launchAff_ do
  liftEffect $ Console.log "Signal backend starting..."

  net <- liftEffect $ Net.createNet Net.Production "SignalPureScript/0.1"
  wsClientRef <- liftEffect $ Ref.new (Nothing :: Maybe Foreign)

  liftEffect $ runEffectFn1 serveWithWsImpl
    { port: 8765
    , host: "127.0.0.1"
    , wsOpen: mkEffectFn1 \ws -> do
        Console.log "WebSocket client connected"
        Ref.write (Just ws) wsClientRef
        launchAff_ do
          msg <- Provisioning.provision net \url -> liftEffect do
            Console.log $ "QR URL: " <> url
            mWs <- Ref.read wsClientRef
            case mWs of
              Just ws' -> sendToWs ws' url
              Nothing -> pure unit
          liftEffect $ Console.log $ "Provisioned! Number: " <> show msg.number
    , wsMessage: mkEffectFn2 \_ _ -> pure unit
    , wsClose: mkEffectFn2 \_ _ -> do
        Console.log "WebSocket client disconnected"
        Ref.write Nothing wsClientRef
    }

  liftEffect $ Console.log "Server running on ws://127.0.0.1:8765"
