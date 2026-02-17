#!/bin/bash
# Fixes react-native-macos bug: PlatformColorValueTypes.macos.js uses
# require('./normalizeColor') but normalizeColor.js uses export default,
# so require() returns { default: fn } instead of the function.
# The fix: append .default to the require call, matching the pattern
# already used for processColor in the same file.

FILE="node_modules/react-native-macos/Libraries/StyleSheet/PlatformColorValueTypes.macos.js"

if [ -f "$FILE" ]; then
  sed -i '' "s|require('./normalizeColor')|require('./normalizeColor').default|g" "$FILE"
  echo "Patched $FILE: normalizeColor require fix applied"
fi

# Fixes missing ReactDevToolsSettingsManager.macos.js — react-native ships
# ios/android variants but no macOS one. Stub with no-ops (can't use iOS
# version because it imports Settings which depends on Platform.OS).
DEVTOOLS_DIR="node_modules/react-native/src/private/devsupport/rndevtools"
DEVTOOLS_MACOS="$DEVTOOLS_DIR/ReactDevToolsSettingsManager.macos.js"

if [ -d "$DEVTOOLS_DIR" ] && [ ! -f "$DEVTOOLS_MACOS" ]; then
  cat > "$DEVTOOLS_MACOS" << 'STUB'
export function setGlobalHookSettings(settings) {}
export function getGlobalHookSettings() { return null; }
STUB
  echo "Patched $DEVTOOLS_DIR: created macOS ReactDevToolsSettingsManager stub"
fi

# Fixes upstream react-native missing Platform.macos.js — Metro resolves
# Platform.ios.js for iOS but has no macOS variant, leaving Platform.OS
# undefined. Create one from the iOS version with OS set to 'macos'.
PLATFORM_DIR="node_modules/react-native/Libraries/Utilities"
PLATFORM_MACOS="$PLATFORM_DIR/Platform.macos.js"

if [ -d "$PLATFORM_DIR" ] && [ ! -f "$PLATFORM_MACOS" ]; then
  cat > "$PLATFORM_MACOS" << 'PLAT'
const Platform = {
  OS: 'macos',
  select: (spec) => 'macos' in spec ? spec.macos : 'ios' in spec ? spec.ios : 'native' in spec ? spec.native : spec.default,
  get Version() { return ''; },
  get constants() { return { osVersion: '', reactNativeVersion: { major: 0, minor: 81, patch: 5 } }; },
  get isPad() { return false; },
  get isTV() { return false; },
  get isTesting() { return false; },
};
export default Platform;
PLAT
  echo "Patched $PLATFORM_DIR: created Platform.macos.js"
fi
