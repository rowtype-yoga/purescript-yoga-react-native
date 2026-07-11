import { afterEach, describe, expect, it, vi } from "vitest";
import { Linking } from "react-native";
import {
  canOpenURLImpl,
  openURLImpl,
} from "../src/Yoga/React/Native/IOS/LinkingIOS.js";

afterEach(() => {
  vi.restoreAllMocks();
});

describe("iOS Linking FFI", () => {
  it("forwards the exact URL to Linking.openURL and invokes Aff success when it resolves", async () => {
    const url = "https://example.com/path?query=a%20b#section";
    const openURL = vi.spyOn(Linking, "openURL").mockResolvedValue(undefined);
    const onError = vi.fn();
    const onSuccess = vi.fn();

    openURLImpl(url)(onError, onSuccess);
    await openURL.mock.results[0].value;

    expect(openURL).toHaveBeenCalledOnce();
    expect(openURL).toHaveBeenCalledWith(url);
    expect(onSuccess).toHaveBeenCalledOnce();
    expect(onSuccess).toHaveBeenCalledWith(undefined);
    expect(onError).not.toHaveBeenCalled();
  });

  it("invokes Aff error with the native rejection and never reports success", async () => {
    const rejection = new Error("Unable to open external URL");
    const openURL = vi.spyOn(Linking, "openURL").mockRejectedValue(rejection);
    const onError = vi.fn();
    const onSuccess = vi.fn();

    openURLImpl("https://example.com/unavailable")(onError, onSuccess);
    await expect(openURL.mock.results[0].value).rejects.toBe(rejection);
    await Promise.resolve();

    expect(onError).toHaveBeenCalledOnce();
    expect(onError).toHaveBeenCalledWith(rejection);
    expect(onSuccess).not.toHaveBeenCalled();
  });

  it("returns a canceler that completes successfully", () => {
    vi.spyOn(Linking, "openURL").mockReturnValue(new Promise(() => {}));
    const cancelError = new Error("cancelled");
    const onCancelerError = vi.fn();
    const onCancelerSuccess = vi.fn();

    const canceler = openURLImpl("https://example.com/pending")(
      vi.fn(),
      vi.fn(),
    );
    canceler(cancelError, onCancelerError, onCancelerSuccess);

    expect(onCancelerSuccess).toHaveBeenCalledOnce();
    expect(onCancelerSuccess).toHaveBeenCalledWith();
    expect(onCancelerError).not.toHaveBeenCalled();
  });

  it("canOpenURL reports capability without opening the URL", async () => {
    const url = "https://example.com/capability-only";
    const canOpenURL = vi.spyOn(Linking, "canOpenURL").mockResolvedValue(false);
    const openURL = vi.spyOn(Linking, "openURL");
    const onError = vi.fn();
    const onSuccess = vi.fn();

    canOpenURLImpl(url)(onError, onSuccess);
    await canOpenURL.mock.results[0].value;

    expect(canOpenURL).toHaveBeenCalledOnce();
    expect(canOpenURL).toHaveBeenCalledWith(url);
    expect(onSuccess).toHaveBeenCalledOnce();
    expect(onSuccess).toHaveBeenCalledWith(false);
    expect(onError).not.toHaveBeenCalled();
    expect(openURL).not.toHaveBeenCalled();
  });
});
