import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeTextEditor")) c = requireNativeComponent("NativeTextEditor"); } catch (e) {}
}
export const _textEditorImpl = c;
