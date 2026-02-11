import { Share } from "react-native";

export const shareImpl = (content) => (onError, onSuccess) => {
  Share.share(content).then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};
