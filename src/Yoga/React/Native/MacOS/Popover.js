import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSPopover")) c = requireNativeComponent("MacOSPopover"); } catch (e) {}
}
export const _popoverImpl = c;
