import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSPatternBackground"))
      c = requireNativeComponent("MacOSPatternBackground");
  } catch (e) {}
}

export const _patternBackgroundImpl = c;
