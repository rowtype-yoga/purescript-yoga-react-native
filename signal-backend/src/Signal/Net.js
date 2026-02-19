import * as SignalNet from "@signalapp/libsignal-client/dist/net.js";

export const createNetImpl = ({ env, userAgent }) =>
  new SignalNet.Net({ env, userAgent });

export const connectProvisioningImpl = (net, listener) =>
  net.connectProvisioning({
    onReceivedAddress: (address, ack) => listener.onReceivedAddress(address, ack),
    onReceivedEnvelope: (envelope, ack) => listener.onReceivedEnvelope(envelope, ack),
    onConnectionInterrupted: (cause) => listener.onConnectionInterrupted(cause || {}),
  });

export const disconnectProvisioningImpl = (conn) => conn.disconnect();

export const ackImpl = (ack, statusCode) => ack.send(statusCode);
