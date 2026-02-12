import { describe, it, expect } from "vitest";
import { dynamicColor } from "../src/Yoga/React/Native/DynamicColorMacOS.js";

describe("DynamicColorMacOS FFI", () => {
  it("dynamicColor returns an object with a color property", () => {
    const result = dynamicColor({ light: "#fff", dark: "#000" });
    expect(result).toHaveProperty("color");
    expect(result.color).toContain("#fff");
    expect(result.color).toContain("#000");
  });
});
