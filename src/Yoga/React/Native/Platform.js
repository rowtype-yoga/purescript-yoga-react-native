import { Platform } from "react-native";

export const os = Platform.OS;

export const version = Platform.Version;

export const isTV = Platform.isTV;

export const selectImpl = (specifics) => Platform.select(specifics);
