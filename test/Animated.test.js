import { describe, it, expect } from "vitest";
import {
  newValueImpl, newValueXYImpl, setValueImpl, setValueXYImpl,
  setOffsetImpl, flattenOffsetImpl, extractOffsetImpl,
  stopAnimationImpl, resetAnimationImpl, interpolateImpl,
  timingImpl, springImpl, decayImpl,
  startImpl, startWithCallbackImpl, stopImpl, resetImpl,
  parallelImpl, sequenceImpl, staggerImpl, delayImpl, loopImpl,
  addImpl, subtractImpl, multiplyImpl, divideImpl, moduloImpl, diffClampImpl,
  _animatedViewImpl, _animatedTextImpl, _animatedImageImpl, _animatedScrollViewImpl,
  useAnimatedValueImpl,
} from "../src/Yoga/React/Native/Animated.js";

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
