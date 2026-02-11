import React from "react";
import { Text, AppRegistry } from "react-native";

export function stringImpl(str) {
  return React.createElement(Text, null, str);
}

export const registerComponentImpl = function (name, comp) {
  AppRegistry.registerComponent(name, () => comp);
};
