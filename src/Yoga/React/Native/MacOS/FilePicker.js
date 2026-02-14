import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSFilePicker"))
      c = requireNativeComponent("MacOSFilePicker");
  } catch (e) {}
}

export const _filePickerImpl = c;
