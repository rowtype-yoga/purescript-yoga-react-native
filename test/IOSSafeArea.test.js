import { afterAll, beforeAll, describe, expect, it } from "vitest";
import React from "react";
import { act, create } from "react-test-renderer";
import {
  SafeAreaProvider,
  SafeAreaView,
} from "react-native-safe-area-context";
import {
  safeAreaProviderImpl,
  safeAreaViewImpl,
} from "../src/Yoga/React/Native/IOS/SafeArea.js";

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

  it("delegates the provider export to react-native-safe-area-context", () => {
    expect(safeAreaProviderImpl).toBe(SafeAreaProvider);
  });

  it("renders the dependency view with props, children, and ref intact", () => {
    const nativeView = { kind: "safe-area-view" };
    const ref = React.createRef();
    let renderer;

    act(() => {
      renderer = create(
        React.createElement(
          safeAreaViewImpl,
          {
            ref,
            edges: ["top", "bottom"],
            mode: "margin",
            testID: "catalogue-safe-area",
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
      edges: ["top", "bottom"],
      mode: "margin",
      testID: "catalogue-safe-area",
    });
    expect(child.props.label).toBe("catalogue content");
    expect(ref.current).toBe(nativeView);

    act(() => renderer.unmount());
  });
});
