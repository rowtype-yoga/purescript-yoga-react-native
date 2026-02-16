import React from "react";
import { requireNativeComponent } from "react-native";
const NativeRadioButton = requireNativeComponent("MacOSRadioButton");
export const radioButtonImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChange === "function") {
    nativeProps.onChange = (e) => props.onChange(!!e.nativeEvent.selected)();
  }
  return React.createElement(NativeRadioButton, { ...nativeProps, ref });
});
