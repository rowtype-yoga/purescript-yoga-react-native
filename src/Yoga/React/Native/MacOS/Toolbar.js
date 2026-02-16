import React from "react";
import { requireNativeComponent } from "react-native";
const NativeToolbar = requireNativeComponent("MacOSToolbar");
export const toolbarImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onSelectItem === "function") {
    nativeProps.onSelectItem = (e) =>
      props.onSelectItem(e.nativeEvent.itemId)();
  }
  return React.createElement(NativeToolbar, { ...nativeProps, ref });
});
