import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeTextField")) c = requireNativeComponent("NativeTextField"); } catch (e) {}
}
export const _textFieldImpl = c;
