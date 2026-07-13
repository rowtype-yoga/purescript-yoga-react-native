import { DynamicColorIOS, Platform, PlatformColor } from "react-native";
import { DynamicColorMacOS } from "react-native-macos";

export const literalColorImpl = (color) => color;

export const platformColorImpl = (colors) => PlatformColor(...colors);

export const dynamicColorImpl = (colors) => {
  if (Platform.OS === "ios") {
    return DynamicColorIOS(colors);
  }

  if (Platform.OS === "macos") {
    return DynamicColorMacOS(colors);
  }

  return colors.light;
};
