import React from "react";

export const SafeAreaProvider = ({ children }) =>
  React.createElement("MockSafeAreaProvider", null, children);

export const SafeAreaView = React.forwardRef((props, ref) =>
  React.createElement("MockSafeAreaView", { ...props, ref }),
);
