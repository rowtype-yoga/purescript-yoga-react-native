import { Image } from "react-native";

export const _imageImpl = Image;

export function uri(url) {
  return { uri: url };
}
