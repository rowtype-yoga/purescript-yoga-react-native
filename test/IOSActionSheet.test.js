import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { ActionSheetIOS, Platform } from "react-native";
import {
  completeActionSheetOptionsImpl,
  completeShareOptionsImpl,
  dismissActionSheet,
  showActionSheetImpl,
  showShareActionSheetImpl,
} from "../src/Yoga/React/Native/IOS/ActionSheet.js";

const originalOS = Platform.OS;
const originalShowShare = ActionSheetIOS.showShareActionSheetWithOptions;

const actionOptions = () => ({
  options: ["Keep", "Cancel", "Delete"],
  cancelButtonIndex: 1,
  destructiveButtonIndices: [2],
  disabledButtonIndices: [2],
  title: null,
  message: "Choose one action",
  anchor: null,
  userInterfaceStyle: "dark",
});

const shareOptions = () => ({
  message: "A useful link",
  url: "https://example.com/path?query=a%20b",
  subject: null,
  excludedActivityTypes: ["com.apple.UIKit.activity.Print"],
  tintColor: null,
  anchor: 42,
  userInterfaceStyle: "light",
});

describe("iOS ActionSheet private bridge", () => {
  beforeEach(() => {
    Platform.OS = "ios";
  });

  afterEach(() => {
    Platform.OS = originalOS;
    if (originalShowShare === undefined) {
      delete ActionSheetIOS.showShareActionSheetWithOptions;
    } else {
      ActionSheetIOS.showShareActionSheetWithOptions = originalShowShare;
    }
    vi.restoreAllMocks();
  });

  it.each([
    {
      name: "action-sheet",
      complete: completeActionSheetOptionsImpl,
    },
    {
      name: "share",
      complete: completeShareOptionsImpl,
    },
  ])(
    "completes $name options before encoding, with supplied options taking precedence",
    ({ complete }) => {
      const encode = vi.fn(({ title, message, anchor }) => ({
        heading: `${title}: ${message}`,
        anchor,
      }));

      const result = complete(
        { title: "Base", message: "Inherited", anchor: null },
        { title: "Override", anchor: 7 },
        encode,
      );

      expect(result).toEqual({
        heading: "Override: Inherited",
        anchor: 7,
      });
    },
  );

  it("sends encoded action metadata, omits absent native options, and reports one typed selection", () => {
    const show = vi
      .spyOn(ActionSheetIOS, "showActionSheetWithOptions")
      .mockImplementation((receivedOptions, onSelect) => {
        onSelect(0);
        onSelect(2);
      });
    const result = vi.fn();

    showActionSheetImpl(actionOptions(), result);

    expect(show).toHaveBeenCalledWith(
      {
        options: ["Keep", "Cancel", "Delete"],
        cancelButtonIndex: 1,
        destructiveButtonIndex: [2],
        disabledButtonIndices: [2],
        message: "Choose one action",
        userInterfaceStyle: "dark",
      },
      expect.any(Function),
    );
    expect(result).toHaveBeenCalledOnce();
    expect(result).toHaveBeenCalledWith({ status: 0, index: 0 });
  });

  it("maps the configured cancel index to dismissal rather than leaking its index", () => {
    vi.spyOn(ActionSheetIOS, "showActionSheetWithOptions").mockImplementation(
      (_options, onSelect) => onSelect(1),
    );
    const result = vi.fn();

    showActionSheetImpl(actionOptions(), result);

    expect(result).toHaveBeenCalledOnce();
    expect(result).toHaveBeenCalledWith({ status: 1, index: -1 });
  });

  it.each([
    { name: "fractional", index: 0.5 },
    { name: "negative", index: -1 },
    { name: "out-of-range", index: 3 },
    { name: "non-numeric", index: "0" },
  ])("rejects a $name native action index", ({ index }) => {
    vi.spyOn(ActionSheetIOS, "showActionSheetWithOptions").mockImplementation(
      (_options, onSelect) => onSelect(index),
    );
    const result = vi.fn();

    showActionSheetImpl(actionOptions(), result);

    expect(result).toHaveBeenCalledOnce();
    expect(result).toHaveBeenCalledWith({ status: 3, index: -1 });
  });

  it("reports action-sheet unavailability off iOS without native dispatch", () => {
    Platform.OS = "android";
    const show = vi.spyOn(ActionSheetIOS, "showActionSheetWithOptions");
    const result = vi.fn();

    showActionSheetImpl(actionOptions(), result);

    expect(show).not.toHaveBeenCalled();
    expect(result).toHaveBeenCalledOnce();
    expect(result).toHaveBeenCalledWith({ status: 2, index: -1 });
  });

  it.each([
    {
      name: "completed share with an activity",
      completed: true,
      activityType: "com.apple.UIKit.activity.CopyToPasteboard",
      expectedActivityType: "com.apple.UIKit.activity.CopyToPasteboard",
    },
    {
      name: "dismissed share without an activity",
      completed: false,
      activityType: undefined,
      expectedActivityType: null,
    },
  ])(
    "reports a $name through the success callback with nullable primitive data",
    ({ completed, activityType, expectedActivityType }) => {
      const showShare = vi.fn((receivedOptions, _onError, onSuccess) => {
        onSuccess(completed, activityType);
        onSuccess(!completed, "late.activity");
      });
      ActionSheetIOS.showShareActionSheetWithOptions = showShare;
      const onError = vi.fn();
      const onSuccess = vi.fn();

      showShareActionSheetImpl(shareOptions(), onError, onSuccess);

      expect(showShare).toHaveBeenCalledWith(
        {
          message: "A useful link",
          url: "https://example.com/path?query=a%20b",
          excludedActivityTypes: ["com.apple.UIKit.activity.Print"],
          anchor: 42,
          userInterfaceStyle: "light",
        },
        expect.any(Function),
        expect.any(Function),
      );
      expect(onSuccess).toHaveBeenCalledOnce();
      expect(onSuccess).toHaveBeenCalledWith(completed, expectedActivityType);
      expect(onError).not.toHaveBeenCalled();
    },
  );

  it("reports a native share failure only through the separate error callback", () => {
    const failure = new Error("The share extension failed");
    ActionSheetIOS.showShareActionSheetWithOptions = vi.fn(
      (_options, onError, onSuccess) => {
        onError(failure);
        onSuccess(true, "late.activity");
      },
    );
    const onError = vi.fn();
    const onSuccess = vi.fn();

    showShareActionSheetImpl(shareOptions(), onError, onSuccess);

    expect(onError).toHaveBeenCalledOnce();
    expect(onError).toHaveBeenCalledWith({
      unavailable: false,
      message: "The share extension failed",
    });
    expect(onSuccess).not.toHaveBeenCalled();
  });

  it("reports share unavailability off iOS through the error callback without native dispatch", () => {
    Platform.OS = "android";
    const showShare = vi.fn();
    ActionSheetIOS.showShareActionSheetWithOptions = showShare;
    const onError = vi.fn();
    const onSuccess = vi.fn();

    showShareActionSheetImpl(shareOptions(), onError, onSuccess);

    expect(showShare).not.toHaveBeenCalled();
    expect(onError).toHaveBeenCalledOnce();
    expect(onError).toHaveBeenCalledWith({ unavailable: true, message: "" });
    expect(onSuccess).not.toHaveBeenCalled();
  });

  it("dismisses the active action sheet on iOS but not on another platform", () => {
    const dismiss = vi.spyOn(ActionSheetIOS, "dismissActionSheet");

    dismissActionSheet();
    Platform.OS = "android";
    dismissActionSheet();

    expect(dismiss).toHaveBeenCalledOnce();
  });
});
