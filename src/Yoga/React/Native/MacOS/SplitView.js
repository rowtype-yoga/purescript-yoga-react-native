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
  const [hovered, setHovered] = useState(false);
  const containerRef = useRef(null);
  const startWidth = useRef(sidebarWidth);
  const widthRef = useRef(sidebarWidth);
  widthRef.current = sidebarWidth;

  const panRef = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: () => true,
      onMoveShouldSetPanResponder: () => true,
      onPanResponderGrant: () => {
        startWidth.current = widthRef.current;
      },
      onPanResponderMove: (_, gesture) => {
        const newWidth = Math.max(minPaneWidth, startWidth.current + gesture.dx);
        setSidebarWidth(newWidth);
      },
      onPanResponderRelease: () => {
        if (typeof onDividerPosition === "function") {
          onDividerPosition({ position: widthRef.current })();
        }
      },
    })
  );

  const kids = Children.toArray(children);
  const leftChild = kids[0] || null;
  const rightChild = kids[1] || null;

  const dColor = dividerColor || "rgba(128,128,128,0.3)";
  const dHoverColor = dividerHoverColor || "rgba(128,128,128,0.6)";

  return React.createElement(
    View,
    {
      ref: containerRef,
      style: [{ flexDirection: "row" }, style],
      ...rest,
    },
    leftChild && React.cloneElement(leftChild, {
      style: [leftChild.props.style, { width: sidebarWidth, overflow: "hidden" }],
    }),
    React.createElement(View, {
      ...panRef.current.panHandlers,
      onMouseEnter: () => setHovered(true),
      onMouseLeave: () => setHovered(false),
      style: {
        width: 9,
        cursor: "col-resize",
        alignItems: "center",
        justifyContent: "center",
      },
    },
      React.createElement(View, {
        style: {
          width: dividerThickness,
          height: "100%",
          backgroundColor: hovered ? dHoverColor : dColor,
        },
        pointerEvents: "none",
      })
    ),
    rightChild && React.cloneElement(rightChild, {
      style: [rightChild.props.style, { flex: 1, overflow: "hidden" }],
    })
  );
});
