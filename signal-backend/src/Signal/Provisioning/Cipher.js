import { PrivateKey, PublicKey, hkdf } from "@signalapp/libsignal-client";
import { createDecipheriv, createHmac } from "node:crypto";

// Protobuf decoding for ProvisionEnvelope and ProvisionMessage
// These are simple enough to decode manually without a protobuf library

function decodeVarint(buf, offset) {
  let result = 0;
  let shift = 0;
  let pos = offset;
  while (pos < buf.length) {
    const byte = buf[pos];
    result |= (byte & 0x7f) << shift;
    pos++;
    if ((byte & 0x80) === 0) break;
    shift += 7;
  }
  return { value: result, bytesRead: pos - offset };
}

function decodeProtobuf(buf) {
  const fields = {};
  let pos = 0;
  while (pos < buf.length) {
    const { value: tag, bytesRead: tagBytes } = decodeVarint(buf, pos);
    pos += tagBytes;
    const fieldNumber = tag >>> 3;
    const wireType = tag & 0x7;

    if (wireType === 0) {
      // varint
      const { value, bytesRead } = decodeVarint(buf, pos);
      pos += bytesRead;
      fields[fieldNumber] = value;
    } else if (wireType === 2) {
      // length-delimited
      const { value: len, bytesRead } = decodeVarint(buf, pos);
      pos += bytesRead;
      fields[fieldNumber] = buf.slice(pos, pos + len);
      pos += len;
    } else {
      break; // unknown wire type
    }
  }
  return fields;
}

function decodeProvisionEnvelope(buf) {
  const fields = decodeProtobuf(buf);
  return {
    publicKey: fields[1] || null,
    body: fields[2] || null,
  };
}

function decodeProvisionMessage(buf) {
  const fields = decodeProtobuf(buf);
  return {
    aciIdentityKeyPublic: fields[1] || null,
    aciIdentityKeyPrivate: fields[2] || null,
    number: fields[3] ? new TextDecoder().decode(fields[3]) : null,
    provisioningCode: fields[4]
      ? new TextDecoder().decode(fields[4])
      : null,
    userAgent: fields[5] ? new TextDecoder().decode(fields[5]) : null,
    profileKey: fields[6] || null,
    readReceipts: fields[7] || null,
    aci: fields[8] ? new TextDecoder().decode(fields[8]) : null,
    provisioningVersion: fields[9] ?? null,
    pni: fields[10] ? new TextDecoder().decode(fields[10]) : null,
    pniIdentityKeyPublic: fields[11] || null,
    pniIdentityKeyPrivate: fields[12] || null,
    masterKey: fields[13] || null,
    ephemeralBackupKey: fields[14] || null,
    accountEntropyPool: fields[15]
      ? new TextDecoder().decode(fields[15])
      : null,
    mediaRootBackupKey: fields[16] || null,
  };
}

export const decryptProvisionEnvelopeImpl = ({ envelope, privateKey }) => {
  // 1. Decode the ProvisionEnvelope protobuf
  const env = decodeProvisionEnvelope(
    envelope instanceof Uint8Array ? envelope : new Uint8Array(envelope)
  );
  if (!env.publicKey || !env.body) {
    throw new Error("Invalid provision envelope: missing publicKey or body");
  }

  // 2. Verify version byte
  const message = new Uint8Array(env.body);
  if (message[0] !== 1) {
    throw new Error(`Unsupported provisioning version: ${message[0]}`);
  }

  // 3. Extract iv, ciphertext, mac
  const iv = message.slice(1, 17);
  const mac = message.slice(message.length - 32);
  const ivAndCiphertext = message.slice(0, message.length - 32);
  const ciphertext = message.slice(17, message.length - 32);

  // 4. ECDH agreement
  const theirPublicKey = PublicKey.deserialize(Buffer.from(env.publicKey));
  const sharedSecret = privateKey.agree(theirPublicKey);

  // 5. Derive keys via HKDF
  const salt = new Uint8Array(32); // 32 zero bytes
  const info = new TextEncoder().encode("TextSecure Provisioning Message");
  const derivedKeys = hkdf(96, sharedSecret, info, salt);
  const aesKey = derivedKeys.slice(0, 32);
  const hmacKey = derivedKeys.slice(32, 64);

  // 6. Verify HMAC
  const hmac = createHmac("sha256", Buffer.from(hmacKey));
  hmac.update(Buffer.from(ivAndCiphertext));
  const computedMac = new Uint8Array(hmac.digest());
  if (!constantTimeEqual(computedMac, mac)) {
    throw new Error("HMAC verification failed");
  }

  // 7. Decrypt AES-256-CBC
  const decipher = createDecipheriv(
    "aes-256-cbc",
    Buffer.from(aesKey),
    Buffer.from(iv)
  );
  const decrypted = Buffer.concat([
    decipher.update(Buffer.from(ciphertext)),
    decipher.final(),
  ]);

  // 8. Decode ProvisionMessage protobuf
  return decodeProvisionMessage(new Uint8Array(decrypted));
};

function constantTimeEqual(a, b) {
  if (a.length !== b.length) return false;
  let result = 0;
  for (let i = 0; i < a.length; i++) {
    result |= a[i] ^ b[i];
  }
  return result === 0;
}
