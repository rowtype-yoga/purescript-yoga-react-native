import { Alert, Platform } from "react-native";

export const alertImpl = (style, title, message, buttons) => () => {
  if (Platform.OS !== "macos") return;
  const mapped = buttons.map((b, i) => ({ text: b, onPress: () => {} }));
  if (mapped.length === 0) mapped.push({ text: "OK", onPress: () => {} });
  Alert.alert(title, message, mapped);
};
