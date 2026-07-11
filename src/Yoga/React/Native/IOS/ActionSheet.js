import { ActionSheetIOS, Platform } from "react-native";

export const showActionSheetImpl = (options, callback) => {
  if (Platform.OS !== "ios") return;
  ActionSheetIOS.showActionSheetWithOptions(options, (index) =>
    callback(index)()
  );
};

export const showShareActionSheetImpl = (options, callback) => {
  if (Platform.OS !== "ios") return;
  ActionSheetIOS.showShareActionSheetWithOptions(
    options,
    (_error) => {},
    (completed, activityType) =>
      callback({
        action: completed ? "sharedAction" : "dismissedAction",
        activityType: activityType || "",
      })()
  );
};

export const dismissActionSheet = () => {
  if (Platform.OS !== "ios") return;
  if (ActionSheetIOS.dismissActionSheet) ActionSheetIOS.dismissActionSheet();
};
