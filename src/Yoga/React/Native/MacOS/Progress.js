import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeProgress")) c = requireNativeComponent("NativeProgress"); } catch (e) {}
}
export const _progressImpl = c;
