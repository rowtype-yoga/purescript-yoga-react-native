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
export const charCodes = (str) => Array.from(str).map((c) => c.charCodeAt(0));
export const abs = (n) => Math.abs(n);
export const setInterval = (ms) => (fn) => () => globalThis.setInterval(fn, ms);
export const clearInterval = (id) => () => globalThis.clearInterval(id);
