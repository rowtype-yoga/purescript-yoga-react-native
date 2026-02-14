export const getField = (key) => (obj) => obj[key] ?? 0;
export const getFieldInt = (key) => (obj) => obj[key] | 0;
export const getFieldStr = (key) => (obj) => String(obj[key] ?? "");
export const getFieldBool = (key) => (obj) => Boolean(obj[key]);
export const unsafeRound = (n) => Math.round(n);
export const isSingleEmoji = (str) => {
  var trimmed = str.trim();
  var re =
    /^(?:\p{Emoji_Presentation}|\p{Emoji}\uFE0F)(?:\u200D(?:\p{Emoji_Presentation}|\p{Emoji}\uFE0F))*$/u;
  return trimmed.length <= 10 && re.test(trimmed);
};
export const getFieldJSON = (key) => (obj) => {
  var v = obj[key];
  if (v === undefined || v === null) return "";
  return JSON.stringify(v);
};
