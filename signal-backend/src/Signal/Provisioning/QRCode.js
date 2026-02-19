export const buildProvisioningUrlImpl = ({ address, publicKeySerialized }) => {
  const pubKeyBase64 = Buffer.from(publicKeySerialized).toString("base64");
  const params = new URLSearchParams({
    uuid: address,
    pub_key: pubKeyBase64,
    capabilities: "",
  });
  return `sgnl://linkdevice?${params.toString()}`;
};
