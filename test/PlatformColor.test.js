import { describe, it, expect } from "vitest";
import { platformColor } from "../src/Yoga/React/Native/PlatformColor.js";

describe("PlatformColor FFI", () => {
  it("platformColor returns an opaque ColorValue object", () => {
    const result = platformColor("systemBlue");
    expect(result).toEqual({ semantic: ["systemBlue"] });
  });
});
