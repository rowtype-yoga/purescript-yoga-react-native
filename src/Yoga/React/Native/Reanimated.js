import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withTiming,
  withDecay,
  withDelay,
  withSequence,
  withRepeat,
  withClamp,
  interpolate,
  cancelAnimation,
  Easing,
  Extrapolation,
  LinearTransition,
  FadeIn,
  FadeOut,
  FadeInDown,
  FadeOutUp,
} from "react-native-reanimated";

// Animated components
export const _reanimatedViewImpl = Animated.View;
export const _reanimatedTextImpl = Animated.Text;
export const _reanimatedImageImpl = Animated.Image;
export const _reanimatedScrollViewImpl = Animated.ScrollView;

// useSharedValue hook
export const useSharedValueImpl = (initial) => () => useSharedValue(initial);

// useAnimatedStyle hook
export const useAnimatedStyleImpl = (updater) => () =>
  useAnimatedStyle(updater);

// useAnimatedStyle that interpolates a single shared value into style properties.
// styleMap is an array of { prop, inputRange, outputRange, extrapolation }.
// This keeps the .value read inside the worklet so Reanimated can track it.
export const useInterpolatedStyleImpl = (sv) => (styleMap) => () =>
  useAnimatedStyle(() => {
    "worklet";
    const style = {};
    for (let i = 0; i < styleMap.length; i++) {
      const { prop, inputRange, outputRange, extrapolation } = styleMap[i];
      style[prop] = interpolate(sv.value, inputRange, outputRange, extrapolation);
    }
    return style;
  });

// useAnimatedStyle that directly reads shared values for height and opacity.
export const useHeightAnimStyleImpl = (heightSV) => (opacitySV) => () =>
  useAnimatedStyle(() => {
    "worklet";
    return { height: heightSV.value, opacity: opacitySV.value };
  });

// Read shared value
export const readSharedValue = (sv) => () => sv.value;

// Pure read of shared value (for use in useAnimatedStyle worklets)
export const readValue = (sv) => sv.value;

// Write shared value (plain assignment)
export const writeSharedValue = (sv) => (val) => () => {
  sv.value = val;
};

// Write shared value with spring
export const writeSharedValueWithSpring =
  (sv) => (target) => (config) => () => {
    sv.value = withSpring(target, config);
  };

// Write shared value with timing
export const writeSharedValueWithTiming =
  (sv) => (target) => (config) => () => {
    sv.value = withTiming(target, config);
  };

// Write shared value with decay
export const writeSharedValueWithDecay = (sv) => (config) => () => {
  sv.value = withDecay(config);
};

// Write shared value with delay
export const writeSharedValueWithDelay = (sv) => (ms) => (animation) => () => {
  sv.value = withDelay(ms, animation);
};

// Standalone animation builders (for composing)
export const withSpringImpl = (target) => (config) =>
  withSpring(target, config);
export const withTimingImpl = (target) => (config) =>
  withTiming(target, config);
export const withDecayImpl = (config) => withDecay(config);
export const withDelayImpl = (ms) => (anim) => withDelay(ms, anim);
export const withSequenceImpl = (anims) => withSequence(...anims);
export const withRepeatImpl = (anim) => (count) => (reverse) =>
  withRepeat(anim, count, reverse);

export const withClampImpl = (config) => (anim) => withClamp(config, anim);

// Interpolation
export const interpolateImpl =
  (value) => (inputRange) => (outputRange) => (extrapolation) =>
    interpolate(value, inputRange, outputRange, extrapolation);

// Write a composed animation value to a shared value
export const animateImpl = (sv) => (animValue) => () => {
  sv.value = animValue;
};

// Cancel animation on a shared value
export const cancelAnimationImpl = (sv) => () => cancelAnimation(sv);

// Extrapolation constants
export const extrapolationClamp = Extrapolation.CLAMP;
export const extrapolationExtend = Extrapolation.EXTEND;
export const extrapolationIdentity = Extrapolation.IDENTITY;

// Layout animations
export const linearTransition = LinearTransition;
export const linearTransitionDuration = (ms) => LinearTransition.duration(ms);
export const fadeIn = FadeIn;
export const fadeOut = FadeOut;
export const fadeInDown = FadeInDown;
export const fadeOutUp = FadeOutUp;
export const fadeInDuration = (ms) => FadeIn.duration(ms);
export const fadeOutDuration = (ms) => FadeOut.duration(ms);

// Easing functions
export const easingLinear = Easing.linear;
export const easingEase = Easing.ease;
export const easingQuad = Easing.quad;
export const easingCubic = Easing.cubic;
export const easingSin = Easing.sin;
export const easingCircle = Easing.circle;
export const easingExp = Easing.exp;
export const easingBounce = Easing.bounce;
export const easingIn = (e) => Easing.in(e);
export const easingOut = (e) => Easing.out(e);
export const easingInOut = (e) => Easing.inOut(e);
export const easingBezier = (x1) => (y1) => (x2) => (y2) =>
  Easing.bezier(x1, y1, x2, y2);
