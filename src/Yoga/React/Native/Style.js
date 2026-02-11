import twrnc from "twrnc";

export function stylesImpl(arr) {
  return Object.assign({}, ...arr);
}

export function tw(classString) {
  return twrnc.style(classString);
}
