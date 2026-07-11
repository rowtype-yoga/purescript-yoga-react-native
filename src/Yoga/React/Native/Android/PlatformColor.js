import { PlatformColor, Platform, TouchableNativeFeedback } from "react-native";

export const platformColorImpl = (colors) => {
  return PlatformColor(...colors);
};

export const selectableBackgroundImpl = () => {
  if (TouchableNativeFeedback && TouchableNativeFeedback.SelectableBackground) {
    return TouchableNativeFeedback.SelectableBackground();
  }
  return null;
};

export const selectableBackgroundBorderlessImpl = () => {
  if (TouchableNativeFeedback && TouchableNativeFeedback.SelectableBackgroundBorderless) {
    return TouchableNativeFeedback.SelectableBackgroundBorderless();
  }
  return null;
};

export const rippleImpl = (color, borderless, radius) => {
  if (TouchableNativeFeedback && TouchableNativeFeedback.Ripple) {
    return TouchableNativeFeedback.Ripple(
      color,
      borderless,
      radius > 0 ? radius : undefined
    );
  }
  return null;
};
