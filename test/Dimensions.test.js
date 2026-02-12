import { describe, it, expect } from "vitest";
import { getImpl, useWindowDimensionsImpl } from "../src/Yoga/React/Native/Dimensions.js";

describe("Dimensions FFI", () => {
  it("getImpl returns scaled size", () => {
    const dims = getImpl("window")();
    expect(dims).toHaveProperty("width");
    expect(dims).toHaveProperty("height");
    expect(dims).toHaveProperty("scale");
    expect(dims).toHaveProperty("fontScale");
  });

  it("useWindowDimensionsImpl is a function", () => {
    expect(typeof useWindowDimensionsImpl).toBe("function");
  });
});
