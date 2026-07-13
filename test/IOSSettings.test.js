import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { Platform, Settings } from "react-native";
import { Just, Nothing } from "../output/Data.Maybe/index.js";
import { Right } from "../output/Data.Either/index.js";
import { Available } from "../output/Yoga.React.Native.Types/index.js";
import {
  stringSetting,
  watch,
} from "../output/Yoga.React.Native.IOS.Settings/index.js";
import {
  disposeSettingsWatchImpl,
  getImpl,
  setImpl,
  watchImpl,
} from "../src/Yoga/React/Native/IOS/Settings.js";

const originalOS = Platform.OS;
const originalSettingsMethods = {
  get: Settings.get,
  set: Settings.set,
  watchKeys: Settings.watchKeys,
  clearWatch: Settings.clearWatch,
};

beforeEach(() => {
  Platform.OS = "ios";
  Object.assign(Settings, originalSettingsMethods);
});

afterEach(() => {
  Platform.OS = originalOS;
  Object.assign(Settings, originalSettingsMethods);
  vi.restoreAllMocks();
});

describe("iOS Settings FFI", () => {
  it("reports unsupported status without touching Settings off iOS", () => {
    Platform.OS = "android";
    const get = vi.spyOn(Settings, "get");
    const set = vi.spyOn(Settings, "set");
    const watchKeys = vi.spyOn(Settings, "watchKeys");
    const clearWatch = vi.spyOn(Settings, "clearWatch");

    expect(getImpl("theme")).toEqual({
      status: 1,
      present: false,
      value: undefined,
    });
    expect(setImpl("theme", "dark")).toBe(1);
    expect(watchImpl("theme", vi.fn())).toEqual({ status: 1, watch: null });

    expect(get).not.toHaveBeenCalled();
    expect(set).not.toHaveBeenCalled();
    expect(watchKeys).not.toHaveBeenCalled();
    expect(clearWatch).not.toHaveBeenCalled();
  });

  it("distinguishes a missing iOS Settings method from an unsupported platform", () => {
    delete Settings.get;
    expect(getImpl("theme")).toEqual({
      status: 2,
      present: false,
      value: undefined,
    });

    Settings.get = originalSettingsMethods.get;
    delete Settings.set;
    expect(setImpl("theme", "dark")).toBe(2);

    Settings.set = originalSettingsMethods.set;
    delete Settings.watchKeys;
    expect(watchImpl("theme", vi.fn())).toEqual({ status: 2, watch: null });

    Settings.watchKeys = originalSettingsMethods.watchKeys;
    delete Settings.clearWatch;
    expect(watchImpl("theme", vi.fn())).toEqual({ status: 2, watch: null });
  });

  it.each([
    { name: "undefined is absent", value: undefined, present: false },
    { name: "null is present", value: null, present: true },
    { name: "an empty string is present", value: "", present: true },
    { name: "false is present", value: false, present: true },
    { name: "zero is present", value: 0, present: true },
  ])("preserves raw Settings values: $name", ({ value, present }) => {
    const get = vi.spyOn(Settings, "get").mockReturnValue(value);

    expect(getImpl("feature.flag")).toEqual({ status: 0, present, value });
    expect(get).toHaveBeenCalledOnce();
    expect(get).toHaveBeenCalledWith("feature.flag");
  });

  it("sets the requested key to the raw value without coercion", () => {
    const set = vi.spyOn(Settings, "set");
    const value = false;

    expect(setImpl("feature.enabled", value)).toBe(0);

    expect(set).toHaveBeenCalledOnce();
    expect(set).toHaveBeenCalledWith({ "feature.enabled": value });
  });

  it("registers one keyed watcher and delivers each native notification exactly once", () => {
    let nativeCallback;
    const watchKeys = vi
      .spyOn(Settings, "watchKeys")
      .mockImplementation((_keys, callback) => {
        nativeCallback = callback;
        return 73;
      });
    const callback = vi.fn();

    const result = watchImpl("theme", callback);
    nativeCallback();
    nativeCallback();

    expect(result).toEqual({
      status: 0,
      watch: { settings: Settings, id: 73, disposed: false },
    });
    expect(watchKeys).toHaveBeenCalledOnce();
    expect(watchKeys).toHaveBeenCalledWith(["theme"], callback);
    expect(callback).toHaveBeenCalledTimes(2);
    expect(callback.mock.calls).toEqual([[], []]);
  });

  it("re-reads and decodes the watched key for every notification", () => {
    let nativeCallback;
    let currentValue = "light";
    vi.spyOn(Settings, "get").mockImplementation(() => currentValue);
    vi.spyOn(Settings, "watchKeys").mockImplementation((_keys, callback) => {
      nativeCallback = callback;
      return 91;
    });
    const observed = [];

    const availability = watch(stringSetting("theme"))((result) => () => {
      observed.push(result);
    })();

    expect(availability).toBeInstanceOf(Available);
    expect(observed).toEqual([]);

    nativeCallback();
    currentValue = "dark";
    nativeCallback();
    currentValue = undefined;
    nativeCallback();

    expect(Settings.get.mock.calls).toEqual([["theme"], ["theme"], ["theme"]]);
    expect(observed).toHaveLength(3);
    expect(observed[0]).toBeInstanceOf(Right);
    expect(observed[0].value0).toBeInstanceOf(Just);
    expect(observed[0].value0.value0).toBe("light");
    expect(observed[1]).toBeInstanceOf(Right);
    expect(observed[1].value0).toBeInstanceOf(Just);
    expect(observed[1].value0.value0).toBe("dark");
    expect(observed[2]).toBeInstanceOf(Right);
    expect(observed[2].value0).toBe(Nothing.value);
  });

  it("clears a native watch at most once when disposed repeatedly", () => {
    vi.spyOn(Settings, "watchKeys").mockReturnValue(117);
    const clearWatch = vi.spyOn(Settings, "clearWatch");
    const { watch: settingsWatch } = watchImpl("theme", vi.fn());

    disposeSettingsWatchImpl(settingsWatch);
    disposeSettingsWatchImpl(settingsWatch);

    expect(clearWatch).toHaveBeenCalledOnce();
    expect(clearWatch).toHaveBeenCalledWith(117);
  });
});
