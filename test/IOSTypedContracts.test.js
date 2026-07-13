import React from "react";
import { act, create } from "react-test-renderer";
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  vi,
} from "vitest";
import {
  ActionSheetIOS,
  Appearance,
  Linking,
  NativeModules,
  Platform,
  Settings,
  Vibration,
} from "react-native";
import { Left as EitherLeft, Right as EitherRight } from "../output/Data.Either/index.js";
import { Just, Nothing } from "../output/Data.Maybe/index.js";
import { eqString } from "../output/Data.Eq/index.js";
import { runAff_ } from "../output/Effect.Aff/index.js";
import {
  Automatic,
  Dark,
  DarkInterface,
  Disabled,
  Enabled,
  Light,
  LightInterface,
  RefreshIdle,
  Refreshing,
  UnsupportedPlatform,
} from "../output/Yoga.React.Native.Types/index.js";
import {
  CancelAction,
  DefaultAction,
  DestructiveAction,
  DismissedActionSheet,
  InvalidNativeActionResponse,
  MultipleCancelActions,
  SelectedAction,
  actions,
  showActionSheet,
} from "../output/Yoga.React.Native.IOS.ActionSheet/index.js";
import {
  ImpactHeavy,
  ImpactLight,
  ImpactMedium,
  NotificationError,
  NotificationSuccess,
  NotificationWarning,
  RepeatVibration,
  VibrateOnce,
  impact,
  notification,
  vibrateWithPattern,
  vibrationDuration,
} from "../output/Yoga.React.Native.IOS.Haptics/index.js";
import {
  SettingsUnavailable,
  WrongSettingType,
  booleanSetting,
  get as getSetting,
} from "../output/Yoga.React.Native.IOS.Settings/index.js";
import {
  Date as DateMode,
  DateAndTime,
  MinimumAfterMaximum,
  Time,
  datePicker,
  datePickerBounds,
} from "../output/Yoga.React.Native.IOS.DatePicker/index.js";
import {
  DuplicateItemId,
  EmptyItemId,
  collectionItems,
  collectionView,
} from "../output/Yoga.React.Native.IOS.CollectionView/index.js";
import { segmentedControl } from "../output/Yoga.React.Native.IOS.SegmentedControl/index.js";
import {
  HideCancelButton,
  ShowCancelButton,
  searchBar,
} from "../output/Yoga.React.Native.IOS.SearchBar/index.js";
import {
  Margin,
  Padding,
  allEdges,
  safeAreaView,
} from "../output/Yoga.React.Native.IOS.SafeArea/index.js";
import {
  getColorScheme,
  setColorScheme,
} from "../output/Yoga.React.Native.Appearance/index.js";
import { getInitialURL } from "../output/Yoga.React.Native.IOS.LinkingIOS/index.js";

const originalOS = Platform.OS;
const originalHapticFeedback = NativeModules.HapticFeedback;
const originalSettingsGet = Settings.get;
const originalActionSheet = ActionSheetIOS.showActionSheetWithOptions;

const nothing = Nothing.value;
const just = (value) => new Just(value);

const expectRight = (result) => {
  expect(result).toBeInstanceOf(EitherRight);
  return result.value0;
};

const expectLeft = (result, ErrorType) => {
  expect(result).toBeInstanceOf(EitherLeft);
  expect(result.value0).toBeInstanceOf(ErrorType);
  return result.value0;
};

const runAff = (aff) =>
  new Promise((resolve, reject) => {
    runAff_((result) => () => {
      if (result instanceof EitherLeft) reject(result.value0);
      else resolve(result.value0);
    })(aff)();
  });

const renderElement = (element, nativeType) => {
  let renderer;
  act(() => {
    renderer = create(element);
  });
  return {
    native: renderer.root.findByType(nativeType),
    unmount: () => act(() => renderer.unmount()),
  };
};

const explicitActionOptions = (userInterfaceStyle) => ({
  title: just("Typed actions"),
  message: just("Choose exactly one"),
  anchor: just(17),
  userInterfaceStyle,
});

const validActions = () => [
  {
    value: "keep-value",
    label: "Keep",
    style: DefaultAction.value,
    state: Enabled.value,
  },
  {
    value: "cancel-value",
    label: "Cancel",
    style: CancelAction.value,
    state: Enabled.value,
  },
  {
    value: "delete-value",
    label: "Delete",
    style: DestructiveAction.value,
    state: Disabled.value,
  },
];

beforeAll(() => {
  globalThis.IS_REACT_ACT_ENVIRONMENT = true;
});

beforeEach(() => {
  Platform.OS = "ios";
  Settings.get = originalSettingsGet;
  ActionSheetIOS.showActionSheetWithOptions = originalActionSheet;
  NativeModules.HapticFeedback = {
    impact: vi.fn(),
    notification: vi.fn(),
    selectionChanged: vi.fn(),
  };
});

afterEach(() => {
  vi.restoreAllMocks();
  Platform.OS = originalOS;
  Settings.get = originalSettingsGet;
  ActionSheetIOS.showActionSheetWithOptions = originalActionSheet;
  if (originalHapticFeedback === undefined) {
    delete NativeModules.HapticFeedback;
  } else {
    NativeModules.HapticFeedback = originalHapticFeedback;
  }
});

afterAll(() => {
  delete globalThis.IS_REACT_ACT_ENVIRONMENT;
});

describe("public typed iOS contracts", () => {
  describe("closed enum encodings", () => {
    it.each([
      { name: "light", value: Light.value, encoded: "light" },
      { name: "dark", value: Dark.value, encoded: "dark" },
    ])("encodes the $name color scheme at the Appearance boundary", ({ value, encoded }) => {
      const setter = vi.spyOn(Appearance, "setColorScheme");

      setColorScheme(just(value))();

      expect(setter).toHaveBeenCalledOnce();
      expect(setter).toHaveBeenCalledWith(encoded);
    });

    it.each([
      { name: "light", value: ImpactLight.value, encoded: "light" },
      { name: "medium", value: ImpactMedium.value, encoded: "medium" },
      { name: "heavy", value: ImpactHeavy.value, encoded: "heavy" },
    ])("encodes the $name impact style at the native module boundary", ({ value, encoded }) => {
      impact(value)();
      expect(NativeModules.HapticFeedback.impact).toHaveBeenCalledWith(encoded);
    });

    it.each([
      { name: "success", value: NotificationSuccess.value, encoded: "success" },
      { name: "warning", value: NotificationWarning.value, encoded: "warning" },
      { name: "error", value: NotificationError.value, encoded: "error" },
    ])("encodes the $name notification type at the native module boundary", ({ value, encoded }) => {
      notification(value)();
      expect(NativeModules.HapticFeedback.notification).toHaveBeenCalledWith(encoded);
    });

    it.each([
      { name: "once", value: VibrateOnce.value, encoded: false },
      { name: "repeat", value: RepeatVibration.value, encoded: true },
    ])("encodes the $name vibration repeat policy", ({ value, encoded }) => {
      const vibrate = vi.spyOn(Vibration, "vibrate");

      vibrateWithPattern([10, 20])(value)();

      expect(vibrate).toHaveBeenCalledWith([10, 20], encoded);
    });

    it.each([
      { name: "date", mode: DateMode.value, encoded: "date" },
      { name: "time", mode: Time.value, encoded: "time" },
      { name: "date and time", mode: DateAndTime.value, encoded: "datetime" },
    ])("encodes $name picker mode and disabled control state", ({ mode, encoded }) => {
      const { native, unmount } = renderElement(
        datePicker({})(Date.parse("2026-07-12T09:30:00.000Z"))(mode)(() => () => {})(
          {
            bounds: { minimum: nothing, maximum: nothing },
            state: Disabled.value,
          },
        ),
        "IOSDatePicker",
      );

      expect(native.props.mode).toBe(encoded);
      expect(native.props.enabled).toBe(false);
      unmount();
    });

    it("encodes every action style, both control states, and all interface styles", () => {
      const received = [];
      vi.spyOn(ActionSheetIOS, "showActionSheetWithOptions").mockImplementation(
        (options, callback) => {
          received.push(options);
          callback(0);
        },
      );
      const typedActions = expectRight(actions(validActions()));

      for (const style of [Automatic.value, LightInterface.value, DarkInterface.value]) {
        showActionSheet({})(typedActions)(explicitActionOptions(style))(() => () => {})();
      }

      expect(received.map(({ userInterfaceStyle }) => userInterfaceStyle)).toEqual([
        "automatic",
        "light",
        "dark",
      ]);
      for (const options of received) {
        expect(options).toMatchObject({
          options: ["Keep", "Cancel", "Delete"],
          cancelButtonIndex: 1,
          destructiveButtonIndex: [2],
          disabledButtonIndices: [2],
        });
      }
    });

    it.each([
      { visibility: HideCancelButton.value, encoded: false },
      { visibility: ShowCancelButton.value, encoded: true },
    ])("encodes cancel-button visibility $encoded and enabled control state", ({ visibility, encoded }) => {
      const { native, unmount } = renderElement(
        searchBar({})("query")(() => () => {})({
          placeholder: just("Search"),
          cancelButton: visibility,
          state: Enabled.value,
          onSubmit: nothing,
          onCancel: nothing,
        }),
        "IOSSearchBar",
      );

      expect(native.props.showsCancelButton).toBe(encoded);
      expect(native.props.enabled).toBe(true);
      unmount();
    });

    it.each([
      { state: RefreshIdle.value, encoded: false },
      { state: Refreshing.value, encoded: true },
    ])("encodes collection refresh state $encoded", ({ state, encoded }) => {
      const typedItems = expectRight(
        collectionItems([{ id: "one", value: 1, title: "One" }]),
      );
      const { native, unmount } = renderElement(
        collectionView({})(typedItems)(() => () => {})(() => {})({
          selected: nothing,
          refreshState: state,
        }),
        "IOSCollectionView",
      );

      expect(native.props.refreshing).toBe(encoded);
      unmount();
    });

    it.each([
      { mode: Padding.value, encoded: "padding" },
      { mode: Margin.value, encoded: "margin" },
    ])("encodes all safe-area edges and $encoded mode", ({ mode, encoded }) => {
      const component = safeAreaView({})({});
      const element = component({ edges: allEdges, mode })([]);
      const { native, unmount } = renderElement(element, "MockSafeAreaView");

      expect(native.props.edges).toEqual(["top", "right", "bottom", "left"]);
      expect(native.props.mode).toBe(encoded);
      unmount();
    });
  });

  describe("validated constructors", () => {
    it.each([
      { name: "negative", value: -1 },
      { name: "NaN", value: Number.NaN },
      { name: "positive infinity", value: Number.POSITIVE_INFINITY },
      { name: "negative infinity", value: Number.NEGATIVE_INFINITY },
    ])("rejects a $name vibration duration", ({ value }) => {
      expect(vibrationDuration(value)).toBe(nothing);
    });

    it("rejects more than one cancel action before native dispatch", () => {
      const result = actions([
        { value: 1, label: "First", style: CancelAction.value, state: Enabled.value },
        { value: 2, label: "Second", style: CancelAction.value, state: Enabled.value },
      ]);

      expectLeft(result, MultipleCancelActions);
    });

    it("rejects empty and duplicate collection identifiers", () => {
      expectLeft(
        collectionItems([{ id: "", value: 1, title: "Empty" }]),
        EmptyItemId,
      );
      const duplicate = expectLeft(
        collectionItems([
          { id: "stable", value: 1, title: "First" },
          { id: "stable", value: 2, title: "Second" },
        ]),
        DuplicateItemId,
      );
      expect(duplicate.value0).toBe("stable");
    });

    it("rejects date bounds whose minimum is after their maximum", () => {
      const result = datePickerBounds(just(2000))(just(1000));
      expectLeft(result, MinimumAfterMaximum);
    });
  });

  describe("typed decoding and malformed native data", () => {
    it("returns WrongSettingType for a present value that violates its key witness", () => {
      vi.spyOn(Settings, "get").mockReturnValue("not-a-boolean");

      const error = expectLeft(getSetting(booleanSetting("feature.enabled"))(), WrongSettingType);

      expect(error.value0).toBe("feature.enabled");
    });

    it("returns SettingsUnavailable UnsupportedPlatform off iOS", () => {
      Platform.OS = "android";
      const nativeGet = vi.spyOn(Settings, "get");

      const error = expectLeft(
        getSetting(booleanSetting("feature.enabled"))(),
        SettingsUnavailable,
      );

      expect(error.value0).toBe(UnsupportedPlatform.value);
      expect(nativeGet).not.toHaveBeenCalled();
    });

    it("filters fractional, negative, unknown, mismatched, and out-of-range segmented selections", () => {
      const selected = vi.fn();
      const segments = [
        { value: "overview-value", label: "Overview" },
        { value: "details-value", label: "Details" },
      ];
      const { native, unmount } = renderElement(
        segmentedControl(eqString)({})(segments)("overview-value")(
          (value) => () => selected(value),
        )({ state: Enabled.value }),
        "IOSSegmentedControl",
      );

      for (const nativeEvent of [
        { id: "0", index: 0.5 },
        { id: "-1", index: -1 },
        { id: "unknown", index: 0 },
        { id: "1", index: 0 },
        { id: "2", index: 2 },
      ]) {
        act(() => native.props.onSelect({ nativeEvent }));
      }
      expect(selected).not.toHaveBeenCalled();

      act(() => native.props.onSelect({ nativeEvent: { id: "1", index: 1 } }));
      expect(selected).toHaveBeenCalledOnce();
      expect(selected).toHaveBeenCalledWith("details-value");
      unmount();
    });

    it("filters fractional, negative, unknown, mismatched, and out-of-range collection selections", () => {
      const selected = vi.fn();
      const typedItems = expectRight(
        collectionItems([
          { id: "first", value: { key: 1 }, title: "First" },
          { id: "second", value: { key: 2 }, title: "Second" },
        ]),
      );
      const { native, unmount } = renderElement(
        collectionView({})(typedItems)((value) => () => selected(value))(() => {})({
          selected: nothing,
          refreshState: RefreshIdle.value,
        }),
        "IOSCollectionView",
      );

      for (const nativeEvent of [
        { id: "first", index: 0.5 },
        { id: "first", index: -1 },
        { id: "unknown", index: 0 },
        { id: "second", index: 0 },
        { id: "second", index: 2 },
      ]) {
        act(() => native.props.onSelectItem({ nativeEvent }));
      }
      expect(selected).not.toHaveBeenCalled();

      act(() => native.props.onSelectItem({ nativeEvent: { id: "second", index: 1 } }));
      expect(selected).toHaveBeenCalledOnce();
      expect(selected).toHaveBeenCalledWith({ key: 2 });
      unmount();
    });

    it("maps an unknown native Appearance scheme to Nothing", () => {
      vi.spyOn(Appearance, "getColorScheme").mockReturnValue("sepia");
      expect(getColorScheme()).toBe(nothing);
    });

    it("maps a null initial URL to Nothing through the public Aff API", async () => {
      vi.spyOn(Linking, "getInitialURL").mockResolvedValue(null);
      await expect(runAff(getInitialURL)).resolves.toBe(nothing);
    });

    it.each([
      {
        name: "valid selection",
        index: 0,
        assertResult: (result) => {
          const value = expectRight(result);
          expect(value).toBeInstanceOf(SelectedAction);
          expect(value.value0).toBe("keep-value");
        },
      },
      {
        name: "cancel",
        index: 1,
        assertResult: (result) => {
          expect(expectRight(result)).toBe(DismissedActionSheet.value);
        },
      },
      {
        name: "fractional invalid index",
        index: 0.5,
        assertResult: (result) => {
          expect(expectLeft(result, InvalidNativeActionResponse)).toBe(
            InvalidNativeActionResponse.value,
          );
        },
      },
      {
        name: "negative invalid index",
        index: -1,
        assertResult: (result) => {
          expect(expectLeft(result, InvalidNativeActionResponse)).toBe(
            InvalidNativeActionResponse.value,
          );
        },
      },
      {
        name: "out-of-range invalid index",
        index: 3,
        assertResult: (result) => {
          expect(expectLeft(result, InvalidNativeActionResponse)).toBe(
            InvalidNativeActionResponse.value,
          );
        },
      },
    ])("maps $name without exposing a native index", ({ index, assertResult }) => {
      vi.spyOn(ActionSheetIOS, "showActionSheetWithOptions").mockImplementation(
        (_options, callback) => callback(index),
      );
      const observed = [];
      const typedActions = expectRight(actions(validActions()));

      showActionSheet({})(typedActions)(explicitActionOptions(DarkInterface.value))(
        (result) => () => observed.push(result),
      )();

      expect(observed).toHaveLength(1);
      assertResult(observed[0]);
      expect(JSON.stringify(observed[0])).not.toContain(`\"${index}\"`);
    });
  });
});
