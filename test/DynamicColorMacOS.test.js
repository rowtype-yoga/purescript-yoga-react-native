import { describe, it, expect } from "vitest";
import { dynamicColor } from "../src/Yoga/React/Native/DynamicColorMacOS.js";

describe("DynamicColorMacOS FFI", () => {
  it("dynamicColor returns a ColorValue with dynamic property", () => {
    const result = dynamicColor({ light: "#fff", dark: "#000" });
    expect(result).toHaveProperty("dynamic");
    expect(result.dynamic.light).toBe("#fff");
    expect(result.dynamic.dark).toBe("#000");
  });
});
