import React from "react";
import { requireNativeComponent } from "react-native";
const NativePathControl = requireNativeComponent("MacOSPathControl");
export const pathControlImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onSelectPath === "function") {
    nativeProps.onSelectPath = (e) => props.onSelectPath(e.nativeEvent.url)();
  }
  return React.createElement(NativePathControl, { ...nativeProps, ref });
});
