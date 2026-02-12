import { describe, it, expect } from "vitest";

import { _viewImpl } from "../src/Yoga/React/Native/View.js";
import { _textImpl } from "../src/Yoga/React/Native/Text.js";
import { _textInputImpl } from "../src/Yoga/React/Native/TextInput.js";
import { _scrollViewImpl } from "../src/Yoga/React/Native/ScrollView.js";
import { _pressableImpl } from "../src/Yoga/React/Native/Pressable.js";
import { _imageImpl, uri } from "../src/Yoga/React/Native/Image.js";
import { _activityIndicatorImpl } from "../src/Yoga/React/Native/ActivityIndicator.js";
import { _flatListImpl } from "../src/Yoga/React/Native/FlatList.js";
import { _switchImpl } from "../src/Yoga/React/Native/Switch.js";
import { _buttonImpl } from "../src/Yoga/React/Native/Button.js";
import { _touchableOpacityImpl } from "../src/Yoga/React/Native/TouchableOpacity.js";
import { _touchableHighlightImpl } from "../src/Yoga/React/Native/TouchableHighlight.js";
import { _touchableWithoutFeedbackImpl } from "../src/Yoga/React/Native/TouchableWithoutFeedback.js";
import { _modalImpl } from "../src/Yoga/React/Native/Modal.js";
import { _safeAreaViewImpl } from "../src/Yoga/React/Native/SafeAreaView.js";
import { _keyboardAvoidingViewImpl } from "../src/Yoga/React/Native/KeyboardAvoidingView.js";
import { _imageBackgroundImpl } from "../src/Yoga/React/Native/ImageBackground.js";
import { _sectionListImpl } from "../src/Yoga/React/Native/SectionList.js";
import { _refreshControlImpl } from "../src/Yoga/React/Native/RefreshControl.js";
import { _statusBarImpl } from "../src/Yoga/React/Native/StatusBar.js";
import { _inputAccessoryViewImpl } from "../src/Yoga/React/Native/InputAccessoryView.js";

describe("Component FFI exports", () => {
  it("View exports the component", () => {
    expect(_viewImpl).toBe("View");
  });

  it("Text exports the component", () => {
    expect(_textImpl).toBe("Text");
  });

  it("TextInput exports the component", () => {
    expect(_textInputImpl).toBe("TextInput");
  });

  it("ScrollView exports the component", () => {
    expect(_scrollViewImpl).toBe("ScrollView");
  });

  it("Pressable exports the component", () => {
    expect(_pressableImpl).toBe("Pressable");
  });

  it("Image exports the component", () => {
    expect(_imageImpl).toBe("Image");
  });

  it("Image.uri wraps a URL", () => {
    expect(uri("https://example.com/img.png")).toEqual({ uri: "https://example.com/img.png" });
  });

  it("ActivityIndicator exports the component", () => {
    expect(_activityIndicatorImpl).toBe("ActivityIndicator");
  });

  it("FlatList exports the component", () => {
    expect(_flatListImpl).toBe("FlatList");
  });

  it("Switch exports the component", () => {
    expect(_switchImpl).toBe("Switch");
  });

  it("Button exports the component", () => {
    expect(_buttonImpl).toBe("Button");
  });

  it("TouchableOpacity exports the component", () => {
    expect(_touchableOpacityImpl).toBe("TouchableOpacity");
  });

  it("TouchableHighlight exports the component", () => {
    expect(_touchableHighlightImpl).toBe("TouchableHighlight");
  });

  it("TouchableWithoutFeedback exports the component", () => {
    expect(_touchableWithoutFeedbackImpl).toBe("TouchableWithoutFeedback");
  });

  it("Modal exports the component", () => {
    expect(_modalImpl).toBe("Modal");
  });

  it("SafeAreaView exports the component", () => {
    expect(_safeAreaViewImpl).toBe("SafeAreaView");
  });

  it("KeyboardAvoidingView exports the component", () => {
    expect(_keyboardAvoidingViewImpl).toBe("KeyboardAvoidingView");
  });

  it("ImageBackground exports the component", () => {
    expect(_imageBackgroundImpl).toBe("ImageBackground");
  });

  it("SectionList exports the component", () => {
    expect(_sectionListImpl).toBe("SectionList");
  });

  it("RefreshControl exports the component", () => {
    expect(_refreshControlImpl).toBe("RefreshControl");
  });

  it("StatusBar exports the component", () => {
    expect(_statusBarImpl).toBe("StatusBar");
  });

  it("InputAccessoryView exports the component", () => {
    expect(_inputAccessoryViewImpl).toBe("InputAccessoryView");
  });
});
