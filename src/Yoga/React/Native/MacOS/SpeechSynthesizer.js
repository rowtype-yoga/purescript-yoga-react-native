import { NativeModules, Platform } from "react-native";

export const sayImpl = (text) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSpeechModule;
  if (mod && mod.say) {
    mod.say(text).catch((e) => console.error("[macosSay]", e));
  }
};

export const sayWithVoiceImpl = (text, voice) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSpeechModule;
  if (mod && mod.sayWithVoice) {
    mod.sayWithVoice(text, voice).catch((e) => console.error("[macosSayWithVoice]", e));
  }
};

export const stopSpeakingImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSpeechModule;
  if (mod && mod.stop) {
    mod.stop().catch((e) => console.error("[macosStopSpeaking]", e));
  }
};
