import React from "react";
import { requireNativeComponent } from "react-native";
const NativeStepper = requireNativeComponent("MacOSStepper");
export const stepperImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChange === "function") {
    nativeProps.onChange = (e) => props.onChange(e.nativeEvent.value ?? 0)();
  }
  return React.createElement(NativeStepper, { ...nativeProps, ref });
});
