import { describe, it, expect, beforeAll } from "vitest";
import { execSync } from "child_process";
import { existsSync, mkdirSync, readFileSync, writeFileSync, copyFileSync } from "fs";
import { join } from "path";
import { PNG } from "pngjs";
import pixelmatch from "pixelmatch";

const BASELINES_DIR = join(import.meta.dirname, "baselines");
const DIFF_DIR = join(import.meta.dirname, "diff");
const UPDATE = !!process.env.UPDATE_BASELINES;
const THRESHOLD = 0.1; // pixel diff threshold (0 = exact, 1 = anything matches)
const MAX_DIFF_PERCENT = 0.5; // allow 0.5% pixel difference (anti-aliasing, timing)

function getWindowBounds() {
  const script = `
import CoreGraphics
import Foundation
let list = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [[String: Any]]
for w in list {
  if let name = w["kCGWindowOwnerName"] as? String, name.contains("YogaReact") {
    let bounds = w["kCGWindowBounds"] as! [String: Double]
    let x = Int(bounds["X"]!)
    let y = Int(bounds["Y"]!)
    let width = Int(bounds["Width"]!)
    let height = Int(bounds["Height"]!)
    print("\\(x),\\(y),\\(width),\\(height)")
  }
}
`;
  const result = execSync(`swift -e '${script}'`, { encoding: "utf8" }).trim();
  if (!result) throw new Error("YogaReactExample window not found. Is the app running?");
  return result;
}

function captureWindow(outputPath) {
  const bounds = getWindowBounds();
  execSync(`screencapture -x -R${bounds} ${outputPath}`);
}

function compareImages(actualPath, baselinePath) {
  const actual = PNG.sync.read(readFileSync(actualPath));
  const baseline = PNG.sync.read(readFileSync(baselinePath));

  const width = Math.min(actual.width, baseline.width);
  const height = Math.min(actual.height, baseline.height);

  // If dimensions differ significantly, fail
  if (Math.abs(actual.width - baseline.width) > 10 || Math.abs(actual.height - baseline.height) > 10) {
    return { match: false, diffPercent: 100, reason: `Size mismatch: ${actual.width}x${actual.height} vs ${baseline.width}x${baseline.height}` };
  }

  const diff = new PNG({ width, height });

  // Crop both to min dimensions for comparison
  const actualCropped = cropPNG(actual, width, height);
  const baselineCropped = cropPNG(baseline, width, height);

  const numDiffPixels = pixelmatch(actualCropped, baselineCropped, diff.data, width, height, { threshold: THRESHOLD });
  const totalPixels = width * height;
  const diffPercent = (numDiffPixels / totalPixels) * 100;

  return { match: diffPercent <= MAX_DIFF_PERCENT, diffPercent, diff, width, height };
}

function cropPNG(png, targetWidth, targetHeight) {
  const buf = Buffer.alloc(targetWidth * targetHeight * 4);
  for (let y = 0; y < targetHeight; y++) {
    const srcOffset = y * png.width * 4;
    const dstOffset = y * targetWidth * 4;
    png.data.copy(buf, dstOffset, srcOffset, srcOffset + targetWidth * 4);
  }
  return buf;
}

function screenshotTest(name) {
  const actualPath = join(DIFF_DIR, `${name}-actual.png`);
  const baselinePath = join(BASELINES_DIR, `${name}.png`);
  const diffPath = join(DIFF_DIR, `${name}-diff.png`);

  captureWindow(actualPath);

  if (UPDATE || !existsSync(baselinePath)) {
    copyFileSync(actualPath, baselinePath);
    console.log(`  Baseline saved: ${baselinePath}`);
    return;
  }

  const result = compareImages(actualPath, baselinePath);

  if (!result.match) {
    if (result.diff) {
      const diffPng = PNG.sync.write(result.diff);
      writeFileSync(diffPath, diffPng);
      console.log(`  Diff image saved: ${diffPath}`);
    }
    throw new Error(`Visual mismatch for "${name}": ${result.reason || `${result.diffPercent.toFixed(2)}% pixels differ (max ${MAX_DIFF_PERCENT}%)`}`);
  }
}

describe("Visual screenshot tests", () => {
  beforeAll(() => {
    mkdirSync(BASELINES_DIR, { recursive: true });
    mkdirSync(DIFF_DIR, { recursive: true });

    // Verify app is running
    try {
      getWindowBounds();
    } catch (e) {
      throw new Error("YogaReactExample must be running for visual tests. Launch with: npx react-native run-macos");
    }
  });

  it("app window captures successfully", () => {
    const tmpPath = join(DIFF_DIR, "capture-test.png");
    captureWindow(tmpPath);
    expect(existsSync(tmpPath)).toBe(true);
    const png = PNG.sync.read(readFileSync(tmpPath));
    expect(png.width).toBeGreaterThan(100);
    expect(png.height).toBeGreaterThan(100);
  });

  it("current tab matches baseline", () => {
    screenshotTest("current-tab");
  });
});
