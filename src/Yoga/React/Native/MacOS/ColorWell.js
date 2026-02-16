import React from "react";
import { requireNativeComponent } from "react-native";
const NativeColorWell = requireNativeComponent("NativeColorWell");
export const colorWellImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChange === "function") {
    nativeProps.onChange = (e) => props.onChange(e.nativeEvent.color)();
  }
  return React.createElement(NativeColorWell, { ...nativeProps, ref });
});
