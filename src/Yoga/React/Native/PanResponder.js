import { PanResponder } from "react-native";
export const createImpl = (config) => PanResponder.create(config);
export const panHandlers = (pr) => pr.panHandlers;
