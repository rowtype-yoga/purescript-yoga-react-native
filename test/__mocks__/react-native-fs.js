const store = {};

export default {
  DocumentDirectoryPath: "/documents",
  CachesDirectoryPath: "/caches",
  TemporaryDirectoryPath: "/tmp",
  DownloadDirectoryPath: "/downloads",
  LibraryDirectoryPath: "/library",
  readFile: (path, encoding) => Promise.resolve(store[path] || ""),
  writeFile: (path, contents, encoding) => { store[path] = contents; return Promise.resolve(); },
  appendFile: (path, contents, encoding) => { store[path] = (store[path] || "") + contents; return Promise.resolve(); },
  exists: (path) => Promise.resolve(path in store),
  unlink: (path) => { delete store[path]; return Promise.resolve(); },
  readDir: (path) => Promise.resolve([
    { name: "file.txt", path: path + "/file.txt", size: 100, isFile: () => true, isDirectory: () => false },
  ]),
  mkdir: (path) => Promise.resolve(),
  stat: (path) => Promise.resolve({
    name: "file.txt", path, size: 100, mode: 0o644,
    ctime: 1700000000, mtime: 1700000000,
    isFile: () => true, isDirectory: () => false,
  }),
  hash: (path, algorithm) => Promise.resolve("abc123"),
  copyFile: (src, dest) => { store[dest] = store[src] || ""; return Promise.resolve(); },
  moveFile: (src, dest) => { store[dest] = store[src] || ""; delete store[src]; return Promise.resolve(); },
  _store: store,
  _reset: () => { Object.keys(store).forEach(k => delete store[k]); },
};
