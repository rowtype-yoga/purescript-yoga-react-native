import { NativeModules, Platform } from "react-native";

const mkAff = (promise) => (onError, onSuccess) => {
  promise.then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) =>
    onCancelerSuccess();
};

export const recognizeTextImpl = (imagePath) => {
  if (Platform.OS !== "macos") return mkAff(Promise.resolve(""));
  const mod = NativeModules.MacOSOCRModule;
  if (mod && mod.recognize) {
    return mkAff(mod.recognize(imagePath));
  }
  return mkAff(Promise.resolve(""));
};
