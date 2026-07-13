import { afterAll, beforeAll, describe, expect, it } from "vitest";
import React from "react";
import { act, create } from "react-test-renderer";
import { SafeAreaView } from "react-native-safe-area-context";
import { safeAreaViewImpl } from "../src/Yoga/React/Native/IOS/SafeArea.js";

describe("iOS SafeArea FFI", () => {
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


  it("encodes typed edges and mode while forwarding children, ref, and base props", () => {
    const typedEdges = Object.freeze({ kind: "opaque-edges" });
    const typedMode = Symbol("opaque-safe-area-mode");
    const style = { paddingHorizontal: 12 };
    const nativeView = { kind: "safe-area-view" };
    const ref = React.createRef();
    const SafeAreaBridge = safeAreaViewImpl(
      (edges) => {
        if (edges !== typedEdges) throw new Error("unexpected typed edges");
        return ["top", "right", "bottom", "left"];
      },
      (mode) => {
        if (mode !== typedMode) throw new Error("unexpected typed mode");
        return "margin";
      },
    );
    let renderer;

    act(() => {
      renderer = create(
        React.createElement(
          SafeAreaBridge,
          {
            ref,
            edges: typedEdges,
            mode: typedMode,
            testID: "catalogue-safe-area",
            accessibilityLabel: "Safe content",
            style,
          },
          React.createElement("MockChild", { label: "catalogue content" }),
        ),
        {
          createNodeMock: (element) =>
            element.type === "MockSafeAreaView" ? nativeView : null,
        },
      );
    });

    const dependencyView = renderer.root.findByType(SafeAreaView);
    const child = renderer.root.findByType("MockChild");

    expect(dependencyView.props).toMatchObject({
      edges: ["top", "right", "bottom", "left"],
      mode: "margin",
      testID: "catalogue-safe-area",
      accessibilityLabel: "Safe content",
      style,
    });
    expect(dependencyView.props.style).toBe(style);
    expect(child.props.label).toBe("catalogue content");
    expect(ref.current).toBe(nativeView);

    act(() => renderer.unmount());
  });
});
