import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSSheet")) c = requireNativeComponent("MacOSSheet"); } catch (e) {}
}
export const _sheetImpl = c;
