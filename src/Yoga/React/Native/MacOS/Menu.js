import { NativeModules, Platform } from "react-native";

export const showMenuImpl = (items, callback) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSMenuModule;
  if (mod && mod.show) {
    mod
      .show(items)
      .then((selectedId) => {
        if (selectedId) callback(selectedId)();
      })
      .catch((e) => console.error("[macosMenu]", e));
  }
};
