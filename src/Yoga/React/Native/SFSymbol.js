import { requireNativeComponent, Platform } from "react-native";

export const _sfSymbolImpl =
  Platform.OS === "macos" ? requireNativeComponent("SFSymbol") : null;
