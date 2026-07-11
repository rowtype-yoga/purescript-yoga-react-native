import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { ActionSheetIOS, Platform } from "react-native";
import {
  dismissActionSheet,
  showActionSheetImpl,
  showShareActionSheetImpl,
} from "../src/Yoga/React/Native/IOS/ActionSheet.js";

const originalOS = Platform.OS;

describe("iOS ActionSheet FFI", () => {
  beforeEach(() => {
    Platform.OS = "ios";
  });

  afterEach(() => {
    Platform.OS = originalOS;
    delete ActionSheetIOS.showShareActionSheetWithOptions;
    vi.restoreAllMocks();
  });

  it("forwards action-sheet options and executes the PureScript callback thunk", () => {
    const options = {
      options: ["Keep", "Delete"],
      cancelButtonIndex: 0,
      destructiveButtonIndex: 1,
      title: "Choose",
    };
    const show = vi
      .spyOn(ActionSheetIOS, "showActionSheetWithOptions")
      .mockImplementation((receivedOptions, onSelect) => onSelect(1));
    const selected = vi.fn();

    showActionSheetImpl(options, (index) => () => selected(index));

    expect(show).toHaveBeenCalledWith(options, expect.any(Function));
    expect(selected).toHaveBeenCalledOnce();
    expect(selected).toHaveBeenCalledWith(1);
  });

  it.each([
    {
      name: "completed share",
      completed: true,
      activityType: "com.apple.UIKit.activity.CopyToPasteboard",
      expected: {
        action: "sharedAction",
        activityType: "com.apple.UIKit.activity.CopyToPasteboard",
      },
    },
    {
      name: "dismissed share without an activity",
      completed: false,
      activityType: undefined,
      expected: { action: "dismissedAction", activityType: "" },
    },
  ])("maps a $name and executes the callback thunk", ({ completed, activityType, expected }) => {
    const options = {
      message: "A useful link",
      url: "https://example.com",
      excludedActivityTypes: ["com.apple.UIKit.activity.Print"],
    };
    const showShare = vi.fn((receivedOptions, _onError, onSuccess) =>
      onSuccess(completed, activityType),
    );
    ActionSheetIOS.showShareActionSheetWithOptions = showShare;
    const result = vi.fn();

    showShareActionSheetImpl(options, (value) => () => result(value));

    expect(showShare).toHaveBeenCalledWith(
      options,
      expect.any(Function),
      expect.any(Function),
    );
    expect(result).toHaveBeenCalledOnce();
    expect(result).toHaveBeenCalledWith(expected);
  });

  it("does not dispatch action, share, or dismiss operations off iOS", () => {
    Platform.OS = "android";
    const show = vi.spyOn(ActionSheetIOS, "showActionSheetWithOptions");
    const dismiss = vi.spyOn(ActionSheetIOS, "dismissActionSheet");
    const showShare = vi.fn();
    ActionSheetIOS.showShareActionSheetWithOptions = showShare;
    const callback = vi.fn();

    showActionSheetImpl({ options: ["OK"] }, () => () => callback());
    showShareActionSheetImpl({ message: "Hello" }, () => () => callback());
    dismissActionSheet();

    expect(show).not.toHaveBeenCalled();
    expect(showShare).not.toHaveBeenCalled();
    expect(dismiss).not.toHaveBeenCalled();
    expect(callback).not.toHaveBeenCalled();
  });

  it("dismisses the active action sheet on iOS", () => {
    const dismiss = vi.spyOn(ActionSheetIOS, "dismissActionSheet");

    dismissActionSheet();

    expect(dismiss).toHaveBeenCalledOnce();
  });
});
