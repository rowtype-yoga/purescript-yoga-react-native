module Signal.Provisioning.Cipher where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Signal.Keys (PrivateKey)

type ProvisionMessage =
  { aciIdentityKeyPublic :: Maybe Uint8Array
  , aciIdentityKeyPrivate :: Maybe Uint8Array
  , pniIdentityKeyPublic :: Maybe Uint8Array
  , pniIdentityKeyPrivate :: Maybe Uint8Array
  , number :: Maybe String
  , provisioningCode :: Maybe String
  , aci :: Maybe String
  , pni :: Maybe String
  , profileKey :: Maybe Uint8Array
  , masterKey :: Maybe Uint8Array
  , accountEntropyPool :: Maybe String
  , provisioningVersion :: Maybe Int
  }

type ProvisionMessageImpl =
  { aciIdentityKeyPublic :: Nullable Uint8Array
  , aciIdentityKeyPrivate :: Nullable Uint8Array
  , pniIdentityKeyPublic :: Nullable Uint8Array
  , pniIdentityKeyPrivate :: Nullable Uint8Array
  , number :: Nullable String
  , provisioningCode :: Nullable String
  , aci :: Nullable String
  , pni :: Nullable String
  , profileKey :: Nullable Uint8Array
  , masterKey :: Nullable Uint8Array
  , accountEntropyPool :: Nullable String
  , provisioningVersion :: Nullable Int
  }

foreign import decryptProvisionEnvelopeImpl :: EffectFn1 { envelope :: Uint8Array, privateKey :: PrivateKey } ProvisionMessageImpl

decryptProvisionEnvelope :: Uint8Array -> PrivateKey -> Effect ProvisionMessage
decryptProvisionEnvelope envelope privateKey = do
  r <- runEffectFn1 decryptProvisionEnvelopeImpl { envelope, privateKey }
  pure
    { aciIdentityKeyPublic: toMaybe r.aciIdentityKeyPublic
    , aciIdentityKeyPrivate: toMaybe r.aciIdentityKeyPrivate
    , pniIdentityKeyPublic: toMaybe r.pniIdentityKeyPublic
    , pniIdentityKeyPrivate: toMaybe r.pniIdentityKeyPrivate
    , number: toMaybe r.number
    , provisioningCode: toMaybe r.provisioningCode
    , aci: toMaybe r.aci
    , pni: toMaybe r.pni
    , profileKey: toMaybe r.profileKey
    , masterKey: toMaybe r.masterKey
    , accountEntropyPool: toMaybe r.accountEntropyPool
    , provisioningVersion: toMaybe r.provisioningVersion
    }
