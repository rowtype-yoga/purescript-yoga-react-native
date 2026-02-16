import React from "react";
import { requireNativeComponent } from "react-native";
const NativeDropZone = requireNativeComponent("MacOSDropZone");
export const dropZoneImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onFileDrop === "function") {
    nativeProps.onFileDrop = (e) => {
      const data = {
        files: e.nativeEvent.files || [],
        strings: e.nativeEvent.strings || [],
      };
      props.onFileDrop(data)();
    };
  }
  if (typeof props.onFilesDragEnter === "function") {
    nativeProps.onFilesDragEnter = () => props.onFilesDragEnter();
  }
  if (typeof props.onFilesDragExit === "function") {
    nativeProps.onFilesDragExit = () => props.onFilesDragExit();
  }
  return React.createElement(NativeDropZone, { ...nativeProps, ref });
});
