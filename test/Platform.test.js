import { describe, it, expect } from "vitest";
import { os, version, isTV, selectImpl } from "../src/Yoga/React/Native/Platform.js";

describe("Platform FFI", () => {
  it("os is a string", () => {
    expect(typeof os).toBe("string");
  });

  it("version is defined", () => {
    expect(version).toBeDefined();
  });

  it("isTV is a boolean", () => {
    expect(typeof isTV).toBe("boolean");
  });

  it("selectImpl picks a platform value", () => {
    const result = selectImpl({ macos: "mac", default: "other" });
    expect(result).toBe("mac");
  });
});
