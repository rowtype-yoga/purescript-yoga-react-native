import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSOutlineView")) c = requireNativeComponent("MacOSOutlineView"); } catch (e) {}
}
export const _outlineViewImpl = c;
