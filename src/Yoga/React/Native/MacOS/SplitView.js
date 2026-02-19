import React, { useState, useRef, Children } from "react";
import { View, PanResponder } from "react-native";

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
  const startWidth = useRef(0);

  const panRef = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: () => true,
      onMoveShouldSetPanResponder: () => true,
      onPanResponderGrant: () => {
        startWidth.current = widthRef.current;
        setDragging(true);
      },
      onPanResponderMove: (_, gesture) => {
        const newWidth = Math.max(minPaneWidth, startWidth.current + gesture.dx);
        setSidebarWidth(newWidth);
      },
      onPanResponderRelease: () => {
        setDragging(false);
        if (typeof onDividerPosition === "function") {
          onDividerPosition({ position: widthRef.current })();
        }
      },
      onPanResponderTerminate: () => {
        setDragging(false);
      },
    })
  );

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
    // 1px visible line with wider invisible PanResponder hit area
    React.createElement(View, {
      style: {
        width: dividerThickness,
        backgroundColor: active ? dHoverColor : dColor,
      },
    },
      React.createElement(View, {
        ...panRef.current.panHandlers,
        onMouseEnter: () => setHovered(true),
        onMouseLeave: () => setHovered(false),
        style: {
          position: "absolute",
          top: 0,
          bottom: 0,
          left: -4,
          right: -4,
          cursor: "col-resize",
          zIndex: 10,
        },
      })
    ),
    rightChild && React.cloneElement(rightChild, {
      style: [rightChild.props.style, { flex: 1 }],
    })
  );
});
