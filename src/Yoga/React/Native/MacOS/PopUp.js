import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativePopUp")) c = requireNativeComponent("NativePopUp"); } catch (e) {}
}
export const _popUpImpl = c;
