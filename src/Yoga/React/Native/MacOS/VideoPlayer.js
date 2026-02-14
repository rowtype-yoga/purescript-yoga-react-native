import {
  View,
  Platform,
  UIManager,
  requireNativeComponent,
} from "react-native";

var c = View;
if (Platform.OS === "macos") {
  try {
    if (UIManager.getViewManagerConfig("MacOSVideoPlayer"))
      c = requireNativeComponent("MacOSVideoPlayer");
  } catch (e) {}
}

export const _videoPlayerImpl = c;
