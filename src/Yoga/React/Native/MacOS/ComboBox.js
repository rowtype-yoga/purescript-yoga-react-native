import React from "react";
import { requireNativeComponent } from "react-native";
const NativeComboBox = requireNativeComponent("MacOSComboBox");
export const comboBoxImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChangeText === "function") {
    nativeProps.onChangeText = (e) => props.onChangeText(e.nativeEvent.text)();
  }
  if (typeof props.onSelectItem === "function") {
    nativeProps.onSelectItem = (e) => props.onSelectItem(e.nativeEvent.text)();
  }
  return React.createElement(NativeComboBox, { ...nativeProps, ref });
});
