import { describe, it, expect } from "vitest";
import { stylesImpl, tw } from "../src/Yoga/React/Native/Style.js";

describe("Style FFI", () => {
  it("stylesImpl merges an array of style objects", () => {
    const result = stylesImpl([{ flex: 1 }, { color: "red" }, { padding: 10 }]);
    expect(result).toEqual({ flex: 1, color: "red", padding: 10 });
  });

  it("stylesImpl later values override earlier", () => {
    const result = stylesImpl([{ color: "red" }, { color: "blue" }]);
    expect(result.color).toBe("blue");
  });

  it("tw returns a style object from a class string", () => {
    const result = tw("flex-1 p-4");
    expect(result).toEqual({ _tw: "flex-1 p-4" });
  });
});
