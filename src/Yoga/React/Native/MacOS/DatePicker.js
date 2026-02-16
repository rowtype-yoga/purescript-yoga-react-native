import React from "react";
import { requireNativeComponent } from "react-native";
const NativeDatePicker = requireNativeComponent("NativeDatePicker");
export const datePickerImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChange === "function") {
    nativeProps.onChange = (e) => props.onChange(e.nativeEvent.date)();
  }
  return React.createElement(NativeDatePicker, { ...nativeProps, ref });
});
