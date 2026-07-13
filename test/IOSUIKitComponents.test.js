import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import React from "react";
import { act, create } from "react-test-renderer";
import { collectionViewImpl } from "../src/Yoga/React/Native/IOS/CollectionView.js";
import { datePickerImpl } from "../src/Yoga/React/Native/IOS/DatePicker.js";
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

  describe("DatePicker", () => {
    it("encodes controlled instants and delivers one decoded Instant per valid native event", () => {
      const changed = vi.fn();
      const value = Date.parse("2026-07-12T09:30:00.000Z");
      const minimum = Date.parse("2026-01-01T00:00:00.000Z");
      const maximum = Date.parse("2026-12-31T23:59:59.999Z");
      const { native, unmount } = renderNative(datePickerImpl, "IOSDatePicker", {
        value,
        mode: "datetime",
        onChange: changed,
        options: {
          minimum,
          maximum,
          enabled: false,
          accessibilityLabel: "UIKit date picker",
        },
      });

      expect(native.props).toMatchObject({
        value: "2026-07-12T09:30:00.000Z",
        mode: "datetime",
        min: "2026-01-01T00:00:00.000Z",
        max: "2026-12-31T23:59:59.999Z",
        enabled: false,
        accessibilityLabel: "UIKit date picker",
      });
      expect(native.props).not.toHaveProperty("minimum");
      expect(native.props).not.toHaveProperty("maximum");
      expect(native.props).not.toHaveProperty("onChange");

      act(() => {
        native.props.onDateChange({
          nativeEvent: { value: "2026-08-01T15:45:00.000Z" },
        });
      });

      expect(changed).toHaveBeenCalledOnce();
      expect(changed).toHaveBeenCalledWith(
        Date.parse("2026-08-01T15:45:00.000Z"),
      );
      unmount();
    });

    it("omits unbounded limits and ignores malformed or missing native dates", () => {
      const changed = vi.fn();
      const { native, unmount } = renderNative(datePickerImpl, "IOSDatePicker", {
        value: Date.parse("2026-07-12T09:30:00.000Z"),
        mode: "date",
        onChange: changed,
        options: { minimum: null, maximum: undefined, enabled: true },
      });

      expect(native.props).not.toHaveProperty("min");
      expect(native.props).not.toHaveProperty("max");

      const malformedEvents = [
        undefined,
        {},
        { nativeEvent: {} },
        { nativeEvent: { value: 0 } },
        { nativeEvent: { value: "" } },
        { nativeEvent: { value: "2026-08-01" } },
        { nativeEvent: { value: "2026-02-30T00:00:00.000Z" } },
        { nativeEvent: { value: "2026-08-01T15:45:00Z" } },
      ];
      act(() => {
        for (const event of malformedEvents) native.props.onDateChange(event);
      });

      expect(changed).not.toHaveBeenCalled();
      unmount();
    });
  });

  describe("SegmentedControl", () => {
    const items = [
      { id: "0", title: "Overview" },
      { id: "1", title: "Details" },
    ];

    it("preserves controlled selection and delivers its validated index exactly once", () => {
      const selected = vi.fn();
      const { native, unmount } = renderNative(
        segmentedControlImpl,
        "IOSSegmentedControl",
        {
          items,
          selectedId: "1",
          enabled: false,
          onSelect: selected,
          accessibilityLabel: "UIKit segmented control",
        },
      );

      expect(native.props).toMatchObject({
        items,
        selectedId: "1",
        enabled: false,
        accessibilityLabel: "UIKit segmented control",
      });

      act(() => {
        native.props.onSelect({ nativeEvent: { id: "0", index: 0 } });
      });

      expect(selected).toHaveBeenCalledOnce();
      expect(selected).toHaveBeenCalledWith(0);
      unmount();
    });

    it("ignores missing, fractional, negative, out-of-range, and mismatched selections", () => {
      const selected = vi.fn();
      const { native, unmount } = renderNative(
        segmentedControlImpl,
        "IOSSegmentedControl",
        { items, selectedId: null, enabled: true, onSelect: selected },
      );

      expect(native.props.selectedId).toBeNull();
      const invalidEvents = [
        undefined,
        {},
        { nativeEvent: {} },
        { nativeEvent: { id: "0", index: 0.5 } },
        { nativeEvent: { id: "-1", index: -1 } },
        { nativeEvent: { id: "2", index: 2 } },
        { nativeEvent: { id: "1", index: 0 } },
        { nativeEvent: { id: "unknown", index: 1 } },
      ];
      act(() => {
        for (const event of invalidEvents) native.props.onSelect(event);
      });

      expect(selected).not.toHaveBeenCalled();
      unmount();
    });
  });

  describe("CollectionView", () => {
    const items = [
      { id: "pressable", title: "Pressable" },
      { id: "collection", title: "UICollectionView" },
    ];

    it("delivers a matching item and refresh exactly once while preserving controlled props", () => {
      const selected = vi.fn();
      const refreshed = vi.fn();
      const { native, unmount } = renderNative(
        collectionViewImpl,
        "IOSCollectionView",
        {
          items,
          selectedId: "collection",
          refreshing: true,
          onSelectItem: selected,
          onRefresh: refreshed,
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
          nativeEvent: { id: "pressable", index: 0 },
        });
        native.props.onRefresh();
      });

      expect(selected).toHaveBeenCalledOnce();
      expect(selected).toHaveBeenCalledWith("pressable", 0);
      expect(refreshed).toHaveBeenCalledOnce();
      expect(refreshed).toHaveBeenCalledWith(undefined);
      unmount();
    });

    it("omits absent selection and ignores malformed, unsafe, or mismatched item data", () => {
      const selected = vi.fn();
      const { native, unmount } = renderNative(
        collectionViewImpl,
        "IOSCollectionView",
        {
          items,
          selectedId: null,
          refreshing: false,
          onSelectItem: selected,
          onRefresh: vi.fn(),
        },
      );

      expect(native.props).not.toHaveProperty("selectedId");
      const invalidEvents = [
        undefined,
        {},
        { nativeEvent: {} },
        { nativeEvent: { id: 0, index: 0 } },
        { nativeEvent: { id: "pressable", index: 0.5 } },
        { nativeEvent: { id: "pressable", index: -1 } },
        { nativeEvent: { id: "pressable", index: 2 } },
        { nativeEvent: { id: "pressable", index: 2147483648 } },
        { nativeEvent: { id: "collection", index: 0 } },
        { nativeEvent: { id: "unknown", index: 1 } },
      ];
      act(() => {
        for (const event of invalidEvents) native.props.onSelectItem(event);
      });

      expect(selected).not.toHaveBeenCalled();
      unmount();
    });
  });

  describe("SearchBar", () => {
    it("delivers valid edit, submit, and cancel events exactly once", () => {
      const changed = vi.fn();
      const submitted = vi.fn();
      const cancelled = vi.fn();
      const { native, unmount } = renderNative(searchBarImpl, "IOSSearchBar", {
        text: "native",
        onChangeText: changed,
        options: {
          placeholder: "Search UIKit",
          showsCancelButton: true,
          enabled: false,
          onSubmit: submitted,
          onCancel: cancelled,
          accessibilityLabel: "UIKit search bar",
        },
      });

      expect(native.props).toMatchObject({
        text: "native",
        placeholder: "Search UIKit",
        showsCancelButton: true,
        enabled: false,
        accessibilityLabel: "UIKit search bar",
      });

      act(() => {
        native.props.onChangeText({
          nativeEvent: { text: "native controls" },
        });
        native.props.onSubmit({ nativeEvent: { text: "native controls" } });
        native.props.onCancel();
      });

      expect(changed).toHaveBeenCalledOnce();
      expect(changed).toHaveBeenCalledWith("native controls");
      expect(submitted).toHaveBeenCalledOnce();
      expect(submitted).toHaveBeenCalledWith("native controls");
      expect(cancelled).toHaveBeenCalledOnce();
      expect(cancelled).toHaveBeenCalledWith();
      unmount();
    });

    it("keeps optional callbacks absent and ignores malformed edit events", () => {
      const changed = vi.fn();
      const { native, unmount } = renderNative(searchBarImpl, "IOSSearchBar", {
        text: "native",
        onChangeText: changed,
        options: { showsCancelButton: false, enabled: true },
      });

      expect(native.props).not.toHaveProperty("onSubmit");
      expect(native.props).not.toHaveProperty("onCancel");
      expect(native.props).not.toHaveProperty("placeholder");

      const invalidEvents = [
        undefined,
        {},
        { nativeEvent: {} },
        { nativeEvent: { text: null } },
        { nativeEvent: { text: 42 } },
      ];
      act(() => {
        for (const event of invalidEvents) native.props.onChangeText(event);
      });

      expect(changed).not.toHaveBeenCalled();
      unmount();
    });

    it("ignores malformed optional submit events without invoking the callback", () => {
      const submitted = vi.fn();
      const { native, unmount } = renderNative(searchBarImpl, "IOSSearchBar", {
        text: "native",
        onChangeText: vi.fn(),
        options: {
          showsCancelButton: false,
          enabled: true,
          onSubmit: submitted,
        },
      });

      act(() => {
        native.props.onSubmit(undefined);
        native.props.onSubmit({});
        native.props.onSubmit({ nativeEvent: {} });
        native.props.onSubmit({ nativeEvent: { text: false } });
      });

      expect(submitted).not.toHaveBeenCalled();
      unmount();
    });
  });
});
