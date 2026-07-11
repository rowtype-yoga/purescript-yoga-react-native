import { Alert, Platform } from "react-native";

export const alertImpl = ({
  title = "",
  message = "",
  buttons = [],
  cancelable = true,
  onDismiss,
}) => {
  const mapped = buttons.map((b) => ({
    text: b.text,
    onPress: typeof b.onPress === "function" ? () => b.onPress() : undefined,
    style: b.style || "default",
  }));
  if (mapped.length === 0) mapped.push({ text: "OK" });
  const options = { cancelable };
  if (typeof onDismiss === "function") {
    options.onDismiss = () => onDismiss();
  }
  Alert.alert(title, message, mapped, options);
};
