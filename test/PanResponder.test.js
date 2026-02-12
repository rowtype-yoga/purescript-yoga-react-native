import { describe, it, expect } from "vitest";
import { createImpl, panHandlers } from "../src/Yoga/React/Native/PanResponder.js";

describe("PanResponder FFI", () => {
  it("createImpl returns a PanResponder with panHandlers", () => {
    const pr = createImpl({
      onStartShouldSetPanResponder: () => true,
      onMoveShouldSetPanResponder: () => true,
      onPanResponderGrant: () => {},
      onPanResponderMove: () => {},
      onPanResponderRelease: () => {},
      onPanResponderTerminate: () => {},
    });
    expect(pr).toBeDefined();
    expect(pr.panHandlers).toBeDefined();
  });

  it("panHandlers extracts handlers from a PanResponder", () => {
    const pr = createImpl({});
    const handlers = panHandlers(pr);
    expect(handlers).toBeDefined();
    expect(typeof handlers).toBe("object");
  });
});
