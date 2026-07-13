import React from "react";
import { requireNativeComponent } from "react-native";

const NativeSegmentedControl = requireNativeComponent("IOSSegmentedControl");

export const completeSegmentedControlPropsImpl = (defaults, given, encode) => ({
  ...given,
  ...encode({ ...defaults, ...given }),
});

export const segmentedControlImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };

  if (typeof props.onSelect === "function") {
    nativeProps.onSelect = (event) => {
      const nativeEvent = event?.nativeEvent;
      const index = nativeEvent?.index;
      const id = nativeEvent?.id;

      if (
        Number.isInteger(index) &&
        index >= 0 &&
        index < props.items.length &&
        id === String(index)
      ) {
        props.onSelect(index);
      }
    };
  }

  return React.createElement(NativeSegmentedControl, { ...nativeProps, ref });
});
