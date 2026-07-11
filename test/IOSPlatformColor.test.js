import { afterEach, describe, expect, it } from "vitest";
import { Platform } from "react-native";
import {
  dynamicColorImpl,
  platformColorImpl,
} from "../src/Yoga/React/Native/IOS/PlatformColor.js";

const originalOS = Platform.OS;

afterEach(() => {
  Platform.OS = originalOS;
});

describe("iOS PlatformColor FFI", () => {
  it("forwards every semantic color name in order", () => {
    expect(
      platformColorImpl(["systemBackground", "secondarySystemBackground"]),
    ).toEqual({
      semantic: ["systemBackground", "secondarySystemBackground"],
    });
  });

  it("creates an iOS dynamic color from both appearance variants", () => {
    Platform.OS = "ios";

    expect(dynamicColorImpl("#ffffff", "#101010")).toEqual({
      dynamic: { light: "#ffffff", dark: "#101010" },
    });
  });

  it("returns the light color unchanged off iOS", () => {
    Platform.OS = "android";

    expect(dynamicColorImpl("#ffffff", "#101010")).toBe("#ffffff");
  });
});
