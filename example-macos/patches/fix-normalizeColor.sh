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

# Fixes Reanimated/Worklets importing Platform from upstream react-native
# which doesn't set Platform.OS on macOS. Redirect to react-native-macos.
REANIMATED_PLATFORM="node_modules/react-native-reanimated/lib/module/common/constants/platform.js"
WORKLETS_PLATFORM="node_modules/react-native-worklets/lib/module/platformChecker.js"

for F in "$REANIMATED_PLATFORM" "$WORKLETS_PLATFORM"; do
  if [ -f "$F" ]; then
    sed -i '' "s|from 'react-native'|from 'react-native-macos'|g" "$F"
    echo "Patched $F: Platform import redirected to react-native-macos"
  fi
done
