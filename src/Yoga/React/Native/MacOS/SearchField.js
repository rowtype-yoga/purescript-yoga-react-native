import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSSearchField")) c = requireNativeComponent("MacOSSearchField"); } catch (e) {}
}
export const _searchFieldImpl = c;
