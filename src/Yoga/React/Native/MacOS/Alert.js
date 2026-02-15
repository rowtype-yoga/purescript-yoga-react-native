import { NativeModules, Platform } from "react-native";

export const alertImpl = (style, title, message, buttons) => () => {
  if (Platform.OS !== "macos" || !NativeModules.MacOSAlertModule) return 0;
  // NSAlert is synchronous on macOS — but NativeModules are async
  // Fall back to the RN Alert API with callback-based approach
  const { Alert } = require("react-native");
  return new Promise((resolve) => {
    const mapped = buttons.map((b, i) => ({ text: b, onPress: () => resolve(i) }));
    if (mapped.length === 0) mapped.push({ text: "OK", onPress: () => resolve(0) });
    Alert.alert(title, message, mapped);
  });
};
