import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeColorWell")) c = requireNativeComponent("NativeColorWell"); } catch (e) {}
}
export const _colorWellImpl = c;
