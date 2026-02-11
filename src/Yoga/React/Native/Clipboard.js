import { Clipboard } from "react-native";

export const getStringImpl = (onError, onSuccess) => {
  Clipboard.getString().then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const setString = (content) => () => Clipboard.setString(content);
