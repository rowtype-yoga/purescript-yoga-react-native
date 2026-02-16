import React from "react";
import { requireNativeComponent } from "react-native";
const NativeSheet = requireNativeComponent("MacOSSheet");
export const sheetImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onDismiss === "function") {
    nativeProps.onDismiss = () => props.onDismiss();
  }
  return React.createElement(NativeSheet, { ...nativeProps, ref });
});
