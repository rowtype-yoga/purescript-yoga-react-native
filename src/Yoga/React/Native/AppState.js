import { AppState } from "react-native";

export const currentState = () => AppState.currentState;

export const addEventListenerImpl = (type, listener) => {
  return AppState.addEventListener(type, listener);
};

export const removeSubscription = (subscription) => () => {
  subscription.remove();
};
