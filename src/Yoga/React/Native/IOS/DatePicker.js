import React from "react";
import { requireNativeComponent } from "react-native";

const NativeDatePicker = requireNativeComponent("IOSDatePicker");

export const date = "date";
export const time = "time";
export const dateTime = "datetime";

export const datePickerImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };

  if (typeof props.onChange === "function") {
    nativeProps.onDateChange = (event) => props.onChange(event.nativeEvent.value)();
    delete nativeProps.onChange;
  }

  return React.createElement(NativeDatePicker, { ...nativeProps, ref });
});
