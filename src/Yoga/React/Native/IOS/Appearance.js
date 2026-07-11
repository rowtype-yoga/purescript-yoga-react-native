import { Appearance } from "react-native";

export const light = "light";
export const dark = "dark";

export const getColorSchemeImpl = () => {
  return Appearance.getColorScheme() || "light";
};

export const setColorSchemeImpl = (scheme) => {
  if (Appearance.setColorScheme) Appearance.setColorScheme(scheme);
};

export const addChangeListenerImpl = (callback) => {
  return Appearance.addChangeListener(({ colorScheme }) =>
    callback(colorScheme || "light")()
  );
};

export const removeChangeListenerImpl = (subscription) => {
  if (subscription && subscription.remove) subscription.remove();
};
