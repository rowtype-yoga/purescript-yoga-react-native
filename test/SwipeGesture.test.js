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
import { Animated, PanResponder } from "react-native";
import {
  swipeGestureViewImpl,
  swipePositionImpl,
  swipeProgressImpl,
  useNativeSwipeImpl,
} from "../src/Yoga/React/Native/GestureHandler.js";

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
  const clamped = Math.max(inputRange[0], Math.min(inputRange.at(-1), input));
  const upperIndex = inputRange.findIndex((boundary) => boundary >= clamped);
  if (upperIndex <= 0) return outputRange[0];
  const lowerIndex = upperIndex - 1;
  const distance = inputRange[upperIndex] - inputRange[lowerIndex];
  const progress = distance === 0 ? 0 : (clamped - inputRange[lowerIndex]) / distance;
  return outputRange[lowerIndex] + progress * (outputRange[upperIndex] - outputRange[lowerIndex]);
};

const returnSpring = {
  family: "physical",
  stiffness: 280,
  damping: 24,
  mass: 0.9,
  delay: 0,
};

const dismissalSpring = {
  family: "physical",
  stiffness: 210,
  damping: 22,
  mass: 0.9,
  delay: 0,
};

const config = {
  dismissalDistance: 110,
  dismissalVelocity: 0.72,
  returnSpring,
  dismissalSpring,
};

const responderFromConfig = (responderConfig) => ({
  panHandlers: {
    onStartShouldSetResponder: responderConfig.onStartShouldSetPanResponder,
    onStartShouldSetResponderCapture:
      responderConfig.onStartShouldSetPanResponderCapture,
    onMoveShouldSetResponder: responderConfig.onMoveShouldSetPanResponder,
    onMoveShouldSetResponderCapture:
      responderConfig.onMoveShouldSetPanResponderCapture,
    onResponderGrant: responderConfig.onPanResponderGrant,
    onResponderMove: responderConfig.onPanResponderMove,
    onResponderRelease: responderConfig.onPanResponderRelease,
    onResponderTerminate: responderConfig.onPanResponderTerminate,
    onResponderTerminationRequest:
      responderConfig.onPanResponderTerminationRequest,
    onShouldBlockNativeResponder: responderConfig.onShouldBlockNativeResponder,
  },
});

const deferredAnimation = () => {
  let completion;
  return {
    start: vi.fn((callback) => {
      completion = callback;
    }),
    stop: vi.fn(),
    complete: (finished = true) => completion?.({ finished }),
  };
};

const mountSwipe = ({
  currentConfig = config,
  onLeft = vi.fn(),
  onRight = vi.fn(),
} = {}) => {
  const result = { current: undefined };

  const SwipeContainer = (props) => {
    const swipe = useNativeSwipeImpl(
      props.currentConfig,
      props.onLeft,
      props.onRight,
    );
    result.current = swipe;
    return swipeGestureViewImpl(
      swipe,
      React.createElement(Animated.View, {
        testID: "swipe-card",
        style: { transform: [{ translateX: swipePositionImpl(swipe) }] },
      }),
    );
  };

  let renderer;
  act(() => {
    renderer = create(
      React.createElement(SwipeContainer, {
        currentConfig,
        onLeft,
        onRight,
      }),
    );
  });

  return {
    renderer,
    result,
    handlers: () => result.current.panHandlers,
    position: () => swipePositionImpl(result.current),
    rerender: (props) =>
      act(() =>
        renderer.update(
          React.createElement(SwipeContainer, {
            currentConfig,
            onLeft,
            onRight,
            ...props,
          }),
        ),
      ),
    unmount: () => act(() => renderer.unmount()),
  };
};

const release = (handlers, { dx, vx }) =>
  act(() => handlers.onResponderRelease({}, { dx, vx }));

const expectedSpring = (model, toValue, velocity) => ({
  stiffness: model.stiffness,
  damping: model.damping,
  mass: model.mass,
  delay: model.delay,
  velocity,
  toValue,
  useNativeDriver: false,
});

describe("reusable native swipe gesture", () => {
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

  beforeEach(() => {
    vi.spyOn(Animated.Value.prototype, "interpolate").mockImplementation(
      function interpolate(config) {
        return interpolationNode(this, config);
      },
    );
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("maps either dismissal boundary to complete progress and the resting position to zero", () => {
    const position = new Animated.Value(0);
    const progress = swipeProgressImpl({
      position,
      dismissalDistance: config.dismissalDistance,
    });

    expect(progress._source).toBe(position);
    expect(progress._config).toEqual({
      inputRange: [-110, 0, 110],
      outputRange: [1, 0, 1],
      extrapolate: "clamp",
    });
    expect([
      interpolateAt(progress, -110),
      interpolateAt(progress, 0),
      interpolateAt(progress, 110),
    ]).toEqual([1, 0, 1]);

    const chained = progress.interpolate({
      inputRange: [0, 1],
      outputRange: [0.58, 1],
      extrapolate: "clamp",
    });
    expect(chained._source).toBe(progress);
    expect([interpolateAt(chained, 0), interpolateAt(chained, 1)]).toEqual([
      0.58, 1,
    ]);
  });

  it("claims horizontal intent in both responder phases without stealing starts or vertical movement", () => {
    const createResponder = vi
      .spyOn(PanResponder, "create")
      .mockImplementation(responderFromConfig);
    const mounted = mountSwipe();
    const handlers = mounted.handlers();

    expect(createResponder).toHaveBeenCalledOnce();
    expect(handlers.onStartShouldSetResponder()).toBe(false);
    expect(handlers.onStartShouldSetResponderCapture()).toBe(false);

    const cases = [
      { name: "at positive slop", dx: 4, dy: 0, expected: false },
      { name: "at negative slop", dx: -4, dy: 0, expected: false },
      { name: "vertical dominant", dx: 6, dy: 7, expected: false },
      { name: "equal axes", dx: -7, dy: 7, expected: false },
      { name: "right horizontal", dx: 5, dy: 4, expected: true },
      { name: "left horizontal", dx: -5, dy: 4, expected: true },
    ];

    for (const { name, dx, dy, expected } of cases) {
      const gesture = { dx, dy };
      expect(handlers.onMoveShouldSetResponder({}, gesture), name).toBe(expected);
      expect(
        handlers.onMoveShouldSetResponderCapture({}, gesture),
        `${name} capture`,
      ).toBe(expected);
    }

    expect(handlers.onResponderTerminationRequest()).toBe(false);
    expect(handlers.onShouldBlockNativeResponder()).toBe(true);
    expect(mounted.renderer.root.findByProps({ testID: "swipe-card" }).props).toMatchObject({
      pointerEvents: "box-only",
      collapsable: false,
    });
    mounted.unmount();
  });

  it("continues movement from the captured visible position", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const mounted = mountSwipe();
    const position = mounted.position();
    vi.spyOn(position, "stopAnimation").mockImplementation((callback) =>
      callback?.(37),
    );
    const setValue = vi.spyOn(position, "setValue");
    const handlers = mounted.handlers();

    act(() => handlers.onResponderGrant({}, { dx: 999 }));
    act(() => handlers.onResponderMove({}, { dx: 13 }));
    act(() => handlers.onResponderMove({}, { dx: -8 }));

    expect(setValue.mock.calls).toEqual([[37], [50], [29]]);
    mounted.unmount();
  });

  it("springs subthreshold releases home and never dismisses", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const animation = deferredAnimation();
    const spring = vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const onLeft = vi.fn();
    const onRight = vi.fn();
    const mounted = mountSwipe({ onLeft, onRight });
    const position = mounted.position();
    const setValue = vi.spyOn(position, "setValue");

    release(mounted.handlers(), { dx: 109.99, vx: 0.719 });

    expect(setValue).toHaveBeenCalledWith(109.99);
    expect(spring).toHaveBeenCalledWith(
      position,
      expectedSpring(returnSpring, 0, 0.719),
    );
    animation.complete(true);
    expect(onLeft).not.toHaveBeenCalled();
    expect(onRight).not.toHaveBeenCalled();
    mounted.unmount();
  });

  it.each([
    { name: "left distance", dx: -110, vx: 0, destination: -485, side: "left" },
    { name: "right distance", dx: 110, vx: 0, destination: 485, side: "right" },
    { name: "left velocity", dx: 2, vx: -0.72, destination: -485, side: "left" },
    { name: "right velocity", dx: -2, vx: 0.72, destination: 485, side: "right" },
  ])(
    "commits $name offscreen, resets first, and invokes only its latest callback once",
    ({ dx, vx, destination, side }) => {
      vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
      const animation = deferredAnimation();
      const spring = vi.spyOn(Animated, "spring").mockReturnValue(animation);
      const initialLeft = vi.fn();
      const initialRight = vi.fn();
      const latestLeft = vi.fn();
      const latestRight = vi.fn();
      const mounted = mountSwipe({
        onLeft: initialLeft,
        onRight: initialRight,
      });
      const position = mounted.position();
      const callback = side === "left" ? latestLeft : latestRight;
      callback.mockImplementation(() => {
        expect(position._value).toBe(0);
      });
      mounted.rerender({ onLeft: latestLeft, onRight: latestRight });

      release(mounted.handlers(), { dx, vx });
      release(mounted.handlers(), { dx: -dx || 200, vx: -vx || 2 });

      expect(spring).toHaveBeenCalledOnce();
      expect(spring).toHaveBeenCalledWith(
        position,
        expectedSpring(dismissalSpring, destination, vx),
      );
      expect(initialLeft).not.toHaveBeenCalled();
      expect(initialRight).not.toHaveBeenCalled();
      expect(latestLeft).not.toHaveBeenCalled();
      expect(latestRight).not.toHaveBeenCalled();

      animation.complete(true);
      animation.complete(true);

      expect(latestLeft).toHaveBeenCalledTimes(side === "left" ? 1 : 0);
      expect(latestRight).toHaveBeenCalledTimes(side === "right" ? 1 : 0);
      mounted.unmount();
    },
  );

  it("resets and unlocks after an interrupted dismissal so the next swipe can complete", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const interruptedAnimation = deferredAnimation();
    const completedAnimation = deferredAnimation();
    vi.spyOn(Animated, "spring")
      .mockReturnValueOnce(interruptedAnimation)
      .mockReturnValueOnce(completedAnimation);
    const onLeft = vi.fn();
    const onRight = vi.fn();
    const mounted = mountSwipe({ onLeft, onRight });
    const position = mounted.position();

    release(mounted.handlers(), { dx: -150, vx: -1 });
    expect(position._value).toBe(-150);
    expect(
      mounted.handlers().onMoveShouldSetResponder({}, { dx: 6, dy: 2 }),
    ).toBe(false);

    act(() => interruptedAnimation.complete(false));

    expect(position._value).toBe(0);
    expect(onLeft).not.toHaveBeenCalled();
    expect(onRight).not.toHaveBeenCalled();
    expect(
      mounted.handlers().onMoveShouldSetResponder({}, { dx: 6, dy: 2 }),
    ).toBe(true);

    release(mounted.handlers(), { dx: 150, vx: 1 });
    act(() => completedAnimation.complete(true));

    expect(position._value).toBe(0);
    expect(onLeft).not.toHaveBeenCalled();
    expect(onRight).toHaveBeenCalledOnce();
    mounted.unmount();
  });

  it("always springs a terminated gesture home with zero velocity and no callback", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const animation = deferredAnimation();
    const spring = vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const onLeft = vi.fn();
    const onRight = vi.fn();
    const mounted = mountSwipe({ onLeft, onRight });
    const position = mounted.position();

    act(() =>
      mounted.handlers().onResponderTerminate({}, { dx: -200, vx: -9 }),
    );

    expect(spring).toHaveBeenCalledWith(
      position,
      expectedSpring(returnSpring, 0, 0),
    );
    animation.complete(true);
    expect(onLeft).not.toHaveBeenCalled();
    expect(onRight).not.toHaveBeenCalled();
    mounted.unmount();
  });
});
