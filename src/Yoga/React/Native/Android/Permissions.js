import { PermissionsAndroid, Platform } from "react-native";

const P =
  Platform.OS === "android" && PermissionsAndroid
    ? PermissionsAndroid.PERMISSIONS
    : {};

export const readCalendar = P.READ_CALENDAR || "android.permission.READ_CALENDAR";
export const writeCalendar = P.WRITE_CALENDAR || "android.permission.WRITE_CALENDAR";
export const camera = P.CAMERA || "android.permission.CAMERA";
export const readContacts = P.READ_CONTACTS || "android.permission.READ_CONTACTS";
export const writeContacts = P.WRITE_CONTACTS || "android.permission.WRITE_CONTACTS";
export const getAccounts = P.GET_ACCOUNTS || "android.permission.GET_ACCOUNTS";
export const accessFineLocation = P.ACCESS_FINE_LOCATION || "android.permission.ACCESS_FINE_LOCATION";
export const accessCoarseLocation = P.ACCESS_COARSE_LOCATION || "android.permission.ACCESS_COARSE_LOCATION";
export const accessBackgroundLocation = P.ACCESS_BACKGROUND_LOCATION || "android.permission.ACCESS_BACKGROUND_LOCATION";
export const recordAudio = P.RECORD_AUDIO || "android.permission.RECORD_AUDIO";
export const readPhoneState = P.READ_PHONE_STATE || "android.permission.READ_PHONE_STATE";
export const callPhone = P.CALL_PHONE || "android.permission.CALL_PHONE";
export const readCallLog = P.READ_CALL_LOG || "android.permission.READ_CALL_LOG";
export const writeCallLog = P.WRITE_CALL_LOG || "android.permission.WRITE_CALL_LOG";
export const bodySensors = P.BODY_SENSORS || "android.permission.BODY_SENSORS";
export const sendSms = P.SEND_SMS || "android.permission.SEND_SMS";
export const receiveSms = P.RECEIVE_SMS || "android.permission.RECEIVE_SMS";
export const readSms = P.READ_SMS || "android.permission.READ_SMS";
export const receiveWapPush = P.RECEIVE_WAP_PUSH || "android.permission.RECEIVE_WAP_PUSH";
export const receiveMms = P.RECEIVE_MMS || "android.permission.RECEIVE_MMS";
export const readExternalStorage = P.READ_EXTERNAL_STORAGE || "android.permission.READ_EXTERNAL_STORAGE";
export const writeExternalStorage = P.WRITE_EXTERNAL_STORAGE || "android.permission.WRITE_EXTERNAL_STORAGE";
export const bluetoothConnect = P.BLUETOOTH_CONNECT || "android.permission.BLUETOOTH_CONNECT";
export const bluetoothScan = P.BLUETOOTH_SCAN || "android.permission.BLUETOOTH_SCAN";
export const bluetoothAdvertise = P.BLUETOOTH_ADVERTISE || "android.permission.BLUETOOTH_ADVERTISE";
export const nearbyWifiDevices = P.NEARBY_WIFI_DEVICES || "android.permission.NEARBY_WIFI_DEVICES";
export const postNotifications = P.POST_NOTIFICATIONS || "android.permission.POST_NOTIFICATIONS";
export const readMediaImages = P.READ_MEDIA_IMAGES || "android.permission.READ_MEDIA_IMAGES";
export const readMediaVideo = P.READ_MEDIA_VIDEO || "android.permission.READ_MEDIA_VIDEO";
export const readMediaAudio = P.READ_MEDIA_AUDIO || "android.permission.READ_MEDIA_AUDIO";
export const activityRecognition = P.ACTIVITY_RECOGNITION || "android.permission.ACTIVITY_RECOGNITION";

const RESULTS =
  Platform.OS === "android" && PermissionsAndroid
    ? PermissionsAndroid.RESULTS
    : { GRANTED: "granted", DENIED: "denied", NEVER_ASK_AGAIN: "never_ask_again" };

export const requestImpl = (permission) => (onError, onSuccess) => {
  if (Platform.OS !== "android") {
    onSuccess(RESULTS.DENIED);
    return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
  }
  PermissionsAndroid.request(permission).then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const requestMultipleImpl = (permissions) => (onError, onSuccess) => {
  if (Platform.OS !== "android") {
    onSuccess([]);
    return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
  }
  PermissionsAndroid.requestMultiple(permissions).then(
    (result) => onSuccess(permissions.map((p) => result[p])),
    onError
  );
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const checkImpl = (permission) => (onError, onSuccess) => {
  if (Platform.OS !== "android") {
    onSuccess(false);
    return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
  }
  PermissionsAndroid.check(permission).then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

export const isGranted = (status) => status === RESULTS.GRANTED;
export const isDenied = (status) => status === RESULTS.DENIED;
export const isNeverAskAgain = (status) => status === RESULTS.NEVER_ASK_AGAIN;
