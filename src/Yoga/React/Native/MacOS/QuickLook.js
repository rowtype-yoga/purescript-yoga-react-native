import { NativeModules, Platform } from "react-native";

export const previewImpl = (path) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSQuickLookModule;
  if (mod && mod.preview) {
    mod.preview(path).catch((e) => console.error("[macosQuickLook]", e));
  }
};
