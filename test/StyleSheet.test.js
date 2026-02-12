import { describe, it, expect } from "vitest";
import { create, hairlineWidth, absoluteFill } from "../src/Yoga/React/Native/StyleSheet.js";

describe("StyleSheet FFI", () => {
  it("create returns the same structure", () => {
    const styles = create({ container: { flex: 1 }, text: { color: "red" } });
    expect(styles.container).toEqual({ flex: 1 });
    expect(styles.text).toEqual({ color: "red" });
  });

  it("hairlineWidth is a number", () => {
    expect(typeof hairlineWidth).toBe("number");
    expect(hairlineWidth).toBeGreaterThan(0);
  });

  it("absoluteFill has position absolute", () => {
    expect(absoluteFill.position).toBe("absolute");
    expect(absoluteFill).toHaveProperty("left");
    expect(absoluteFill).toHaveProperty("right");
    expect(absoluteFill).toHaveProperty("top");
    expect(absoluteFill).toHaveProperty("bottom");
  });
});
