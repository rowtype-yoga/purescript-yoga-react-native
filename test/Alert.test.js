import { describe, it, expect, vi } from "vitest";
import { alertImpl } from "../src/Yoga/React/Native/Alert.js";

describe("Alert FFI", () => {
  it("alertImpl calls without throwing", () => {
    expect(() => alertImpl("Title", "Message", [])).not.toThrow();
  });

  it("alertImpl passes buttons through", () => {
    const onPress = () => {};
    expect(() => alertImpl("T", "M", [{ text: "OK", onPress, style: "default" }])).not.toThrow();
  });
});
