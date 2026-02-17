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

# Fixes New Architecture (Fabric) and general macOS support: many files in
# react-native are backwards-compat shims that import themselves, expecting
# Metro to resolve a platform-specific variant (.ios.js, .macos.js, etc).
# react-native-macos ships .macos.js variants but they only exist in the
# react-native-macos package. Since Metro resolves from react-native (not
# react-native-macos), we must copy them over.
MACOS_FILES="
  Libraries/NativeComponent/BaseViewConfig.macos.js
  Libraries/Image/Image.macos.js
  Libraries/Alert/RCTAlertManager.macos.js
  Libraries/Components/AccessibilityInfo/legacySendAccessibilityEvent.macos.js
  Libraries/DevToolsSettings/DevToolsSettingsManager.macos.js
  Libraries/Network/RCTNetworking.macos.js
  Libraries/Settings/Settings.macos.js
  Libraries/StyleSheet/PlatformColorValueTypes.macos.js
  Libraries/StyleSheet/PlatformColorValueTypesMacOS.macos.js
  Libraries/Utilities/BackHandler.macos.js
"

for f in $MACOS_FILES; do
  SRC="node_modules/react-native-macos/$f"
  DST="node_modules/react-native/$f"
  if [ -f "$SRC" ] && [ ! -f "$DST" ]; then
    mkdir -p "$(dirname "$DST")"
    cp "$SRC" "$DST"
    echo "Patched $DST: copied .macos.js variant from react-native-macos"
  fi
done
