import React from "react";

// Component mocks — just string tags
const View = "View";
const Text = "Text";
const TextInput = "TextInput";
const ScrollView = "ScrollView";
const Pressable = "Pressable";
const Image = "Image";
const ActivityIndicator = "ActivityIndicator";
const FlatList = "FlatList";
const Switch = "Switch";
const Button = "Button";
const TouchableOpacity = "TouchableOpacity";
const TouchableHighlight = "TouchableHighlight";
const TouchableWithoutFeedback = "TouchableWithoutFeedback";
const Modal = "Modal";
const SafeAreaView = "SafeAreaView";
const KeyboardAvoidingView = "KeyboardAvoidingView";
const ImageBackground = "ImageBackground";
const SectionList = "SectionList";
const RefreshControl = "RefreshControl";
const StatusBar = "StatusBar";
const InputAccessoryView = "InputAccessoryView";

// Animated
const AnimatedValue = class {
  constructor(n) {
    this._value = n;
  }
  setValue(n) {
    this._value = n;
  }
  setOffset(n) {
    this._offset = n;
  }
  flattenOffset() {}
  extractOffset() {}
  stopAnimation(cb) {
    if (cb) cb(this._value);
  }
  resetAnimation(cb) {
    if (cb) cb(this._value);
  }
  interpolate(config) {
    return { ...config, _interpolated: true };
  }
};

const AnimatedValueXY = class {
  constructor({ x, y }) {
    this.x = new AnimatedValue(x);
    this.y = new AnimatedValue(y);
  }
  setValue(xy) {
    this.x.setValue(xy.x);
    this.y.setValue(xy.y);
  }
};

const mockCompositeAnimation = () => ({
  start: (cb) => {
    if (cb) cb({ finished: true });
  },
  stop: () => {},
  reset: () => {},
});

const Animated = {
  Value: AnimatedValue,
  ValueXY: AnimatedValueXY,
  timing: (v, config) => mockCompositeAnimation(),
  spring: (v, config) => mockCompositeAnimation(),
  decay: (v, config) => mockCompositeAnimation(),
  parallel: (anims) => mockCompositeAnimation(),
  sequence: (anims) => mockCompositeAnimation(),
  stagger: (time, anims) => mockCompositeAnimation(),
  delay: (time) => mockCompositeAnimation(),
  loop: (anim, config) => mockCompositeAnimation(),
  event: (mapping, config) => () => {},
  add: (a, b) => ({ _type: "add", a, b }),
  subtract: (a, b) => ({ _type: "subtract", a, b }),
  multiply: (a, b) => ({ _type: "multiply", a, b }),
  divide: (a, b) => ({ _type: "divide", a, b }),
  modulo: (a, n) => ({ _type: "modulo", a, n }),
  diffClamp: (a, min, max) => ({ _type: "diffClamp", a, min, max }),
  View: "Animated.View",
  Text: "Animated.Text",
  Image: "Animated.Image",
  ScrollView: "Animated.ScrollView",
};

const useAnimatedValue = (n) => new AnimatedValue(n);

// Easing
const Easing = {
  step0: (t) => (t > 0 ? 1 : 0),
  step1: (t) => (t >= 1 ? 1 : 0),
  linear: (t) => t,
  ease: (t) => t,
  quad: (t) => t * t,
  cubic: (t) => t * t * t,
  poly: (n) => (t) => Math.pow(t, n),
  sin: (t) => 1 - Math.cos((t * Math.PI) / 2),
  circle: (t) => 1 - Math.sqrt(1 - t * t),
  exp: (t) => Math.pow(2, 10 * (t - 1)),
  elastic: (b) => (t) => t,
  back: (s) => (t) => t,
  bounce: (t) => t,
  bezier: (x1, y1, x2, y2) => (t) => t,
  in: (fn) => fn,
  out: (fn) => (t) => 1 - fn(1 - t),
  inOut: (fn) => (t) => (t < 0.5 ? fn(t * 2) / 2 : 1 - fn((1 - t) * 2) / 2),
};

// StyleSheet
const StyleSheet = {
  create: (styles) => styles,
  hairlineWidth: 0.5,
  absoluteFill: { position: "absolute", left: 0, right: 0, top: 0, bottom: 0 },
};

// PanResponder
const PanResponder = {
  create: (config) => ({
    panHandlers: {
      onStartShouldSetResponder: config.onStartShouldSetPanResponder,
      onMoveShouldSetResponder: config.onMoveShouldSetPanResponder,
      onResponderGrant: config.onPanResponderGrant,
      onResponderMove: config.onPanResponderMove,
      onResponderRelease: config.onPanResponderRelease,
      onResponderTerminate: config.onPanResponderTerminate,
    },
  }),
};

// PixelRatio
const PixelRatio = {
  get: () => 2,
  getFontScale: () => 1,
  getPixelSizeForLayoutSize: (n) => n * 2,
  roundToNearestPixel: (n) => Math.round(n * 2) / 2,
};

// AccessibilityInfo
const AccessibilityInfo = {
  isScreenReaderEnabled: () => Promise.resolve(false),
  isReduceMotionEnabled: () => Promise.resolve(false),
  isBoldTextEnabled: () => Promise.resolve(false),
  isGrayscaleEnabled: () => Promise.resolve(false),
  isInvertColorsEnabled: () => Promise.resolve(false),
  isReduceTransparencyEnabled: () => Promise.resolve(false),
  announceForAccessibility: (msg) => {},
};

// ActionSheetIOS
const ActionSheetIOS = {
  showActionSheetWithOptions: (options, callback) => {
    callback(0);
  },
  dismissActionSheet: () => {},
};

// LayoutAnimation
const LayoutAnimation = {
  configureNext: (config) => {},
  Presets: {
    easeInEaseOut: {
      duration: 300,
      create: { type: "easeInEaseOut", property: "opacity" },
      update: { type: "easeInEaseOut" },
      delete: { type: "easeInEaseOut", property: "opacity" },
    },
    linear: {
      duration: 500,
      create: { type: "linear", property: "opacity" },
      update: { type: "linear" },
      delete: { type: "linear", property: "opacity" },
    },
    spring: {
      duration: 700,
      create: { type: "spring", property: "scaleXY" },
      update: { type: "spring" },
      delete: { type: "spring", property: "scaleXY" },
    },
  },
};

// I18nManager
const I18nManager = {
  isRTL: false,
  allowRTL: (allow) => {},
  forceRTL: (force) => {},
  swapLeftAndRightInRTL: (swap) => {},
};

// PlatformColor
const PlatformColor = (...colors) => ({ semantic: colors });

// Alert
const Alert = {
  alert: (title, message, buttons, options) => {},
};

// ToastAndroid
const ToastAndroid = {
  SHORT: 0,
  LONG: 1,
  TOP: 0,
  BOTTOM: 1,
  CENTER: 2,
  show: (message, duration) => {},
  showWithGravity: (message, duration, gravity) => {},
  showWithGravityAndOffset: (message, duration, gravity, xOff, yOff) => {},
};

// PermissionsAndroid
const PermissionsAndroid = {
  PERMISSIONS: {
    READ_CALENDAR: "android.permission.READ_CALENDAR",
    WRITE_CALENDAR: "android.permission.WRITE_CALENDAR",
    CAMERA: "android.permission.CAMERA",
    READ_CONTACTS: "android.permission.READ_CONTACTS",
    WRITE_CONTACTS: "android.permission.WRITE_CONTACTS",
    GET_ACCOUNTS: "android.permission.GET_ACCOUNTS",
    ACCESS_FINE_LOCATION: "android.permission.ACCESS_FINE_LOCATION",
    ACCESS_COARSE_LOCATION: "android.permission.ACCESS_COARSE_LOCATION",
    ACCESS_BACKGROUND_LOCATION: "android.permission.ACCESS_BACKGROUND_LOCATION",
    RECORD_AUDIO: "android.permission.RECORD_AUDIO",
    READ_PHONE_STATE: "android.permission.READ_PHONE_STATE",
    CALL_PHONE: "android.permission.CALL_PHONE",
    READ_CALL_LOG: "android.permission.READ_CALL_LOG",
    WRITE_CALL_LOG: "android.permission.WRITE_CALL_LOG",
    BODY_SENSORS: "android.permission.BODY_SENSORS",
    SEND_SMS: "android.permission.SEND_SMS",
    RECEIVE_SMS: "android.permission.RECEIVE_SMS",
    READ_SMS: "android.permission.READ_SMS",
    RECEIVE_WAP_PUSH: "android.permission.RECEIVE_WAP_PUSH",
    RECEIVE_MMS: "android.permission.RECEIVE_MMS",
    READ_EXTERNAL_STORAGE: "android.permission.READ_EXTERNAL_STORAGE",
    WRITE_EXTERNAL_STORAGE: "android.permission.WRITE_EXTERNAL_STORAGE",
    BLUETOOTH_CONNECT: "android.permission.BLUETOOTH_CONNECT",
    BLUETOOTH_SCAN: "android.permission.BLUETOOTH_SCAN",
    BLUETOOTH_ADVERTISE: "android.permission.BLUETOOTH_ADVERTISE",
    NEARBY_WIFI_DEVICES: "android.permission.NEARBY_WIFI_DEVICES",
    POST_NOTIFICATIONS: "android.permission.POST_NOTIFICATIONS",
    READ_MEDIA_IMAGES: "android.permission.READ_MEDIA_IMAGES",
    READ_MEDIA_VIDEO: "android.permission.READ_MEDIA_VIDEO",
    READ_MEDIA_AUDIO: "android.permission.READ_MEDIA_AUDIO",
    ACTIVITY_RECOGNITION: "android.permission.ACTIVITY_RECOGNITION",
  },
  RESULTS: {
    GRANTED: "granted",
    DENIED: "denied",
    NEVER_ASK_AGAIN: "never_ask_again",
  },
  request: (permission) => Promise.resolve("granted"),
  requestMultiple: (permissions) => {
    const result = {};
    permissions.forEach((p) => { result[p] = "granted"; });
    return Promise.resolve(result);
  },
  check: (permission) => Promise.resolve(true),
};

// BackHandler
const BackHandler = {
  addEventListener: (eventName, handler) => ({ remove: () => {} }),
  exitApp: () => {},
};

// DrawerLayoutAndroid
const DrawerLayoutAndroid = {
  positions: { Left: "left", Right: "right" },
};

// Vibration
const Vibration = {
  vibrate: (pattern, repeat) => {},
  cancel: () => {},
};

// Settings (iOS)
const Settings = {
  get: (key) => undefined,
  set: (values) => {},
  watchKeys: (keys, callback) => 42,
  clearWatch: (watchId) => {},
};

// DynamicColorIOS
const DynamicColorIOS = ({ light, dark }) => ({ dynamic: { light, dark } });

// TouchableNativeFeedback
const TouchableNativeFeedback = {
  SelectableBackground: () => ({ type: "selectableBackground" }),
  SelectableBackgroundBorderless: () => ({ type: "selectableBackgroundBorderless" }),
  Ripple: (color, borderless, radius) => ({ type: "ripple", color, borderless, radius }),
};

// Appearance
const Appearance = {
  getColorScheme: () => "light",
  setColorScheme: (scheme) => {},
};

const useColorScheme = () => "light";

// AppState
const AppState = {
  currentState: "active",
  addEventListener: (type, listener) => ({ remove: () => {} }),
};

// Clipboard
const Clipboard = {
  getString: () => Promise.resolve("clipboard-content"),
  setString: (content) => {},
};

// Dimensions
const Dimensions = {
  get: (dim) => ({ width: 375, height: 812, scale: 2, fontScale: 1 }),
};

const useWindowDimensions = () => ({
  width: 375,
  height: 812,
  scale: 2,
  fontScale: 1,
});

// Keyboard
const Keyboard = {
  dismiss: () => {},
  isVisible: () => false,
};

// Linking
const Linking = {
  openURL: (url) => Promise.resolve(),
  canOpenURL: (url) => Promise.resolve(true),
  getInitialURL: () => Promise.resolve(null),
  openSettings: () => Promise.resolve(),
  addEventListener: (eventName, handler) => ({ remove: () => {} }),
};

// Platform
const Platform = {
  OS: "macos",
  Version: 14,
  isTV: false,
  select: (specifics) => specifics.macos || specifics.default,
};

// Share
const Share = {
  share: (content) =>
    Promise.resolve({ action: "sharedAction", activityType: "" }),
};

// AppRegistry
const AppRegistry = {
  registerComponent: (name, getComponent) => {},
};

// UIManager — returns a truthy config for any component name
const UIManager = {
  getViewManagerConfig: (name) => ({ name }),
};

// requireNativeComponent — returns the component name as a string tag
const requireNativeComponent = (name) => name;

// NativeModules — stubs for imperative native modules
const NativeModules = {
  MacOSAlertModule: {
    show: (style, title, message, buttons) => Promise.resolve(0),
  },
  MacOSMenuModule: {
    show: (items) => Promise.resolve(""),
  },
  MacOSShareModule: {
    share: (items) => Promise.resolve(true),
  },
  MacOSNotificationModule: {
    notify: (title, body) => Promise.resolve(true),
  },
  MacOSSoundModule: {
    play: (name) => Promise.resolve(true),
    beep: () => Promise.resolve(true),
  },
  MacOSStatusBarModule: {
    set: (config) => Promise.resolve(true),
    remove: () => Promise.resolve(true),
  },
  MacOSQuickLookModule: {
    preview: (path) => Promise.resolve(true),
  },
  MacOSSpeechModule: {
    say: (text) => Promise.resolve(true),
    sayWithVoice: (text, voice) => Promise.resolve(true),
    stop: () => Promise.resolve(true),
  },
  MacOSColorPanelModule: {
    show: () => Promise.resolve(true),
    hide: () => Promise.resolve(true),
  },
  MacOSFontPanelModule: {
    show: () => Promise.resolve(true),
    hide: () => Promise.resolve(true),
  },
  MacOSOCRModule: {
    recognize: (path) => Promise.resolve("Recognized text from " + path),
  },
  MacOSSpeechRecognitionModule: {
    start: () => Promise.resolve("started"),
    stop: () => Promise.resolve("final transcript"),
    getTranscript: () => Promise.resolve("partial transcript"),
  },
  MacOSNLModule: {
    detectLanguage: (text) => Promise.resolve("en"),
    sentiment: (text) => Promise.resolve(0.5),
    tokenize: (text) => Promise.resolve(text.split(" ")),
  },
};

export {
  View,
  Text,
  TextInput,
  ScrollView,
  Pressable,
  Image,
  ActivityIndicator,
  FlatList,
  Switch,
  Button,
  TouchableOpacity,
  TouchableHighlight,
  TouchableWithoutFeedback,
  Modal,
  SafeAreaView,
  KeyboardAvoidingView,
  ImageBackground,
  SectionList,
  RefreshControl,
  StatusBar,
  InputAccessoryView,
  Animated,
  useAnimatedValue,
  Easing,
  StyleSheet,
  PanResponder,
  PixelRatio,
  AccessibilityInfo,
  ActionSheetIOS,
  LayoutAnimation,
  I18nManager,
  PlatformColor,
  Alert,
  Appearance,
  useColorScheme,
  AppState,
  Clipboard,
  Dimensions,
  useWindowDimensions,
  Keyboard,
  Linking,
  Platform,
  Share,
  AppRegistry,
  UIManager,
  requireNativeComponent,
  NativeModules,
  ToastAndroid,
  PermissionsAndroid,
  BackHandler,
  DrawerLayoutAndroid,
  Vibration,
  Settings,
  DynamicColorIOS,
  TouchableNativeFeedback,
};
