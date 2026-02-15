import { NativeModules, Platform } from "react-native";

export const recognizeImpl = (imagePath, callback) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSOCRModule;
  if (mod && mod.recognize) {
    mod
      .recognize(imagePath)
      .then((text) => callback(text)())
      .catch((e) => console.error("[macosOCR]", e));
  }
};
