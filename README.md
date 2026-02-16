# purescript-yoga-react-native

PureScript bindings for React Native macOS with 55+ native AppKit components.

## Quick Start

```bash
# Clone and install
git clone https://github.com/rowtype-yoga/purescript-yoga-react-native.git
cd purescript-yoga-react-native
bun install
cd example-macos && bun install && cd ..

# Install CocoaPods
cd example-macos/macos && bundle exec pod install && cd ../..

# Build PureScript
cd example-macos && bunx spago build && cd ..

# Run the example app
cd example-macos && npx react-native run-macos
```

## Using in Your Project

Add to `spago.yaml`:

```yaml
extraPackages:
  yoga-react-native:
    git: https://github.com/rowtype-yoga/purescript-yoga-react-native.git
    ref: main
  yoga-react:
    git: https://github.com/rowtype-yoga/purescript-yoga-react.git
    ref: main
```

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

- macOS 14+
- Xcode 16+
- Node.js 20+ / Bun
- PureScript 0.15+ and Spago
- CocoaPods
