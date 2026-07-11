import { PlatformColor, DynamicColorIOS, Platform } from "react-native";

export const platformColorImpl = (colors) => {
  return PlatformColor(...colors);
};

export const dynamicColorImpl = (light, dark) => {
  if (Platform.OS === "ios" && DynamicColorIOS) {
    return DynamicColorIOS({ light, dark });
  }
  return light;
};
