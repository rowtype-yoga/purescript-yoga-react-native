import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSToolbar"))
      c = requireNativeComponent("MacOSToolbar");
  } catch (e) {}
}

export const _toolbarImpl = c;
