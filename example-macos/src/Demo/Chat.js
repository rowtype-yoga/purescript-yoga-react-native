export const isSingleEmoji = (str) => {
  var trimmed = str.trim();
  var re =
    /^(?:\p{Emoji_Presentation}|\p{Emoji}\uFE0F)(?:\u200D(?:\p{Emoji_Presentation}|\p{Emoji}\uFE0F))*$/u;
  return trimmed.length <= 10 && re.test(trimmed);
};
export const charCodes = (str) => Array.from(str).map((c) => c.charCodeAt(0));
export const abs = (n) => Math.abs(n);

var emojiMap = {
  "+1": "👍",
  "-1": "👎",
  heart: "❤️",
  broken_heart: "💔",
  fire: "🔥",
  rocket: "🚀",
  star: "⭐",
  sparkles: "✨",
  tada: "🎉",
  party_popper: "🎉",
  smile: "😄",
  grin: "😁",
  laugh: "😂",
  joy: "😂",
  wink: "😉",
  blush: "😊",
  heart_eyes: "😍",
  kissing_heart: "😘",
  thinking: "🤔",
  shush: "🤫",
  rolling_eyes: "🙄",
  grimace: "😬",
  sob: "😭",
  angry: "😠",
  skull: "💀",
  clown: "🤡",
  ghost: "👻",
  alien: "👽",
  robot: "🤖",
  poop: "💩",
  wave: "👋",
  clap: "👏",
  pray: "🙏",
  muscle: "💪",
  eyes: "👀",
  brain: "🧠",
  tongue: "👅",
  sun: "☀️",
  moon: "🌙",
  cloud: "☁️",
  rainbow: "🌈",
  snowflake: "❄️",
  zap: "⚡",
  cyclone: "🌀",
  umbrella: "☂️",
  dog: "🐶",
  cat: "🐱",
  unicorn: "🦄",
  bee: "🐝",
  butterfly: "🦋",
  crab: "🦀",
  octopus: "🐙",
  snake: "🐍",
  turtle: "🐢",
  apple: "🍎",
  pizza: "🍕",
  taco: "🌮",
  coffee: "☕",
  beer: "🍺",
  wine: "🍷",
  cake: "🎂",
  cookie: "🍪",
  icecream: "🍦",
  soccer: "⚽",
  basketball: "🏀",
  football: "🏈",
  tennis: "🎾",
  check: "✅",
  x: "❌",
  warning: "⚠️",
  question: "❓",
  exclamation: "❗",
  bulb: "💡",
  pin: "📌",
  link: "🔗",
  lock: "🔒",
  key: "🔑",
  hammer: "🔨",
  wrench: "🔧",
  gear: "⚙️",
  gem: "💎",
  trophy: "🏆",
  gift: "🎁",
  balloon: "🎈",
  confetti: "🎊",
  music: "🎵",
  mic: "🎤",
  art: "🎨",
  film: "🎬",
  camera: "📷",
  phone: "📱",
  laptop: "💻",
  mail: "📧",
  memo: "📝",
  book: "📖",
  clock: "🕐",
  hourglass: "⏳",
  100: "💯",
  zzz: "💤",
  boom: "💥",
  sweat_drops: "💦",
  dash: "💨",
  point_up: "☝️",
  point_down: "👇",
  point_left: "👈",
  point_right: "👉",
  ok_hand: "👌",
  peace: "✌️",
  crossed_fingers: "🤞",
  metal: "🤘",
  thumbsup: "👍",
  thumbsdown: "👎",
  raised_hands: "🙌",
  handshake: "🤝",
  hugs: "🤗",
  salute: "🫡",
  shrug: "🤷",
};
export const replaceEmoji = (str) =>
  str.replace(
    /:([a-z0-9_]+):/gi,
    (m, code) => emojiMap[code.toLowerCase()] || m
  );
export const setTimeout_ = (ms, fn) => {
  setTimeout(fn, ms);
};
export const emojiDir =
  "/Users/mark/Developer/purescript-yoga-react-native/example-macos/macos/YogaReactExample-macOS/emoji";

// Replace custom emoji shortcodes with a placeholder character for sizing
export const stripCustomEmoji_ = (emojiMap) => (str) =>
  str.replace(/:([a-zA-Z0-9_]+):/g, (m, name) =>
    emojiMap[name] ? "\u2003" : m
  );

// Returns the custom emoji filename if the message is a single custom emoji, otherwise null
export const singleCustomEmoji_ = (emojiMap) => (str) => {
  var trimmed = str.trim();
  var match = trimmed.match(/^:([a-zA-Z0-9_]+):$/);
  if (!match) return null;
  var name = match[1];
  var file = emojiMap[name];
  return file || null;
};
