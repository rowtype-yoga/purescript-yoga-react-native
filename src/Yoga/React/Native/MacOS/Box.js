import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSBox")) c = requireNativeComponent("MacOSBox"); } catch (e) {}
}
export const _boxImpl = c;
