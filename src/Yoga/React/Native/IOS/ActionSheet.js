import { ActionSheetIOS, Platform } from "react-native";

export const completeActionSheetOptionsImpl = (defaults, given, encode) =>
  encode({ ...defaults, ...given });

export const completeShareOptionsImpl = (defaults, given, encode) =>
  encode({ ...defaults, ...given });

const present = (value) => value !== null && value !== undefined;

const nativeActionSheetOptions = (options) => ({
  options: options.options,
  ...(present(options.cancelButtonIndex)
    ? { cancelButtonIndex: options.cancelButtonIndex }
    : {}),
  ...(options.destructiveButtonIndices.length > 0
    ? { destructiveButtonIndex: options.destructiveButtonIndices }
    : {}),
  ...(options.disabledButtonIndices.length > 0
    ? { disabledButtonIndices: options.disabledButtonIndices }
    : {}),
  ...(present(options.title) ? { title: options.title } : {}),
  ...(present(options.message) ? { message: options.message } : {}),
  ...(present(options.anchor) ? { anchor: options.anchor } : {}),
  userInterfaceStyle: options.userInterfaceStyle,
});

export const showActionSheetImpl = (options, callback) => {
  if (
    Platform.OS !== "ios" ||
    !ActionSheetIOS ||
    typeof ActionSheetIOS.showActionSheetWithOptions !== "function"
  ) {
    callback({ status: 2, index: -1 });
    return;
  }

  let settled = false;
  ActionSheetIOS.showActionSheetWithOptions(
    nativeActionSheetOptions(options),
    (index) => {
      if (settled) return;
      settled = true;

      if (index === options.cancelButtonIndex) {
        callback({ status: 1, index: -1 });
      } else if (
        Number.isInteger(index) &&
        index >= 0 &&
        index < options.options.length
      ) {
        callback({ status: 0, index });
      } else {
        callback({ status: 3, index: -1 });
      }
    }
  );
};

const nativeShareOptions = (options) => ({
  ...(present(options.message) ? { message: options.message } : {}),
  ...(present(options.url) ? { url: options.url } : {}),
  ...(present(options.subject) ? { subject: options.subject } : {}),
  excludedActivityTypes: options.excludedActivityTypes,
  ...(present(options.tintColor) ? { tintColor: options.tintColor } : {}),
  ...(present(options.anchor) ? { anchor: options.anchor } : {}),
  userInterfaceStyle: options.userInterfaceStyle,
});

const shareFailureMessage = (error) => {
  if (error instanceof Error) return error.message;
  if (typeof error === "string") return error;
  if (error && typeof error.message === "string") return error.message;
  return String(error ?? "Unknown share failure");
};

export const showShareActionSheetImpl = (
  options,
  errorCallback,
  successCallback
) => {
  if (
    Platform.OS !== "ios" ||
    !ActionSheetIOS ||
    typeof ActionSheetIOS.showShareActionSheetWithOptions !== "function"
  ) {
    errorCallback({ unavailable: true, message: "" });
    return;
  }

  let settled = false;
  ActionSheetIOS.showShareActionSheetWithOptions(
    nativeShareOptions(options),
    (error) => {
      if (settled) return;
      settled = true;
      errorCallback({
        unavailable: false,
        message: shareFailureMessage(error),
      });
    },
    (completed, activityType) => {
      if (settled) return;
      settled = true;
      successCallback(completed === true, activityType ?? null);
    }
  );
};

export const dismissActionSheet = () => {
  if (Platform.OS !== "ios") return;
  if (typeof ActionSheetIOS?.dismissActionSheet === "function") {
    ActionSheetIOS.dismissActionSheet();
  }
};
