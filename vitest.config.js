import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    globals: true,
    include: ["test/**/*.test.js"],
    exclude: ["test/visual/**"],
    alias: {
      "react-native": new URL(
        "./test/__mocks__/react-native.js",
        import.meta.url,
      ).pathname,
      "react-native-macos": new URL(
        "./test/__mocks__/react-native-macos.js",
        import.meta.url,
      ).pathname,
      "react-native-fs": new URL(
        "./test/__mocks__/react-native-fs.js",
        import.meta.url,
      ).pathname,
      twrnc: new URL("./test/__mocks__/twrnc.js", import.meta.url).pathname,
    },
  },
});
