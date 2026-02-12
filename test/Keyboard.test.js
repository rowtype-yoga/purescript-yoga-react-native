import { describe, it, expect } from "vitest";
import { dismiss, isVisible } from "../src/Yoga/React/Native/Keyboard.js";

describe("Keyboard FFI", () => {
  it("dismiss is an effect", () => {
    expect(() => dismiss()).not.toThrow();
  });

  it("isVisible returns a boolean", () => {
    const result = isVisible();
    expect(typeof result).toBe("boolean");
  });
});
