import React from "react";
import { requireNativeComponent } from "react-native";

const NativeDatePicker = requireNativeComponent("IOSDatePicker");

const instantToISOString = (instant) => {
  if (typeof instant !== "number" || !Number.isFinite(instant)) {
    throw new TypeError("DatePicker received an invalid Instant");
  }

  return new Date(instant).toISOString();
};


const canonicalDatePattern =
  /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/;

const instantFromNativeEvent = (event) => {
  const value = event?.nativeEvent?.value;
  if (typeof value !== "string" || !canonicalDatePattern.test(value)) {
    return null;
  }

  const instant = Date.parse(value);
  if (!Number.isFinite(instant) || new Date(instant).toISOString() !== value) {
    return null;
  }

  return instant;
};

export const completeDatePickerOptionsImpl = (defaults, given, encode) => {
  const merged = { ...defaults, ...given };
  const behavior = encode({ bounds: merged.bounds, state: merged.state });
  const options = { ...given, ...behavior };
  delete options.bounds;
  delete options.state;
  return options;
};

export const datePickerImpl = React.forwardRef(
  ({ value, mode, onChange, options }, ref) => {
    const nativeProps = {
      ...options,
      value: instantToISOString(value),
      mode,
      ...(options.minimum == null
        ? {}
        : { min: instantToISOString(options.minimum) }),
      ...(options.maximum == null
        ? {}
        : { max: instantToISOString(options.maximum) }),
      enabled: options.enabled,
      ref,
      onDateChange: (event) => {
        const instant = instantFromNativeEvent(event);
        if (instant !== null) onChange(instant);
      },
    };

    delete nativeProps.minimum;
    delete nativeProps.maximum;
    return React.createElement(NativeDatePicker, nativeProps);
  }
);
