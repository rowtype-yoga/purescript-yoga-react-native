import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSDropZone"))
      c = requireNativeComponent("MacOSDropZone");
  } catch (e) {}
}

export const _dropZoneImpl = c;
