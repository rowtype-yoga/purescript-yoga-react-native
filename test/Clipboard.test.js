import { describe, it, expect } from "vitest";
import { getStringImpl, setString } from "../src/Yoga/React/Native/Clipboard.js";

describe("Clipboard FFI", () => {
  it("getStringImpl returns a cancellable aff", async () => {
    let result;
    const cancel = getStringImpl(
      (err) => { throw err; },
      (val) => { result = val; }
    );
    await new Promise((r) => setTimeout(r, 10));
    expect(result).toBe("clipboard-content");
    expect(typeof cancel).toBe("function");
  });

  it("setString is a curried effect", () => {
    expect(() => setString("hello")()).not.toThrow();
  });
});
