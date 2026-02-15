import { Platform } from "react-native";

export const copyToClipboardImpl = (text) => () => {
  if (Platform.OS === "macos") {
    const { Clipboard } = require("react-native");
    if (Clipboard && Clipboard.setString) {
      Clipboard.setString(text);
      return;
    }
  }
  if (typeof navigator !== "undefined" && navigator.clipboard) {
    navigator.clipboard.writeText(text);
  }
};

export const readClipboardImpl = () => {
  if (Platform.OS === "macos") {
    try {
      const { Clipboard } = require("react-native");
      if (Clipboard && Clipboard.getString) {
        return Clipboard.getString();
      }
    } catch (e) {}
  }
  if (typeof navigator !== "undefined" && navigator.clipboard) {
    return navigator.clipboard.readText();
  }
  return Promise.resolve("");
};
