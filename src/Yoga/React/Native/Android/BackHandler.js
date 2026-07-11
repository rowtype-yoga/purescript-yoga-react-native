import { BackHandler, Platform } from "react-native";

export const addEventListenerImpl = (eventName, handler) => {
  if (Platform.OS !== "android") return { remove: () => {} };
  return BackHandler.addEventListener(eventName, handler);
};

export const removeEventListenerImpl = (subscription) => {
  if (subscription && subscription.remove) subscription.remove();
};

export const exitAppImpl = () => {
  if (Platform.OS === "android") BackHandler.exitApp();
};
