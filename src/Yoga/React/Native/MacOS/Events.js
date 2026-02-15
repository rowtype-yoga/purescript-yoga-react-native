export const getField = (key) => (obj) => obj[key] ?? 0;
export const getFieldInt = (key) => (obj) => obj[key] | 0;
export const getFieldStr = (key) => (obj) => String(obj[key] ?? "");
export const getFieldBool = (key) => (obj) => Boolean(obj[key]);
export const getFieldArray = (key) => (obj) =>
  Array.isArray(obj[key]) ? obj[key].map(String) : [];
