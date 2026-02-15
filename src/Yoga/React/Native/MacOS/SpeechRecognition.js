import { NativeModules, Platform } from "react-native";

export const startImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSpeechRecognitionModule;
  if (mod && mod.start) {
    mod.start().catch((e) => console.error("[SpeechRecognition]", e));
  }
};

export const stopImpl = (callback) => {
  if (Platform.OS !== "macos") {
    callback("")();
    return;
  }
  const mod = NativeModules.MacOSSpeechRecognitionModule;
  if (mod && mod.stop) {
    mod
      .stop()
      .then((text) => callback(text)())
      .catch(() => callback("")());
  } else {
    callback("")();
  }
};

export const pollTranscriptImpl = (callback) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSpeechRecognitionModule;
  if (mod && mod.getTranscript) {
    mod
      .getTranscript()
      .then((text) => callback(text)())
      .catch(() => {});
  }
};

export const setIntervalImpl = (ms, cb) => setInterval(cb, ms);

export const clearIntervalImpl = (id) => clearInterval(id);
