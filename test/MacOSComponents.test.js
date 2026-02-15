import { describe, it, expect } from "vitest";

// Batch 1 — existing macOS native components
import { buttonImpl } from "../src/Yoga/React/Native/MacOS/Button.js";
import { segmentedImpl } from "../src/Yoga/React/Native/MacOS/Segmented.js";
import { textFieldImpl } from "../src/Yoga/React/Native/MacOS/TextField.js";
import { sliderImpl } from "../src/Yoga/React/Native/MacOS/Slider.js";
import { switchImpl } from "../src/Yoga/React/Native/MacOS/Switch.js";
import { progressImpl } from "../src/Yoga/React/Native/MacOS/Progress.js";
import { datePickerImpl } from "../src/Yoga/React/Native/MacOS/DatePicker.js";
import { colorWellImpl } from "../src/Yoga/React/Native/MacOS/ColorWell.js";
import { popUpImpl } from "../src/Yoga/React/Native/MacOS/PopUp.js";
import { textEditorImpl } from "../src/Yoga/React/Native/MacOS/TextEditor.js";
import { webViewImpl } from "../src/Yoga/React/Native/MacOS/WebView.js";
import { levelIndicatorImpl } from "../src/Yoga/React/Native/MacOS/LevelIndicator.js";
import { nativeScrollViewImpl } from "../src/Yoga/React/Native/MacOS/ScrollView.js";
import { visualEffectImpl } from "../src/Yoga/React/Native/MacOS/VisualEffect.js";
import { contextMenuImpl } from "../src/Yoga/React/Native/MacOS/ContextMenu.js";
import { filePickerImpl } from "../src/Yoga/React/Native/MacOS/FilePicker.js";
import { videoPlayerImpl } from "../src/Yoga/React/Native/MacOS/VideoPlayer.js";
import { animatedImageImpl } from "../src/Yoga/React/Native/MacOS/AnimatedImage.js";
import { patternBackgroundImpl } from "../src/Yoga/React/Native/MacOS/PatternBackground.js";
import { splitViewImpl } from "../src/Yoga/React/Native/MacOS/SplitView.js";
import { tabViewImpl } from "../src/Yoga/React/Native/MacOS/TabView.js";
import { comboBoxImpl } from "../src/Yoga/React/Native/MacOS/ComboBox.js";
import { stepperImpl } from "../src/Yoga/React/Native/MacOS/Stepper.js";
import { boxImpl } from "../src/Yoga/React/Native/MacOS/Box.js";
import { popoverImpl } from "../src/Yoga/React/Native/MacOS/Popover.js";
import { imageImpl } from "../src/Yoga/React/Native/MacOS/Image.js";

// Batch 2 — new macOS native components
import { checkboxImpl } from "../src/Yoga/React/Native/MacOS/Checkbox.js";
import { radioButtonImpl } from "../src/Yoga/React/Native/MacOS/RadioButton.js";
import { searchFieldImpl } from "../src/Yoga/React/Native/MacOS/SearchField.js";
import { tokenFieldImpl } from "../src/Yoga/React/Native/MacOS/TokenField.js";
import { separatorImpl } from "../src/Yoga/React/Native/MacOS/Separator.js";
import { helpButtonImpl } from "../src/Yoga/React/Native/MacOS/HelpButton.js";
import { pathControlImpl } from "../src/Yoga/React/Native/MacOS/PathControl.js";
import { sheetImpl } from "../src/Yoga/React/Native/MacOS/Sheet.js";
import { tableViewImpl } from "../src/Yoga/React/Native/MacOS/TableView.js";

describe("macOS native component FFI exports (batch 1)", () => {
  it("Button resolves to NativeButton", () => {
    expect(buttonImpl).toBe("NativeButton");
  });

  it("Segmented resolves to NativeSegmented", () => {
    expect(segmentedImpl).toBe("NativeSegmented");
  });

  it("TextField resolves to NativeTextField", () => {
    expect(textFieldImpl).toBe("NativeTextField");
  });

  it("Slider resolves to NativeSlider", () => {
    expect(sliderImpl).toBe("NativeSlider");
  });

  it("Switch resolves to NativeSwitch", () => {
    expect(switchImpl).toBe("NativeSwitch");
  });

  it("Progress resolves to NativeProgress", () => {
    expect(progressImpl).toBe("NativeProgress");
  });

  it("DatePicker resolves to NativeDatePicker", () => {
    expect(datePickerImpl).toBe("NativeDatePicker");
  });

  it("ColorWell resolves to NativeColorWell", () => {
    expect(colorWellImpl).toBe("NativeColorWell");
  });

  it("PopUp resolves to NativePopUp", () => {
    expect(popUpImpl).toBe("NativePopUp");
  });

  it("TextEditor resolves to NativeTextEditor", () => {
    expect(textEditorImpl).toBe("NativeTextEditor");
  });

  it("WebView resolves to NativeWebView", () => {
    expect(webViewImpl).toBe("NativeWebView");
  });

  it("LevelIndicator resolves to NativeLevelIndicator", () => {
    expect(levelIndicatorImpl).toBe("NativeLevelIndicator");
  });

  it("ScrollView resolves to MacOSScrollView", () => {
    expect(nativeScrollViewImpl).toBe("MacOSScrollView");
  });

  it("VisualEffect resolves to MacOSVisualEffectView", () => {
    expect(visualEffectImpl).toBe("MacOSVisualEffectView");
  });

  it("ContextMenu resolves to MacOSContextMenu", () => {
    expect(contextMenuImpl).toBe("MacOSContextMenu");
  });

  it("FilePicker resolves to MacOSFilePicker", () => {
    expect(filePickerImpl).toBe("MacOSFilePicker");
  });

  it("VideoPlayer resolves to MacOSVideoPlayer", () => {
    expect(videoPlayerImpl).toBe("MacOSVideoPlayer");
  });

  it("AnimatedImage resolves to MacOSAnimatedImage", () => {
    expect(animatedImageImpl).toBe("MacOSAnimatedImage");
  });

  it("PatternBackground resolves to MacOSPatternBackground", () => {
    expect(patternBackgroundImpl).toBe("MacOSPatternBackground");
  });

  it("SplitView resolves to MacOSSplitView", () => {
    expect(splitViewImpl).toBe("MacOSSplitView");
  });

  it("TabView resolves to MacOSTabView", () => {
    expect(tabViewImpl).toBe("MacOSTabView");
  });

  it("ComboBox resolves to MacOSComboBox", () => {
    expect(comboBoxImpl).toBe("MacOSComboBox");
  });

  it("Stepper resolves to MacOSStepper", () => {
    expect(stepperImpl).toBe("MacOSStepper");
  });

  it("Box resolves to MacOSBox", () => {
    expect(boxImpl).toBe("MacOSBox");
  });

  it("Popover resolves to MacOSPopover", () => {
    expect(popoverImpl).toBe("MacOSPopover");
  });

  it("Image resolves to MacOSImage", () => {
    expect(imageImpl).toBe("MacOSImage");
  });
});

describe("macOS native component FFI exports (batch 2)", () => {
  it("Checkbox resolves to MacOSCheckbox", () => {
    expect(checkboxImpl).toBe("MacOSCheckbox");
  });

  it("RadioButton resolves to MacOSRadioButton", () => {
    expect(radioButtonImpl).toBe("MacOSRadioButton");
  });

  it("SearchField resolves to MacOSSearchField", () => {
    expect(searchFieldImpl).toBe("MacOSSearchField");
  });

  it("TokenField resolves to MacOSTokenField", () => {
    expect(tokenFieldImpl).toBe("MacOSTokenField");
  });

  it("Separator resolves to MacOSSeparator", () => {
    expect(separatorImpl).toBe("MacOSSeparator");
  });

  it("HelpButton resolves to MacOSHelpButton", () => {
    expect(helpButtonImpl).toBe("MacOSHelpButton");
  });

  it("PathControl resolves to MacOSPathControl", () => {
    expect(pathControlImpl).toBe("MacOSPathControl");
  });

  it("Sheet resolves to MacOSSheet", () => {
    expect(sheetImpl).toBe("MacOSSheet");
  });

  it("TableView resolves to MacOSTableView", () => {
    expect(tableViewImpl).toBe("MacOSTableView");
  });
});

// Batch 3
import { outlineViewImpl } from "../src/Yoga/React/Native/MacOS/OutlineView.js";

describe("macOS native component FFI exports (batch 3)", () => {
  it("OutlineView resolves to MacOSOutlineView", () => {
    expect(outlineViewImpl).toBe("MacOSOutlineView");
  });
});

// Batch 4
import { mapViewImpl } from "../src/Yoga/React/Native/MacOS/MapView.js";
import { pdfViewImpl } from "../src/Yoga/React/Native/MacOS/PDFView.js";

describe("macOS native component FFI exports (batch 4)", () => {
  it("MapView resolves to MacOSMapView", () => {
    expect(mapViewImpl).toBe("MacOSMapView");
  });

  it("PDFView resolves to MacOSPDFView", () => {
    expect(pdfViewImpl).toBe("MacOSPDFView");
  });
});
