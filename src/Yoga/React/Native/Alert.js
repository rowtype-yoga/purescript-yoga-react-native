import { Alert } from "react-native";

export const alertImpl = (title, message, buttons) => {
  const mapped = buttons.length === 0 ? undefined : buttons.map((b) => ({
    text: b.text,
    onPress: b.onPress,
    style: b.style,
  }));
  Alert.alert(title, message, mapped);
};
