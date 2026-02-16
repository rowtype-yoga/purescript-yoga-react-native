import React from "react";
import { requireNativeComponent } from "react-native";
const NativeSearchField = requireNativeComponent("MacOSSearchField");
export const searchFieldImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChangeText === "function") {
    nativeProps.onChangeText = (e) => props.onChangeText(e.nativeEvent.text)();
  }
  if (typeof props.onSearch === "function") {
    nativeProps.onSearch = (e) => props.onSearch(e.nativeEvent.text)();
  }
  return React.createElement(NativeSearchField, { ...nativeProps, ref });
});
