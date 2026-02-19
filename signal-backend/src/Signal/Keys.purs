module Signal.Keys where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Data.ArrayBuffer.Types (Uint8Array)

foreign import data PrivateKey :: Type
foreign import data PublicKey :: Type
foreign import data IdentityKeyPair :: Type

foreign import generatePrivateKeyImpl :: Effect PrivateKey
foreign import getPublicKeyImpl :: EffectFn1 PrivateKey PublicKey
foreign import serializePublicKeyImpl :: EffectFn1 PublicKey Uint8Array
foreign import agreeImpl :: EffectFn1 { privateKey :: PrivateKey, otherKey :: PublicKey } Uint8Array
foreign import deserializePublicKeyImpl :: EffectFn1 Uint8Array PublicKey

generatePrivateKey :: Effect PrivateKey
generatePrivateKey = generatePrivateKeyImpl

getPublicKey :: PrivateKey -> Effect PublicKey
getPublicKey = runEffectFn1 getPublicKeyImpl

serializePublicKey :: PublicKey -> Effect Uint8Array
serializePublicKey = runEffectFn1 serializePublicKeyImpl

agree :: PrivateKey -> PublicKey -> Effect Uint8Array
agree privateKey otherKey = runEffectFn1 agreeImpl { privateKey, otherKey }

deserializePublicKey :: Uint8Array -> Effect PublicKey
deserializePublicKey = runEffectFn1 deserializePublicKeyImpl
