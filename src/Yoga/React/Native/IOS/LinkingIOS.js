import { Linking } from "react-native";

const disposedSubscriptions = new WeakSet();

export const openSettingsImpl = () =>
  Linking.openSettings().then(() => undefined);

export const canOpenURLImpl = (url) => Linking.canOpenURL(url);

export const openURLImpl = (url) =>
  Linking.openURL(url).then(() => undefined);

export const getInitialURLImpl = () => Linking.getInitialURL();

export const addURLListenerImpl = (handler) =>
  Linking.addEventListener("url", (event) => {
    if (event != null && typeof event.url === "string") {
      handler(event.url);
    }
  });

export const disposeLinkingSubscriptionImpl = (subscription) => {
  if (disposedSubscriptions.has(subscription)) return;

  disposedSubscriptions.add(subscription);
  subscription.remove();
};
