import React from "react";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";


export const safeAreaProviderImpl = SafeAreaProvider;

export const safeAreaViewImpl = (encodeEdges, encodeMode) =>
  React.forwardRef((props, ref) => {
    const nativeProps = { ...props };

    if (props.edges !== undefined) {
      nativeProps.edges = encodeEdges(props.edges);
    }

    if (props.mode !== undefined) {
      nativeProps.mode = encodeMode(props.mode);
    }

    return React.createElement(SafeAreaView, { ...nativeProps, ref });
  });
