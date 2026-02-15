import { NativeModules, Platform } from "react-native";

export const shareImpl = (items) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSShareModule;
  if (mod && mod.share) {
    mod.share(items).catch((e) => console.error("[macosShare]", e));
  }
};
