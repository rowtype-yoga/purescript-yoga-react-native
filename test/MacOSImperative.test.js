import { describe, it, expect, vi } from "vitest";
import { NativeModules } from "react-native";
import { alertImpl } from "../src/Yoga/React/Native/MacOS/Alert.js";
import { showMenuImpl } from "../src/Yoga/React/Native/MacOS/Menu.js";
import {
  copyToClipboardImpl,
  readClipboardImpl,
} from "../src/Yoga/React/Native/MacOS/Pasteboard.js";

describe("macOS Alert FFI", () => {
  it("alertImpl calls NativeModules.MacOSAlertModule.show", () => {
    const spy = vi.spyOn(NativeModules.MacOSAlertModule, "show");
    alertImpl("warning", "Title", "Message", ["OK", "Cancel"]);
    expect(spy).toHaveBeenCalledWith("warning", "Title", "Message", [
      "OK",
      "Cancel",
    ]);
    spy.mockRestore();
  });

  it("alertImpl passes style through", () => {
    const spy = vi.spyOn(NativeModules.MacOSAlertModule, "show");
    alertImpl("critical", "Error", "Something broke", ["Retry"]);
    expect(spy).toHaveBeenCalledWith("critical", "Error", "Something broke", [
      "Retry",
    ]);
    spy.mockRestore();
  });

  it("alertImpl does not throw with empty buttons", () => {
    expect(() => alertImpl("informational", "Info", "Note", [])).not.toThrow();
  });
});

describe("macOS Menu FFI", () => {
  it("showMenuImpl calls NativeModules.MacOSMenuModule.show with items", () => {
    const spy = vi.spyOn(NativeModules.MacOSMenuModule, "show");
    const items = [
      { title: "Cut", id: "cut" },
      { title: "Copy", id: "copy" },
    ];
    const callback = (_id) => () => {};
    showMenuImpl(items, callback);
    expect(spy).toHaveBeenCalledWith(items);
    spy.mockRestore();
  });

  it("showMenuImpl invokes callback when item selected", async () => {
    const selectedId = "paste";
    vi.spyOn(NativeModules.MacOSMenuModule, "show").mockResolvedValueOnce(
      selectedId,
    );
    let result = "";
    const callback = (id) => () => {
      result = id;
    };
    showMenuImpl([{ title: "Paste", id: "paste" }], callback);
    await new Promise((r) => setTimeout(r, 10));
    expect(result).toBe("paste");
  });

  it("showMenuImpl does not invoke callback when no item selected", async () => {
    vi.spyOn(NativeModules.MacOSMenuModule, "show").mockResolvedValueOnce("");
    let called = false;
    const callback = (_id) => () => {
      called = true;
    };
    showMenuImpl([{ title: "Save", id: "save" }], callback);
    await new Promise((r) => setTimeout(r, 10));
    expect(called).toBe(false);
  });
});

describe("macOS Pasteboard FFI", () => {
  it("copyToClipboardImpl does not throw", () => {
    expect(() => copyToClipboardImpl("Hello from tests")).not.toThrow();
  });

  it("readClipboardImpl does not throw", () => {
    expect(() => readClipboardImpl()).not.toThrow();
  });
});
