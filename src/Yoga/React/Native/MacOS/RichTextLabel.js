import React from "react";
import { requireNativeComponent } from "react-native";
const NativeRichTextLabel = requireNativeComponent("NativeRichTextLabel");
export const richTextLabelImpl = React.forwardRef((props, ref) => {
  return React.createElement(NativeRichTextLabel, { ...props, ref });
});
export const emojiMapImpl = (obj) => obj;
