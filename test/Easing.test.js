import { describe, it, expect } from "vitest";
import {
  step0, step1, linear, ease, quad, cubic, poly,
  sin, circle, exp, elastic, back, bounce, bezier,
  easeIn, easeOut, easeInOut,
} from "../src/Yoga/React/Native/Easing.js";

describe("Easing FFI", () => {
  it("step0 returns 0 for t=0 and 1 for t>0", () => {
    expect(step0(0)).toBe(0);
    expect(step0(0.5)).toBe(1);
  });

  it("step1 returns 0 for t<1 and 1 for t=1", () => {
    expect(step1(0.5)).toBe(0);
    expect(step1(1)).toBe(1);
  });

  it("linear is identity", () => {
    expect(linear(0.5)).toBe(0.5);
  });

  it("ease is a function", () => {
    expect(typeof ease).toBe("function");
    expect(typeof ease(0.5)).toBe("number");
  });

  it("quad squares input", () => {
    expect(quad(0.5)).toBe(0.25);
  });

  it("cubic cubes input", () => {
    expect(cubic(0.5)).toBeCloseTo(0.125);
  });

  it("poly returns a function", () => {
    const p = poly(4);
    expect(typeof p).toBe("function");
    expect(p(0.5)).toBeCloseTo(0.0625);
  });

  it("sin is a function", () => {
    expect(typeof sin(0.5)).toBe("number");
  });

  it("circle is a function", () => {
    expect(typeof circle(0.5)).toBe("number");
  });

  it("exp is a function", () => {
    expect(typeof exp(0.5)).toBe("number");
  });

  it("elastic returns a function", () => {
    const e = elastic(1);
    expect(typeof e).toBe("function");
    expect(typeof e(0.5)).toBe("number");
  });

  it("back returns a function", () => {
    const b = back(1.5);
    expect(typeof b).toBe("function");
    expect(typeof b(0.5)).toBe("number");
  });

  it("bounce is a function", () => {
    expect(typeof bounce(0.5)).toBe("number");
  });

  it("bezier returns a function", () => {
    const b = bezier(0.25)(0.1)(0.25)(1.0);
    expect(typeof b).toBe("function");
    expect(typeof b(0.5)).toBe("number");
  });

  it("easeIn wraps a function", () => {
    const fn = easeIn(quad);
    expect(typeof fn).toBe("function");
  });

  it("easeOut wraps a function", () => {
    const fn = easeOut(quad);
    expect(typeof fn).toBe("function");
  });

  it("easeInOut wraps a function", () => {
    const fn = easeInOut(quad);
    expect(typeof fn).toBe("function");
  });
});
