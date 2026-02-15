import { describe, it, expect } from "vitest";

// Import compiled PureScript output — newtypes are transparent at runtime
import * as Types from "../output/Yoga.React.Native.MacOS.Types/index.js";

describe("macOS Types — BezelStyle", () => {
  it("push = 'push'", () => expect(Types.push).toBe("push"));
  it("toolbar = 'toolbar'", () => expect(Types.toolbar).toBe("toolbar"));
  it("texturedSquare = 'texturedSquare'", () =>
    expect(Types.texturedSquare).toBe("texturedSquare"));
  it("inline = 'inline'", () => expect(Types.inline).toBe("inline"));
});

describe("macOS Types — VisualEffectMaterial", () => {
  it("sidebar = 'sidebar'", () => expect(Types.sidebar).toBe("sidebar"));
  it("headerView = 'headerView'", () =>
    expect(Types.headerView).toBe("headerView"));
  it("titlebar = 'titlebar'", () => expect(Types.titlebar).toBe("titlebar"));
  it("contentBackground = 'contentBackground'", () =>
    expect(Types.contentBackground).toBe("contentBackground"));
  it("menu = 'menu'", () => expect(Types.menu).toBe("menu"));
});

describe("macOS Types — BlendingMode", () => {
  it("withinWindow = 'withinWindow'", () =>
    expect(Types.withinWindow).toBe("withinWindow"));
  it("behindWindow = 'behindWindow'", () =>
    expect(Types.behindWindow).toBe("behindWindow"));
});

describe("macOS Types — ControlsStyle", () => {
  it("noControls = 'none'", () => expect(Types.noControls).toBe("none"));
  it("inlineControls = 'inline'", () =>
    expect(Types.inlineControls).toBe("inline"));
  it("floatingControls = 'floating'", () =>
    expect(Types.floatingControls).toBe("floating"));
  it("defaultControls = 'default'", () =>
    expect(Types.defaultControls).toBe("default"));
});

describe("macOS Types — PopoverEdge", () => {
  it("bottom = 'bottom'", () => expect(Types.bottom).toBe("bottom"));
  it("top = 'top'", () => expect(Types.top).toBe("top"));
  it("left = 'left'", () => expect(Types.left).toBe("left"));
  it("right = 'right'", () => expect(Types.right).toBe("right"));
});

describe("macOS Types — AlertStyle", () => {
  it("warning = 'warning'", () => expect(Types.warning).toBe("warning"));
  it("critical = 'critical'", () => expect(Types.critical).toBe("critical"));
  it("informational = 'informational'", () =>
    expect(Types.informational).toBe("informational"));
});

describe("macOS Types — PathControlStyle", () => {
  it("standardPath = 'standard'", () =>
    expect(Types.standardPath).toBe("standard"));
  it("popupPath = 'popup'", () => expect(Types.popupPath).toBe("popup"));
});

describe("macOS Types — ImageContentMode", () => {
  it("scaleToFit = 'scaleToFit'", () =>
    expect(Types.scaleToFit).toBe("scaleToFit"));
  it("center = 'center'", () => expect(Types.center).toBe("center"));
  it("scaleProportionally = 'scaleProportionally'", () =>
    expect(Types.scaleProportionally).toBe("scaleProportionally"));
});

describe("macOS Types — FilePickerMode", () => {
  it("openFile = 'open'", () => expect(Types.openFile).toBe("open"));
  it("saveFile = 'save'", () => expect(Types.saveFile).toBe("save"));
});

describe("macOS Types — ToolbarStyle", () => {
  it("unified = 'unified'", () => expect(Types.unified).toBe("unified"));
  it("expanded = 'expanded'", () => expect(Types.expanded).toBe("expanded"));
  it("preference = 'preference'", () =>
    expect(Types.preference).toBe("preference"));
  it("unifiedCompact = 'unifiedCompact'", () =>
    expect(Types.unifiedCompact).toBe("unifiedCompact"));
});
