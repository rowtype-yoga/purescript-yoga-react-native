import { describe, it, expect } from "vitest";
import { colorWithSystemEffect } from "../src/Yoga/React/Native/ColorWithSystemEffectMacOS.js";

describe("ColorWithSystemEffectMacOS FFI", () => {
  it("colorWithSystemEffect combines color and effect", () => {
    const result = colorWithSystemEffect("systemBlue")("pressed");
    expect(typeof result).toBe("string");
    expect(result).toContain("systemBlue");
    expect(result).toContain("pressed");
  });
});
