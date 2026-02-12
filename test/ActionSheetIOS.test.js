import { describe, it, expect } from "vitest";
import { showActionSheetImpl, dismissActionSheet } from "../src/Yoga/React/Native/ActionSheetIOS.js";

describe("ActionSheetIOS FFI", () => {
  it("showActionSheetImpl calls the callback", () => {
    let selectedIndex;
    showActionSheetImpl(
      { options: ["Cancel", "Delete"], cancelButtonIndex: 0, destructiveButtonIndex: 1 },
      (index) => { selectedIndex = index; }
    );
    expect(selectedIndex).toBe(0);
  });

  it("dismissActionSheet is an effect", () => {
    expect(() => dismissActionSheet()).not.toThrow();
  });
});
