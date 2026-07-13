import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  vi,
} from "vitest";
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
import {
  ActionSheetIOS,
  Appearance,
  Linking,
  NativeModules,
  Platform,
} from "react-native";

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

const renderCatalogue = () => {
  let renderer;
  act(() => {
    renderer = create(
      React.createElement(SafeAreaProvider, null, iosDemo({})),
    );
  });
  return renderer;
};

const visibleText = (renderer) =>
  renderer.root.findAllByType("Text").map(({ children }) => children.join(""));

const expectVisible = (renderer, text) => {
  expect(visibleText(renderer)).toContain(text);
};

const nativeStackOptions = (renderer, name) =>
  renderer.root.findByProps({ name }).props.options;

describe("iOS catalogue UIKit routing", () => {
  const hadActEnvironment = Object.hasOwn(
    globalThis,
    "IS_REACT_ACT_ENVIRONMENT",
  );
  const previousActEnvironment = globalThis.IS_REACT_ACT_ENVIRONMENT;
  const originalOS = Platform.OS;
  const originalHapticFeedback = NativeModules.HapticFeedback;

  beforeAll(() => {
    globalThis.IS_REACT_ACT_ENVIRONMENT = true;
  });

  beforeEach(() => {
    Platform.OS = "ios";
    NativeModules.HapticFeedback = {
      selectionChanged: vi.fn(),
      impact: vi.fn(),
      notification: vi.fn(),
    };
  });

  afterEach(() => {
    Platform.OS = originalOS;
    if (originalHapticFeedback === undefined) {
      delete NativeModules.HapticFeedback;
    } else {
      NativeModules.HapticFeedback = originalHapticFeedback;
    }
    vi.restoreAllMocks();
  });

  afterAll(() => {
    if (hadActEnvironment) {
      globalThis.IS_REACT_ACT_ENVIRONMENT = previousActEnvironment;
    } else {
      delete globalThis.IS_REACT_ACT_ENVIRONMENT;
    }
  });

  it("disables native back gestures only where drags or landing require it", () => {
    const renderer = renderCatalogue();

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

  it("updates typed UIKit control results and ignores malformed native events", () => {
    const renderer = renderCatalogue();
    press(renderer, "Open UIKit widgets examples");

    expectVisible(renderer, "UIKit widgets");
    expectVisible(renderer, "Genuine UIKit UIDatePicker");
    expectVisible(renderer, "Genuine UIKit UISegmentedControl");
    expectVisible(renderer, "Genuine UIKit UISearchBar");

    const initialDate = "2026-07-12T09:30:00.000Z";
    const changedDate = "2026-08-01T15:45:00.000Z";
    expect(renderer.root.findByType("IOSDatePicker").props.value).toBe(
      initialDate,
    );
    act(() => {
      renderer.root.findByType("IOSDatePicker").props.onDateChange({
        nativeEvent: { value: "2026-08-01" },
      });
    });
    expect(renderer.root.findByType("IOSDatePicker").props.value).toBe(
      initialDate,
    );
    act(() => {
      renderer.root.findByType("IOSDatePicker").props.onDateChange({
        nativeEvent: { value: changedDate },
      });
    });
    expect(renderer.root.findByType("IOSDatePicker").props.value).toBe(
      changedDate,
    );
    expect(
      visibleText(renderer).find((text) =>
        text.startsWith("Result: controlled instant = "),
      ),
    ).toContain("August");

    const initialSegmentResult = "Result: selected id = overview; index = 0.";
    expectVisible(renderer, initialSegmentResult);
    act(() => {
      for (const event of [
        { nativeEvent: { id: "0", index: 0.5 } },
        { nativeEvent: { id: "-1", index: -1 } },
        { nativeEvent: { id: "1", index: 0 } },
        { nativeEvent: { id: "unknown", index: 1 } },
      ]) {
        renderer.root.findByType("IOSSegmentedControl").props.onSelect(event);
      }
    });
    expectVisible(renderer, initialSegmentResult);
    act(() => {
      renderer.root.findByType("IOSSegmentedControl").props.onSelect({
        nativeEvent: { id: "1", index: 1 },
      });
    });
    expect(renderer.root.findByType("IOSSegmentedControl").props.selectedId).toBe(
      "1",
    );
    expectVisible(renderer, "Result: selected id = details; index = 1.");

    const initialSearchResult = "Result: no search event yet.";
    act(() => {
      renderer.root.findByType("IOSSearchBar").props.onChangeText({
        nativeEvent: { text: 42 },
      });
      renderer.root.findByType("IOSSearchBar").props.onSubmit({
        nativeEvent: { text: null },
      });
    });
    expect(renderer.root.findByType("IOSSearchBar").props.text).toBe("");
    expectVisible(renderer, initialSearchResult);

    act(() => {
      renderer.root.findByType("IOSSearchBar").props.onChangeText({
        nativeEvent: { text: "typed UIKit" },
      });
    });
    expect(renderer.root.findByType("IOSSearchBar").props.text).toBe(
      "typed UIKit",
    );
    expectVisible(renderer, "Result: change = “typed UIKit”.");
    act(() => {
      renderer.root.findByType("IOSSearchBar").props.onSubmit({
        nativeEvent: { text: "typed UIKit" },
      });
    });
    expectVisible(renderer, "Result: submitted = “typed UIKit”.");
    act(() => renderer.root.findByType("IOSSearchBar").props.onCancel());
    expect(renderer.root.findByType("IOSSearchBar").props.text).toBe("");
    expectVisible(
      renderer,
      "Result: cancel received; controlled text cleared.",
    );

    act(() => renderer.unmount());
  });

  it("omits absent collection selection and changes state only for matching native items", () => {
    const renderer = renderCatalogue();
    press(renderer, "Open Data & media examples");
    press(renderer, "Open native collection");

    const initialCollection = renderer.root.findByType("IOSCollectionView");
    expect(initialCollection.props).not.toHaveProperty("selectedId");
    expect(initialCollection.props).toMatchObject({
      refreshing: false,
      accessibilityLabel: "Native UIKit component collection",
    });
    expectVisible(renderer, "Tap a row or pull to refresh. · refreshes: 0");

    act(() => {
      for (const event of [
        { nativeEvent: { id: "pressable", index: 0.5 } },
        { nativeEvent: { id: "pressable", index: -1 } },
        { nativeEvent: { id: "text-input", index: 0 } },
        { nativeEvent: { id: "unknown", index: 1 } },
      ]) {
        renderer.root.findByType("IOSCollectionView").props.onSelectItem(event);
      }
    });
    expect(renderer.root.findByType("IOSCollectionView").props).not.toHaveProperty(
      "selectedId",
    );
    expectVisible(renderer, "Tap a row or pull to refresh. · refreshes: 0");

    act(() => {
      renderer.root.findByType("IOSCollectionView").props.onSelectItem({
        nativeEvent: { id: "pressable", index: 0 },
      });
    });
    expect(renderer.root.findByType("IOSCollectionView").props.selectedId).toBe(
      "pressable",
    );
    expectVisible(
      renderer,
      "Selected native row 0: pressable · Dispatched selection feedback. · refreshes: 0",
    );
    expect(NativeModules.HapticFeedback.selectionChanged).toHaveBeenCalledOnce();

    act(() => renderer.root.findByType("IOSCollectionView").props.onRefresh());
    expectVisible(renderer, "Native refresh completed · 1 · refreshes: 1");

    act(() => renderer.unmount());
  });

  it("shows typed action, haptic, Appearance, and Linking outcomes", async () => {
    const renderer = renderCatalogue();
    press(renderer, "Open Apple services examples");

    const showActionSheet = vi.spyOn(
      ActionSheetIOS,
      "showActionSheetWithOptions",
    );
    showActionSheet.mockImplementationOnce((_options, onSelect) => onSelect(99));
    press(renderer, "Show action sheet");
    expectVisible(renderer, "Action sheet returned an invalid native response.");
    showActionSheet.mockImplementationOnce((_options, onSelect) => onSelect(1));
    press(renderer, "Show action sheet");
    expectVisible(renderer, "Action sheet selected “Save”.");

    press(renderer, "Impact light");
    expectVisible(renderer, "Dispatched light impact.");
    expect(NativeModules.HapticFeedback.impact).toHaveBeenCalledOnce();
    expect(NativeModules.HapticFeedback.impact).toHaveBeenCalledWith("light");

    vi.spyOn(Appearance, "getColorScheme").mockReturnValue("sepia");
    press(renderer, "Read color scheme");
    expectVisible(renderer, "Native color scheme unavailable.");
    Appearance.getColorScheme.mockReturnValue("dark");
    press(renderer, "Read color scheme");
    expectVisible(renderer, "Native color scheme: dark.");

    vi.spyOn(Linking, "canOpenURL").mockResolvedValue(false);
    const canOpen = renderer.root.findByProps({
      accessibilityLabel: "Can open website?",
    });
    await act(async () => {
      canOpen.props.onPress();
      await Promise.resolve();
      await Promise.resolve();
    });
    expectVisible(renderer, "Can open https: false.");

    vi.spyOn(Linking, "getInitialURL").mockResolvedValue(null);
    const getInitialURL = renderer.root.findByProps({
      accessibilityLabel: "Get initial URL",
    });
    await act(async () => {
      getInitialURL.props.onPress();
      await Promise.resolve();
      await Promise.resolve();
    });
    expectVisible(renderer, "Initial URL: none.");

    act(() => renderer.unmount());
  });
});
