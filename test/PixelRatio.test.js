import { describe, it, expect } from "vitest";
import { get, getFontScale, getPixelSizeForLayoutSize, roundToNearestPixel } from "../src/Yoga/React/Native/PixelRatio.js";

describe("PixelRatio FFI", () => {
  it("get is a number", () => {
    expect(typeof get).toBe("number");
    expect(get).toBeGreaterThan(0);
  });

  it("getFontScale is a number", () => {
    expect(typeof getFontScale).toBe("number");
    expect(getFontScale).toBeGreaterThan(0);
  });

  it("getPixelSizeForLayoutSize scales a value", () => {
    const result = getPixelSizeForLayoutSize(100);
    expect(typeof result).toBe("number");
    expect(result).toBeGreaterThan(0);
  });

  it("roundToNearestPixel rounds a value", () => {
    const result = roundToNearestPixel(100.3);
    expect(typeof result).toBe("number");
  });
});
