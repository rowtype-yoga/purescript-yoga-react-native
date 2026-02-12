import { describe, it, expect } from "vitest";
import { isRTL, allowRTL, forceRTL, swapLeftAndRightInRTL } from "../src/Yoga/React/Native/I18nManager.js";

describe("I18nManager FFI", () => {
  it("isRTL is a boolean", () => {
    expect(typeof isRTL).toBe("boolean");
  });

  it("allowRTL is a curried effect", () => {
    expect(() => allowRTL(true)()).not.toThrow();
  });

  it("forceRTL is a curried effect", () => {
    expect(() => forceRTL(false)()).not.toThrow();
  });

  it("swapLeftAndRightInRTL is a curried effect", () => {
    expect(() => swapLeftAndRightInRTL(true)()).not.toThrow();
  });
});
