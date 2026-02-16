import React from "react";
import { requireNativeComponent } from "react-native";
const NativeTableView = requireNativeComponent("MacOSTableView");
export const tableViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onSelectRow === "function") {
    nativeProps.onSelectRow = (e) =>
      props.onSelectRow(e.nativeEvent.rowIndex | 0)();
  }
  if (typeof props.onDoubleClickRow === "function") {
    nativeProps.onDoubleClickRow = (e) =>
      props.onDoubleClickRow(e.nativeEvent.rowIndex | 0)();
  }
  return React.createElement(NativeTableView, { ...nativeProps, ref });
});
