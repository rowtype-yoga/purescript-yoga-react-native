import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSScrollView"))
      c = requireNativeComponent("MacOSScrollView");
  } catch (e) {}
}

export const _nativeScrollViewImpl = c;
