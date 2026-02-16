import React from "react";
import { requireNativeComponent } from "react-native";
const NativeOutlineView = requireNativeComponent("MacOSOutlineView");
export const outlineViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onSelectItem === "function") {
    nativeProps.onSelectItem = (e) => props.onSelectItem(e.nativeEvent.id)();
  }
  return React.createElement(NativeOutlineView, { ...nativeProps, ref });
});
