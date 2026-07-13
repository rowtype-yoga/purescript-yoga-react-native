import { afterEach, describe, expect, it, vi } from "vitest";
import { Linking } from "react-native";
import {
  addURLListenerImpl,
  canOpenURLImpl,
  disposeLinkingSubscriptionImpl,
  getInitialURLImpl,
  openSettingsImpl,
  openURLImpl,
} from "../src/Yoga/React/Native/IOS/LinkingIOS.js";

afterEach(() => {
  vi.restoreAllMocks();
});

describe("iOS Linking FFI", () => {
  it("returns openURL's Promise result after forwarding the exact URL", async () => {
    const url = "custom-scheme://host/path?query=a%20b#section";
    const openURL = vi.spyOn(Linking, "openURL").mockResolvedValue("ignored");

    await expect(openURLImpl(url)).resolves.toBeUndefined();

    expect(openURL).toHaveBeenCalledOnce();
    expect(openURL).toHaveBeenCalledWith(url);
  });

  it.each([
    {
      operation: "openURL",
      invoke: () => openURLImpl("https://example.com/unavailable"),
    },
    {
      operation: "canOpenURL",
      invoke: () => canOpenURLImpl("custom-scheme://unavailable"),
    },
    { operation: "getInitialURL", invoke: () => getInitialURLImpl() },
    { operation: "openSettings", invoke: () => openSettingsImpl() },
  ])(
    "preserves the native $operation rejection identity",
    async ({ operation, invoke }) => {
      const rejection = new Error(`${operation} rejected`);
      vi.spyOn(Linking, operation).mockRejectedValue(rejection);

      await expect(invoke()).rejects.toBe(rejection);
    },
  );

  it("reports URL capability without opening the URL", async () => {
    const url = "custom-scheme://capability-only";
    const canOpenURL = vi.spyOn(Linking, "canOpenURL").mockResolvedValue(false);
    const openURL = vi.spyOn(Linking, "openURL");

    await expect(canOpenURLImpl(url)).resolves.toBe(false);

    expect(canOpenURL).toHaveBeenCalledOnce();
    expect(canOpenURL).toHaveBeenCalledWith(url);
    expect(openURL).not.toHaveBeenCalled();
  });

  it.each([
    { nativeURL: null, expected: null },
    { nativeURL: "custom-scheme://initial", expected: "custom-scheme://initial" },
  ])(
    "preserves the native initial URL result $nativeURL",
    async ({ nativeURL, expected }) => {
      vi.spyOn(Linking, "getInitialURL").mockResolvedValue(nativeURL);

      await expect(getInitialURLImpl()).resolves.toBe(expected);
    },
  );

  it("resolves openSettings to Unit", async () => {
    const openSettings = vi
      .spyOn(Linking, "openSettings")
      .mockResolvedValue("ignored");

    await expect(openSettingsImpl()).resolves.toBeUndefined();
    expect(openSettings).toHaveBeenCalledOnce();
  });

  it("hardcodes the url event and delivers only string URL payloads", () => {
    let nativeListener;
    const subscription = { remove: vi.fn() };
    const addEventListener = vi
      .spyOn(Linking, "addEventListener")
      .mockImplementation((eventName, listener) => {
        nativeListener = listener;
        return subscription;
      });
    const callback = vi.fn();

    expect(addURLListenerImpl(callback)).toBe(subscription);
    expect(addEventListener).toHaveBeenCalledOnce();
    expect(addEventListener).toHaveBeenCalledWith("url", nativeListener);

    nativeListener({ url: "custom-scheme://valid" });
    nativeListener({ url: "" });
    nativeListener({ url: 42 });
    nativeListener({});
    nativeListener(null);

    expect(callback.mock.calls).toEqual([
      ["custom-scheme://valid"],
      [""],
    ]);
  });

  it("removes the same native subscription at most once", () => {
    const remove = vi.fn();
    const subscription = { remove };

    disposeLinkingSubscriptionImpl(subscription);
    disposeLinkingSubscriptionImpl(subscription);

    expect(remove).toHaveBeenCalledOnce();
  });

  it("does not retry native removal after remove throws", () => {
    const rejection = new Error("native removal failed");
    const remove = vi.fn(() => {
      throw rejection;
    });
    const subscription = { remove };

    expect(() => disposeLinkingSubscriptionImpl(subscription)).toThrow(rejection);
    expect(() => disposeLinkingSubscriptionImpl(subscription)).not.toThrow();
    expect(remove).toHaveBeenCalledOnce();
  });
});
