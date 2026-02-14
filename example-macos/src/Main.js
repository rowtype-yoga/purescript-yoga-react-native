export const getField = (key) => (obj) => obj[key] ?? 0;
export const getFieldInt = (key) => (obj) => obj[key] | 0;
export const getFieldStr = (key) => (obj) => String(obj[key] ?? "");
export const getFieldBool = (key) => (obj) => Boolean(obj[key]);
export const unsafeRound = (n) => Math.round(n);
export const isSingleEmoji = (str) => {
  var trimmed = str.trim();
  var segments = [
    ...new Intl.Segmenter("en", { granularity: "grapheme" }).segment(trimmed),
  ];
  return segments.length === 1 && /\p{Emoji_Presentation}/u.test(trimmed);
};
export const getFieldJSON = (key) => (obj) => {
  var v = obj[key];
  if (v === undefined || v === null) return "";
  return JSON.stringify(v);
};
