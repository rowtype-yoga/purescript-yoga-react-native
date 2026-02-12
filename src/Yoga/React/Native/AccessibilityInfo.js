import { AccessibilityInfo } from "react-native";
const mkAff = (promise) => (onError, onSuccess) => {
  promise.then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};
export const isScreenReaderEnabledImpl = mkAff(AccessibilityInfo.isScreenReaderEnabled());
export const isReduceMotionEnabledImpl = mkAff(AccessibilityInfo.isReduceMotionEnabled());
export const isBoldTextEnabledImpl = mkAff(AccessibilityInfo.isBoldTextEnabled());
export const isGrayscaleEnabledImpl = mkAff(AccessibilityInfo.isGrayscaleEnabled());
export const isInvertColorsEnabledImpl = mkAff(AccessibilityInfo.isInvertColorsEnabled());
export const isReduceTransparencyEnabledImpl = mkAff(AccessibilityInfo.isReduceTransparencyEnabled());
export const announceForAccessibility = (msg) => () => AccessibilityInfo.announceForAccessibility(msg);
