import {
  requireNativeComponent,
  Platform,
  UIManager,
  View,
} from "react-native";

let _impl = View;
if (Platform.OS === "macos") {
  try {
    const config = UIManager.getViewManagerConfig("SFSymbol");
    if (config) {
      _impl = requireNativeComponent("SFSymbol");
    } else {
      console.warn(
        "[SFSymbol] Native component not found, using View fallback",
      );
    }
  } catch (e) {
    console.warn("[SFSymbol] Failed to load native component:", e.message);
  }
}
export const _sfSymbolImpl = _impl;
