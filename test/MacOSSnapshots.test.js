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
import { _buttonImpl } from "../src/Yoga/React/Native/MacOS/Button.js";
import { _checkboxImpl } from "../src/Yoga/React/Native/MacOS/Checkbox.js";
import { _radioButtonImpl } from "../src/Yoga/React/Native/MacOS/RadioButton.js";
import { _searchFieldImpl } from "../src/Yoga/React/Native/MacOS/SearchField.js";
import { _tokenFieldImpl } from "../src/Yoga/React/Native/MacOS/TokenField.js";
import { _separatorImpl } from "../src/Yoga/React/Native/MacOS/Separator.js";
import { _helpButtonImpl } from "../src/Yoga/React/Native/MacOS/HelpButton.js";
import { _pathControlImpl } from "../src/Yoga/React/Native/MacOS/PathControl.js";
import { _textFieldImpl } from "../src/Yoga/React/Native/MacOS/TextField.js";
import { _sliderImpl } from "../src/Yoga/React/Native/MacOS/Slider.js";
import { _switchImpl } from "../src/Yoga/React/Native/MacOS/Switch.js";
import { _progressImpl } from "../src/Yoga/React/Native/MacOS/Progress.js";
import { _datePickerImpl } from "../src/Yoga/React/Native/MacOS/DatePicker.js";
import { _colorWellImpl } from "../src/Yoga/React/Native/MacOS/ColorWell.js";
import { _popUpImpl } from "../src/Yoga/React/Native/MacOS/PopUp.js";
import { _textEditorImpl } from "../src/Yoga/React/Native/MacOS/TextEditor.js";
import { _levelIndicatorImpl } from "../src/Yoga/React/Native/MacOS/LevelIndicator.js";
import { _segmentedImpl } from "../src/Yoga/React/Native/MacOS/Segmented.js";
import { _stepperImpl } from "../src/Yoga/React/Native/MacOS/Stepper.js";
import { _comboBoxImpl } from "../src/Yoga/React/Native/MacOS/ComboBox.js";
import { _imageImpl } from "../src/Yoga/React/Native/MacOS/Image.js";
import { _animatedImageImpl } from "../src/Yoga/React/Native/MacOS/AnimatedImage.js";
import { _videoPlayerImpl } from "../src/Yoga/React/Native/MacOS/VideoPlayer.js";
import { _tableViewImpl } from "../src/Yoga/React/Native/MacOS/TableView.js";

// Container components (with children)
import { _sheetImpl } from "../src/Yoga/React/Native/MacOS/Sheet.js";
import { _boxImpl } from "../src/Yoga/React/Native/MacOS/Box.js";
import { _popoverImpl } from "../src/Yoga/React/Native/MacOS/Popover.js";
import { _nativeScrollViewImpl } from "../src/Yoga/React/Native/MacOS/ScrollView.js";
import { _visualEffectImpl } from "../src/Yoga/React/Native/MacOS/VisualEffect.js";
import { _contextMenuImpl } from "../src/Yoga/React/Native/MacOS/ContextMenu.js";
import { _splitViewImpl } from "../src/Yoga/React/Native/MacOS/SplitView.js";
import { _tabViewImpl } from "../src/Yoga/React/Native/MacOS/TabView.js";
import { _patternBackgroundImpl } from "../src/Yoga/React/Native/MacOS/PatternBackground.js";

const noop = () => {};

describe("macOS component snapshots", () => {
  // -- Controls --

  it("Button", () => {
    const { toJSON } = render(
      el(_buttonImpl, {
        title: "Click Me",
        bezelStyle: "rounded",
        onPress: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Checkbox checked", () => {
    const { toJSON } = render(
      el(_checkboxImpl, {
        checked: true,
        title: "Accept terms",
        enabled: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Checkbox unchecked", () => {
    const { toJSON } = render(
      el(_checkboxImpl, {
        checked: false,
        title: "Accept terms",
        enabled: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("RadioButton selected", () => {
    const { toJSON } = render(
      el(_radioButtonImpl, {
        selected: true,
        title: "Option A",
        enabled: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("RadioButton unselected", () => {
    const { toJSON } = render(
      el(_radioButtonImpl, {
        selected: false,
        title: "Option B",
        enabled: true,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Switch on", () => {
    const { toJSON } = render(el(_switchImpl, { value: true, onChange: noop }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("Slider", () => {
    const { toJSON } = render(
      el(_sliderImpl, {
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
      el(_stepperImpl, {
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
      el(_segmentedImpl, {
        values: ["A", "B", "C"],
        selectedIndex: 1,
        onChange: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("HelpButton", () => {
    const { toJSON } = render(el(_helpButtonImpl, { onPress: noop }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("PopUp", () => {
    const { toJSON } = render(
      el(_popUpImpl, {
        items: ["One", "Two"],
        selectedIndex: 0,
        onChange: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("ComboBox", () => {
    const { toJSON } = render(
      el(_comboBoxImpl, {
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
      el(_textFieldImpl, {
        text: "Hello",
        placeholder: "Type here",
        onChangeText: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("SearchField", () => {
    const { toJSON } = render(
      el(_searchFieldImpl, {
        text: "",
        placeholder: "Search...",
        onChangeText: noop,
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("TokenField", () => {
    const { toJSON } = render(
      el(_tokenFieldImpl, {
        tokens: ["swift", "purescript"],
        placeholder: "Add tag",
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("TextEditor", () => {
    const { toJSON } = render(
      el(_textEditorImpl, { text: "Some long text", onChangeText: noop }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Indicators --

  it("Progress determinate", () => {
    const { toJSON } = render(el(_progressImpl, { value: 0.6, style: "bar" }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("LevelIndicator", () => {
    const { toJSON } = render(
      el(_levelIndicatorImpl, { value: 3, minValue: 0, maxValue: 5 }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Pickers --

  it("DatePicker", () => {
    const { toJSON } = render(
      el(_datePickerImpl, { date: "2025-01-15", onChange: noop }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("ColorWell", () => {
    const { toJSON } = render(
      el(_colorWellImpl, { color: "#ff0000", onChange: noop }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("PathControl", () => {
    const { toJSON } = render(
      el(_pathControlImpl, {
        url: "/Users/test/file.txt",
        pathStyle: "standard",
      }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Media --

  it("Image", () => {
    const { toJSON } = render(
      el(_imageImpl, { source: "test.png", resizeMode: "cover" }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("AnimatedImage", () => {
    const { toJSON } = render(el(_animatedImageImpl, { source: "anim.gif" }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("VideoPlayer", () => {
    const { toJSON } = render(
      el(_videoPlayerImpl, { source: "video.mp4", autoPlay: false }),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Layout --

  it("Separator horizontal", () => {
    const { toJSON } = render(el(_separatorImpl, { vertical: false }));
    expect(toJSON()).toMatchSnapshot();
  });

  it("Separator vertical", () => {
    const { toJSON } = render(el(_separatorImpl, { vertical: true }));
    expect(toJSON()).toMatchSnapshot();
  });

  // -- Data --

  it("TableView", () => {
    const { toJSON } = render(
      el(_tableViewImpl, {
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

  // -- Containers --

  it("Sheet with child", () => {
    const { toJSON } = render(
      elK(_sheetImpl, { visible: true, onDismiss: noop }, [
        el("View", { key: "1" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Box with child", () => {
    const { toJSON } = render(
      elK(_boxImpl, { title: "Group" }, [el("View", { key: "1" })]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("Popover with child", () => {
    const { toJSON } = render(
      elK(_popoverImpl, { visible: true }, [el("View", { key: "1" })]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("ScrollView with child", () => {
    const { toJSON } = render(
      elK(_nativeScrollViewImpl, {}, [el("View", { key: "1" })]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("VisualEffect with child", () => {
    const { toJSON } = render(
      elK(_visualEffectImpl, { material: "sidebar" }, [
        el("View", { key: "1" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("ContextMenu with child", () => {
    const { toJSON } = render(
      elK(_contextMenuImpl, { menuItems: [{ title: "Copy" }] }, [
        el("View", { key: "1" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("SplitView with children", () => {
    const { toJSON } = render(
      elK(_splitViewImpl, { vertical: false }, [
        el("View", { key: "1" }),
        el("View", { key: "2" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("TabView with children", () => {
    const { toJSON } = render(
      elK(_tabViewImpl, { selectedIndex: 0 }, [el("View", { key: "1" })]),
    );
    expect(toJSON()).toMatchSnapshot();
  });

  it("PatternBackground with child", () => {
    const { toJSON } = render(
      elK(_patternBackgroundImpl, { pattern: "dots" }, [
        el("View", { key: "1" }),
      ]),
    );
    expect(toJSON()).toMatchSnapshot();
  });
});
