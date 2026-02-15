import { NativeModules, Platform } from "react-native";

export const playSoundImpl = (name) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSoundModule;
  if (mod && mod.play) {
    mod.play(name).catch((e) => console.error("[macosPlaySound]", e));
  }
};

export const beepImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSoundModule;
  if (mod && mod.beep) {
    mod.beep().catch((e) => console.error("[macosBeep]", e));
  }
};
