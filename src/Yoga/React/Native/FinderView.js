import { requireNativeComponent, Platform, UIManager, View } from "react-native";

let _impl = View;
if (Platform.OS === "macos") {
  try {
    const config = UIManager.getViewManagerConfig("FinderView");
    if (config) {
      _impl = requireNativeComponent("FinderView");
    }
  } catch (e) {
    // fallback to View
  }
}
export const _finderViewImpl = _impl;
