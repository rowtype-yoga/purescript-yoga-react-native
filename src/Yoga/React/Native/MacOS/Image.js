import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSImage")) c = requireNativeComponent("MacOSImage"); } catch (e) {}
}
export const _imageImpl = c;
