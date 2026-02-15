import { NativeModules, Platform } from "react-native";

export const alertImpl = (style, title, message, buttons) => () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSAlertModule;
  if (mod) {
    mod.show(style, title, message, buttons);
  }
};
