import { Platform } from "react-native";
import RNFS from "react-native-fs";

export const homePath =
  Platform.OS === "macos"
    ? RNFS.DocumentDirectoryPath.replace(/\/Documents$/, "")
    : RNFS.DocumentDirectoryPath;

export const lengthStr = (s) => s.length;
export const floor = (n) => Math.floor(n);
