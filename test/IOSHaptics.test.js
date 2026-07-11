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
  NativeModules.HapticFeedback = hapticFeedback;
  Platform.OS = "ios";
  haptics = await import("../src/Yoga/React/Native/IOS/Haptics.js");
});

beforeEach(() => {
  Platform.OS = "ios";
  delete hapticFeedback.selectionChanged;
  delete hapticFeedback.impact;
  delete hapticFeedback.notification;
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
  it("forwards one-shot and patterned vibration requests and cancels vibration", () => {
    const vibrate = vi.spyOn(Vibration, "vibrate");
    const cancel = vi.spyOn(Vibration, "cancel");

    haptics.vibrateImpl(125);
    haptics.vibrateWithPatternImpl([0, 20, 40], true);
    haptics.cancelImpl();

    expect(vibrate).toHaveBeenNthCalledWith(1, 125);
    expect(vibrate).toHaveBeenNthCalledWith(2, [0, 20, 40], true);
    expect(cancel).toHaveBeenCalledOnce();
  });

  it("dispatches selection, impact, and notification events to the native haptics module", () => {
    hapticFeedback.selectionChanged = vi.fn();
    hapticFeedback.impact = vi.fn();
    hapticFeedback.notification = vi.fn();
    const vibrate = vi.spyOn(Vibration, "vibrate");

    haptics.selectionChangedImpl();
    haptics.impactImpl(haptics.impactHeavy);
    haptics.notificationImpl(haptics.notificationWarning);

    expect(hapticFeedback.selectionChanged).toHaveBeenCalledOnce();
    expect(hapticFeedback.impact).toHaveBeenCalledWith("heavy");
    expect(hapticFeedback.notification).toHaveBeenCalledWith("warning");
    expect(vibrate).not.toHaveBeenCalled();
  });

  it.each([
    { operation: "selection", invoke: () => haptics.selectionChangedImpl(), expected: 10 },
    { operation: "light impact", invoke: () => haptics.impactImpl(haptics.impactLight), expected: 10 },
    { operation: "medium impact", invoke: () => haptics.impactImpl(haptics.impactMedium), expected: 30 },
    { operation: "heavy impact", invoke: () => haptics.impactImpl(haptics.impactHeavy), expected: 50 },
    { operation: "success notification", invoke: () => haptics.notificationImpl(haptics.notificationSuccess), expected: 30 },
    { operation: "warning notification", invoke: () => haptics.notificationImpl(haptics.notificationWarning), expected: [0, 30, 30] },
    { operation: "error notification", invoke: () => haptics.notificationImpl(haptics.notificationError), expected: [0, 50, 50, 50] },
  ])("uses the iOS vibration fallback for $operation", ({ invoke, expected }) => {
    const vibrate = vi.spyOn(Vibration, "vibrate");

    invoke();

    expect(vibrate).toHaveBeenCalledOnce();
    expect(vibrate).toHaveBeenCalledWith(expected);
  });

  it("does not synthesize haptics with vibration off iOS", () => {
    Platform.OS = "android";
    const vibrate = vi.spyOn(Vibration, "vibrate");

    haptics.selectionChangedImpl();
    haptics.impactImpl(haptics.impactHeavy);
    haptics.notificationImpl(haptics.notificationError);

    expect(vibrate).not.toHaveBeenCalled();
  });
});
