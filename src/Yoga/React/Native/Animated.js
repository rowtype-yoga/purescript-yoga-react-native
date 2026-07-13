import { Animated, useAnimatedValue } from "react-native";
import { useRef, useEffect } from "react";

export const newValueImpl = (n) => new Animated.Value(n);
export const newValueXYImpl = (x, y) => new Animated.ValueXY({ x, y });
export const setValueImpl = (v, n) => v.setValue(n);
export const setValueXYImpl = (v, xy) => v.setValue(xy);
export const setOffsetImpl = (v, n) => v.setOffset(n);
export const flattenOffsetImpl = (v) => v.flattenOffset();
export const extractOffsetImpl = (v) => v.extractOffset();
export const stopAnimationImpl = (v) => v.stopAnimation();
export const resetAnimationImpl = (v) => v.resetAnimation();
export const interpolateImpl = (v) => (config) => v.interpolate(config);
export const interpolateRotationImpl = (value) => (config) =>
  value.interpolate({
    ...config,
    outputRange: config.outputRange.map((degrees) => `${degrees}deg`),
  });
export const timingImpl = (v) => (config) => Animated.timing(v, config);
export const springImpl = (v) => (config) => Animated.spring(v, config);
export const decayImpl = (v) => (config) => Animated.decay(v, config);
export const startImpl = (anim) => anim.start();
export const startWithCallbackImpl = (anim, cb) => anim.start(cb);
export const stopImpl = (anim) => anim.stop();
export const resetImpl = (anim) => anim.reset();
export const parallelImpl = (anims) => Animated.parallel(anims);
export const sequenceImpl = (anims) => Animated.sequence(anims);
export const staggerImpl = (time) => (anims) => Animated.stagger(time, anims);
export const delayImpl = (time) => Animated.delay(time);
export const loopImpl = (anim) => (config) => Animated.loop(anim, config);
export const addImpl = (a) => (b) => Animated.add(a, b);
export const subtractImpl = (a) => (b) => Animated.subtract(a, b);
export const multiplyImpl = (a) => (b) => Animated.multiply(a, b);
export const divideImpl = (a) => (b) => Animated.divide(a, b);
export const moduloImpl = (a) => (n) => Animated.modulo(a, n);
export const diffClampImpl = (a) => (min) => (max) =>
  Animated.diffClamp(a, min, max);
export const _animatedViewImpl = Animated.View;
export const _animatedTextImpl = Animated.Text;
export const _animatedImageImpl = Animated.Image;
export const _animatedScrollViewImpl = Animated.ScrollView;
export const useAnimatedValueImpl = (n) => () => useAnimatedValue(n);

export const useSpringImpl = (target) => (config) => () => {
  const valueRef = useRef(null);
  const prevTargetRef = useRef(target);
  if (valueRef.current === null) {
    valueRef.current = new Animated.Value(target);
  }
  useEffect(() => {
    if (prevTargetRef.current !== target) {
      prevTargetRef.current = target;
      const anim = Animated.spring(valueRef.current, {
        toValue: target,
        ...config,
      });
      anim.start();
      return () => anim.stop();
    }
  });
  return valueRef.current;
};

const springConfig = (model, target, useNativeDriver) => {
  let family;
  switch (model.family) {
    case "physical":
      family = {
        stiffness: model.stiffness,
        damping: model.damping,
        mass: model.mass,
      };
      break;
    case "tension":
      family = { tension: model.tension, friction: model.friction };
      break;
    case "bouncy":
      family = { speed: model.speed, bounciness: model.bounciness };
      break;
    default:
      throw new Error(`Unknown spring family: ${model.family}`);
  }

  return {
    ...family,
    delay: model.delay,
    velocity: model.velocity,
    toValue: target,
    useNativeDriver,
  };
};

export const useTypedSpringImpl = (target) => (model) => (useNativeDriver) => () => {
  const valueRef = useRef(null);
  if (valueRef.current === null) {
    valueRef.current = new Animated.Value(target);
  }

  const dependencies = [
    target,
    model.family,
    model.stiffness,
    model.damping,
    model.mass,
    model.tension,
    model.friction,
    model.speed,
    model.bounciness,
    model.delay,
    model.velocity,
    useNativeDriver,
  ];
  const previousDependenciesRef = useRef(dependencies);

  useEffect(() => {
    const previousDependencies = previousDependenciesRef.current;
    previousDependenciesRef.current = dependencies;
    if (dependencies.every((value, index) => Object.is(value, previousDependencies[index]))) {
      return;
    }

    const animation = Animated.spring(
      valueRef.current,
      springConfig(model, target, useNativeDriver),
    );
    animation.start();
    return () => animation.stop();
  }, dependencies);

  return valueRef.current;
};
