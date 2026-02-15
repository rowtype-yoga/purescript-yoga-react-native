import { NativeModules, Platform } from "react-native";

export const alertImpl = (style, title, message, buttons) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSAlertModule;
  if (mod && mod.show) {
    mod
      .show(style, title, message, buttons)
      .catch((e) => console.error("[macosAlert]", e));
    return;
  }
  try {
    const { Alert } = require("react-native");
    const mapped = buttons.map((b) => ({ text: b }));
    if (mapped.length === 0) mapped.push({ text: "OK" });
    Alert.alert(title, message, mapped);
  } catch (e) {
    console.warn("macosAlert: no alert implementation available", e);
  }
};
