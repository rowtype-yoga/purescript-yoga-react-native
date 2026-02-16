import React from "react";
import { requireNativeComponent } from "react-native";
const NativeButton = requireNativeComponent("NativeButton");
export const buttonImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onPress === "function") {
    nativeProps.onPress = () => props.onPress();
  }
  return React.createElement(NativeButton, { ...nativeProps, ref });
});
