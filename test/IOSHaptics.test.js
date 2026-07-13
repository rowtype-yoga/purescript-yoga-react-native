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
import { NativeModules, Platform, Vibration } from "react-native";

const originalOS = Platform.OS;
const originalHapticFeedback = NativeModules.HapticFeedback;
const hapticFeedback = {};
let haptics;

beforeAll(async () => {
  haptics = await import("../src/Yoga/React/Native/IOS/Haptics.js");
});

beforeEach(() => {
  Platform.OS = "ios";
  NativeModules.HapticFeedback = hapticFeedback;
  hapticFeedback.selectionChanged = vi.fn();
  hapticFeedback.impact = vi.fn();
  hapticFeedback.notification = vi.fn();
});

afterEach(() => {
  Platform.OS = originalOS;
  vi.restoreAllMocks();
});

afterAll(() => {
  if (originalHapticFeedback === undefined) {
    delete NativeModules.HapticFeedback;
  } else {
    NativeModules.HapticFeedback = originalHapticFeedback;
  }
});

describe("iOS Haptics FFI", () => {
  it("forwards vibration duration, pattern repeat state, and cancellation exactly", () => {
    Platform.OS = "android";
    const vibrate = vi.spyOn(Vibration, "vibrate");
    const cancel = vi.spyOn(Vibration, "cancel");

    haptics.vibrateImpl(125);
    haptics.vibrateWithPatternImpl([0, 20, 40], false);
    haptics.vibrateWithPatternImpl([10, 30], true);
    haptics.cancelImpl();

    expect(vibrate).toHaveBeenCalledTimes(3);
    expect(vibrate).toHaveBeenNthCalledWith(1, 125);
    expect(vibrate).toHaveBeenNthCalledWith(2, [0, 20, 40], false);
    expect(vibrate).toHaveBeenNthCalledWith(3, [10, 30], true);
    expect(cancel).toHaveBeenCalledOnce();
  });

  it.each([
    {
      operation: "selection change",
      method: "selectionChanged",
      invoke: () => haptics.selectionChangedImpl(),
      argument: undefined,
    },
    {
      operation: "impact",
      method: "impact",
      invoke: () => haptics.impactImpl("heavy"),
      argument: "heavy",
    },
    {
      operation: "notification",
      method: "notification",
      invoke: () => haptics.notificationImpl("warning"),
      argument: "warning",
    },
  ])(
    "invokes the native $operation method once and reports available",
    ({ method, invoke, argument }) => {
      const vibrate = vi.spyOn(Vibration, "vibrate");

      expect(invoke()).toBe(0);

      expect(hapticFeedback[method]).toHaveBeenCalledOnce();
      if (argument === undefined) {
        expect(hapticFeedback[method]).toHaveBeenCalledWith();
      } else {
        expect(hapticFeedback[method]).toHaveBeenCalledWith(argument);
      }
      expect(vibrate).not.toHaveBeenCalled();
    },
  );

  it.each([
    ["selection change", () => haptics.selectionChangedImpl()],
    ["impact", () => haptics.impactImpl("light")],
    ["notification", () => haptics.notificationImpl("success")],
  ])("reports unsupported platform for %s without invoking native haptics", (_operation, invoke) => {
    Platform.OS = "android";

    expect(invoke()).toBe(1);

    expect(hapticFeedback.selectionChanged).not.toHaveBeenCalled();
    expect(hapticFeedback.impact).not.toHaveBeenCalled();
    expect(hapticFeedback.notification).not.toHaveBeenCalled();
  });

  it.each([
    ["selection change", () => haptics.selectionChangedImpl()],
    ["impact", () => haptics.impactImpl("medium")],
    ["notification", () => haptics.notificationImpl("error")],
  ])("reports a missing native module for %s when the module is absent", (_operation, invoke) => {
    delete NativeModules.HapticFeedback;

    expect(invoke()).toBe(2);
  });

  it.each([
    ["selectionChanged", () => haptics.selectionChangedImpl()],
    ["impact", () => haptics.impactImpl("medium")],
    ["notification", () => haptics.notificationImpl("error")],
  ])("reports a missing native module when %s is not callable", (method, invoke) => {
    hapticFeedback[method] = undefined;

    expect(invoke()).toBe(2);

    for (const nativeMethod of ["selectionChanged", "impact", "notification"]) {
      if (nativeMethod !== method) {
        expect(hapticFeedback[nativeMethod]).not.toHaveBeenCalled();
      }
    }
  });
});
