import { describe, it, expect } from "vitest";
import { getColorScheme, setColorScheme, useColorSchemeImpl } from "../src/Yoga/React/Native/Appearance.js";

describe("Appearance FFI", () => {
  it("getColorScheme returns a string", () => {
    const result = getColorScheme();
    expect(typeof result).toBe("string");
  });

  it("setColorScheme does not throw", () => {
    expect(() => setColorScheme("dark")()).not.toThrow();
  });

  it("useColorSchemeImpl is a function", () => {
    expect(typeof useColorSchemeImpl).toBe("function");
  });
});
