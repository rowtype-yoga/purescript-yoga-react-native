import React from "react";
import { requireNativeComponent } from "react-native";

const NativeTextField = requireNativeComponent("NativeTextField");

export const textFieldImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChangeText === "function") {
    nativeProps.onChangeText = (e) => props.onChangeText(e.nativeEvent.text)();
  }
  if (typeof props.onSubmit === "function") {
    nativeProps.onSubmit = (e) => props.onSubmit(e.nativeEvent.text)();
  }
  return React.createElement(NativeTextField, { ...nativeProps, ref });
});
