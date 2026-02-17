/**
 * @format
 */

import { AppRegistry, Text, View } from "react-native";
import React from "react";

function App() {
  return React.createElement(
    View,
    {
      style: {
        flex: 1,
        backgroundColor: "#1e1e1e",
        justifyContent: "center",
        alignItems: "center",
      },
    },
    React.createElement(
      Text,
      { style: { color: "#fff", fontSize: 24, fontWeight: "bold" } },
      "Minimal test app"
    ),
    React.createElement(
      Text,
      { style: { color: "#aaa", fontSize: 14, marginTop: 8 } },
      "If you see this, React Native macOS works"
    )
  );
}

AppRegistry.registerComponent("YogaReactExample", () => App);
