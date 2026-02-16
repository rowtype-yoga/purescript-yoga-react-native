import React from "react";
import { requireNativeComponent } from "react-native";
const NativeCheckbox = requireNativeComponent("MacOSCheckbox");
export const checkboxImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChange === "function") {
    nativeProps.onChange = (e) => props.onChange(!!e.nativeEvent.checked)();
  }
  return React.createElement(NativeCheckbox, { ...nativeProps, ref });
});
