import { DynamicColorMacOS } from "react-native-macos";

export const dynamicColor = (colors) => ({
  color: DynamicColorMacOS(colors),
});
