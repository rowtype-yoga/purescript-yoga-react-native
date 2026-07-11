import React from "react";
import { Platform } from "react-native";

let DrawerLayoutAndroid;
try {
  DrawerLayoutAndroid = require("react-native").DrawerLayoutAndroid;
} catch (e) {}

export const left = Platform.OS === "android" && DrawerLayoutAndroid ? DrawerLayoutAndroid.positions?.Left ?? "left" : "left";
export const right = Platform.OS === "android" && DrawerLayoutAndroid ? DrawerLayoutAndroid.positions?.Right ?? "right" : "right";

export const drawerLayoutImpl = React.forwardRef((props, ref) => {
  if (!DrawerLayoutAndroid) return null;
  const nativeProps = { ...props };
  if (typeof props.onDrawerClose === "function") {
    nativeProps.onDrawerClose = () => props.onDrawerClose();
  }
  if (typeof props.onDrawerOpen === "function") {
    nativeProps.onDrawerOpen = () => props.onDrawerOpen();
  }
  if (typeof props.onDrawerSlide === "function") {
    nativeProps.onDrawerSlide = (e) =>
      props.onDrawerSlide(e.nativeEvent.offset)();
  }
  if (typeof props.onDrawerStateChanged === "function") {
    nativeProps.onDrawerStateChanged = (e) =>
      props.onDrawerStateChanged(e.nativeEvent.drawerState)();
  }
  if (typeof props.renderNavigationView === "function") {
    nativeProps.renderNavigationView = () => props.renderNavigationView()
  }
  return React.createElement(DrawerLayoutAndroid, { ...nativeProps, ref });
});
