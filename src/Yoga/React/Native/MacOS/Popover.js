import React from "react";
import { requireNativeComponent } from "react-native";
const NativePopover = requireNativeComponent("MacOSPopover");
export const popoverImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onClose === "function") {
    nativeProps.onClose = () => props.onClose();
  }
  return React.createElement(NativePopover, { ...nativeProps, ref });
});
