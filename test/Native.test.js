import { describe, it, expect } from "vitest";
import { stringImpl, registerComponentImpl } from "../src/Yoga/React/Native.js";

describe("Native FFI", () => {
  it("stringImpl creates a Text element from a string", () => {
    const el = stringImpl("hello");
    expect(el).toBeDefined();
    expect(el.props.children).toBe("hello");
  });

  it("registerComponentImpl does not throw", () => {
    expect(() => registerComponentImpl("TestApp", () => null)).not.toThrow();
  });
});
