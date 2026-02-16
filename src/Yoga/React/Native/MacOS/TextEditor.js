import React from "react";
import { requireNativeComponent } from "react-native";
const NativeTextEditor = requireNativeComponent("NativeTextEditor");
export const textEditorImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChangeText === "function") {
    nativeProps.onChangeText = (e) => props.onChangeText(e.nativeEvent.text)();
  }
  return React.createElement(NativeTextEditor, { ...nativeProps, ref });
});
