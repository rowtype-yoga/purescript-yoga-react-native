import { PixelRatio } from "react-native";
export const get = PixelRatio.get();
export const getFontScale = PixelRatio.getFontScale();
export const getPixelSizeForLayoutSize = (n) => PixelRatio.getPixelSizeForLayoutSize(n);
export const roundToNearestPixel = (n) => PixelRatio.roundToNearestPixel(n);
