import { NativeModules, Platform } from "react-native";

const mkAff = (promise) => (onError, onSuccess) => {
  promise.then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) =>
    onCancelerSuccess();
};

export const detectLanguageImpl = (text) => {
  if (Platform.OS !== "macos") return mkAff(Promise.resolve("unknown"));
  const mod = NativeModules.MacOSNLModule;
  if (mod && mod.detectLanguage) {
    return mkAff(mod.detectLanguage(text));
  }
  return mkAff(Promise.resolve("unknown"));
};

export const analyzeSentimentImpl = (text) => {
  if (Platform.OS !== "macos") return mkAff(Promise.resolve(0));
  const mod = NativeModules.MacOSNLModule;
  if (mod && mod.sentiment) {
    return mkAff(mod.sentiment(text));
  }
  return mkAff(Promise.resolve(0));
};

export const tokenizeImpl = (text) => {
  if (Platform.OS !== "macos") return mkAff(Promise.resolve([]));
  const mod = NativeModules.MacOSNLModule;
  if (mod && mod.tokenize) {
    return mkAff(mod.tokenize(text));
  }
  return mkAff(Promise.resolve([]));
};
