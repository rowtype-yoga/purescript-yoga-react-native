import React from "react";
import { requireNativeComponent } from "react-native";
const NativeTokenField = requireNativeComponent("MacOSTokenField");
export const tokenFieldImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onChangeTokens === "function") {
    nativeProps.onChangeTokens = (e) =>
      props.onChangeTokens(e.nativeEvent.tokens || [])();
  }
  return React.createElement(NativeTokenField, { ...nativeProps, ref });
});
