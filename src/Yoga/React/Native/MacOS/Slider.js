import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeSlider")) c = requireNativeComponent("NativeSlider"); } catch (e) {}
}
export const _sliderImpl = c;
