import React from "react";
import { requireNativeComponent } from "react-native";

const NativeSlider = requireNativeComponent("NativeSlider");

export const sliderImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChange === "function") {
    nativeProps.onChange = (e) => props.onChange(e.nativeEvent.value ?? 0)();
  }
  return React.createElement(NativeSlider, { ...nativeProps, ref });
});
