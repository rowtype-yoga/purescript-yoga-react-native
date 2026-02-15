import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSTabView")) c = requireNativeComponent("MacOSTabView"); } catch (e) {}
}
export const _tabViewImpl = c;
