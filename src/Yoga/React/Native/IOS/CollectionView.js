import React from "react";
import { requireNativeComponent } from "react-native";

const NativeCollectionView = requireNativeComponent("IOSCollectionView");

export const collectionViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };

  if (typeof props.onSelectItem === "function") {
    nativeProps.onSelectItem = (event) => {
      const { id, index } = event.nativeEvent;
      props.onSelectItem({ id, index: index | 0 })();
    };
  }

  if (typeof props.onRefresh === "function") {
    nativeProps.onRefresh = () => props.onRefresh();
  }

  return React.createElement(NativeCollectionView, { ...nativeProps, ref });
});
