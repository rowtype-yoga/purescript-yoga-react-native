import React from "react";
import { requireNativeComponent } from "react-native";
const NativeWebView = requireNativeComponent("NativeWebView");
export const webViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onNavigate === "function") {
    nativeProps.onNavigate = (e) => props.onNavigate(e.nativeEvent.url)();
  }
  if (typeof props.onFinishLoad === "function") {
    nativeProps.onFinishLoad = (e) => props.onFinishLoad(e.nativeEvent.url)();
  }
  return React.createElement(NativeWebView, { ...nativeProps, ref });
});
