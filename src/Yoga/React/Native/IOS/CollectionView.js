import React from "react";
import { requireNativeComponent } from "react-native";

const NativeCollectionView = requireNativeComponent("IOSCollectionView");

const present = (value) => value !== null && value !== undefined;

export const completeCollectionViewPropsImpl = (defaults, given, encode) => {
  const merged = { ...defaults, ...given };
  const { selected, refreshState } = merged;
  const {
    selected: _selected,
    refreshState: _refreshState,
    ...baseProps
  } = given;

  return {
    ...baseProps,
    ...encode({ selected, refreshState }),
  };
};

export const collectionViewImpl = React.forwardRef((props, ref) => {
  const nativeProps = { ...props };

  if (!present(props.selectedId)) {
    delete nativeProps.selectedId;
  }

  nativeProps.onSelectItem = (event) => {
    const nativeEvent = event?.nativeEvent;
    const index = nativeEvent?.index;
    const id = nativeEvent?.id;

    if (
      typeof id !== "string" ||
      !Number.isSafeInteger(index) ||
      index < 0 ||
      index > 2147483647 ||
      index >= props.items.length ||
      props.items[index]?.id !== id
    ) {
      return;
    }

    props.onSelectItem(id, index);
  };

  nativeProps.onRefresh = () => props.onRefresh(undefined);

  return React.createElement(NativeCollectionView, { ...nativeProps, ref });
});
