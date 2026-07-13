import React from "react";
import { requireNativeComponent } from "react-native";

const NativeSearchBar = requireNativeComponent("IOSSearchBar");

const present = (value) => value !== null && value !== undefined;

export const completeSearchBarOptionsImpl = (defaults, given, encode) => {
  const encoded = encode({ ...defaults, ...given });
  const options = { ...given };

  delete options.cancelButton;
  delete options.state;
  delete options.onSubmit;
  delete options.onCancel;
  delete options.placeholder;

  if (present(encoded.placeholder)) {
    options.placeholder = encoded.placeholder;
  }
  options.showsCancelButton = encoded.showsCancelButton;
  options.enabled = encoded.enabled;
  if (present(encoded.onSubmit)) {
    options.onSubmit = encoded.onSubmit;
  }
  if (present(encoded.onCancel)) {
    options.onCancel = encoded.onCancel;
  }

  return options;
};

const nativeText = (event) => {
  const text = event?.nativeEvent?.text;
  return typeof text === "string" ? text : null;
};

export const searchBarImpl = React.forwardRef(
  ({ text, onChangeText, options }, ref) => {
    const nativeProps = { ...options, text };

    nativeProps.onChangeText = (event) => {
      const nextText = nativeText(event);
      if (nextText !== null) onChangeText(nextText);
    };

    if (typeof options.onSubmit === "function") {
      nativeProps.onSubmit = (event) => {
        const submittedText = nativeText(event);
        if (submittedText !== null) options.onSubmit(submittedText);
      };
    }
    if (typeof options.onCancel === "function") {
      nativeProps.onCancel = () => options.onCancel();
    }

    return React.createElement(NativeSearchBar, { ...nativeProps, ref });
  }
);
