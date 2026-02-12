import { describe, it, expect } from "vitest";
import { openURLImpl, canOpenURLImpl, getInitialURLImpl, openSettingsImpl } from "../src/Yoga/React/Native/Linking.js";

describe("Linking FFI", () => {
  it("openURLImpl returns a cancellable aff", async () => {
    let resolved = false;
    openURLImpl("https://example.com")(
      (err) => { throw err; },
      () => { resolved = true; }
    );
    await new Promise((r) => setTimeout(r, 10));
    expect(resolved).toBe(true);
  });

  it("canOpenURLImpl resolves to boolean", async () => {
    let result;
    canOpenURLImpl("https://example.com")(
      (err) => { throw err; },
      (val) => { result = val; }
    );
    await new Promise((r) => setTimeout(r, 10));
    expect(typeof result).toBe("boolean");
  });

  it("getInitialURLImpl resolves", async () => {
    let called = false;
    getInitialURLImpl(
      (err) => { throw err; },
      (val) => { called = true; }
    );
    await new Promise((r) => setTimeout(r, 10));
    expect(called).toBe(true);
  });

  it("openSettingsImpl resolves", async () => {
    let called = false;
    openSettingsImpl(
      (err) => { throw err; },
      () => { called = true; }
    );
    await new Promise((r) => setTimeout(r, 10));
    expect(called).toBe(true);
  });
});
