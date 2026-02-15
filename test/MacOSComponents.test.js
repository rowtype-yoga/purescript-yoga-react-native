import { describe, it, expect } from "vitest";

// Batch 1 — existing macOS native components
import { _buttonImpl } from "../src/Yoga/React/Native/MacOS/Button.js";
import { _segmentedImpl } from "../src/Yoga/React/Native/MacOS/Segmented.js";
import { _textFieldImpl } from "../src/Yoga/React/Native/MacOS/TextField.js";
import { _sliderImpl } from "../src/Yoga/React/Native/MacOS/Slider.js";
import { _switchImpl } from "../src/Yoga/React/Native/MacOS/Switch.js";
import { _progressImpl } from "../src/Yoga/React/Native/MacOS/Progress.js";
import { _datePickerImpl } from "../src/Yoga/React/Native/MacOS/DatePicker.js";
import { _colorWellImpl } from "../src/Yoga/React/Native/MacOS/ColorWell.js";
import { _popUpImpl } from "../src/Yoga/React/Native/MacOS/PopUp.js";
import { _textEditorImpl } from "../src/Yoga/React/Native/MacOS/TextEditor.js";
import { _webViewImpl } from "../src/Yoga/React/Native/MacOS/WebView.js";
import { _levelIndicatorImpl } from "../src/Yoga/React/Native/MacOS/LevelIndicator.js";
import { _nativeScrollViewImpl } from "../src/Yoga/React/Native/MacOS/ScrollView.js";
import { _visualEffectImpl } from "../src/Yoga/React/Native/MacOS/VisualEffect.js";
import { _contextMenuImpl } from "../src/Yoga/React/Native/MacOS/ContextMenu.js";
import { _filePickerImpl } from "../src/Yoga/React/Native/MacOS/FilePicker.js";
import { _videoPlayerImpl } from "../src/Yoga/React/Native/MacOS/VideoPlayer.js";
import { _animatedImageImpl } from "../src/Yoga/React/Native/MacOS/AnimatedImage.js";
import { _patternBackgroundImpl } from "../src/Yoga/React/Native/MacOS/PatternBackground.js";
import { _splitViewImpl } from "../src/Yoga/React/Native/MacOS/SplitView.js";
import { _tabViewImpl } from "../src/Yoga/React/Native/MacOS/TabView.js";
import { _comboBoxImpl } from "../src/Yoga/React/Native/MacOS/ComboBox.js";
import { _stepperImpl } from "../src/Yoga/React/Native/MacOS/Stepper.js";
import { _boxImpl } from "../src/Yoga/React/Native/MacOS/Box.js";
import { _popoverImpl } from "../src/Yoga/React/Native/MacOS/Popover.js";
import { _imageImpl } from "../src/Yoga/React/Native/MacOS/Image.js";

// Batch 2 — new macOS native components
import { _checkboxImpl } from "../src/Yoga/React/Native/MacOS/Checkbox.js";
import { _radioButtonImpl } from "../src/Yoga/React/Native/MacOS/RadioButton.js";
import { _searchFieldImpl } from "../src/Yoga/React/Native/MacOS/SearchField.js";
import { _tokenFieldImpl } from "../src/Yoga/React/Native/MacOS/TokenField.js";
import { _separatorImpl } from "../src/Yoga/React/Native/MacOS/Separator.js";
import { _helpButtonImpl } from "../src/Yoga/React/Native/MacOS/HelpButton.js";
import { _pathControlImpl } from "../src/Yoga/React/Native/MacOS/PathControl.js";
import { _sheetImpl } from "../src/Yoga/React/Native/MacOS/Sheet.js";
import { _tableViewImpl } from "../src/Yoga/React/Native/MacOS/TableView.js";

describe("macOS native component FFI exports (batch 1)", () => {
  it("Button resolves to NativeButton", () => {
    expect(_buttonImpl).toBe("NativeButton");
  });

  it("Segmented resolves to NativeSegmented", () => {
    expect(_segmentedImpl).toBe("NativeSegmented");
  });

  it("TextField resolves to NativeTextField", () => {
    expect(_textFieldImpl).toBe("NativeTextField");
  });

  it("Slider resolves to NativeSlider", () => {
    expect(_sliderImpl).toBe("NativeSlider");
  });

  it("Switch resolves to NativeSwitch", () => {
    expect(_switchImpl).toBe("NativeSwitch");
  });

  it("Progress resolves to NativeProgress", () => {
    expect(_progressImpl).toBe("NativeProgress");
  });

  it("DatePicker resolves to NativeDatePicker", () => {
    expect(_datePickerImpl).toBe("NativeDatePicker");
  });

  it("ColorWell resolves to NativeColorWell", () => {
    expect(_colorWellImpl).toBe("NativeColorWell");
  });

  it("PopUp resolves to NativePopUp", () => {
    expect(_popUpImpl).toBe("NativePopUp");
  });

  it("TextEditor resolves to NativeTextEditor", () => {
    expect(_textEditorImpl).toBe("NativeTextEditor");
  });

  it("WebView resolves to NativeWebView", () => {
    expect(_webViewImpl).toBe("NativeWebView");
  });

  it("LevelIndicator resolves to NativeLevelIndicator", () => {
    expect(_levelIndicatorImpl).toBe("NativeLevelIndicator");
  });

  it("ScrollView resolves to MacOSScrollView", () => {
    expect(_nativeScrollViewImpl).toBe("MacOSScrollView");
  });

  it("VisualEffect resolves to MacOSVisualEffectView", () => {
    expect(_visualEffectImpl).toBe("MacOSVisualEffectView");
  });

  it("ContextMenu resolves to MacOSContextMenu", () => {
    expect(_contextMenuImpl).toBe("MacOSContextMenu");
  });

  it("FilePicker resolves to MacOSFilePicker", () => {
    expect(_filePickerImpl).toBe("MacOSFilePicker");
  });

  it("VideoPlayer resolves to MacOSVideoPlayer", () => {
    expect(_videoPlayerImpl).toBe("MacOSVideoPlayer");
  });

  it("AnimatedImage resolves to MacOSAnimatedImage", () => {
    expect(_animatedImageImpl).toBe("MacOSAnimatedImage");
  });

  it("PatternBackground resolves to MacOSPatternBackground", () => {
    expect(_patternBackgroundImpl).toBe("MacOSPatternBackground");
  });

  it("SplitView resolves to MacOSSplitView", () => {
    expect(_splitViewImpl).toBe("MacOSSplitView");
  });

  it("TabView resolves to MacOSTabView", () => {
    expect(_tabViewImpl).toBe("MacOSTabView");
  });

  it("ComboBox resolves to MacOSComboBox", () => {
    expect(_comboBoxImpl).toBe("MacOSComboBox");
  });

  it("Stepper resolves to MacOSStepper", () => {
    expect(_stepperImpl).toBe("MacOSStepper");
  });

  it("Box resolves to MacOSBox", () => {
    expect(_boxImpl).toBe("MacOSBox");
  });

  it("Popover resolves to MacOSPopover", () => {
    expect(_popoverImpl).toBe("MacOSPopover");
  });

  it("Image resolves to MacOSImage", () => {
    expect(_imageImpl).toBe("MacOSImage");
  });
});

describe("macOS native component FFI exports (batch 2)", () => {
  it("Checkbox resolves to MacOSCheckbox", () => {
    expect(_checkboxImpl).toBe("MacOSCheckbox");
  });

  it("RadioButton resolves to MacOSRadioButton", () => {
    expect(_radioButtonImpl).toBe("MacOSRadioButton");
  });

  it("SearchField resolves to MacOSSearchField", () => {
    expect(_searchFieldImpl).toBe("MacOSSearchField");
  });

  it("TokenField resolves to MacOSTokenField", () => {
    expect(_tokenFieldImpl).toBe("MacOSTokenField");
  });

  it("Separator resolves to MacOSSeparator", () => {
    expect(_separatorImpl).toBe("MacOSSeparator");
  });

  it("HelpButton resolves to MacOSHelpButton", () => {
    expect(_helpButtonImpl).toBe("MacOSHelpButton");
  });

  it("PathControl resolves to MacOSPathControl", () => {
    expect(_pathControlImpl).toBe("MacOSPathControl");
  });

  it("Sheet resolves to MacOSSheet", () => {
    expect(_sheetImpl).toBe("MacOSSheet");
  });

  it("TableView resolves to MacOSTableView", () => {
    expect(_tableViewImpl).toBe("MacOSTableView");
  });
});
