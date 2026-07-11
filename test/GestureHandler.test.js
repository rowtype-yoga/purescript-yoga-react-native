import {
  afterAll,
  afterEach,
  beforeAll,
  describe,
  expect,
  it,
  vi,
} from "vitest";
import React from "react";
import { act, create } from "react-test-renderer";
import { Animated } from "react-native";
import { State } from "react-native-gesture-handler";
import { useNativeSnapPanImpl } from "../src/Yoga/React/Native/GestureHandler.js";

const model = {
  family: "physical",
  stiffness: 180,
  damping: 18,
  mass: 1.25,
  delay: 12,
};

const renderHook = (hook, { initialProps, strict = false }) => {
  const result = { current: undefined };
  const HookContainer = ({ hookProps }) => {
    result.current = hook(hookProps);
    return null;
  };
  const render = (hookProps) => {
    const child = React.createElement(HookContainer, { hookProps });
    return strict ? React.createElement(React.StrictMode, null, child) : child;
  };

  let renderer;
  act(() => {
    renderer = create(render(initialProps), { unstable_strictMode: strict });
  });

  return {
    result,
    rerender: (hookProps) => act(() => renderer.update(render(hookProps))),
    unmount: () => act(() => renderer.unmount()),
  };
};

const usePan = ({ initial = 10, snapPoints = [-100, 100], chooseTarget }) =>
  useNativeSnapPanImpl(initial)(snapPoints)(chooseTarget)(model)();

const stateEvent = (state, sample = {}) => ({
  nativeEvent: { state, ...sample },
});

const deferredAnimation = () => ({
  start: vi.fn(),
  stop: vi.fn(),
});

describe("useNativeSnapPanImpl", () => {
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

  it("maps translationX directly to the drag value with the native driver", () => {
    const nativeHandler = vi.fn();
    const event = vi.spyOn(Animated, "event").mockReturnValue(nativeHandler);
    const chooseTarget = vi.fn(() => 100);
    const { result, rerender, unmount } = renderHook(usePan, {
      initialProps: { chooseTarget },
    });
    const drag = result.current.position.b;

    expect(event).toHaveBeenCalledWith(
      [{ nativeEvent: { translationX: drag } }],
      { useNativeDriver: true },
    );
    expect(result.current.onGestureEvent).toBe(nativeHandler);

    rerender({ chooseTarget });
    expect(event).toHaveBeenCalledTimes(1);
    expect(result.current.onGestureEvent).toBe(nativeHandler);

    unmount();
  });

  it("interrupts a running spring on retouch and snaps from its captured presentation position", () => {
    const animations = [deferredAnimation(), deferredAnimation()];
    const spring = vi
      .spyOn(Animated, "spring")
      .mockReturnValueOnce(animations[0])
      .mockReturnValueOnce(animations[1]);
    const chooseTarget = vi.fn(({ position }) => (position < 0 ? -100 : 100));
    const { result, unmount } = renderHook(usePan, {
      initialProps: { chooseTarget },
    });
    const base = result.current.position.a;
    const drag = result.current.position.b;

    act(() => {
      result.current.onHandlerStateChange(
        stateEvent(State.END, { translationX: 20, velocityX: 5 }),
      );
    });
    expect(chooseTarget).toHaveBeenLastCalledWith({ position: 30, velocity: 5 });

    const stopBase = vi
      .spyOn(base, "stopAnimation")
      .mockImplementation((callback) => callback?.(47));
    const stopDrag = vi.spyOn(drag, "stopAnimation");
    act(() => {
      result.current.onHandlerStateChange(stateEvent(State.BEGAN));
    });

    expect(animations[0].stop).toHaveBeenCalledTimes(1);
    expect(stopBase).toHaveBeenCalledTimes(1);
    expect(stopDrag).toHaveBeenCalledTimes(1);
    expect(base._value).toBe(47);
    expect(drag._value).toBe(0);

    act(() => {
      result.current.onHandlerStateChange(
        stateEvent(State.END, { translationX: -2, velocityX: -6 }),
      );
    });

    expect(chooseTarget).toHaveBeenLastCalledWith({ position: 45, velocity: -6 });
    expect(spring).toHaveBeenLastCalledWith(base, {
      stiffness: 180,
      damping: 18,
      mass: 1.25,
      delay: 12,
      velocity: -6,
      toValue: 100,
      useNativeDriver: true,
    });
    expect(animations[1].start).toHaveBeenCalledTimes(1);

    unmount();
  });

  it("queues END until an asynchronous retouch capture resolves", () => {
    const animations = [deferredAnimation(), deferredAnimation()];
    const spring = vi
      .spyOn(Animated, "spring")
      .mockReturnValueOnce(animations[0])
      .mockReturnValueOnce(animations[1]);
    const chooseTarget = vi.fn(({ position }) => (position < 50 ? -100 : 100));
    const { result, unmount } = renderHook(usePan, {
      initialProps: { chooseTarget },
    });
    const base = result.current.position.a;

    act(() => {
      result.current.onHandlerStateChange(
        stateEvent(State.END, { translationX: 10, velocityX: 1 }),
      );
    });

    let resolveCapture;
    vi.spyOn(base, "stopAnimation").mockImplementation((callback) => {
      resolveCapture = callback;
    });
    act(() => {
      result.current.onHandlerStateChange(stateEvent(State.BEGAN));
      result.current.onHandlerStateChange(
        stateEvent(State.END, { translationX: -7, velocityX: 9 }),
      );
    });

    expect(animations[0].stop).toHaveBeenCalledTimes(1);
    expect(chooseTarget).toHaveBeenCalledTimes(1);
    expect(spring).toHaveBeenCalledTimes(1);
    expect(animations[1].start).not.toHaveBeenCalled();

    act(() => {
      resolveCapture(42);
    });

    expect(chooseTarget).toHaveBeenNthCalledWith(2, { position: 35, velocity: 9 });
    expect(spring).toHaveBeenNthCalledWith(2, base, {
      stiffness: 180,
      damping: 18,
      mass: 1.25,
      delay: 12,
      velocity: 9,
      toValue: -100,
      useNativeDriver: true,
    });
    expect(base._value).toBe(35);
    expect(animations[1].start).toHaveBeenCalledTimes(1);

    unmount();
  });

  it("stops a replaced native spring before starting the next settlement", () => {
    const animations = [deferredAnimation(), deferredAnimation()];
    vi.spyOn(Animated, "spring")
      .mockReturnValueOnce(animations[0])
      .mockReturnValueOnce(animations[1]);
    const chooseTarget = vi.fn(({ position }) => (position < 50 ? -100 : 100));
    const { result, unmount } = renderHook(usePan, {
      initialProps: { initial: 0, chooseTarget },
    });

    act(() => {
      result.current.onHandlerStateChange(
        stateEvent(State.END, { translationX: 20, velocityX: 2 }),
      );
      result.current.onHandlerStateChange(
        stateEvent(State.END, { translationX: 40, velocityX: 3 }),
      );
    });

    expect(chooseTarget).toHaveBeenNthCalledWith(1, { position: 20, velocity: 2 });
    expect(chooseTarget).toHaveBeenNthCalledWith(2, { position: 60, velocity: 3 });
    expect(animations[0].stop).toHaveBeenCalledTimes(1);
    expect(animations[1].start).toHaveBeenCalledTimes(1);

    unmount();
  });

  it.each([
    ["cancelled", State.CANCELLED],
    ["failed", State.FAILED],
  ])("settles a %s gesture with a zero sample when RNGH omits motion fields", (_name, state) => {
    const animation = deferredAnimation();
    const spring = vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const chooseTarget = vi.fn(() => -100);
    const { result, unmount } = renderHook(usePan, {
      initialProps: { initial: 25, chooseTarget },
    });
    const base = result.current.position.a;

    act(() => {
      result.current.onHandlerStateChange(stateEvent(state));
    });

    expect(chooseTarget).toHaveBeenCalledWith({ position: 25, velocity: 0 });
    expect(spring).toHaveBeenCalledWith(base, {
      stiffness: 180,
      damping: 18,
      mass: 1.25,
      delay: 12,
      velocity: 0,
      toValue: -100,
      useNativeDriver: true,
    });
    expect(animation.start).toHaveBeenCalledTimes(1);

    unmount();
  });

  it("stops the active spring and both animated values on unmount", () => {
    const animation = deferredAnimation();
    vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const { result, unmount } = renderHook(usePan, {
      initialProps: { chooseTarget: () => 100 },
    });
    const base = result.current.position.a;
    const drag = result.current.position.b;
    const stopBase = vi.spyOn(base, "stopAnimation");
    const stopDrag = vi.spyOn(drag, "stopAnimation");

    act(() => {
      result.current.onHandlerStateChange(
        stateEvent(State.END, { translationX: 12, velocityX: 4 }),
      );
    });
    const dragStopsBeforeUnmount = stopDrag.mock.calls.length;

    unmount();

    expect(animation.stop).toHaveBeenCalledTimes(1);
    expect(stopBase).toHaveBeenCalledTimes(1);
    expect(stopDrag).toHaveBeenCalledTimes(dragStopsBeforeUnmount + 1);
  });

  it("recaptures spring position after the StrictMode effect cleanup probe", () => {
    const animation = deferredAnimation();
    vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const chooseTarget = vi.fn(() => 100);
    const { result, unmount } = renderHook(usePan, {
      initialProps: { initial: 5, chooseTarget },
      strict: true,
    });
    const base = result.current.position.a;
    vi.spyOn(base, "stopAnimation").mockImplementation((callback) => callback?.(61));

    act(() => {
      result.current.onHandlerStateChange(stateEvent(State.BEGAN));
      result.current.onHandlerStateChange(
        stateEvent(State.END, { translationX: 4, velocityX: 2 }),
      );
    });

    expect(chooseTarget).toHaveBeenCalledWith({ position: 65, velocity: 2 });
    expect(animation.start).toHaveBeenCalledTimes(1);

    unmount();
  });
});
