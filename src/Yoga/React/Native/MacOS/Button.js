import React from "react";
import { requireNativeComponent } from "react-native";
const NativeButton = requireNativeComponent("NativeButton");
export const buttonImpl = React.forwardRef((props, ref) => {
  const { onPress, ...rest } = props;
  const nativeProps = { ...rest };
  if (typeof onPress === "function") {
    nativeProps.onPressButton = () => onPress();
  }
  return React.createElement(NativeButton, { ...nativeProps, ref });
});
