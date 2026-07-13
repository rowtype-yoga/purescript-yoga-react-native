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
import { Animated } from "react-native";

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

const press = (renderer, accessibilityLabel) => {
  const target = renderer.root.findByProps({ accessibilityLabel });
  act(() => target.props.onPress());
};

const visibleText = (renderer) =>
  renderer.root.findAllByType("Text").map(({ children }) => children.join(""));

const expectVisible = (renderer, text) => {
  expect(visibleText(renderer)).toContain(text);
};

const expectProfile = (renderer, position, name) => {
  expect(
    renderer.root.findByProps({ accessibilityLabel: `Profile ${position} of 4` }),
  ).toBeDefined();
  expectVisible(renderer, name);
};

const profileCard = (renderer, name) =>
  renderer.root.findByProps({
    accessible: true,
    accessibilityRole: "adjustable",
    accessibilityLabel: `Profile card for ${name}`,
  });

const interpolationNode = (source, config) => ({
  _interpolated: true,
  _source: source,
  _config: config,
  interpolate(nextConfig) {
    return interpolationNode(this, nextConfig);
  },
});

const interpolateAt = ({ _config: config }, input) => {
  const { inputRange, outputRange } = config;
  const clamped = Math.max(
    inputRange[0],
    Math.min(inputRange.at(-1), input),
  );
  const upperIndex = inputRange.findIndex(
    (boundary) => boundary >= clamped,
  );
  if (upperIndex <= 0) return outputRange[0];
  const lowerIndex = upperIndex - 1;
  const distance = inputRange[upperIndex] - inputRange[lowerIndex];
  const progress =
    distance === 0 ? 0 : (clamped - inputRange[lowerIndex]) / distance;
  return (
    outputRange[lowerIndex] +
    progress * (outputRange[upperIndex] - outputRange[lowerIndex])
  );
};

const profileImage = (renderer, name) =>
  renderer.root.findByProps({
    accessibilityLabel: {
      Mara: "Portrait of Mara outdoors in warm evening light. Mara, 29",
      Sol: "Portrait of Sol smiling against a soft city background. Sol, 31",
    }[name],
  });

const loadingIndicators = (image) => image.findAllByType("ActivityIndicator");

const renderCatalogue = () => {
  let renderer;
  act(() => {
    renderer = create(
      React.createElement(SafeAreaProvider, null, iosDemo({})),
    );
  });
  return renderer;
};

describe("Lumen dating demo integration", () => {
  const hadActEnvironment = Object.hasOwn(
    globalThis,
    "IS_REACT_ACT_ENVIRONMENT",
  );
  const previousActEnvironment = globalThis.IS_REACT_ACT_ENVIRONMENT;
  let renderer;
  let consoleError;

  beforeAll(() => {
    globalThis.IS_REACT_ACT_ENVIRONMENT = true;
  });

  beforeEach(() => {
    vi.spyOn(Animated.Value.prototype, "interpolate").mockImplementation(
      function interpolate(config) {
        return interpolationNode(this, config);
      },
    );
    consoleError = vi.spyOn(console, "error").mockImplementation(() => {});
  });

  afterEach(() => {
    if (renderer != null) {
      act(() => renderer.unmount());
      renderer = undefined;
    }

    const unexpectedErrors = consoleError.mock.calls.filter(
      ([message]) =>
        typeof message !== "string" ||
        !message.includes("react-test-renderer is deprecated"),
    );
    expect(unexpectedErrors).toEqual([]);
    vi.restoreAllMocks();
  });

  afterAll(() => {
    if (hadActEnvironment) {
      globalThis.IS_REACT_ACT_ENVIRONMENT = previousActEnvironment;
    } else {
      delete globalThis.IS_REACT_ACT_ENVIRONMENT;
    }
  });

  it("drives the behind card opacity, lift, and scale from shared swipe progress", () => {
    renderer = renderCatalogue();
    press(renderer, "Open Lumen dating demo examples");

    const animatedViews = renderer.root.findAllByType("Animated.View");
    const behindCard = animatedViews.find(
      ({ props }) => props.style?.opacity?._config?.outputRange?.[0] === 0.58,
    );
    const scaledCard = animatedViews.find(
      ({ props }) => props.style?.transform?.[0]?.scale?._config != null,
    );

    expect(behindCard).toBeDefined();
    expect(scaledCard).toBeDefined();

    const opacity = behindCard.props.style.opacity;
    const translateY = behindCard.props.style.transform[0].translateY;
    const scale = scaledCard.props.style.transform[0].scale;
    const progress = opacity._source;

    expect(progress._config).toEqual({
      inputRange: [-110, 0, 110],
      outputRange: [1, 0, 1],
      extrapolate: "clamp",
    });
    expect(translateY._source).toBe(progress);
    expect(scale._source).toBe(progress);
    expect(opacity._config).toEqual({
      inputRange: [0, 1],
      outputRange: [0.58, 1],
      extrapolate: "clamp",
    });
    expect(translateY._config).toEqual({
      inputRange: [0, 1],
      outputRange: [12, 0],
      extrapolate: "clamp",
    });
    expect(scale._config).toEqual({
      inputRange: [0, 1],
      outputRange: [0.94, 1],
      extrapolate: "clamp",
    });
    expect([
      interpolateAt(opacity, 0),
      interpolateAt(translateY, 0),
      interpolateAt(scale, 0),
    ]).toEqual([0.58, 12, 0.94]);
    expect([
      interpolateAt(opacity, 1),
      interpolateAt(translateY, 1),
      interpolateAt(scale, 1),
    ]).toEqual([1, 0, 1]);
  });

  it("shows image loading feedback through completion and promotes a preloaded profile without a flash", () => {
    renderer = renderCatalogue();
    press(renderer, "Open Lumen dating demo examples");
    const loadingMara = profileImage(renderer, "Mara");
    expect(loadingIndicators(loadingMara)).toHaveLength(1);

    act(() => loadingMara.props.onError({}));
    expect(loadingIndicators(profileImage(renderer, "Mara"))).toHaveLength(0);
    const preloadedSol = profileImage(renderer, "Sol");
    expect(loadingIndicators(preloadedSol)).toHaveLength(1);

    act(() => preloadedSol.props.onLoad({}));
    expect(loadingIndicators(profileImage(renderer, "Sol"))).toHaveLength(0);

    const maraCard = profileCard(renderer, "Mara");
    act(() => maraCard.props.onResponderRelease({}, { dx: -110, vx: 0 }));

    expectProfile(renderer, 2, "Sol");
    expect(loadingIndicators(profileImage(renderer, "Sol"))).toHaveLength(0);
  });

  it("advances and matches through the library swipe responder attached to the profile card", () => {
    renderer = renderCatalogue();
    press(renderer, "Open Lumen dating demo examples");

    const maraCard = renderer.root.findByProps({
      accessibilityLabel: "Profile card for Mara",
    });
    expect(maraCard.props.onMoveShouldSetResponder({}, { dx: -6, dy: 2 })).toBe(
      true,
    );

    act(() => maraCard.props.onResponderRelease({}, { dx: -110, vx: 0 }));
    expectProfile(renderer, 2, "Sol");

    press(renderer, "Undo last choice");
    const restoredMaraCard = renderer.root.findByProps({
      accessibilityLabel: "Profile card for Mara",
    });
    act(() =>
      restoredMaraCard.props.onResponderRelease({}, { dx: 110, vx: 0 }),
    );

    expect(
      renderer.root.findByProps({ accessibilityLabel: "You and Mara matched" }),
    ).toBeDefined();
    expectProfile(renderer, 2, "Sol");
  });

  it("completes three consecutive left swipes through one responder after each card rerender", () => {
    const pendingAnimations = [];
    const spring = vi.spyOn(Animated, "spring").mockImplementation((value, options) => {
      let completion;
      const animation = {
        start: vi.fn((callback) => {
          completion = callback;
        }),
        stop: vi.fn(),
        complete: (finished = true) => completion?.({ finished }),
      };
      pendingAnimations.push({ value, options, animation });
      return animation;
    });

    renderer = renderCatalogue();
    press(renderer, "Open Lumen dating demo examples");

    const profiles = ["Mara", "Sol", "Noor"];
    const nextProfiles = [
      { position: 2, name: "Sol" },
      { position: 3, name: "Noor" },
      { position: 4, name: "Inez" },
    ];
    let sharedPosition;
    let sharedRelease;

    profiles.forEach((name, index) => {
      const card = renderer.root.findByProps({
        accessibilityLabel: `Profile card for ${name}`,
      });
      const position = card.props.style.transform[0].translateX;

      if (index === 0) {
        sharedPosition = position;
        sharedRelease = card.props.onResponderRelease;
      } else {
        expect(position).toBe(sharedPosition);
        expect(card.props.onResponderRelease).toBe(sharedRelease);
      }

      expect(card.props.onMoveShouldSetResponder({}, { dx: -6, dy: 2 })).toBe(
        true,
      );
      act(() => card.props.onResponderRelease({}, { dx: -110, vx: 0 }));

      expect(sharedPosition._value).toBe(-110);
      expect(card.props.onMoveShouldSetResponder({}, { dx: -6, dy: 2 })).toBe(
        false,
      );
      expect(pendingAnimations).toHaveLength(index + 1);
      expect(pendingAnimations[index]).toMatchObject({
        value: sharedPosition,
        options: { toValue: -485, useNativeDriver: false },
      });

      act(() => pendingAnimations[index].animation.complete(true));

      expect(sharedPosition._value).toBe(0);
      expectProfile(
        renderer,
        nextProfiles[index].position,
        nextProfiles[index].name,
      );
    });

    expect(spring).toHaveBeenCalledTimes(3);
  });

  it("keeps the responder reusable while a right-swipe match overlay is rendered", () => {
    renderer = renderCatalogue();
    press(renderer, "Open Lumen dating demo examples");

    const maraCard = renderer.root.findByProps({
      accessibilityLabel: "Profile card for Mara",
    });
    act(() => maraCard.props.onResponderRelease({}, { dx: 110, vx: 0 }));

    expect(
      renderer.root.findByProps({ accessibilityLabel: "You and Mara matched" }),
    ).toBeDefined();
    const coveredSolCard = renderer.root.findByProps({
      accessibilityLabel: "Profile card for Sol",
    });
    expect(
      coveredSolCard.props.onMoveShouldSetResponder({}, { dx: -6, dy: 2 }),
    ).toBe(true);

    press(renderer, "Dismiss match");
    const exposedSolCard = renderer.root.findByProps({
      accessibilityLabel: "Profile card for Sol",
    });
    act(() =>
      exposedSolCard.props.onResponderRelease({}, { dx: -110, vx: 0 }),
    );

    expectProfile(renderer, 3, "Noor");
  });

  it("navigates from category 08 and preserves discovery, match, and tab transitions", () => {
    renderer = renderCatalogue();

    expectVisible(renderer, "08");
    expectVisible(renderer, "Lumen dating demo");
    press(renderer, "Open Lumen dating demo examples");

    expect(
      renderer.root.findByProps({ accessibilityLabel: "Lumen dating discovery" }),
    ).toBeDefined();
    expectVisible(renderer, "LUMEN");
    expectProfile(renderer, 1, "Mara");

    press(renderer, "Pass on this profile");
    expectProfile(renderer, 2, "Sol");

    press(renderer, "Undo last choice");
    expectProfile(renderer, 1, "Mara");

    expect(
      renderer.root.findByProps({ accessibilityLabel: "Discover, selected" }),
    ).toBeDefined();
    press(renderer, "Signals");
    expect(
      renderer.root.findByProps({ accessibilityLabel: "Signals, selected" }),
    ).toBeDefined();
    expect(
      renderer.root.findAllByProps({ accessibilityLabel: "Discover, selected" }),
    ).toHaveLength(0);

    press(renderer, "Like this profile");
    expect(
      renderer.root.findByProps({ accessibilityLabel: "You and Mara matched" }),
    ).toBeDefined();
    expectVisible(renderer, "The feeling is mutual.");
    press(renderer, "Keep browsing");
    expect(
      renderer.root.findAllByProps({ accessibilityLabel: "You and Mara matched" }),
    ).toHaveLength(0);
    expectProfile(renderer, 2, "Sol");

    press(renderer, "Undo last choice");
    press(renderer, "Like this profile");
    expect(
      renderer.root.findByProps({ accessibilityLabel: "You and Mara matched" }),
    ).toBeDefined();
    press(renderer, "Dismiss match");
    expect(
      renderer.root.findAllByProps({ accessibilityLabel: "You and Mara matched" }),
    ).toHaveLength(0);
  });
});
