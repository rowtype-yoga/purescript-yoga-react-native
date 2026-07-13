import { Vibration, Platform, NativeModules } from "react-native";

export const vibrateImpl = (duration) => {
  Vibration.vibrate(duration);
};

export const vibrateWithPatternImpl = (pattern, repeat) => {
  Vibration.vibrate(pattern, repeat);
};

export const cancelImpl = () => {
  Vibration.cancel();
};

const AVAILABLE = 0;
const UNSUPPORTED_PLATFORM = 1;
const MISSING_NATIVE_MODULE = 2;

const invokeHaptic = (method, argument) => {
  if (Platform.OS !== "ios") {
    return UNSUPPORTED_PLATFORM;
  }

  const haptics = NativeModules.HapticFeedback;
  if (!haptics || typeof haptics[method] !== "function") {
    return MISSING_NATIVE_MODULE;
  }

  if (argument === undefined) {
    haptics[method]();
  } else {
    haptics[method](argument);
  }
  return AVAILABLE;
};

export const selectionChangedImpl = () =>
  invokeHaptic("selectionChanged");

export const impactImpl = (style) => invokeHaptic("impact", style);

export const notificationImpl = (type) => invokeHaptic("notification", type);
