import { ToastAndroid, Platform } from "react-native";

const toast = Platform.OS === "android" ? ToastAndroid : null;

export const short = toast ? ToastAndroid.SHORT : 0;
export const long = toast ? ToastAndroid.LONG : 1;
export const top = toast ? ToastAndroid.TOP : 0;
export const bottom = toast ? ToastAndroid.BOTTOM : 1;
export const center = toast ? ToastAndroid.CENTER : 2;

export const showImpl = (message, duration) => {
  if (toast) toast.show(message, duration);
};

export const showWithGravityImpl = (message, duration, gravity) => {
  if (toast) toast.showWithGravity(message, duration, gravity);
};

export const showWithGravityAndOffsetImpl = (
  message,
  duration,
  gravity,
  xOffset,
  yOffset
) => {
  if (toast)
    toast.showWithGravityAndOffset(message, duration, gravity, xOffset, yOffset);
};
