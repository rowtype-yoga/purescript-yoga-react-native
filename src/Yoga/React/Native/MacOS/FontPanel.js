import { NativeModules, Platform } from "react-native";

export const showFontPanelImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSFontPanelModule;
  if (mod && mod.show) {
    mod.show().catch((e) => console.error("[macosShowFontPanel]", e));
  }
};

export const hideFontPanelImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSFontPanelModule;
  if (mod && mod.hide) {
    mod.hide().catch((e) => console.error("[macosHideFontPanel]", e));
  }
};
