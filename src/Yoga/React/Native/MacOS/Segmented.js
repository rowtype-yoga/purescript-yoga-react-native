import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeSegmented")) c = requireNativeComponent("NativeSegmented"); } catch (e) {}
}
export const _segmentedImpl = c;
