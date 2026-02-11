import { Appearance, useColorScheme } from "react-native";

export const getColorScheme = () => Appearance.getColorScheme();

export const setColorScheme = (scheme) => () => Appearance.setColorScheme(scheme);

export const useColorSchemeImpl = useColorScheme;
