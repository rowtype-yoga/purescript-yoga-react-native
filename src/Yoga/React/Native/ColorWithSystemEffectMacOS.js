import { ColorWithSystemEffectMacOS } from "react-native-macos";

export const colorWithSystemEffect = (color) => (effect) =>
  ColorWithSystemEffectMacOS(color, effect);
