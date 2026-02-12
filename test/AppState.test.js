import { describe, it, expect } from "vitest";
import { currentState, addEventListenerImpl, removeSubscription } from "../src/Yoga/React/Native/AppState.js";

describe("AppState FFI", () => {
  it("currentState returns a string", () => {
    const state = currentState();
    expect(typeof state).toBe("string");
  });

  it("addEventListenerImpl returns a subscription", () => {
    const sub = addEventListenerImpl("change", (state) => {});
    expect(sub).toBeDefined();
    expect(typeof sub.remove).toBe("function");
  });

  it("removeSubscription calls remove", () => {
    const sub = addEventListenerImpl("change", (state) => {});
    expect(() => removeSubscription(sub)()).not.toThrow();
  });
});
