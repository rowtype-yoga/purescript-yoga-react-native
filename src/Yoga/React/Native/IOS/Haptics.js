import { Vibration, Platform, NativeModules } from "react-native";

export const impactLight = "light";
export const impactMedium = "medium";
export const impactHeavy = "heavy";

export const notificationSuccess = "success";
export const notificationWarning = "warning";
export const notificationError = "error";

export const vibrateImpl = (duration) => {
  Vibration.vibrate(duration);
};

export const vibrateWithPatternImpl = (pattern, repeat) => {
  Vibration.vibrate(pattern, repeat);
};

export const cancelImpl = () => {
  Vibration.cancel();
};

const haptics =
  Platform.OS === "ios" && NativeModules.HapticFeedback
    ? NativeModules.HapticFeedback
    : null;

export const selectionChangedImpl = () => {
  if (haptics && haptics.selectionChanged) {
    haptics.selectionChanged();
  } else if (Platform.OS === "ios") {
    Vibration.vibrate(10);
  }
};

export const impactImpl = (style) => {
  if (haptics && haptics.impact) {
    haptics.impact(style);
  } else if (Platform.OS === "ios") {
    Vibration.vibrate(style === "heavy" ? 50 : style === "medium" ? 30 : 10);
  }
};

export const notificationImpl = (type) => {
  if (haptics && haptics.notification) {
    haptics.notification(type);
  } else if (Platform.OS === "ios") {
    Vibration.vibrate(
      type === "error" ? [0, 50, 50, 50] : type === "warning" ? [0, 30, 30] : 30
    );
  }
};
