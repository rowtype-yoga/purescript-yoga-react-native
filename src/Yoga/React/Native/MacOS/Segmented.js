import React from "react";
import { requireNativeComponent } from "react-native";
const NativeSegmented = requireNativeComponent("NativeSegmented");
export const segmentedImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChange === "function") {
    nativeProps.onChange = (e) =>
      props.onChange(e.nativeEvent.selectedIndex | 0)();
  }
  return React.createElement(NativeSegmented, { ...nativeProps, ref });
});
