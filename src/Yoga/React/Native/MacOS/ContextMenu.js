import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSContextMenu"))
      c = requireNativeComponent("MacOSContextMenu");
  } catch (e) {}
}

export const _contextMenuImpl = c;
