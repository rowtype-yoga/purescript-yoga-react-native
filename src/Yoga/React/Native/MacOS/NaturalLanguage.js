import { NativeModules, Platform } from "react-native";

export const detectLanguageImpl = (text, callback) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSNLModule;
  if (mod && mod.detectLanguage) {
    mod
      .detectLanguage(text)
      .then((lang) => callback(lang)())
      .catch((e) => console.error("[macosDetectLanguage]", e));
  }
};

export const sentimentImpl = (text, callback) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSNLModule;
  if (mod && mod.sentiment) {
    mod
      .sentiment(text)
      .then((score) => callback(score)())
      .catch((e) => console.error("[macosAnalyzeSentiment]", e));
  }
};

export const tokenizeImpl = (text, callback) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSNLModule;
  if (mod && mod.tokenize) {
    mod
      .tokenize(text)
      .then((tokens) => callback(tokens)())
      .catch((e) => console.error("[macosTokenize]", e));
  }
};
