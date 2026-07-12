import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import React from "react";
import { act, create } from "react-test-renderer";
import { collectionViewImpl } from "../src/Yoga/React/Native/IOS/CollectionView.js";
import {
  date,
  datePickerImpl,
  dateTime,
  time,
} from "../src/Yoga/React/Native/IOS/DatePicker.js";
import { segmentedControlImpl } from "../src/Yoga/React/Native/IOS/SegmentedControl.js";
import { searchBarImpl } from "../src/Yoga/React/Native/IOS/SearchBar.js";

const renderNative = (component, nativeName, props) => {
  let renderer;
  act(() => {
    renderer = create(React.createElement(component, props));
  });
  return {
    native: renderer.root.findByType(nativeName),
    unmount: () => act(() => renderer.unmount()),
  };
};

describe("iOS UIKit component FFI", () => {
  const hadActEnvironment = Object.hasOwn(
    globalThis,
    "IS_REACT_ACT_ENVIRONMENT",
  );
  const previousActEnvironment = globalThis.IS_REACT_ACT_ENVIRONMENT;

  beforeAll(() => {
    globalThis.IS_REACT_ACT_ENVIRONMENT = true;
  });

  afterAll(() => {
    if (hadActEnvironment) {
      globalThis.IS_REACT_ACT_ENVIRONMENT = previousActEnvironment;
    } else {
      delete globalThis.IS_REACT_ACT_ENVIRONMENT;
    }
  });

  it("keeps CollectionView controlled props and executes selection and refresh thunks", () => {
    const items = [
      { id: "pressable", title: "Pressable" },
      { id: "collection", title: "UICollectionView" },
    ];
    const selected = vi.fn();
    const refreshed = vi.fn();
    const { native, unmount } = renderNative(
      collectionViewImpl,
      "IOSCollectionView",
      {
        items,
        selectedId: "collection",
        refreshing: true,
        onSelectItem: (selection) => () => selected(selection),
        onRefresh: () => refreshed(),
        accessibilityLabel: "UIKit collection",
      },
    );

    expect(native.props).toMatchObject({
      items,
      selectedId: "collection",
      refreshing: true,
      accessibilityLabel: "UIKit collection",
    });

    act(() => {
      native.props.onSelectItem({
        nativeEvent: { id: "pressable", index: 4.9 },
      });
      native.props.onRefresh();
    });

    expect(selected).toHaveBeenCalledOnce();
    expect(selected).toHaveBeenCalledWith({ id: "pressable", index: 4 });
    expect(refreshed).toHaveBeenCalledOnce();
    unmount();
  });

  it("maps DatePicker onChange exclusively to native onDateChange and executes its thunk", () => {
    const changed = vi.fn();
    const { native, unmount } = renderNative(datePickerImpl, "IOSDatePicker", {
      value: "2026-07-12T09:30:00.000Z",
      mode: dateTime,
      min: "2026-01-01T00:00:00.000Z",
      max: "2026-12-31T23:59:59.999Z",
      enabled: false,
      onChange: (value) => () => changed(value),
      accessibilityLabel: "UIKit date picker",
    });

    expect({ date, time, dateTime }).toEqual({
      date: "date",
      time: "time",
      dateTime: "datetime",
    });
    expect(native.props).toMatchObject({
      value: "2026-07-12T09:30:00.000Z",
      mode: "datetime",
      min: "2026-01-01T00:00:00.000Z",
      max: "2026-12-31T23:59:59.999Z",
      enabled: false,
      accessibilityLabel: "UIKit date picker",
    });
    expect(native.props).not.toHaveProperty("onChange");
    expect(native.props.onDateChange).toEqual(expect.any(Function));

    act(() => {
      native.props.onDateChange({
        nativeEvent: { value: "2026-08-01T15:45:00.000Z" },
      });
    });

    expect(changed).toHaveBeenCalledOnce();
    expect(changed).toHaveBeenCalledWith("2026-08-01T15:45:00.000Z");
    unmount();
  });

  it("keeps SegmentedControl controlled props and executes the selection thunk", () => {
    const items = [
      { id: "overview", title: "Overview" },
      { id: "details", title: "Details" },
    ];
    const selected = vi.fn();
    const { native, unmount } = renderNative(
      segmentedControlImpl,
      "IOSSegmentedControl",
      {
        items,
        selectedId: "details",
        enabled: false,
        onSelect: (selection) => () => selected(selection),
        accessibilityLabel: "UIKit segmented control",
      },
    );

    expect(native.props).toMatchObject({
      items,
      selectedId: "details",
      enabled: false,
      accessibilityLabel: "UIKit segmented control",
    });

    act(() => {
      native.props.onSelect({ nativeEvent: { id: "overview", index: 1.8 } });
    });

    expect(selected).toHaveBeenCalledOnce();
    expect(selected).toHaveBeenCalledWith({ id: "overview", index: 1 });
    unmount();
  });

  it("keeps SearchBar controlled props and executes edit, submit, and cancel thunks", () => {
    const changed = vi.fn();
    const submitted = vi.fn();
    const cancelled = vi.fn();
    const { native, unmount } = renderNative(searchBarImpl, "IOSSearchBar", {
      text: "native",
      placeholder: "Search UIKit",
      showsCancelButton: true,
      enabled: false,
      onChangeText: (value) => () => changed(value),
      onSubmit: (value) => () => submitted(value),
      onCancel: () => cancelled(),
      accessibilityLabel: "UIKit search bar",
    });

    expect(native.props).toMatchObject({
      text: "native",
      placeholder: "Search UIKit",
      showsCancelButton: true,
      enabled: false,
      accessibilityLabel: "UIKit search bar",
    });

    act(() => {
      native.props.onChangeText({ nativeEvent: { text: "native controls" } });
      native.props.onSubmit({ nativeEvent: { text: "native controls" } });
      native.props.onCancel();
    });

    expect(changed).toHaveBeenCalledOnce();
    expect(changed).toHaveBeenCalledWith("native controls");
    expect(submitted).toHaveBeenCalledOnce();
    expect(submitted).toHaveBeenCalledWith("native controls");
    expect(cancelled).toHaveBeenCalledOnce();
    unmount();
  });
});
