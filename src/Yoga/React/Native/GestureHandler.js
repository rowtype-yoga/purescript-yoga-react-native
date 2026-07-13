import React, { useEffect, useRef } from "react";
import { Animated, Dimensions, PanResponder } from "react-native";
import { GestureHandlerRootView } from "react-native-gesture-handler";

const springConfig = (model, target, velocity) => {
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
    velocity,
    toValue: target,
    useNativeDriver: true,
  };
};

export const useNativeSnapPanImpl =
  (initial) => (snapPoints) => (chooseTarget) => (model) => () => {
    const positionRef = useRef(null);
    const basePositionRef = useRef(initial);
    const animationRef = useRef(null);
    const mountedRef = useRef(true);
    const responderRef = useRef(null);

    if (positionRef.current === null) {
      positionRef.current = new Animated.Value(initial);
    }

    const settle = (dx, velocity) => {
      const current = basePositionRef.current + dx;
      const target = chooseTarget({ position: current, velocity });
      positionRef.current.setValue(current);
      basePositionRef.current = current;

      animationRef.current?.stop();
      const animation = Animated.spring(positionRef.current, {
        ...springConfig(model, target, velocity),
        useNativeDriver: false,
      });
      animationRef.current = animation;
      animation.start(({ finished }) => {
        if (finished) basePositionRef.current = target;
        if (animationRef.current === animation) animationRef.current = null;
      });
    };

    if (responderRef.current === null) {
      responderRef.current = PanResponder.create({
        onStartShouldSetPanResponder: () => false,
        onMoveShouldSetPanResponder: (_event, gesture) =>
          Math.abs(gesture.dx) > 4 && Math.abs(gesture.dx) > Math.abs(gesture.dy),
        onPanResponderGrant: () => {
          animationRef.current?.stop();
          animationRef.current = null;
          positionRef.current.stopAnimation((current) => {
            if (!mountedRef.current) return;
            basePositionRef.current = current;
          });
        },
        onPanResponderMove: (_event, gesture) => {
          positionRef.current.setValue(basePositionRef.current + gesture.dx);
        },
        onPanResponderRelease: (_event, gesture) => {
          settle(gesture.dx, gesture.vx);
        },
        onPanResponderTerminate: (_event, gesture) => {
          settle(gesture.dx, 0);
        },
        onPanResponderTerminationRequest: () => false,
      });
    }

    useEffect(() => {
      mountedRef.current = true;
      return () => {
        mountedRef.current = false;
        animationRef.current?.stop();
        positionRef.current.stopAnimation();
      };
    }, []);

    return {
      position: positionRef.current,
      snapPoints,
      panHandlers: responderRef.current.panHandlers,
    };
  };

export const positionImpl = (pan) => pan.position;

export const gestureHandlerRootView = (child) =>
  React.createElement(GestureHandlerRootView, { style: { flex: 1 } }, child);

export const panGestureView = (pan) => (child) =>
  React.cloneElement(child, pan.panHandlers);

export const useNativeSwipeImpl = (config, onLeft, onRight) => {
  const positionRef = useRef(null);
  const basePositionRef = useRef(0);
  const animationRef = useRef(null);
  const mountedRef = useRef(true);
  const committingRef = useRef(false);
  const gestureTokenRef = useRef(0);
  const captureRef = useRef(null);
  const responderRef = useRef(null);
  const configRef = useRef(config);
  const onLeftRef = useRef(onLeft);
  const onRightRef = useRef(onRight);

  configRef.current = config;
  onLeftRef.current = onLeft;
  onRightRef.current = onRight;

  if (positionRef.current === null) {
    positionRef.current = new Animated.Value(0);
  }

  const stopActiveAnimation = () => {
    const animation = animationRef.current;
    animationRef.current = null;
    animation?.stop();
  };

  const startSpring = (target, velocity, model, onFinished) => {
    const animation = Animated.spring(positionRef.current, {
      ...springConfig(model, target, velocity),
      // PanResponder reads and resets this value between cards. Keeping the
      // spring on the JS driver prevents the native value from remaining
      // detached/offscreen after the first completed dismissal.
      useNativeDriver: false,
    });
    animationRef.current = animation;
    animation.start(({ finished }) => {
      if (animationRef.current !== animation) return;
      animationRef.current = null;
      if (mountedRef.current) onFinished(finished);
    });
  };

  const springHome = (current, velocity) => {
    stopActiveAnimation();
    positionRef.current.setValue(current);
    basePositionRef.current = current;
    startSpring(0, velocity, configRef.current.returnSpring, (finished) => {
      if (finished) basePositionRef.current = 0;
    });
  };

  const commit = (direction, current, velocity) => {
    if (committingRef.current) return;
    stopActiveAnimation();
    committingRef.current = true;
    positionRef.current.setValue(current);
    basePositionRef.current = current;

    const measuredWidth = Dimensions.get("window").width;
    const windowWidth = Number.isFinite(measuredWidth) ? measuredWidth : 0;
    const threshold = Math.abs(configRef.current.dismissalDistance);
    const offscreenDistance = Math.max(windowWidth + threshold, Math.abs(current) + 1);
    const destination = direction * Math.max(1, offscreenDistance);

    startSpring(
      destination,
      velocity,
      configRef.current.dismissalSpring,
      (finished) => {
        if (!committingRef.current) return;
        // Always unlock and return the reusable native value to center. Only a
        // finished dismissal is allowed to notify application state.
        positionRef.current.setValue(0);
        basePositionRef.current = 0;
        committingRef.current = false;
        if (!finished) return;
        const callback = direction < 0 ? onLeftRef.current : onRightRef.current;
        callback();
      },
    );
  };

  const finishGesture = (terminal) => {
    if (committingRef.current) return;
    const dx = Number.isFinite(terminal.dx) ? terminal.dx : 0;
    const velocity = Number.isFinite(terminal.velocity) ? terminal.velocity : 0;
    const current = basePositionRef.current + dx;

    if (terminal.terminated) {
      springHome(current, 0);
      return;
    }

    const distanceThreshold = Math.abs(configRef.current.dismissalDistance);
    const velocityThreshold = Math.abs(configRef.current.dismissalVelocity);
    const distanceCommits = Math.abs(current) >= distanceThreshold;
    const velocityCommits = Math.abs(velocity) >= velocityThreshold;
    const direction = distanceCommits ? Math.sign(current) : Math.sign(velocity);

    if ((distanceCommits || velocityCommits) && direction !== 0) {
      commit(direction, current, velocity);
    } else {
      springHome(current, velocity);
    }
  };

  const finishOrDefer = (terminal) => {
    const capture = captureRef.current;
    if (capture !== null) {
      capture.dx = terminal.dx;
      capture.terminal = terminal;
      return;
    }
    finishGesture(terminal);
  };

  if (responderRef.current === null) {
    const shouldClaimHorizontalMove = (_event, gesture) =>
      !committingRef.current &&
      Math.abs(gesture.dx) > 4 &&
      Math.abs(gesture.dx) > Math.abs(gesture.dy);

    responderRef.current = PanResponder.create({
      onStartShouldSetPanResponder: () => false,
      onStartShouldSetPanResponderCapture: () => false,
      onMoveShouldSetPanResponder: shouldClaimHorizontalMove,
      onMoveShouldSetPanResponderCapture: shouldClaimHorizontalMove,
      onPanResponderGrant: () => {
        if (committingRef.current) return;
        const token = ++gestureTokenRef.current;
        stopActiveAnimation();
        const capture = { token, dx: 0, terminal: null };
        captureRef.current = capture;
        positionRef.current.stopAnimation((visiblePosition) => {
          if (
            !mountedRef.current ||
            captureRef.current !== capture ||
            gestureTokenRef.current !== token
          ) {
            return;
          }
          basePositionRef.current = visiblePosition;
          captureRef.current = null;
          positionRef.current.setValue(visiblePosition + capture.dx);
          if (capture.terminal !== null) finishGesture(capture.terminal);
        });
      },
      onPanResponderMove: (_event, gesture) => {
        if (committingRef.current) return;
        const dx = Number.isFinite(gesture.dx) ? gesture.dx : 0;
        if (captureRef.current !== null) {
          captureRef.current.dx = dx;
          return;
        }
        positionRef.current.setValue(basePositionRef.current + dx);
      },
      onPanResponderRelease: (_event, gesture) => {
        finishOrDefer({ dx: gesture.dx, velocity: gesture.vx, terminated: false });
      },
      onPanResponderTerminate: (_event, gesture) => {
        finishOrDefer({ dx: gesture.dx, velocity: 0, terminated: true });
      },
      onPanResponderTerminationRequest: () => false,
      onShouldBlockNativeResponder: () => true,
    });
  }

  useEffect(() => {
    mountedRef.current = true;
    return () => {
      mountedRef.current = false;
      gestureTokenRef.current += 1;
      captureRef.current = null;
      committingRef.current = false;
      stopActiveAnimation();
      positionRef.current.stopAnimation();
    };
  }, []);

  return {
    position: positionRef.current,
    dismissalDistance: Math.max(1, Math.abs(config.dismissalDistance)),
    panHandlers: responderRef.current.panHandlers,
  };
};
export const swipeProgressImpl = (swipe) =>
  swipe.position.interpolate({
    inputRange: [-swipe.dismissalDistance, 0, swipe.dismissalDistance],
    outputRange: [1, 0, 1],
    extrapolate: "clamp",
  });

export const swipePositionImpl = (swipe) => swipe.position;

export const swipeGestureViewImpl = (swipe, child) =>
  React.cloneElement(child, {
    ...swipe.panHandlers,
    pointerEvents: "box-only",
    collapsable: false,
  });
