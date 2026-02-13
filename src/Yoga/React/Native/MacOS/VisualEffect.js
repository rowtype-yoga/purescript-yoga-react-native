import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSVisualEffectView"))
      c = requireNativeComponent("MacOSVisualEffectView");
  } catch (e) {}
}

export const _visualEffectImpl = c;
