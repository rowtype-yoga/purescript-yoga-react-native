import { describe, it, expect } from "vitest";
import { configureNextImpl, easeInEaseOut, linear, spring } from "../src/Yoga/React/Native/LayoutAnimation.js";

describe("LayoutAnimation FFI", () => {
  it("configureNextImpl accepts a config", () => {
    expect(() => configureNextImpl({
      duration: 300,
      create: { type: "easeInEaseOut", property: "opacity" },
      update: { type: "easeInEaseOut" },
      delete: { type: "easeInEaseOut", property: "opacity" },
    })).not.toThrow();
  });

  it("easeInEaseOut is an effect", () => {
    expect(() => easeInEaseOut()).not.toThrow();
  });

  it("linear is an effect", () => {
    expect(() => linear()).not.toThrow();
  });

  it("spring is an effect", () => {
    expect(() => spring()).not.toThrow();
  });
});
