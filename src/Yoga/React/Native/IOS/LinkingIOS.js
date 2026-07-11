import { Linking } from "react-native";

export const openSettingsImpl = (onError, onSuccess) => {
  Linking.openSettings().then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const canOpenURLImpl = (url) => (onError, onSuccess) => {
  Linking.canOpenURL(url).then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const openURLImpl = (url) => (onError, onSuccess) => {
  Linking.openURL(url).then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const getInitialURLImpl = (onError, onSuccess) => {
  Linking.getInitialURL().then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const addEventListenerImpl = (eventName, handler) => {
  return Linking.addEventListener(eventName, ({ url }) => handler(url)());
};
