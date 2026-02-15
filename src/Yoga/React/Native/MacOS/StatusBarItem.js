import { NativeModules, Platform } from "react-native";

export const setStatusBarItemImpl = (config) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSStatusBarModule;
  if (mod && mod.set) {
    mod.set(config).catch((e) => console.error("[macosStatusBar]", e));
  }
};

export const removeStatusBarItemImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSStatusBarModule;
  if (mod && mod.remove) {
    mod.remove().catch((e) => console.error("[macosStatusBar remove]", e));
  }
};
