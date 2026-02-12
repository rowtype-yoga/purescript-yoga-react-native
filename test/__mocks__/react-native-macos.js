export const DynamicColorMacOS = (colors) => ({
  dynamic: {
    light: colors.light,
    dark: colors.dark,
    highContrastLight: colors.highContrastLight,
    highContrastDark: colors.highContrastDark,
  },
});

export const ColorWithSystemEffectMacOS = (color, effect) => ({
  colorWithSystemEffect: {
    baseColor: color,
    systemEffect: effect,
  },
});
