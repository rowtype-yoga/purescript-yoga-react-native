import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSTokenField")) c = requireNativeComponent("MacOSTokenField"); } catch (e) {}
}
export const _tokenFieldImpl = c;
