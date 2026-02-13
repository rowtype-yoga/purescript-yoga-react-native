import { requireNativeComponent, Platform, UIManager, View } from "react-native";

let _impl = View;
if (Platform.OS === "macos") {
  try {
    const config = UIManager.getViewManagerConfig("NativeShowcase");
    if (config) {
      _impl = requireNativeComponent("NativeShowcase");
    }
  } catch (e) {
    // fallback
  }
}
export const _nativeShowcaseImpl = _impl;
