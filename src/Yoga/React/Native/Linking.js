import { Linking } from "react-native";

export const openURLImpl = (url) => (onError, onSuccess) => {
  Linking.openURL(url).then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const canOpenURLImpl = (url) => (onError, onSuccess) => {
  Linking.canOpenURL(url).then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const getInitialURLImpl = (onError, onSuccess) => {
  Linking.getInitialURL().then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const openSettingsImpl = (onError, onSuccess) => {
  Linking.openSettings().then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};
