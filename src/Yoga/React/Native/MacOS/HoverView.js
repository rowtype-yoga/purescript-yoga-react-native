import React from "react";
import { requireNativeComponent } from "react-native";
const NativeHoverView = requireNativeComponent("MacOSHoverView");
export const hoverViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onHoverChange === "function") {
    nativeProps.onHoverChange = (e) =>
      props.onHoverChange(e.nativeEvent.hovered)();
  }
  if (typeof props.onPress === "function") {
    nativeProps.onPress = () => props.onPress();
  }
  return React.createElement(NativeHoverView, { ...nativeProps, ref });
});
