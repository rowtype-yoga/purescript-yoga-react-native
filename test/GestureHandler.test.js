import { afterAll, afterEach, beforeAll, describe, expect, it, vi } from "vitest";
import React from "react";
import { act, create } from "react-test-renderer";
import { Animated, PanResponder } from "react-native";
import {
  panGestureView,
  useNativeSnapPanImpl,
} from "../src/Yoga/React/Native/GestureHandler.js";

const model = {
  family: "physical",
  stiffness: 180,
  damping: 18,
  mass: 1.25,
  delay: 12,
};

const usePan = ({ initial = 10, snapPoints = [-100, 100], chooseTarget }) =>
  useNativeSnapPanImpl(initial)(snapPoints)(chooseTarget)(model)();

const deferredAnimation = () => ({
  start: vi.fn(),
  stop: vi.fn(),
});

const responderFromConfig = (config) => ({
  panHandlers: {
    onStartShouldSetResponder: config.onStartShouldSetPanResponder,
    onMoveShouldSetResponder: config.onMoveShouldSetPanResponder,
    onResponderGrant: config.onPanResponderGrant,
    onResponderMove: config.onPanResponderMove,
    onResponderRelease: config.onPanResponderRelease,
    onResponderTerminate: config.onPanResponderTerminate,
  },
});

const mountPan = ({ initial = 10, chooseTarget, strict = false }) => {
  const result = { current: undefined };

  const PanContainer = ({ hookProps }) => {
    const pan = usePan(hookProps);
    result.current = pan;
    return panGestureView(pan)(
      React.createElement(Animated.View, {
        testID: "snap-thumb",
        accessibilityLabel: "Draggable snap thumb",
        style: { transform: [{ translateX: pan.position }] },
      }),
    );
  };

  const render = (hookProps) => {
    const child = React.createElement(PanContainer, { hookProps });
    return strict ? React.createElement(React.StrictMode, null, child) : child;
  };

  let renderer;
  act(() => {
    renderer = create(render({ initial, chooseTarget }), {
      unstable_strictMode: strict,
    });
  });

  return {
    renderer,
    result,
    handlers: () => {
      expect(result.current.panHandlers).toBeDefined();
      return result.current.panHandlers;
    },
    rerender: (props = { initial, chooseTarget }) =>
      act(() => renderer.update(render(props))),
    thumb: () => renderer.root.findByProps({ testID: "snap-thumb" }),
    unmount: () => act(() => renderer.unmount()),
  };
};

const expectedSpringConfig = (toValue, velocity) => ({
  stiffness: 180,
  damping: 18,
  mass: 1.25,
  delay: 12,
  velocity,
  toValue,
  useNativeDriver: false,
});

describe("useNativeSnapPanImpl PanResponder orchestration", () => {
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

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("creates one responder and keeps its handlers and Animated.Value stable across rerenders", () => {
    const createResponder = vi
      .spyOn(PanResponder, "create")
      .mockImplementation(responderFromConfig);
    const chooseTarget = vi.fn(() => 100);
    const mounted = mountPan({ initial: 23, chooseTarget });

    expect(createResponder).toHaveBeenCalledTimes(1);
    const position = mounted.result.current.position;
    const panHandlers = mounted.handlers();

    mounted.rerender({ initial: 999, chooseTarget });

    expect(createResponder).toHaveBeenCalledTimes(1);
    expect(mounted.result.current.position).toBe(position);
    expect(mounted.result.current.panHandlers).toBe(panHandlers);
    mounted.unmount();
  });

  it("claims only horizontal movement beyond the drag threshold", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const mounted = mountPan({ chooseTarget: vi.fn(() => 100) });
    const handlers = mounted.handlers();

    expect(
      handlers.onStartShouldSetResponder({}, { dx: 20, dy: 0 }),
    ).toBe(false);

    const moveCases = [
      { name: "positive threshold", gesture: { dx: 4, dy: 0 }, expected: false },
      { name: "negative threshold", gesture: { dx: -4, dy: 0 }, expected: false },
      { name: "vertical dominant", gesture: { dx: 5, dy: 6 }, expected: false },
      { name: "equal axes", gesture: { dx: -5, dy: 5 }, expected: false },
      { name: "rightward drag", gesture: { dx: 5, dy: 4 }, expected: true },
      { name: "leftward drag", gesture: { dx: -5, dy: 4 }, expected: true },
    ];

    for (const { name, gesture, expected } of moveCases) {
      expect(handlers.onMoveShouldSetResponder({}, gesture), name).toBe(expected);
    }

    mounted.unmount();
  });

  it("clones the animated child and attaches responder handlers directly to it", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const mounted = mountPan({ chooseTarget: vi.fn(() => 100) });
    const thumb = mounted.thumb();
    const handlers = mounted.handlers();

    expect(mounted.renderer.toJSON()).toMatchObject({
      type: "Animated.View",
      props: {
        testID: "snap-thumb",
        accessibilityLabel: "Draggable snap thumb",
      },
    });
    expect(thumb.props.onResponderGrant).toBe(handlers.onResponderGrant);
    expect(thumb.props.onResponderMove).toBe(handlers.onResponderMove);
    expect(thumb.props.onResponderRelease).toBe(handlers.onResponderRelease);
    expect(thumb.props.onResponderTerminate).toBe(handlers.onResponderTerminate);
    mounted.unmount();
  });

  it("captures the visible value on grant and writes base plus dx on every move", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const mounted = mountPan({ chooseTarget: vi.fn(() => 100) });
    const position = mounted.result.current.position;
    const stopAnimation = vi
      .spyOn(position, "stopAnimation")
      .mockImplementation((callback) => callback?.(41));
    const setValue = vi.spyOn(position, "setValue");
    const handlers = mounted.handlers();

    act(() => handlers.onResponderGrant({}, { dx: 900, vx: 900 }));
    act(() => handlers.onResponderMove({}, { dx: 9, vx: 2 }));
    act(() => handlers.onResponderMove({}, { dx: -6, vx: -3 }));

    expect(stopAnimation).toHaveBeenCalledTimes(1);
    expect(setValue.mock.calls).toEqual([[50], [35]]);
    mounted.unmount();
  });

  it("samples the absolute release position and velocity, then springs the same value", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const animation = deferredAnimation();
    const spring = vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const chooseTarget = vi.fn(({ position }) => (position < 50 ? -100 : 100));
    const mounted = mountPan({ initial: 10, chooseTarget });
    const position = mounted.result.current.position;
    vi.spyOn(position, "stopAnimation").mockImplementation((callback) =>
      callback?.(34),
    );
    const setValue = vi.spyOn(position, "setValue");
    const handlers = mounted.handlers();

    act(() => handlers.onResponderGrant({}, { dx: 0, vx: 0 }));
    act(() => handlers.onResponderMove({}, { dx: 12, vx: -1 }));
    act(() => handlers.onResponderRelease({}, { dx: 19, vx: 5 }));

    expect(setValue.mock.calls).toEqual([[46], [53]]);
    expect(chooseTarget).toHaveBeenCalledOnce();
    expect(chooseTarget).toHaveBeenCalledWith({ position: 53, velocity: 5 });
    expect(spring).toHaveBeenCalledOnce();
    expect(spring).toHaveBeenCalledWith(
      position,
      expectedSpringConfig(100, 5),
    );
    expect(animation.start).toHaveBeenCalledOnce();
    mounted.unmount();
  });

  it("stops an active spring on retouch and continues from its captured visible value", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const animation = deferredAnimation();
    vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const mounted = mountPan({ initial: 10, chooseTarget: vi.fn(() => 100) });
    const position = mounted.result.current.position;
    const stopAnimation = vi
      .spyOn(position, "stopAnimation")
      .mockImplementation((callback) => callback?.(10));
    const setValue = vi.spyOn(position, "setValue");
    const handlers = mounted.handlers();

    act(() => handlers.onResponderRelease({}, { dx: 20, vx: 4 }));
    stopAnimation.mockImplementation((callback) => callback?.(47));
    setValue.mockClear();

    act(() => handlers.onResponderGrant({}, { dx: 0, vx: 0 }));
    act(() => handlers.onResponderMove({}, { dx: -7, vx: -2 }));

    expect(animation.stop).toHaveBeenCalledTimes(1);
    expect(stopAnimation).toHaveBeenCalledTimes(1);
    expect(setValue).toHaveBeenCalledOnce();
    expect(setValue).toHaveBeenCalledWith(40);
    mounted.unmount();
  });

  it("terminates at the absolute gesture position with zero release velocity", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const animation = deferredAnimation();
    const spring = vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const chooseTarget = vi.fn(() => -100);
    const mounted = mountPan({ initial: 25, chooseTarget });
    const position = mounted.result.current.position;
    vi.spyOn(position, "stopAnimation").mockImplementation((callback) =>
      callback?.(25),
    );
    const setValue = vi.spyOn(position, "setValue");
    const handlers = mounted.handlers();

    act(() => handlers.onResponderGrant({}, { dx: 0, vx: 0 }));
    act(() => handlers.onResponderTerminate({}, { dx: 6, vx: 99 }));

    expect(setValue).toHaveBeenCalledOnce();
    expect(setValue).toHaveBeenCalledWith(31);
    expect(chooseTarget).toHaveBeenCalledWith({ position: 31, velocity: 0 });
    expect(spring).toHaveBeenCalledWith(
      position,
      expectedSpringConfig(-100, 0),
    );
    expect(animation.start).toHaveBeenCalledOnce();
    mounted.unmount();
  });

  it("remains interactive after the StrictMode effect cleanup probe", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const animation = deferredAnimation();
    const spring = vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const chooseTarget = vi.fn(() => 100);
    const mounted = mountPan({ initial: 5, chooseTarget, strict: true });
    const position = mounted.result.current.position;
    vi.spyOn(position, "stopAnimation").mockImplementation((callback) =>
      callback?.(61),
    );
    const handlers = mounted.handlers();

    act(() => handlers.onResponderGrant({}, { dx: 0, vx: 0 }));
    act(() => handlers.onResponderRelease({}, { dx: 4, vx: 2 }));

    expect(chooseTarget).toHaveBeenCalledWith({ position: 65, velocity: 2 });
    expect(spring).toHaveBeenCalledWith(
      position,
      expectedSpringConfig(100, 2),
    );
    expect(animation.start).toHaveBeenCalledOnce();
    mounted.unmount();
  });

  it("stops both the active spring and Animated.Value when unmounted", () => {
    vi.spyOn(PanResponder, "create").mockImplementation(responderFromConfig);
    const animation = deferredAnimation();
    vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const mounted = mountPan({ chooseTarget: vi.fn(() => 100) });
    const position = mounted.result.current.position;
    const stopAnimation = vi.spyOn(position, "stopAnimation");
    const handlers = mounted.handlers();

    act(() => handlers.onResponderRelease({}, { dx: 8, vx: 3 }));
    stopAnimation.mockClear();
    mounted.unmount();

    expect(animation.stop).toHaveBeenCalledOnce();
    expect(stopAnimation).toHaveBeenCalledOnce();
  });
});
