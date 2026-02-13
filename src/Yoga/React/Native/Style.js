import twrnc from "twrnc";

export function stylesImpl(arr) {
  const result = {};
  for (const s of arr) {
    if (s == null) continue;
    const keys = Object.keys(s);
    for (let i = 0; i < keys.length; i++) {
      result[keys[i]] = s[keys[i]];
    }
    // Copy symbol-keyed properties (needed for PlatformColor)
    const syms = Object.getOwnPropertySymbols(s);
    for (let i = 0; i < syms.length; i++) {
      result[syms[i]] = s[syms[i]];
    }
  }
  return result;
}

export function tw(classString) {
  return twrnc.style(classString);
}
