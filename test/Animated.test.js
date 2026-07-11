import { describe, it, expect, vi, beforeAll, afterAll, afterEach } from "vitest";
import React from "react";
import { create, act } from "react-test-renderer";
import { Animated } from "react-native";
import {
  newValueImpl, newValueXYImpl, setValueImpl, setValueXYImpl,
  setOffsetImpl, flattenOffsetImpl, extractOffsetImpl,
  stopAnimationImpl, resetAnimationImpl, interpolateImpl,
  timingImpl, springImpl, decayImpl,
  startImpl, startWithCallbackImpl, stopImpl, resetImpl,
  parallelImpl, sequenceImpl, staggerImpl, delayImpl, loopImpl,
  addImpl, subtractImpl, multiplyImpl, divideImpl, moduloImpl, diffClampImpl,
  _animatedViewImpl, _animatedTextImpl, _animatedImageImpl, _animatedScrollViewImpl,
  useAnimatedValueImpl, useTypedSpringImpl,
} from "../src/Yoga/React/Native/Animated.js";

const renderHook = (hook, { initialProps }) => {
  const result = { current: undefined };
  const HookContainer = ({ hookProps }) => {
    result.current = hook(hookProps);
    return null;
  };
  let renderer;
  act(() => {
    renderer = create(React.createElement(HookContainer, { hookProps: initialProps }));
  });
  return {
    result,
    rerender: (hookProps) => {
      renderer.update(React.createElement(HookContainer, { hookProps }));
    },
    unmount: () => renderer.unmount(),
  };
};

describe("Animated FFI", () => {
  it("newValueImpl creates an AnimatedValue", () => {
    const v = newValueImpl(42);
    expect(v).toBeDefined();
    expect(v._value).toBe(42);
  });

  it("newValueXYImpl creates an AnimatedValueXY", () => {
    const v = newValueXYImpl(10, 20);
    expect(v).toBeDefined();
    expect(v.x._value).toBe(10);
    expect(v.y._value).toBe(20);
  });

  it("setValueImpl sets the value", () => {
    const v = newValueImpl(0);
    setValueImpl(v, 99);
    expect(v._value).toBe(99);
  });

  it("setValueXYImpl sets xy values", () => {
    const v = newValueXYImpl(0, 0);
    setValueXYImpl(v, { x: 5, y: 10 });
    expect(v.x._value).toBe(5);
    expect(v.y._value).toBe(10);
  });

  it("setOffsetImpl sets offset", () => {
    const v = newValueImpl(0);
    setOffsetImpl(v, 10);
    expect(v._offset).toBe(10);
  });

  it("flattenOffsetImpl does not throw", () => {
    const v = newValueImpl(0);
    expect(() => flattenOffsetImpl(v)).not.toThrow();
  });

  it("extractOffsetImpl does not throw", () => {
    const v = newValueImpl(0);
    expect(() => extractOffsetImpl(v)).not.toThrow();
  });

  it("stopAnimationImpl does not throw", () => {
    const v = newValueImpl(0);
    expect(() => stopAnimationImpl(v)).not.toThrow();
  });

  it("resetAnimationImpl does not throw", () => {
    const v = newValueImpl(0);
    expect(() => resetAnimationImpl(v)).not.toThrow();
  });

  it("interpolateImpl returns an interpolated value", () => {
    const v = newValueImpl(0);
    const config = { inputRange: [0, 1], outputRange: [0, 100] };
    const result = interpolateImpl(v)(config);
    expect(result).toBeDefined();
    expect(result._interpolated).toBe(true);
  });

  it("timingImpl returns a CompositeAnimation", () => {
    const v = newValueImpl(0);
    const anim = timingImpl(v)({ toValue: 1, duration: 300 });
    expect(anim).toBeDefined();
    expect(typeof anim.start).toBe("function");
    expect(typeof anim.stop).toBe("function");
  });

  it("springImpl returns a CompositeAnimation", () => {
    const v = newValueImpl(0);
    const anim = springImpl(v)({ toValue: 1 });
    expect(typeof anim.start).toBe("function");
  });

  it("decayImpl returns a CompositeAnimation", () => {
    const v = newValueImpl(0);
    const anim = decayImpl(v)({ velocity: 0.5 });
    expect(typeof anim.start).toBe("function");
  });

  it("startImpl starts an animation", () => {
    const v = newValueImpl(0);
    const anim = timingImpl(v)({ toValue: 1 });
    expect(() => startImpl(anim)).not.toThrow();
  });

  it("startWithCallbackImpl calls back with finished", () => {
    const v = newValueImpl(0);
    const anim = timingImpl(v)({ toValue: 1 });
    let result;
    startWithCallbackImpl(anim, (r) => { result = r; });
    expect(result).toEqual({ finished: true });
  });

  it("stopImpl stops an animation", () => {
    const v = newValueImpl(0);
    const anim = timingImpl(v)({ toValue: 1 });
    expect(() => stopImpl(anim)).not.toThrow();
  });

  it("resetImpl resets an animation", () => {
    const v = newValueImpl(0);
    const anim = timingImpl(v)({ toValue: 1 });
    expect(() => resetImpl(anim)).not.toThrow();
  });

  it("parallelImpl returns a CompositeAnimation", () => {
    const anim = parallelImpl([]);
    expect(typeof anim.start).toBe("function");
  });

  it("sequenceImpl returns a CompositeAnimation", () => {
    const anim = sequenceImpl([]);
    expect(typeof anim.start).toBe("function");
  });

  it("staggerImpl returns a CompositeAnimation", () => {
    const anim = staggerImpl(100)([]);
    expect(typeof anim.start).toBe("function");
  });

  it("delayImpl returns a CompositeAnimation", () => {
    const anim = delayImpl(100);
    expect(typeof anim.start).toBe("function");
  });

  it("loopImpl returns a CompositeAnimation", () => {
    const v = newValueImpl(0);
    const inner = timingImpl(v)({ toValue: 1 });
    const anim = loopImpl(inner)({});
    expect(typeof anim.start).toBe("function");
  });

  it("addImpl returns an animated node", () => {
    const a = newValueImpl(1);
    const b = newValueImpl(2);
    expect(addImpl(a)(b)).toBeDefined();
  });

  it("subtractImpl returns an animated node", () => {
    const a = newValueImpl(1);
    const b = newValueImpl(2);
    expect(subtractImpl(a)(b)).toBeDefined();
  });

  it("multiplyImpl returns an animated node", () => {
    expect(multiplyImpl(newValueImpl(2))(newValueImpl(3))).toBeDefined();
  });

  it("divideImpl returns an animated node", () => {
    expect(divideImpl(newValueImpl(6))(newValueImpl(3))).toBeDefined();
  });

  it("moduloImpl returns an animated node", () => {
    expect(moduloImpl(newValueImpl(7))(3)).toBeDefined();
  });

  it("diffClampImpl returns an animated node", () => {
    expect(diffClampImpl(newValueImpl(5))(0)(10)).toBeDefined();
  });

  it("animated component exports are defined", () => {
    expect(_animatedViewImpl).toBe("Animated.View");
    expect(_animatedTextImpl).toBe("Animated.Text");
    expect(_animatedImageImpl).toBe("Animated.Image");
    expect(_animatedScrollViewImpl).toBe("Animated.ScrollView");
  });

  it("useAnimatedValueImpl returns an effect thunk that returns an animated value", () => {
    const thunk = useAnimatedValueImpl(42);
    expect(typeof thunk).toBe("function");
    const v = thunk();
    expect(v._value).toBe(42);
  });
});

describe("useTypedSpringImpl", () => {
  const physical = {
    family: "physical",
    stiffness: 180,
    damping: 18,
    mass: 1.25,
    delay: 12,
    velocity: -0.5,
    tension: 901,
    friction: 902,
    speed: 903,
    bounciness: 904,
    toValue: 905,
    useNativeDriver: "from-model",
  };

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

  it.each([
    {
      name: "physical",
      model: physical,
      familyConfig: { stiffness: 180, damping: 18, mass: 1.25 },
    },
    {
      name: "tension",
      model: {
        ...physical,
        family: "tension",
        tension: 72,
        friction: 9,
      },
      familyConfig: { tension: 72, friction: 9 },
    },
    {
      name: "bouncy",
      model: {
        ...physical,
        family: "bouncy",
        speed: 14,
        bounciness: 7,
      },
      familyConfig: { speed: 14, bounciness: 7 },
    },
  ])("encodes only the $name family and forwards target/driver last", ({ model, familyConfig }) => {
    const animation = { start: vi.fn(), stop: vi.fn() };
    const spring = vi.spyOn(Animated, "spring").mockReturnValue(animation);
    const { result, rerender, unmount } = renderHook(
      ({ target, currentModel, native }) =>
        useTypedSpringImpl(target)(currentModel)(native)(),
      { initialProps: { target: -10, currentModel: model, native: true } },
    );

    expect(result.current._value).toBe(-10);
    expect(spring).not.toHaveBeenCalled();

    act(() => {
      rerender({ target: 44, currentModel: model, native: false });
    });

    expect(spring).toHaveBeenCalledTimes(1);
    expect(spring).toHaveBeenCalledWith(result.current, {
      ...familyConfig,
      delay: 12,
      velocity: -0.5,
      toValue: 44,
      useNativeDriver: false,
    });
    expect(animation.start).toHaveBeenCalledTimes(1);

    act(() => {
      unmount();
    });
  });

  it("restarts only for scalar target/config changes and stops replaced and unmounted animations", () => {
    const animations = [
      { start: vi.fn(), stop: vi.fn() },
      { start: vi.fn(), stop: vi.fn() },
    ];
    const spring = vi
      .spyOn(Animated, "spring")
      .mockReturnValueOnce(animations[0])
      .mockReturnValueOnce(animations[1]);
    const { rerender, unmount } = renderHook(
      ({ target, model }) => useTypedSpringImpl(target)(model)(true)(),
      { initialProps: { target: 10, model: physical } },
    );

    expect(spring).not.toHaveBeenCalled();

    act(() => {
      rerender({ target: 20, model: { ...physical } });
    });
    expect(spring).toHaveBeenCalledTimes(1);
    expect(animations[0].start).toHaveBeenCalledTimes(1);
    expect(animations[0].stop).not.toHaveBeenCalled();

    act(() => {
      rerender({ target: 20, model: { ...physical } });
    });
    expect(spring).toHaveBeenCalledTimes(1);
    expect(animations[0].stop).not.toHaveBeenCalled();

    const changedModel = { ...physical, damping: 24 };
    act(() => {
      rerender({ target: 20, model: changedModel });
    });
    expect(animations[0].stop).toHaveBeenCalledTimes(1);
    expect(spring).toHaveBeenCalledTimes(2);
    expect(spring).toHaveBeenLastCalledWith(expect.anything(), {
      stiffness: 180,
      damping: 24,
      mass: 1.25,
      delay: 12,
      velocity: -0.5,
      toValue: 20,
      useNativeDriver: true,
    });
    expect(animations[1].start).toHaveBeenCalledTimes(1);

    act(() => {
      unmount();
    });
    expect(animations[1].stop).toHaveBeenCalledTimes(1);
  });
});
