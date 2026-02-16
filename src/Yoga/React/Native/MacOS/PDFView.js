import React from "react";
import { requireNativeComponent } from "react-native";
const NativePDFView = requireNativeComponent("MacOSPDFView");
export const pdfViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onPageChange === "function") {
    nativeProps.onPageChange = (e) =>
      props.onPageChange(e.nativeEvent.pageIndex | 0)();
  }
  return React.createElement(NativePDFView, { ...nativeProps, ref });
});
