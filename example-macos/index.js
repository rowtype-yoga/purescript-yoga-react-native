/**
 * @format
 */

import { AppRegistry, Text, View, LogBox, PlatformColor } from "react-native";
import React from "react";
import { main } from "./output/Main/index.js";

// Global error handler to capture full stack
const originalHandler = ErrorUtils.getGlobalHandler();
ErrorUtils.setGlobalHandler((error, isFatal) => {
  console.error("=== GLOBAL ERROR ===");
  console.error("Fatal:", isFatal);
  console.error("Message:", error?.message);
  console.error("Stack:", error?.stack);
  console.error("ComponentStack:", error?.componentStack);
  if (originalHandler) originalHandler(error, isFatal);
});

try {
  const pc = PlatformColor("controlAccentColor");
  console.log("=== PlatformColor test ===");
  console.log("type:", typeof pc);
  console.log("keys:", Object.keys(pc));
  console.log("JSON:", JSON.stringify(pc));
  console.log("semantic:", pc.semantic);
  console.log("=== CALLING MAIN ===");
  main();
  console.log("=== MAIN COMPLETED ===");
} catch (e) {
  console.error("=== STARTUP ERROR ===");
  console.error(e.message);
  console.error(e.stack);
}
