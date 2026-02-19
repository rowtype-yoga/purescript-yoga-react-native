import {
  PrivateKey,
  PublicKey,
} from "@signalapp/libsignal-client";

export const generatePrivateKeyImpl = () => PrivateKey.generate();

export const getPublicKeyImpl = (privateKey) => privateKey.getPublicKey();

export const serializePublicKeyImpl = (publicKey) => publicKey.serialize();

export const agreeImpl = ({ privateKey, otherKey }) =>
  privateKey.agree(otherKey);

export const deserializePublicKeyImpl = (buf) => PublicKey.deserialize(buf);
