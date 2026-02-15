import {
  requireNativeComponent,
  Platform,
  UIManager,
  View,
} from "react-native";

export const nativeComponent = (name) => {
  if (Platform.OS !== "macos") return View;
  try {
    if (UIManager.getViewManagerConfig(name))
      return requireNativeComponent(name);
  } catch (_) {}
  return View;
};
