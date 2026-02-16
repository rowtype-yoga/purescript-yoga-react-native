import React from "react";
import { requireNativeComponent } from "react-native";
const NativeContextMenu = requireNativeComponent("MacOSContextMenu");
export const contextMenuImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onSelectItem === "function") {
    nativeProps.onSelectItem = (e) =>
      props.onSelectItem(e.nativeEvent.itemId)();
  }
  return React.createElement(NativeContextMenu, { ...nativeProps, ref });
});
