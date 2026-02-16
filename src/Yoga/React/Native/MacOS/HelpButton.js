import React from "react";
import { requireNativeComponent } from "react-native";
const NativeHelpButton = requireNativeComponent("MacOSHelpButton");
export const helpButtonImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onPress === "function") {
    nativeProps.onPress = () => props.onPress();
  }
  return React.createElement(NativeHelpButton, { ...nativeProps, ref });
});
