/**
 * @format
 */

import { AppRegistry, Text, View } from "react-native";
import React from "react";

// Register a fallback error screen first
let startupError = null;

function ErrorScreen() {
  return React.createElement(
    View,
    { style: { flex: 1, padding: 20, backgroundColor: "#300" } },
    React.createElement(
      Text,
      { style: { color: "#fff", fontSize: 16, fontWeight: "bold" } },
      "Startup Error"
    ),
    React.createElement(
      Text,
      { style: { color: "#fcc", fontSize: 13, marginTop: 10 } },
      String(startupError)
    )
  );
}

try {
  const { main } = require("./output/Main/index.js");
  main();
} catch (e) {
  startupError = e.message + "\n\n" + e.stack;
  AppRegistry.registerComponent("YogaReactExample", () => ErrorScreen);
}
