import React from "react";
import { requireNativeComponent } from "react-native";
const NativeTabView = requireNativeComponent("MacOSTabView");
export const tabViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onSelectTab === "function") {
    nativeProps.onSelectTab = (e) => props.onSelectTab(e.nativeEvent.tabId)();
  }
  return React.createElement(NativeTabView, { ...nativeProps, ref });
});
