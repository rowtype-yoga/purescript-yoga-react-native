import { NativeModules, Platform } from "react-native";

export const startListeningImpl = () => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSpeechRecognitionModule;
  if (mod && mod.start) {
    mod.start().catch((e) => console.error("[macosStartListening]", e));
  }
};

export const stopListeningImpl = (callback) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSpeechRecognitionModule;
  if (mod && mod.stop) {
    mod
      .stop()
      .then((text) => callback(text)())
      .catch((e) => console.error("[macosStopListening]", e));
  }
};

export const getTranscriptImpl = (callback) => {
  if (Platform.OS !== "macos") return;
  const mod = NativeModules.MacOSSpeechRecognitionModule;
  if (mod && mod.getTranscript) {
    mod
      .getTranscript()
      .then((text) => callback(text)())
      .catch((e) => console.error("[macosGetTranscript]", e));
  }
};
