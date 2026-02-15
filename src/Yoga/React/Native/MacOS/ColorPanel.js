import { NativeModules, Platform } from "react-native";

export const showColorPanelImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSColorPanelModule;
  if (mod && mod.show) {
    mod.show().catch((e) => console.error("[macosShowColorPanel]", e));
  }
};

export const hideColorPanelImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSColorPanelModule;
  if (mod && mod.hide) {
    mod.hide().catch((e) => console.error("[macosHideColorPanel]", e));
  }
};
