module Signal.Provisioning.QRCode where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)

foreign import buildProvisioningUrlImpl :: EffectFn1 { address :: String, publicKeySerialized :: Uint8Array } String

buildProvisioningUrl :: String -> Uint8Array -> Effect String
buildProvisioningUrl address publicKeySerialized =
  runEffectFn1 buildProvisioningUrlImpl { address, publicKeySerialized }
