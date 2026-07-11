# purescript-yoga-react-native

PureScript bindings for React Native on macOS and iOS, including 55+ native AppKit components.

## Quick Start

```bash
# Clone and install
git clone https://github.com/rowtype-yoga/purescript-yoga-react-native.git
cd purescript-yoga-react-native
bun install
cd example-macos && bun install && cd ..

# Install CocoaPods for both Apple targets
cd example-macos/macos && pod install && cd ../..
cd example-macos/ios && pod install && cd ../..

# Build PureScript before starting Metro
cd example-macos && bunx spago build

# Run macOS, or launch the default iOS simulator
bun run macos
bun run ios

# To select an installed simulator explicitly
bun run ios -- --simulator "iPhone 17 Pro"

# List the exact simulator names available on this Mac
xcrun simctl list devices available

```

`output/` is generated and ignored by Git, so the PureScript build is required after every clean checkout. `ios/Pods/`, `ios/build/`, and `.xcode.env.local` are local/generated files; regenerate Pods with `pod install` rather than committing them.

For a physical iPhone, connect and trust the device, select an Apple Development team and a unique bundle identifier in Xcode, then run `bun run ios -- --device "Device Name"`. Distribution additionally requires Apple Developer Program membership, signing/provisioning, an App Store Connect record, an archive, and App Store Connect/TestFlight upload.

## Using in Your Project

Add the package dependency and source locations to `spago.yaml`:
```yaml
package:
  dependencies:
    - yoga-react-native

workspace:
  extraPackages:
    yoga-react-native:
      git: https://github.com/rowtype-yoga/purescript-yoga-react-native.git
      ref: main
    yoga-react:
      git: https://github.com/rowtype-yoga/purescript-yoga-react.git
      ref: main
```

The gesture bindings have one required JavaScript peer dependency. Install the React Native 0.81-compatible release with Bun:

```bash
bun add react-native-gesture-handler@2.28.0
```

Autolink the native dependency on each Apple target after installation:

```bash
cd ios && pod install && cd ..
# For a react-native-macos target as well:
cd macos && pod install && cd ..
```

Wrap the registered application with `GestureHandlerRootView` before rendering gesture-backed components:

```purescript
import Yoga.React.Native.GestureHandler (gestureHandlerRootView)

app :: {} -> JSX
app _ = gestureHandlerRootView application
```

`Yoga.React.Native.GestureHandler` imports `react-native-gesture-handler` directly; applications that use this module must provide the JavaScript package and linked native pod. The wrapper must be above every `panGestureView` in the rendered tree.

```purescript
import Yoga.React.Native (text, tw, view)
import Yoga.React.Native.MacOS.Button (nativeButton)
import Yoga.React.Native.MacOS.Types as T

myButton = nativeButton
  { title: "Click me"
  , bezelStyle: T.push
  , onPress: handler_ doSomething
  , style: Style.style { height: 24.0 }
  }
```

## Components

### Input Controls
`nativeButton` `nativeSwitch` `nativeSlider` `nativePopUp` `nativeComboBox` `nativeStepper` `nativeDatePicker` `nativeColorWell` `nativeCheckbox` `nativeRadioButton` `nativeSearchField` `nativeTokenField` `nativeSegmented`

### Text
`nativeTextField` `nativeTextEditor`

### Display
`nativeImage` `nativeAnimatedImage` `nativeVideoPlayer` `nativeLevelIndicator` `nativeProgress` `nativeSeparator` `nativePathControl`

### Layout
`nativeBox` `nativeSplitView` `nativeTabView` `nativeScrollView` `sidebarLayout` `nativeToolbar` `nativeVisualEffect` `nativePatternBackground`

### Overlays
`macosAlert` `nativeSheet` `nativePopover` `nativeContextMenu` `macosShowMenu`

### Data Views
`nativeTableView` `nativeOutlineView`

### Files & Drag/Drop
`nativeDropZone` `nativeFilePicker`

### Rich Media
`nativeMapView` `nativePDFView` `nativeWebView` `nativeCameraView` `nativeRiveView`

### System Services
`copyToClipboard` `macosShare` `macosNotify` `macosPlaySound` `macosSetStatusBarItem` `macosQuickLook` `macosShowColorPanel` `macosShowFontPanel` `say`

### AI & ML
`recognizeText` (OCR) `useSpeechRecognition` `detectLanguage` `analyzeSentiment` `tokenize`

## Prerequisites

- macOS 14.5+ and Xcode 16.1+ for React Native 0.81
- Xcode Command Line Tools selected in **Xcode → Settings → Locations**
- An iOS Simulator runtime installed in **Xcode → Settings → Platforms**, or an iPhone running iOS 15.1+
- Node.js 20.19.4+ for React Native, CocoaPods, and Xcode build scripts
- Bun for JavaScript dependency installation and project scripts
- PureScript 0.15+; the example pins Spago 1.0.3 in `devDependencies`
- CocoaPods 1.16.2, matching `ios/Podfile.lock`

Watchman is recommended for Metro file-watching performance but is not required. Simulator builds require no Apple account or signing configuration.
