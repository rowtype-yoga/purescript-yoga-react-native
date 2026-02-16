import React from "react";
import { requireNativeComponent } from "react-native";
const NativeMapView = requireNativeComponent("MacOSMapView");
export const mapViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };
  if (typeof props.onRegionChange === "function") {
    nativeProps.onRegionChange = (e) => {
      const r = e.nativeEvent;
      props.onRegionChange({
        latitude: r.latitude ?? 0,
        longitude: r.longitude ?? 0,
        latitudeDelta: r.latitudeDelta ?? 0,
        longitudeDelta: r.longitudeDelta ?? 0,
      })();
    };
  }
  if (typeof props.onSelectAnnotation === "function") {
    nativeProps.onSelectAnnotation = (e) =>
      props.onSelectAnnotation(e.nativeEvent.title || "")();
  }
  return React.createElement(NativeMapView, { ...nativeProps, ref });
});
