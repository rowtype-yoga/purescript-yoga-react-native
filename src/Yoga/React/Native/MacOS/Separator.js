import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSSeparator")) c = requireNativeComponent("MacOSSeparator"); } catch (e) {}
}
export const _separatorImpl = c;
