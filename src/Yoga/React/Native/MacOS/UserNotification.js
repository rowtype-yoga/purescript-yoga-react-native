import { NativeModules, Platform } from "react-native";

export const notifyImpl = ({ title = "", body = "" }) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSNotificationModule;
  if (mod && mod.notify) {
    mod.notify(title, body).catch((e) => console.error("[macosNotify]", e));
  }
};
