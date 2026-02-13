import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("NativeWebView")) c = requireNativeComponent("NativeWebView"); } catch (e) {}
}
export const _webViewImpl = c;
