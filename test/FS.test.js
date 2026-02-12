import { describe, it, expect, beforeEach } from "vitest";
import RNFS from "react-native-fs";
import {
  documentDirectoryPath, cachesDirectoryPath, temporaryDirectoryPath,
  downloadDirectoryPath, libraryDirectoryPath,
  readFileImpl, writeFileImpl, appendFileImpl,
  existsImpl, unlinkImpl, readDirImpl, mkdirImpl,
  statImpl, hashImpl, copyFileImpl, moveFileImpl,
} from "../src/Yoga/React/Native/FS.js";

beforeEach(() => { RNFS._reset(); });

const runAff = (aff) => new Promise((resolve, reject) => {
  aff(reject, resolve);
});

describe("FS FFI", () => {
  it("path constants are strings", () => {
    expect(typeof documentDirectoryPath).toBe("string");
    expect(typeof cachesDirectoryPath).toBe("string");
    expect(typeof temporaryDirectoryPath).toBe("string");
    expect(typeof downloadDirectoryPath).toBe("string");
    expect(typeof libraryDirectoryPath).toBe("string");
  });

  it("writeFileImpl then readFileImpl round-trips", async () => {
    await runAff(writeFileImpl("/test.txt")("hello")("utf8"));
    const result = await runAff(readFileImpl("/test.txt")("utf8"));
    expect(result).toBe("hello");
  });

  it("appendFileImpl appends content", async () => {
    await runAff(writeFileImpl("/a.txt")("hello")("utf8"));
    await runAff(appendFileImpl("/a.txt")(" world")("utf8"));
    const result = await runAff(readFileImpl("/a.txt")("utf8"));
    expect(result).toBe("hello world");
  });

  it("existsImpl returns true for written files", async () => {
    await runAff(writeFileImpl("/exists.txt")("data")("utf8"));
    const exists = await runAff(existsImpl("/exists.txt"));
    expect(exists).toBe(true);
  });

  it("existsImpl returns false for missing files", async () => {
    const exists = await runAff(existsImpl("/nope.txt"));
    expect(exists).toBe(false);
  });

  it("unlinkImpl removes a file", async () => {
    await runAff(writeFileImpl("/del.txt")("data")("utf8"));
    await runAff(unlinkImpl("/del.txt"));
    const exists = await runAff(existsImpl("/del.txt"));
    expect(exists).toBe(false);
  });

  it("readDirImpl returns an array of DirItems", async () => {
    const items = await runAff(readDirImpl("/some/path"));
    expect(Array.isArray(items)).toBe(true);
    expect(items[0]).toHaveProperty("name");
    expect(items[0]).toHaveProperty("path");
    expect(items[0]).toHaveProperty("size");
    expect(items[0]).toHaveProperty("isFile");
    expect(items[0]).toHaveProperty("isDirectory");
  });

  it("mkdirImpl does not throw", async () => {
    await expect(runAff(mkdirImpl("/new/dir"))).resolves.not.toThrow();
  });

  it("statImpl returns a StatResult", async () => {
    const stat = await runAff(statImpl("/some/file"));
    expect(stat).toHaveProperty("name");
    expect(stat).toHaveProperty("path");
    expect(stat).toHaveProperty("size");
    expect(stat).toHaveProperty("mode");
    expect(stat).toHaveProperty("ctime");
    expect(stat).toHaveProperty("mtime");
    expect(stat).toHaveProperty("isFile");
    expect(stat).toHaveProperty("isDirectory");
  });

  it("hashImpl returns a hash string", async () => {
    const h = await runAff(hashImpl("/file")("md5"));
    expect(typeof h).toBe("string");
  });

  it("copyFileImpl copies content", async () => {
    await runAff(writeFileImpl("/src.txt")("copied")("utf8"));
    await runAff(copyFileImpl("/src.txt")("/dst.txt"));
    const result = await runAff(readFileImpl("/dst.txt")("utf8"));
    expect(result).toBe("copied");
  });

  it("moveFileImpl moves content", async () => {
    await runAff(writeFileImpl("/mv-src.txt")("moved")("utf8"));
    await runAff(moveFileImpl("/mv-src.txt")("/mv-dst.txt"));
    const result = await runAff(readFileImpl("/mv-dst.txt")("utf8"));
    expect(result).toBe("moved");
    const srcExists = await runAff(existsImpl("/mv-src.txt"));
    expect(srcExists).toBe(false);
  });

  it("aff canceller is a function", () => {
    const cancel = writeFileImpl("/c.txt")("x")("utf8")(
      () => {},
      () => {}
    );
    expect(typeof cancel).toBe("function");
  });
});
