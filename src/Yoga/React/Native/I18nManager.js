import { I18nManager } from "react-native";
export const isRTL = I18nManager.isRTL;
export const allowRTL = (allow) => () => I18nManager.allowRTL(allow);
export const forceRTL = (force) => () => I18nManager.forceRTL(force);
export const swapLeftAndRightInRTL = (swap) => () => I18nManager.swapLeftAndRightInRTL(swap);
