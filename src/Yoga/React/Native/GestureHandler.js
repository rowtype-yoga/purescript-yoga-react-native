import React, { useEffect, useRef } from "react";
import { Animated } from "react-native";
import {
  GestureHandlerRootView,
  PanGestureHandler,
  State,
} from "react-native-gesture-handler";

const settleStates = new Set([State.END, State.CANCELLED, State.FAILED]);

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
    const baseRef = useRef(null);
    const dragRef = useRef(null);
    const positionRef = useRef(null);
    const basePositionRef = useRef(initial);
    const animationRef = useRef(null);
    const mountedRef = useRef(true);
    const captureGenerationRef = useRef(0);
    const capturePendingRef = useRef(false);
    const pendingSettleRef = useRef(null);

    if (baseRef.current === null) {
      baseRef.current = new Animated.Value(initial);
      dragRef.current = new Animated.Value(0);
      positionRef.current = Animated.add(baseRef.current, dragRef.current);
    }

    const gestureEventRef = useRef(null);
    if (gestureEventRef.current === null) {
      gestureEventRef.current = Animated.event(
        [{ nativeEvent: { translationX: dragRef.current } }],
        { useNativeDriver: true },
      );
    }

    const begin = () => {
      const captureGeneration = ++captureGenerationRef.current;
      capturePendingRef.current = true;
      pendingSettleRef.current = null;
      animationRef.current?.stop();
      animationRef.current = null;
      baseRef.current.stopAnimation((current) => {
        if (!mountedRef.current || captureGeneration !== captureGenerationRef.current) return;
        basePositionRef.current = current;
        baseRef.current.setValue(current);
        capturePendingRef.current = false;
        if (pendingSettleRef.current !== null) {
          const pending = pendingSettleRef.current;
          pendingSettleRef.current = null;
          settleValues(pending.translation, pending.velocity);
        }
      });
      dragRef.current.stopAnimation();
      dragRef.current.setValue(0);
    };

    const settleValues = (translation, velocity) => {
      const current = basePositionRef.current + translation;
      const target = chooseTarget({ position: current, velocity });

      dragRef.current.stopAnimation();
      dragRef.current.setValue(0);
      basePositionRef.current = current;
      baseRef.current.setValue(current);

      animationRef.current?.stop();
      const animation = Animated.spring(
        baseRef.current,
        springConfig(model, target, velocity),
      );
      animationRef.current = animation;
      animation.start(({ finished }) => {
        if (finished) basePositionRef.current = target;
        if (animationRef.current === animation) animationRef.current = null;
      });
    };

    const settle = (event, includeVelocity) => {
      const translation = event.nativeEvent.translationX ?? 0;
      const velocity = includeVelocity ? (event.nativeEvent.velocityX ?? 0) : 0;
      if (capturePendingRef.current) {
        pendingSettleRef.current = { translation, velocity };
      } else {
        settleValues(translation, velocity);
      }
    };

    const stateChangeRef = useRef(null);
    stateChangeRef.current = (event) => {
      const state = event.nativeEvent.state;
      if (state === State.BEGAN) begin();
      else if (settleStates.has(state)) settle(event, state === State.END);
    };

    useEffect(() => {
      mountedRef.current = true;
      return () => {
        mountedRef.current = false;
        captureGenerationRef.current += 1;
        pendingSettleRef.current = null;
        animationRef.current?.stop();
        baseRef.current.stopAnimation();
        dragRef.current.stopAnimation();
      };
    }, []);

    return {
      position: positionRef.current,
      snapPoints,
      onGestureEvent: gestureEventRef.current,
      onHandlerStateChange: (event) => stateChangeRef.current(event),
    };
  };

export const positionImpl = (pan) => pan.position;

export const gestureHandlerRootView = (child) =>
  React.createElement(GestureHandlerRootView, { style: { flex: 1 } }, child);

export const panGestureView = (pan) => (child) =>
  React.createElement(
    PanGestureHandler,
    {
      activeOffsetX: [-4, 4],
      failOffsetY: [-12, 12],
      onGestureEvent: pan.onGestureEvent,
      onHandlerStateChange: pan.onHandlerStateChange,
    },
    child,
  );
