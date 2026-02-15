import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSSplitView")) c = requireNativeComponent("MacOSSplitView"); } catch (e) {}
}
export const _splitViewImpl = c;
