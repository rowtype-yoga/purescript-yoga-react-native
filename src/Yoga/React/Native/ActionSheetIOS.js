import { ActionSheetIOS } from "react-native";
export const showActionSheetImpl = (options, callback) => {
  ActionSheetIOS.showActionSheetWithOptions(options, callback);
};
export const dismissActionSheet = () => ActionSheetIOS.dismissActionSheet();
