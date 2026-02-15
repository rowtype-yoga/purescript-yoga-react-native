import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSHelpButton")) c = requireNativeComponent("MacOSHelpButton"); } catch (e) {}
}
export const _helpButtonImpl = c;
