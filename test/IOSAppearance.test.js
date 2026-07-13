import { afterEach, describe, expect, it, vi } from "vitest";
import { Appearance } from "react-native";
import {
  addChangeListenerImpl,
  disposeAppearanceSubscriptionImpl,
  getColorSchemeImpl,
  setColorSchemeImpl,
  useColorSchemeImpl,
} from "../src/Yoga/React/Native/Appearance.js";

const originalAddChangeListener = Appearance.addChangeListener;

afterEach(() => {
  vi.restoreAllMocks();
  if (originalAddChangeListener === undefined) {
    delete Appearance.addChangeListener;
  } else {
    Appearance.addChangeListener = originalAddChangeListener;
  }
});

describe("Appearance FFI", () => {
  it.each([
    { nativeScheme: "light", expected: "light" },
    { nativeScheme: "dark", expected: "dark" },
    { nativeScheme: null, expected: null },
    { nativeScheme: "sepia", expected: "sepia" },
    { nativeScheme: { unexpected: true }, expected: null },
  ])(
    "normalizes native getter scheme $nativeScheme to $expected",
    ({ nativeScheme, expected }) => {
      vi.spyOn(Appearance, "getColorScheme").mockReturnValue(nativeScheme);

      expect(getColorSchemeImpl()).toBe(expected);
    },
  );

  it("passes primitive and null schemes through the uncurried setter bridge", () => {
    const setColorScheme = vi.spyOn(Appearance, "setColorScheme");

    setColorSchemeImpl("dark");
    setColorSchemeImpl(null);

    expect(setColorScheme.mock.calls).toEqual([["dark"], [null]]);
  });

  it("returns the hook's primitive scheme without an Effect thunk", () => {
    expect(useColorSchemeImpl()).toBe("light");
  });

  it("delivers each native event once, preserves strings, and normalizes malformed values", () => {
    let nativeListener;
    Appearance.addChangeListener = vi.fn((listener) => {
      nativeListener = listener;
      return { remove: vi.fn() };
    });
    const callback = vi.fn();

    addChangeListenerImpl(callback);
    nativeListener({ colorScheme: "dark" });
    nativeListener({ colorScheme: "sepia" });
    nativeListener({ colorScheme: { unexpected: true } });

    expect(callback.mock.calls).toEqual([["dark"], ["sepia"], [null]]);
  });

  it("removes the same native subscription only once when disposed twice", () => {
    const remove = vi.fn();
    Appearance.addChangeListener = vi.fn(() => ({ remove }));
    const subscription = addChangeListenerImpl(vi.fn());

    disposeAppearanceSubscriptionImpl(subscription);
    disposeAppearanceSubscriptionImpl(subscription);

    expect(remove).toHaveBeenCalledTimes(1);
  });
});
