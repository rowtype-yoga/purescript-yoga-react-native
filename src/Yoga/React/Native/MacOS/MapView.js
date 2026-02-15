import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSMapView")) c = requireNativeComponent("MacOSMapView"); } catch (e) {}
}
export const _mapViewImpl = c;
