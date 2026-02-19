module Signal.Net where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn1, mkEffectFn2, runEffectFn1, runEffectFn2)
import Promise (Promise)
import Promise.Aff (toAffE) as Promise

foreign import data SignalNet :: Type
foreign import data ProvisioningConnection :: Type
foreign import data ChatServerMessageAck :: Type

data Environment = Staging | Production

foreign import createNetImpl :: EffectFn1 { env :: Int, userAgent :: String } SignalNet

createNet :: Environment -> String -> Effect SignalNet
createNet env userAgent = runEffectFn1 createNetImpl { env: envToInt env, userAgent }
  where
  envToInt Staging = 0
  envToInt Production = 1

type ProvisioningListenerImpl =
  { onReceivedAddress :: EffectFn2 String ChatServerMessageAck Unit
  , onReceivedEnvelope :: EffectFn2 Uint8Array ChatServerMessageAck Unit
  , onConnectionInterrupted :: EffectFn1 {} Unit
  }

type ProvisioningListener =
  { onReceivedAddress :: String -> ChatServerMessageAck -> Effect Unit
  , onReceivedEnvelope :: Uint8Array -> ChatServerMessageAck -> Effect Unit
  , onConnectionInterrupted :: Effect Unit
  }

foreign import connectProvisioningImpl :: EffectFn2 SignalNet ProvisioningListenerImpl (Promise ProvisioningConnection)
foreign import disconnectProvisioningImpl :: EffectFn1 ProvisioningConnection (Promise Unit)
foreign import ackImpl :: EffectFn2 ChatServerMessageAck Int Unit

connectProvisioning :: SignalNet -> ProvisioningListener -> Aff ProvisioningConnection
connectProvisioning net listener = do
  let
    listenerImpl =
      { onReceivedAddress: mkEffectFn2 listener.onReceivedAddress
      , onReceivedEnvelope: mkEffectFn2 listener.onReceivedEnvelope
      , onConnectionInterrupted: mkEffectFn1 \_ -> listener.onConnectionInterrupted
      }
  runEffectFn2 connectProvisioningImpl net listenerImpl # Promise.toAffE

disconnectProvisioning :: ProvisioningConnection -> Aff Unit
disconnectProvisioning conn = runEffectFn1 disconnectProvisioningImpl conn # Promise.toAffE

ack :: ChatServerMessageAck -> Int -> Effect Unit
ack = runEffectFn2 ackImpl
