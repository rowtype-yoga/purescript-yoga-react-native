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
# ios/android variants but no macOS one. Copy the iOS version which works.
DEVTOOLS_DIR="node_modules/react-native/src/private/devsupport/rndevtools"
DEVTOOLS_MACOS="$DEVTOOLS_DIR/ReactDevToolsSettingsManager.macos.js"
DEVTOOLS_IOS="$DEVTOOLS_DIR/ReactDevToolsSettingsManager.ios.js"

if [ -f "$DEVTOOLS_IOS" ] && [ ! -f "$DEVTOOLS_MACOS" ]; then
  cp "$DEVTOOLS_IOS" "$DEVTOOLS_MACOS"
  echo "Patched $DEVTOOLS_DIR: created macOS ReactDevToolsSettingsManager"
fi
