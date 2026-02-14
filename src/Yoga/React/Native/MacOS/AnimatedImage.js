import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSAnimatedImage"))
      c = requireNativeComponent("MacOSAnimatedImage");
  } catch (e) {}
}

export const _animatedImageImpl = c;
