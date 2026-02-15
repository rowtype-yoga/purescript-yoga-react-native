import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSPDFView")) c = requireNativeComponent("MacOSPDFView"); } catch (e) {}
}
export const _pdfViewImpl = c;
