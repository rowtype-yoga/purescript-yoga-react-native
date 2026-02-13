import twrnc from "twrnc";
import { StyleSheet } from "react-native";

export function stylesImpl(arr) {
  return arr;
}

export function tw(classString) {
  return twrnc.style(classString);
}
