import { describe, it, expect } from "vitest";
import React from "react";
import { createNativeElementImpl, createNativeElementNoKidsImpl } from "../src/Yoga/React/Native/Internal.js";

describe("Internal FFI", () => {
  it("createNativeElementImpl creates an element with no children", () => {
    const el = createNativeElementImpl("div", { id: "test" }, null);
    expect(el).toBeDefined();
    expect(el.type).toBe("div");
    expect(el.props.id).toBe("test");
  });

  it("createNativeElementImpl creates an element with array children", () => {
    const child1 = React.createElement("span", null, "a");
    const child2 = React.createElement("span", null, "b");
    const el = createNativeElementImpl("div", {}, [child1, child2]);
    expect(el.type).toBe("div");
    expect(el.props.children).toHaveLength(2);
  });

  it("createNativeElementImpl creates an element with single child", () => {
    const child = React.createElement("span", null, "only");
    const el = createNativeElementImpl("div", {}, child);
    expect(el.type).toBe("div");
    expect(el.props.children).toBeDefined();
  });

  it("createNativeElementImpl handles empty array", () => {
    const el = createNativeElementImpl("div", { id: "empty" }, []);
    expect(el.type).toBe("div");
    expect(el.props.id).toBe("empty");
  });

  it("createNativeElementNoKidsImpl is React.createElement", () => {
    expect(createNativeElementNoKidsImpl).toBe(React.createElement);
  });
});
