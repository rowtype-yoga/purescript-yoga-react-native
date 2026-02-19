import React, { useState, useRef, useCallback, Children } from "react";
import { View } from "react-native";

export const splitViewImpl = React.forwardRef((props, ref) => {
  const {
    initialPosition = 240,
    minPaneWidth = 100,
    dividerThickness = 1,
    dividerColor,
    dividerHoverColor,
    onDividerPosition,
    style,
    children,
    ...rest
  } = props;

  const [sidebarWidth, setSidebarWidth] = useState(initialPosition);
  const [dragging, setDragging] = useState(false);
  const [hovered, setHovered] = useState(false);
  const widthRef = useRef(sidebarWidth);
  widthRef.current = sidebarWidth;
  const startX = useRef(0);
  const startW = useRef(0);

  const onGrant = useCallback((e) => {
    startX.current = e.nativeEvent.pageX;
    startW.current = widthRef.current;
    setDragging(true);
  }, []);

  const onMove = useCallback((e) => {
    const dx = e.nativeEvent.pageX - startX.current;
    const newWidth = Math.max(minPaneWidth, startW.current + dx);
    setSidebarWidth(newWidth);
  }, [minPaneWidth]);

  const onRelease = useCallback(() => {
    setDragging(false);
    if (typeof onDividerPosition === "function") {
      onDividerPosition({ position: widthRef.current })();
    }
  }, [onDividerPosition]);

  const kids = Children.toArray(children);
  const leftChild = kids[0] || null;
  const rightChild = kids[1] || null;

  const dColor = dividerColor || "rgba(128,128,128,0.3)";
  const dHoverColor = dividerHoverColor || "rgba(128,128,128,0.6)";
  const active = dragging || hovered;

  return React.createElement(
    View,
    {
      ref,
      style: [{ flexDirection: "row" }, style],
      ...rest,
    },
    leftChild && React.cloneElement(leftChild, {
      style: [leftChild.props.style, { width: sidebarWidth }],
    }),
    React.createElement(View, {
      onStartShouldSetResponder: () => true,
      onMoveShouldSetResponder: () => true,
      onResponderGrant: onGrant,
      onResponderMove: onMove,
      onResponderRelease: onRelease,
      onResponderTerminate: onRelease,
      onMouseEnter: () => setHovered(true),
      onMouseLeave: () => setHovered(false),
      style: {
        width: dividerThickness,
        cursor: "col-resize",
        backgroundColor: active ? dHoverColor : dColor,
      },
    }),
    rightChild && React.cloneElement(rightChild, {
      style: [rightChild.props.style, { flex: 1 }],
    })
  );
});
