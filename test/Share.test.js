import { describe, it, expect } from "vitest";
import { shareImpl } from "../src/Yoga/React/Native/Share.js";

describe("Share FFI", () => {
  it("shareImpl returns a cancellable aff that resolves", async () => {
    let result;
    shareImpl({ message: "Hello", title: "Title", url: "" })(
      (err) => { throw err; },
      (val) => { result = val; }
    );
    await new Promise((r) => setTimeout(r, 10));
    expect(result).toHaveProperty("action");
  });
});
