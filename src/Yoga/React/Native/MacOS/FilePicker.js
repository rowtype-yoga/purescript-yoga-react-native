import React from "react";
import { requireNativeComponent } from "react-native";
const NativeFilePicker = requireNativeComponent("MacOSFilePicker");
export const filePickerImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onPickFiles === "function") {
    nativeProps.onPickFiles = (e) =>
      props.onPickFiles(e.nativeEvent.files || [])();
  }
  if (typeof props.onCancel === "function") {
    nativeProps.onCancel = () => props.onCancel();
  }
  return React.createElement(NativeFilePicker, { ...nativeProps, ref });
});
