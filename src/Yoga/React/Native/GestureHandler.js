import React, { useEffect, useRef } from "react";
import { Animated, PanResponder } from "react-native";
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
