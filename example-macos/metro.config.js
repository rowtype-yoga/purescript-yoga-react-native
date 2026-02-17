const path = require("path");
const { getDefaultConfig, mergeConfig } = require("@react-native/metro-config");

/**
 * Metro configuration
 * https://reactnative.dev/docs/metro
 *
 * @type {import('@react-native/metro-config').MetroConfig}
 */
const modules = path.resolve(__dirname, "node_modules");
const config = {
  watchFolders: [path.resolve(__dirname, "..", "output")],
  resolver: {
    unstable_enableSymlinks: true,
    nodeModulesPaths: [modules],
    extraNodeModules: {
      "react-native": path.resolve(modules, "react-native-macos"),
    },
    resolveRequest: (context, moduleName, platform) => {
      if (context.originModulePath.includes("/output/")) {
        return context.resolveRequest(
          {
            ...context,
            nodeModulesPaths: [modules, ...context.nodeModulesPaths],
          },
          moduleName,
          platform
        );
      }
      return context.resolveRequest(context, moduleName, platform);
    },
  },
};

module.exports = mergeConfig(getDefaultConfig(__dirname), config);
