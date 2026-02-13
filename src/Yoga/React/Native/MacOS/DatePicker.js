import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeDatePicker")) c = requireNativeComponent("NativeDatePicker"); } catch (e) {}
}
export const _datePickerImpl = c;
