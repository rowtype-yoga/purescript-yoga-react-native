import { describe, it, expect } from "vitest";
import { colorWithSystemEffect } from "../src/Yoga/React/Native/ColorWithSystemEffectMacOS.js";

describe("ColorWithSystemEffectMacOS FFI", () => {
  it("colorWithSystemEffect wraps color with system effect", () => {
    const color = { semantic: ["controlAccentColor"] };
    const result = colorWithSystemEffect(color)("pressed");
    expect(result).toHaveProperty("colorWithSystemEffect");
    expect(result.colorWithSystemEffect.baseColor).toEqual(color);
    expect(result.colorWithSystemEffect.systemEffect).toBe("pressed");
  });
});
