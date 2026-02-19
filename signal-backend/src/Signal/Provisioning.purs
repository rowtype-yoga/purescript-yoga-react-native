module Signal.Provisioning where

import Prelude

import Effect.Aff (Aff)
import Effect.Aff.AVar as AffAVar
import Effect.AVar as AVar
import Effect.Class (liftEffect)
import Effect.Console as Console
import Signal.Keys as Keys
import Signal.Net as Net
import Signal.Provisioning.Cipher (ProvisionMessage)
import Signal.Provisioning.Cipher as Cipher
import Signal.Provisioning.QRCode as QRCode

provision :: Net.SignalNet -> (String -> Aff Unit) -> Aff ProvisionMessage
provision net onQRCode = do
  privateKey <- liftEffect Keys.generatePrivateKey
  publicKey <- liftEffect $ Keys.getPublicKey privateKey
  publicKeySerialized <- liftEffect $ Keys.serializePublicKey publicKey
  messageVar <- liftEffect AVar.empty
  urlVar <- liftEffect AVar.empty

  let
    listener =
      { onReceivedAddress: \address ack -> do
          url <- QRCode.buildProvisioningUrl address publicKeySerialized
          Console.log "Provisioning: QR code ready"
          void $ AVar.tryPut url urlVar
          Net.ack ack 200
      , onReceivedEnvelope: \envelope ack -> do
          Console.log "Provisioning: decrypting envelope..."
          msg <- Cipher.decryptProvisionEnvelope envelope privateKey
          void $ AVar.tryPut msg messageVar
          Net.ack ack 200
      , onConnectionInterrupted:
          Console.log "Provisioning: connection closed"
      }

  _conn <- Net.connectProvisioning net listener

  url <- AffAVar.read urlVar
  onQRCode url

  AffAVar.read messageVar
