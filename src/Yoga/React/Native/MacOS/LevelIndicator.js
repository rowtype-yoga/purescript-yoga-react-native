import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeLevelIndicator")) c = requireNativeComponent("NativeLevelIndicator"); } catch (e) {}
}
export const _levelIndicatorImpl = c;
