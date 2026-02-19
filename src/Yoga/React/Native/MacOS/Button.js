import React from "react";
import { requireNativeComponent } from "react-native";
const NativeButton = requireNativeComponent("NativeButton");
export const buttonImpl = React.forwardRef((props, ref) => {
  const { onPress, onEmojiPick, ...rest } = props;
  const nativeProps = { ...rest };
  if (typeof onPress === "function") {
    nativeProps.onPressButton = () => onPress();
  }
  if (typeof onEmojiPick === "function") {
    nativeProps.onEmojiPick = (e) => onEmojiPick(e.nativeEvent.emoji)();
  }
  return React.createElement(NativeButton, { ...nativeProps, ref });
});
