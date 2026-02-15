import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSTableView")) c = requireNativeComponent("MacOSTableView"); } catch (e) {}
}
export const _tableViewImpl = c;
