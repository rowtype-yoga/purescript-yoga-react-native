import { Dimensions, useWindowDimensions } from "react-native";

export const getImpl = (dim) => () => Dimensions.get(dim);

export const useWindowDimensionsImpl = useWindowDimensions;
