import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import React from "react";
import { act, create } from "react-test-renderer";
import { SafeAreaProvider } from "react-native-safe-area-context";

vi.mock("@react-navigation/native", async () => {
  const React = await import("react");
  return {
    NavigationContainer: ({ children }) =>
      React.createElement(React.Fragment, null, children),
  };
});

vi.mock("@react-navigation/native-stack", async () => {
  const React = await import("react");

  const Screen = ({ children: _children, ...props }) =>
    React.createElement("NativeStackScreen", props);
  const Navigator = ({ children, initialRouteName }) => {
    const [route, setRoute] = React.useState(initialRouteName);
    const screens = React.Children.toArray(children);
    const activeScreen = screens.find((screen) => screen.props.name === route);

    if (activeScreen == null) return null;

    const renderedScreens = screens.map((screen) =>
      React.cloneElement(screen, {
        key: screen.props.name,
        children: undefined,
      }),
    );

    return React.createElement(
      React.Fragment,
      null,
      renderedScreens,
      activeScreen.props.children({
        navigation: {
          navigate: setRoute,
          goBack: () => setRoute("landing"),
        },
      }),
    );
  };

  return {
    createNativeStackNavigator: () => ({ Navigator, Screen }),
  };
});

vi.mock("react-native-screens", () => ({ enableScreens: vi.fn() }));
import { iosDemo } from "../output/Demo.IOSBindings/index.js";

vi.mock("react-native", async (importOriginal) => {
  const [React, native] = await Promise.all([
    import("react"),
    importOriginal(),
  ]);

  const FlatList = ({ data, renderItem, keyExtractor, ...props }) =>
    React.createElement(
      "FlatList",
      { ...props, data, renderItem, keyExtractor },
      data.map((item, index) =>
        React.createElement(
          React.Fragment,
          { key: keyExtractor(item, index) },
          renderItem({ item, index }),
        ),
      ),
    );

  return { ...native, FlatList };
});

const press = (renderer, accessibilityLabel) => {
  const target = renderer.root.findByProps({ accessibilityLabel });
  act(() => target.props.onPress());
};

const nativeStackOptions = (renderer, name) =>
  renderer.root.findByProps({ name }).props.options;

describe("iOS catalogue UIKit routing", () => {
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

  it("disables native back gestures only where drags or landing require it", () => {
    let renderer;
    act(() => {
      renderer = create(
        React.createElement(SafeAreaProvider, null, iosDemo({})),
      );
    });

    expect(nativeStackOptions(renderer, "springs")).toMatchObject({
      gestureEnabled: false,
      fullScreenGestureEnabled: false,
      customAnimationOnGesture: false,
    });
    expect(nativeStackOptions(renderer, "landing")).toMatchObject({
      gestureEnabled: false,
      fullScreenGestureEnabled: false,
    });
    expect(nativeStackOptions(renderer, "controls")).toMatchObject({
      gestureEnabled: true,
      fullScreenGestureEnabled: true,
      customAnimationOnGesture: true,
    });

    act(() => renderer.unmount());
  });

  it("routes to a dedicated screen containing the genuine UIKit controls", () => {
    let renderer;
    act(() => {
      renderer = create(
        React.createElement(SafeAreaProvider, null, iosDemo({})),
      );
    });

    press(renderer, "Open UIKit widgets examples");

    const visibleText = renderer.root
      .findAllByType("Text")
      .map(({ children }) => children.join(""));
    expect(visibleText).toContain("UIKit widgets");
    expect(visibleText).toContain("Genuine UIKit UIDatePicker");
    expect(visibleText).toContain("Genuine UIKit UISegmentedControl");
    expect(visibleText).toContain("Genuine UIKit UISearchBar");
    expect(renderer.root.findAllByType("IOSDatePicker")).toHaveLength(1);
    expect(renderer.root.findAllByType("IOSSegmentedControl")).toHaveLength(1);
    expect(renderer.root.findAllByType("IOSSearchBar")).toHaveLength(1);

    act(() => renderer.unmount());
  });

  it("routes to the genuine UIKit collection and reflects native selection", () => {
    let renderer;
    act(() => {
      renderer = create(
        React.createElement(SafeAreaProvider, null, iosDemo({})),
      );
    });

    press(renderer, "Open Data & media examples");
    press(renderer, "Open native collection");

    const collection = renderer.root.findByType("IOSCollectionView");
    expect(collection.props).toMatchObject({
      selectedId: "",
      refreshing: false,
      accessibilityLabel: "Native UIKit component collection",
    });

    act(() => {
      collection.props.onSelectItem({
        nativeEvent: { id: "pressable", index: 0 },
      });
    });

    expect(renderer.root.findByType("IOSCollectionView").props.selectedId).toBe(
      "pressable",
    );
    const visibleText = renderer.root
      .findAllByType("Text")
      .map(({ children }) => children.join(""));
    expect(visibleText).toContain("Selected native row 0: pressable · refreshes: 0");

    act(() => renderer.unmount());
  });
});
