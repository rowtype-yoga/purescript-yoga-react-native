import { LayoutAnimation } from "react-native";
export const configureNextImpl = (config) => LayoutAnimation.configureNext(config);
export const easeInEaseOut = () => LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
export const linear = () => LayoutAnimation.configureNext(LayoutAnimation.Presets.linear);
export const spring = () => LayoutAnimation.configureNext(LayoutAnimation.Presets.spring);
