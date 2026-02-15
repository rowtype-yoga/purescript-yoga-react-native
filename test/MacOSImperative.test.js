import { describe, it, expect, vi } from "vitest";
import { NativeModules } from "react-native";
import { alertImpl } from "../src/Yoga/React/Native/MacOS/Alert.js";
import { showMenuImpl } from "../src/Yoga/React/Native/MacOS/Menu.js";
import {
  copyToClipboardImpl,
  readClipboardImpl,
} from "../src/Yoga/React/Native/MacOS/Pasteboard.js";
import { shareImpl } from "../src/Yoga/React/Native/MacOS/ShareService.js";
import { notifyImpl } from "../src/Yoga/React/Native/MacOS/UserNotification.js";
import {
  playSoundImpl,
  beepImpl,
} from "../src/Yoga/React/Native/MacOS/Sound.js";
import {
  setStatusBarItemImpl,
  removeStatusBarItemImpl,
} from "../src/Yoga/React/Native/MacOS/StatusBarItem.js";
import { previewImpl } from "../src/Yoga/React/Native/MacOS/QuickLook.js";
import {
  sayImpl,
  sayWithVoiceImpl,
  stopSpeakingImpl,
} from "../src/Yoga/React/Native/MacOS/SpeechSynthesizer.js";
import {
  showColorPanelImpl,
  hideColorPanelImpl,
} from "../src/Yoga/React/Native/MacOS/ColorPanel.js";
import {
  showFontPanelImpl,
  hideFontPanelImpl,
} from "../src/Yoga/React/Native/MacOS/FontPanel.js";

describe("macOS Alert FFI", () => {
  it("alertImpl calls NativeModules.MacOSAlertModule.show", () => {
    const spy = vi.spyOn(NativeModules.MacOSAlertModule, "show");
    alertImpl("warning", "Title", "Message", ["OK", "Cancel"]);
    expect(spy).toHaveBeenCalledWith("warning", "Title", "Message", [
      "OK",
      "Cancel",
    ]);
    spy.mockRestore();
  });

  it("alertImpl passes style through", () => {
    const spy = vi.spyOn(NativeModules.MacOSAlertModule, "show");
    alertImpl("critical", "Error", "Something broke", ["Retry"]);
    expect(spy).toHaveBeenCalledWith("critical", "Error", "Something broke", [
      "Retry",
    ]);
    spy.mockRestore();
  });

  it("alertImpl does not throw with empty buttons", () => {
    expect(() => alertImpl("informational", "Info", "Note", [])).not.toThrow();
  });
});

describe("macOS Menu FFI", () => {
  it("showMenuImpl calls NativeModules.MacOSMenuModule.show with items", () => {
    const spy = vi.spyOn(NativeModules.MacOSMenuModule, "show");
    const items = [
      { title: "Cut", id: "cut" },
      { title: "Copy", id: "copy" },
    ];
    const callback = (_id) => () => {};
    showMenuImpl(items, callback);
    expect(spy).toHaveBeenCalledWith(items);
    spy.mockRestore();
  });

  it("showMenuImpl invokes callback when item selected", async () => {
    const selectedId = "paste";
    vi.spyOn(NativeModules.MacOSMenuModule, "show").mockResolvedValueOnce(
      selectedId,
    );
    let result = "";
    const callback = (id) => () => {
      result = id;
    };
    showMenuImpl([{ title: "Paste", id: "paste" }], callback);
    await new Promise((r) => setTimeout(r, 10));
    expect(result).toBe("paste");
  });

  it("showMenuImpl does not invoke callback when no item selected", async () => {
    vi.spyOn(NativeModules.MacOSMenuModule, "show").mockResolvedValueOnce("");
    let called = false;
    const callback = (_id) => () => {
      called = true;
    };
    showMenuImpl([{ title: "Save", id: "save" }], callback);
    await new Promise((r) => setTimeout(r, 10));
    expect(called).toBe(false);
  });
});

describe("macOS Pasteboard FFI", () => {
  it("copyToClipboardImpl does not throw", () => {
    expect(() => copyToClipboardImpl("Hello from tests")).not.toThrow();
  });

  it("readClipboardImpl does not throw", () => {
    expect(() => readClipboardImpl()).not.toThrow();
  });
});

describe("macOS ShareService FFI", () => {
  it("shareImpl calls NativeModules.MacOSShareModule.share", () => {
    const spy = vi.spyOn(NativeModules.MacOSShareModule, "share");
    shareImpl(["Hello", "https://example.com"]);
    expect(spy).toHaveBeenCalledWith(["Hello", "https://example.com"]);
    spy.mockRestore();
  });

  it("shareImpl does not throw with empty array", () => {
    expect(() => shareImpl([])).not.toThrow();
  });
});

describe("macOS UserNotification FFI", () => {
  it("notifyImpl calls NativeModules.MacOSNotificationModule.notify", () => {
    const spy = vi.spyOn(NativeModules.MacOSNotificationModule, "notify");
    notifyImpl("Title", "Body");
    expect(spy).toHaveBeenCalledWith("Title", "Body");
    spy.mockRestore();
  });
});

describe("macOS Sound FFI", () => {
  it("playSoundImpl calls NativeModules.MacOSSoundModule.play", () => {
    const spy = vi.spyOn(NativeModules.MacOSSoundModule, "play");
    playSoundImpl("Glass");
    expect(spy).toHaveBeenCalledWith("Glass");
    spy.mockRestore();
  });

  it("beepImpl calls NativeModules.MacOSSoundModule.beep", () => {
    const spy = vi.spyOn(NativeModules.MacOSSoundModule, "beep");
    beepImpl();
    expect(spy).toHaveBeenCalled();
    spy.mockRestore();
  });
});

describe("macOS StatusBarItem FFI", () => {
  it("setStatusBarItemImpl calls NativeModules.MacOSStatusBarModule.set", () => {
    const spy = vi.spyOn(NativeModules.MacOSStatusBarModule, "set");
    const config = {
      title: "Test",
      sfSymbol: "star",
      menuItems: [{ id: "a", title: "Item A" }],
    };
    setStatusBarItemImpl(config);
    expect(spy).toHaveBeenCalledWith(config);
    spy.mockRestore();
  });

  it("removeStatusBarItemImpl calls NativeModules.MacOSStatusBarModule.remove", () => {
    const spy = vi.spyOn(NativeModules.MacOSStatusBarModule, "remove");
    removeStatusBarItemImpl();
    expect(spy).toHaveBeenCalled();
    spy.mockRestore();
  });
});

describe("macOS QuickLook FFI", () => {
  it("previewImpl calls NativeModules.MacOSQuickLookModule.preview", () => {
    const spy = vi.spyOn(NativeModules.MacOSQuickLookModule, "preview");
    previewImpl("/tmp/test.txt");
    expect(spy).toHaveBeenCalledWith("/tmp/test.txt");
    spy.mockRestore();
  });
});

describe("macOS SpeechSynthesizer FFI", () => {
  it("sayImpl calls NativeModules.MacOSSpeechModule.say", () => {
    const spy = vi.spyOn(NativeModules.MacOSSpeechModule, "say");
    sayImpl("Hello");
    expect(spy).toHaveBeenCalledWith("Hello");
    spy.mockRestore();
  });

  it("sayWithVoiceImpl calls NativeModules.MacOSSpeechModule.sayWithVoice", () => {
    const spy = vi.spyOn(NativeModules.MacOSSpeechModule, "sayWithVoice");
    sayWithVoiceImpl("Hello", "com.apple.voice.Alex");
    expect(spy).toHaveBeenCalledWith("Hello", "com.apple.voice.Alex");
    spy.mockRestore();
  });

  it("stopSpeakingImpl calls NativeModules.MacOSSpeechModule.stop", () => {
    const spy = vi.spyOn(NativeModules.MacOSSpeechModule, "stop");
    stopSpeakingImpl();
    expect(spy).toHaveBeenCalled();
    spy.mockRestore();
  });
});

describe("macOS ColorPanel FFI", () => {
  it("showColorPanelImpl calls NativeModules.MacOSColorPanelModule.show", () => {
    const spy = vi.spyOn(NativeModules.MacOSColorPanelModule, "show");
    showColorPanelImpl();
    expect(spy).toHaveBeenCalled();
    spy.mockRestore();
  });

  it("hideColorPanelImpl calls NativeModules.MacOSColorPanelModule.hide", () => {
    const spy = vi.spyOn(NativeModules.MacOSColorPanelModule, "hide");
    hideColorPanelImpl();
    expect(spy).toHaveBeenCalled();
    spy.mockRestore();
  });
});

describe("macOS FontPanel FFI", () => {
  it("showFontPanelImpl calls NativeModules.MacOSFontPanelModule.show", () => {
    const spy = vi.spyOn(NativeModules.MacOSFontPanelModule, "show");
    showFontPanelImpl();
    expect(spy).toHaveBeenCalled();
    spy.mockRestore();
  });

  it("hideFontPanelImpl calls NativeModules.MacOSFontPanelModule.hide", () => {
    const spy = vi.spyOn(NativeModules.MacOSFontPanelModule, "hide");
    hideFontPanelImpl();
    expect(spy).toHaveBeenCalled();
    spy.mockRestore();
  });
});
