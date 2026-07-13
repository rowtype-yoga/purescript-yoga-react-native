import { Appearance, useColorScheme } from "react-native";

const disposedSubscriptions = new WeakSet();

const normalizeColorScheme = (scheme) =>
  typeof scheme === "string" ? scheme : null;

export const getColorSchemeImpl = () =>
  normalizeColorScheme(Appearance.getColorScheme());

export const setColorSchemeImpl = (scheme) => {
  Appearance.setColorScheme(scheme);
};

export const useColorSchemeImpl = () => normalizeColorScheme(useColorScheme());

export const addChangeListenerImpl = (callback) =>
  Appearance.addChangeListener((event) => {
    callback(normalizeColorScheme(event?.colorScheme));
  });

export const disposeAppearanceSubscriptionImpl = (subscription) => {
  if (
    subscription == null ||
    (typeof subscription !== "object" && typeof subscription !== "function") ||
    disposedSubscriptions.has(subscription)
  ) {
    return;
  }

  disposedSubscriptions.add(subscription);
  subscription.remove?.();
};
