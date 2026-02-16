export const unsafeRound = (n) => Math.round(n);
export const getFieldJSON = (key) => (obj) => {
  var v = obj[key];
  if (v === undefined || v === null) return "";
  return JSON.stringify(v);
};
