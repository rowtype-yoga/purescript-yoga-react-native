import { describe, it, expect } from "vitest";
import { platformColor } from "../src/Yoga/React/Native/PlatformColor.js";

describe("PlatformColor FFI", () => {
  it("platformColor wraps a color name", () => {
    const result = platformColor("systemBlue");
    expect(result).toBeDefined();
    expect(typeof result).toBe("string");
    expect(result).toContain("systemBlue");
  });
});
