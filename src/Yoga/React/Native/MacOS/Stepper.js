import { requireNativeComponent, Platform, UIManager, View } from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try { if (UIManager.getViewManagerConfig("MacOSStepper")) c = requireNativeComponent("MacOSStepper"); } catch (e) {}
}
export const _stepperImpl = c;
