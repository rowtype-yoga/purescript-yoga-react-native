import { afterEach, describe, expect, it } from "vitest";
import { Platform } from "react-native";
import {
  dynamicColorImpl,
  literalColorImpl,
  platformColorImpl,
} from "../src/Yoga/React/Native/PlatformColor.js";

const originalOS = Platform.OS;

afterEach(() => {
  Platform.OS = originalOS;
});

describe("PlatformColor FFI", () => {
  it("preserves a literal color value by identity", () => {
    const literal = { process: "display-p3", components: [0.1, 0.2, 0.3] };

    expect(literalColorImpl(literal)).toBe(literal);
  });

  it("forwards every semantic color name in order", () => {
    expect(
      platformColorImpl([
        "systemBackground",
        "secondarySystemBackground",
        "separator",
      ]),
    ).toEqual({
      semantic: [
        "systemBackground",
        "secondarySystemBackground",
        "separator",
      ],
    });
  });

  it("dispatches dynamic colors through DynamicColorIOS on iOS", () => {
    Platform.OS = "ios";

    expect(
      dynamicColorImpl({ light: "#ffffff", dark: "#101010" }),
    ).toEqual({
      dynamic: { light: "#ffffff", dark: "#101010" },
    });
  });

  it("dispatches dynamic colors through DynamicColorMacOS on macOS", () => {
    Platform.OS = "macos";

    expect(
      dynamicColorImpl({ light: "#fefefe", dark: "#121212" }),
    ).toEqual({
      dynamic: {
        light: "#fefefe",
        dark: "#121212",
        highContrastLight: undefined,
        highContrastDark: undefined,
      },
    });
  });

  it.each(["android", "windows", "web"])(
    "uses the light color unchanged on %s",
    (os) => {
      Platform.OS = os;
      const light = { token: "surface-light" };

      expect(
        dynamicColorImpl({ light, dark: { token: "surface-dark" } }),
      ).toBe(light);
    },
  );
});
