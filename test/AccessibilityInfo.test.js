import { describe, it, expect } from "vitest";
import {
  isScreenReaderEnabledImpl, isReduceMotionEnabledImpl,
  isBoldTextEnabledImpl, isGrayscaleEnabledImpl,
  isInvertColorsEnabledImpl, isReduceTransparencyEnabledImpl,
  announceForAccessibility,
} from "../src/Yoga/React/Native/AccessibilityInfo.js";

describe("AccessibilityInfo FFI", () => {
  it("isScreenReaderEnabledImpl resolves to boolean", async () => {
    let result;
    isScreenReaderEnabledImpl((err) => { throw err; }, (val) => { result = val; });
    await new Promise((r) => setTimeout(r, 10));
    expect(typeof result).toBe("boolean");
  });

  it("isReduceMotionEnabledImpl resolves to boolean", async () => {
    let result;
    isReduceMotionEnabledImpl((err) => { throw err; }, (val) => { result = val; });
    await new Promise((r) => setTimeout(r, 10));
    expect(typeof result).toBe("boolean");
  });

  it("isBoldTextEnabledImpl resolves to boolean", async () => {
    let result;
    isBoldTextEnabledImpl((err) => { throw err; }, (val) => { result = val; });
    await new Promise((r) => setTimeout(r, 10));
    expect(typeof result).toBe("boolean");
  });

  it("isGrayscaleEnabledImpl resolves to boolean", async () => {
    let result;
    isGrayscaleEnabledImpl((err) => { throw err; }, (val) => { result = val; });
    await new Promise((r) => setTimeout(r, 10));
    expect(typeof result).toBe("boolean");
  });

  it("isInvertColorsEnabledImpl resolves to boolean", async () => {
    let result;
    isInvertColorsEnabledImpl((err) => { throw err; }, (val) => { result = val; });
    await new Promise((r) => setTimeout(r, 10));
    expect(typeof result).toBe("boolean");
  });

  it("isReduceTransparencyEnabledImpl resolves to boolean", async () => {
    let result;
    isReduceTransparencyEnabledImpl((err) => { throw err; }, (val) => { result = val; });
    await new Promise((r) => setTimeout(r, 10));
    expect(typeof result).toBe("boolean");
  });

  it("announceForAccessibility is a curried effect", () => {
    expect(() => announceForAccessibility("hello")()).not.toThrow();
  });
});
