import React from "react";

export const createNativeElementImpl = (component, props, children) => {
  if (
    typeof children === "undefined" ||
    children == null ||
    children.length === 0
  )
    return React.createElement(component, props);
  if (!Array.isArray(children))
    return React.createElement(component, props, children);
  return React.createElement(component, props, ...children);
};

export const createNativeElementNoKidsImpl = React.createElement;
