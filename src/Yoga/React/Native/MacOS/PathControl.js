import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSPathControl")) c = requireNativeComponent("MacOSPathControl"); } catch (e) {}
}
export const _pathControlImpl = c;
