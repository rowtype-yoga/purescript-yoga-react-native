import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeSwitch")) c = requireNativeComponent("NativeSwitch"); } catch (e) {}
}
export const _switchImpl = c;
