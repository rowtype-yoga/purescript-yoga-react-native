import { requireNativeComponent, Platform, UIManager, View } from "react-native";

let _impl = View;
if (Platform.OS === "macos") {
  try {
    const config = UIManager.getViewManagerConfig("GhosttyTerminal");
    if (config) {
      _impl = requireNativeComponent("GhosttyTerminal");
    }
  } catch (e) {
    // fallback to View
  }
}
export const _ghosttyTerminalImpl = _impl;
