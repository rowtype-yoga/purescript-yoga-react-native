import React from "react";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";

export const allEdges = ["top", "right", "bottom", "left"];
export const noEdges = [];
export const topOnly = ["top"];
export const bottomOnly = ["bottom"];

export const safeAreaProviderImpl = SafeAreaProvider;

export const safeAreaViewImpl = React.forwardRef((props, ref) => {
  return React.createElement(SafeAreaView, { ...props, ref });
});
