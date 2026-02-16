import React from "react";
import { requireNativeComponent } from "react-native";
const NativePopUp = requireNativeComponent("NativePopUp");
export const popUpImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChange === "function") {
    nativeProps.onChange = (e) =>
      props.onChange(e.nativeEvent.selectedIndex | 0)();
  }
  return React.createElement(NativePopUp, { ...nativeProps, ref });
});
