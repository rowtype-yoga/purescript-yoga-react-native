import React from "react";
import { SafeAreaView } from "react-native";

export const allEdges = ["top", "right", "bottom", "left"];
export const noEdges = [];
export const topOnly = ["top"];
export const bottomOnly = ["bottom"];

export const safeAreaViewImpl = React.forwardRef((props, ref) => {
  return React.createElement(SafeAreaView, { ...props, ref });
});
