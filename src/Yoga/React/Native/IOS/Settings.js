import { Settings, Platform } from "react-native";

const AVAILABLE = 0;
const UNSUPPORTED_PLATFORM = 1;
const MISSING_NATIVE_MODULE = 2;

const availabilityStatus = (method) => {
  if (Platform.OS !== "ios") return UNSUPPORTED_PLATFORM;
  if (Settings == null || typeof Settings[method] !== "function") {
    return MISSING_NATIVE_MODULE;
  }
  return AVAILABLE;
};

export const getImpl = (key) => {
  const status = availabilityStatus("get");
  if (status !== AVAILABLE) {
    return { status, present: false, value: undefined };
  }

  const value = Settings.get(key);
  return { status, present: value !== undefined, value };
};

export const setImpl = (key, value) => {
  const status = availabilityStatus("set");
  if (status !== AVAILABLE) return status;

  Settings.set({ [key]: value });
  return AVAILABLE;
};

export const watchImpl = (key, callback) => {
  const watchStatus = availabilityStatus("watchKeys");
  const clearStatus = availabilityStatus("clearWatch");
  const status = watchStatus !== AVAILABLE ? watchStatus : clearStatus;
  if (status !== AVAILABLE) return { status, watch: null };

  const id = Settings.watchKeys([key], callback);
  return {
    status: AVAILABLE,
    watch: { settings: Settings, id, disposed: false },
  };
};

export const disposeSettingsWatchImpl = (watch) => {
  if (watch.disposed) return;
  watch.disposed = true;
  watch.settings.clearWatch(watch.id);
};

export const readStringImpl = (value) =>
  typeof value === "string" ? value : null;

export const readBooleanImpl = (value) =>
  typeof value === "boolean" ? value : null;

export const readNumberImpl = (value) =>
  typeof value === "number" ? value : null;

export const stringToForeign = (value) => value;
export const booleanToForeign = (value) => value;
export const numberToForeign = (value) => value;
