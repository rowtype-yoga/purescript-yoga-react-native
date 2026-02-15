import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSRadioButton")) c = requireNativeComponent("MacOSRadioButton"); } catch (e) {}
}
export const _radioButtonImpl = c;
