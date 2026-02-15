import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSComboBox")) c = requireNativeComponent("MacOSComboBox"); } catch (e) {}
}
export const _comboBoxImpl = c;
