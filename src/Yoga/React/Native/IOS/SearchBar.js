import React from "react";
import { requireNativeComponent } from "react-native";

const NativeSearchBar = requireNativeComponent("IOSSearchBar");

export const searchBarImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };

  if (typeof props.onChangeText === "function") {
    nativeProps.onChangeText = (event) => props.onChangeText(event.nativeEvent.text)();
  }
  if (typeof props.onSubmit === "function") {
    nativeProps.onSubmit = (event) => props.onSubmit(event.nativeEvent.text)();
  }
  if (typeof props.onCancel === "function") {
    nativeProps.onCancel = () => props.onCancel();
  }

  return React.createElement(NativeSearchBar, { ...nativeProps, ref });
});
