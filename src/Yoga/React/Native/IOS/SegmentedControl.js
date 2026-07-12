import React from "react";
import { requireNativeComponent } from "react-native";

const NativeSegmentedControl = requireNativeComponent("IOSSegmentedControl");

export const segmentedControlImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };

  if (typeof props.onSelect === "function") {
    nativeProps.onSelect = (event) => {
      const { id, index } = event.nativeEvent;
      props.onSelect({ id, index: index | 0 })();
    };
  }

  return React.createElement(NativeSegmentedControl, { ...nativeProps, ref });
});
