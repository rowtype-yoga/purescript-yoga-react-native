import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSRiveView"))
      c = requireNativeComponent("MacOSRiveView");
  } catch (e) {}
}

export const _nativeRiveViewImpl = c;
