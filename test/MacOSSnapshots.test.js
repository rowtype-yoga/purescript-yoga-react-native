import { describe, it, expect } from "vitest";
import React from "react";

// Serialize a React element tree to a plain object for snapshot comparison.
// Our mocks return string tags (e.g. "MacOSCheckbox") which react-test-renderer
// can't render, so we walk the element tree directly.
function toTree(element) {
  if (element == null) return null;
  if (typeof element === "string") return element;
  if (typeof element === "number") return String(element);
  if (Array.isArray(element)) return element.map(toTree);
  const { type, props } = element;
  const { children, ...rest } = props || {};
  const name =
    typeof type === "string"
      ? type
      : type?.displayName || type?.name || "Unknown";
  const node = { type: name };
  // Strip functions from props (event handlers) for stable snapshots
  const cleanProps = {};
  let hasProps = false;
  for (const [k, v] of Object.entries(rest)) {
    if (typeof v !== "function") {
      cleanProps[k] = v;
      hasProps = true;
    }
  }
  if (hasProps) node.props = cleanProps;
  if (children != null) {
    const kids = Array.isArray(children)
      ? children.map(toTree)
      : [toTree(children)];
    const filtered = kids.filter((k) => k != null);
    if (filtered.length > 0) node.children = filtered;
  }
  return node;
}

const render = (element) => ({
  toJSON: () => toTree(element),
});

import {
  createNativeElementNoKidsImpl as el,
  createNativeElementImpl as elK,
} from "../src/Yoga/React/Native/Internal.js";

// Leaf components (no children)
import { buttonImpl } from "../src/Yoga/React/Native/MacOS/Button.js";
import { checkboxImpl } from "../src/Yoga/React/Native/MacOS/Checkbox.js";
import { radioButtonImpl } from "../src/Yoga/React/Native/MacOS/RadioButton.js";
import { searchFieldImpl } from "../src/Yoga/React/Native/MacOS/SearchField.js";
import { tokenFieldImpl } from "../src/Yoga/React/Native/MacOS/TokenField.js";
import { separatorImpl } from "../src/Yoga/React/Native/MacOS/Separator.js";
import { helpButtonImpl } from "../src/Yoga/React/Native/MacOS/HelpButton.js";
import { pathControlImpl } from "../src/Yoga/React/Native/MacOS/PathControl.js";
import { textFieldImpl } from "../src/Yoga/React/Native/MacOS/TextField.js";
import { sliderImpl } from "../src/Yoga/React/Native/MacOS/Slider.js";
import { switchImpl } from "../src/Yoga/React/Native/MacOS/Switch.js";
import { progressImpl } from "../src/Yoga/React/Native/MacOS/Progress.js";
import { datePickerImpl } from "../src/Yoga/React/Native/MacOS/DatePicker.js";
import { colorWellImpl } from "../src/Yoga/React/Native/MacOS/ColorWell.js";
import { popUpImpl } from "../src/Yoga/React/Native/MacOS/PopUp.js";
import { textEditorImpl } from "../src/Yoga/React/Native/MacOS/TextEditor.js";
import { levelIndicatorImpl } from "../src/Yoga/React/Native/MacOS/LevelIndicator.js";
import { segmentedImpl } from "../src/Yoga/React/Native/MacOS/Segmented.js";
import { stepperImpl } from "../src/Yoga/React/Native/MacOS/Stepper.js";
import { comboBoxImpl } from "../src/Yoga/React/Native/MacOS/ComboBox.js";
import { imageImpl } from "../src/Yoga/React/Native/MacOS/Image.js";
import { animatedImageImpl } from "../src/Yoga/React/Native/MacOS/AnimatedImage.js";
import { videoPlayerImpl } from "../src/Yoga/React/Native/MacOS/VideoPlayer.js";
import { tableViewImpl } from "../src/Yoga/React/Native/MacOS/TableView.js";
import { outlineViewImpl } from "../src/Yoga/React/Native/MacOS/OutlineView.js";
import { mapViewImpl } from "../src/Yoga/React/Native/MacOS/MapView.js";
import { pdfViewImpl } from "../src/Yoga/React/Native/MacOS/PDFView.js";
import { cameraViewImpl } from "../src/Yoga/React/Native/MacOS/CameraView.js";

// Container components (with children)
import { sheetImpl } from "../src/Yoga/React/Native/MacOS/Sheet.js";
import { boxImpl } from "../src/Yoga/React/Native/MacOS/Box.js";
import { popoverImpl } from "../src/Yoga/React/Native/MacOS/Popover.js";
import { nativeScrollViewImpl } from "../src/Yoga/React/Native/MacOS/ScrollView.js";
import { visualEffectImpl } from "../src/Yoga/React/Native/MacOS/VisualEffect.js";
import { contextMenuImpl } from "../src/Yoga/React/Native/MacOS/ContextMenu.js";
import { splitViewImpl } from "../src/Yoga/React/Native/MacOS/SplitView.js";
import { tabViewImpl } from "../src/Yoga/React/Native/MacOS/TabView.js";
import { patternBackgroundImpl } from "../src/Yoga/React/Native/MacOS/PatternBackground.js";

const noop = () => {};

describe("macOS component snapshots", () => {
  // -- Controls --

  it("Button", () => {
    const { toJSON } = render(
      el(buttonImpl, {
        title: "Click Me",
        bezelStyle: "rounded",
        onPress: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Checkbox checked", () => {
    const { toJSON } = render(
      el(checkboxImpl, {
        checked: true,
        title: "Accept terms",
        enabled: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Checkbox unchecked", () => {
    const { toJSON } = render(
      el(checkboxImpl, {
        checked: false,
        title: "Accept terms",
        enabled: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("RadioButton selected", () => {
    const { toJSON } = render(
      el(radioButtonImpl, {
        selected: true,
        title: "Option A",
        enabled: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("RadioButton unselected", () => {
    const { toJSON } = render(
      el(radioButtonImpl, {
        selected: false,
        title: "Option B",
        enabled: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Switch on", () => {
    const { toJSON } = render(el(switchImpl, { value: true, onChange: noop }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("Slider", () => {
    const { toJSON } = render(
      el(sliderImpl, {
        value: 50,
        minimumValue: 0,
        maximumValue: 100,
        onValueChange: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Stepper", () => {
    const { toJSON } = render(
      el(stepperImpl, {
        value: 5,
        minValue: 0,
        maxValue: 10,
        onValueChange: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Segmented", () => {
    const { toJSON } = render(
      el(segmentedImpl, {
        values: ["A", "B", "C"],
        selectedIndex: 1,
        onChange: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("HelpButton", () => {
    const { toJSON } = render(el(helpButtonImpl, { onPress: noop }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("PopUp", () => {
    const { toJSON } = render(
      el(popUpImpl, {
        items: ["One", "Two"],
        selectedIndex: 0,
        onChange: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("ComboBox", () => {
    const { toJSON } = render(
      el(comboBoxImpl, {
        items: ["foo", "bar"],
        text: "foo",
        onChangeText: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Text input --

  it("TextField", () => {
    const { toJSON } = render(
      el(textFieldImpl, {
        text: "Hello",
        placeholder: "Type here",
        onChangeText: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("SearchField", () => {
    const { toJSON } = render(
      el(searchFieldImpl, {
        text: "",
        placeholder: "Search...",
        onChangeText: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("TokenField", () => {
    const { toJSON } = render(
      el(tokenFieldImpl, {
        tokens: ["swift", "purescript"],
        placeholder: "Add tag",
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("TextEditor", () => {
    const { toJSON } = render(
      el(textEditorImpl, { text: "Some long text", onChangeText: noop }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Indicators --

  it("Progress determinate", () => {
    const { toJSON } = render(el(progressImpl, { value: 0.6, style: "bar" }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("LevelIndicator", () => {
    const { toJSON } = render(
      el(levelIndicatorImpl, { value: 3, minValue: 0, maxValue: 5 }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Pickers --

  it("DatePicker", () => {
    const { toJSON } = render(
      el(datePickerImpl, { date: "2025-01-15", onChange: noop }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("ColorWell", () => {
    const { toJSON } = render(
      el(colorWellImpl, { color: "#ff0000", onChange: noop }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("PathControl", () => {
    const { toJSON } = render(
      el(pathControlImpl, {
        url: "/Users/test/file.txt",
        pathStyle: "standard",
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Media --

  it("Image", () => {
    const { toJSON } = render(
      el(imageImpl, { source: "test.png", resizeMode: "cover" }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("AnimatedImage", () => {
    const { toJSON } = render(el(animatedImageImpl, { source: "anim.gif" }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("VideoPlayer", () => {
    const { toJSON } = render(
      el(videoPlayerImpl, { source: "video.mp4", autoPlay: false }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Layout --

  it("Separator horizontal", () => {
    const { toJSON } = render(el(separatorImpl, { vertical: false }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("Separator vertical", () => {
    const { toJSON } = render(el(separatorImpl, { vertical: true }));
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Data --

  it("TableView", () => {
    const { toJSON } = render(
      el(tableViewImpl, {
        columns: [
          { title: "Name", width: 100 },
          { title: "Age", width: 50 },
        ],
        rows: [
          ["Alice", "30"],
          ["Bob", "25"],
        ],
        headerVisible: true,
        alternatingRows: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("OutlineView", () => {
    const { toJSON } = render(
      el(outlineViewImpl, {
        items: [
          {
            id: "1",
            title: "Root",
            children: [
              { id: "1.1", title: "Child A", sfSymbol: "doc" },
              { id: "1.2", title: "Child B" },
            ],
          },
        ],
        headerVisible: false,
        onSelectItem: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("MapView", () => {
    const { toJSON } = render(
      el(mapViewImpl, {
        latitude: 37.7749,
        longitude: -122.4194,
        latitudeDelta: 0.05,
        longitudeDelta: 0.05,
        mapType: "standard",
        showsUserLocation: false,
        annotations: [{ latitude: 37.7749, longitude: -122.4194, title: "SF" }],
        onRegionChange: noop,
        onSelectAnnotation: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("PDFView", () => {
    const { toJSON } = render(
      el(pdfViewImpl, {
        source: "/tmp/test.pdf",
        autoScales: true,
        displayMode: "singlePageContinuous",
        onPageChange: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Containers --

  it("Sheet with child", () => {
    const { toJSON } = render(
      elK(sheetImpl, { visible: true, onDismiss: noop }, [
        el("View", { key: "1" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Box with child", () => {
    const { toJSON } = render(
      elK(boxImpl, { title: "Group" }, [el("View", { key: "1" })]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Popover with child", () => {
    const { toJSON } = render(
      elK(popoverImpl, { visible: true }, [el("View", { key: "1" })]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("ScrollView with child", () => {
    const { toJSON } = render(
      elK(nativeScrollViewImpl, {}, [el("View", { key: "1" })]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("VisualEffect with child", () => {
    const { toJSON } = render(
      elK(visualEffectImpl, { material: "sidebar" }, [
        el("View", { key: "1" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("ContextMenu with child", () => {
    const { toJSON } = render(
      elK(contextMenuImpl, { menuItems: [{ title: "Copy" }] }, [
        el("View", { key: "1" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("SplitView with children", () => {
    const { toJSON } = render(
      elK(splitViewImpl, { vertical: false }, [
        el("View", { key: "1" }),
        el("View", { key: "2" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("TabView with children", () => {
    const { toJSON } = render(
      elK(tabViewImpl, { selectedIndex: 0 }, [el("View", { key: "1" })]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("PatternBackground with child", () => {
    const { toJSON } = render(
      elK(patternBackgroundImpl, { pattern: "dots" }, [
        el("View", { key: "1" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("CameraView", () => {
    const { toJSON } = render(el(cameraViewImpl, { active: true }));
    expect(toJSON()).toMatchSnapshot();
  });
});
