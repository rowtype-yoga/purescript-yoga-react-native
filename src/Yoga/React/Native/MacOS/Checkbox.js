import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSCheckbox")) c = requireNativeComponent("MacOSCheckbox"); } catch (e) {}
}
export const _checkboxImpl = c;
