import {
  requireNativeComponent,
  Platform,
  UIManager,
  View,
} from "react-native";
let c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("NativeButton"))
      c = requireNativeComponent("NativeButton");
  } catch (e) {}
}
export const _buttonImpl = c;
