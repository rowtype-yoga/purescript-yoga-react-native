const path = require("path");
const { getDefaultConfig, mergeConfig } = require("@react-native/metro-config");
const root = path.resolve(__dirname, "..");
const modules = path.resolve(__dirname, "node_modules");
const config = {
  projectRoot: root,
  watchFolders: [__dirname],
  resolver: {
    unstable_enableSymlinks: true,
    nodeModulesPaths: [modules],
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
