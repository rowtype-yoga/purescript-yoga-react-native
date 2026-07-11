import { Settings, Platform } from "react-native";

const settings = Platform.OS === "ios" ? Settings : null;

export const getImpl = (key) => {
  if (!settings) return undefined;
  return settings.get(key);
};

export const setImpl = (values) => {
  if (!settings) return;
  settings.set(values);
};

export const watchKeysImpl = (keys, callback) => {
  if (!settings) return -1;
  return settings.watchKeys(keys, () => callback());
};

export const clearWatchImpl = (watchId) => {
  if (!settings) return;
  settings.clearWatch(watchId);
};
