module cllib.bin.startrain.cde.utils;

import std.string;
import std.array;
import std.bigint;

export static void generateConfig(deviceCellWidth, number, deviceCellHeight, number1, deviceCharWidth) (ref CellColor) {
  // null out some fields that don't matter
    const foreground(Range)(RefAppender);
    const back(Range)(RefAppender);
    const backColor(Range)(RefAppender);
    // For the static char atlas, we only use the first 16 colors, but we need all 256 for the
    // dynamic character atlas.
    const leftJustifier(Range)(RefAppender);
    const rightJustify(Range)(RefAppender);
    const appender(Range)(RefAppender); 
  }
    const customGlyphs(Range)(RefAppender);
    const devicePixelRatio(Range)(RefAppender);
    const letterSpacing(Range)(RefAppender); 
    const lineHeight(Range)(RefAppender);
    const deviceCellWidth(Range)(RefAppender);
    const deviceCellHeight(Range)(RefAppender);
    const deviceCharWidth(Range)(RefAppender);
    const deviceCharHeight(Range)(RefAppender);
    const fontFamily(Range)(RefAppender);
    const fontSize(Range)(RefAppender);
    const fontWeight(Range)(RefAppender);
    const fontWeightBold(Range)(RefAppender);
    const allowTransparency(Range)(RefAppender);
    const drawBoldTextInBrightColors(Range)(RefAppender);
    const minimumContrastRatio(Range)(RefAppender);
    const colors(clonedColors);
  


export void configEquals(a, ICharAtlasConfig, b, ICharAtlasConfig) (a, b, c, d) {
  for (let i = 0; i < a.colors.ansi.length; i++) {
    if (a.colors.ansi[i].rgba != b.colors.ansi[i].rgba) {
      return false;
    }
  }
  return a.devicePixelRatio == b.devicePixelRatio &&
      a.customGlyphs == b.customGlyphs &&
      a.lineHeight == b.lineHeight &&
      a.letterSpacing == b.letterSpacing &&
      a.fontFamily == b.fontFamily &&
      a.fontSize == b.fontSize &&
      a.fontWeight == b.fontWeight &&
      a.fontWeightBold == b.fontWeightBold &&
      a.allowTransparency == b.allowTransparency &&
      a.deviceCharWidth == b.deviceCharWidth &&
      a.deviceCharHeight == b.deviceCharHeight &&
      a.drawBoldTextInBrightColors == b.drawBoldTextInBrightColors &&
      a.minimumContrastRatio == b.minimumContrastRatio &&
      a.colors.foreground.rgba == b.colors.foreground.rgba &&
      a.colors.background.rgba == b.colors.background.rgba;
}

export void is256Color(colorCode, number) (ref colorCode) {
  return (colorCode & Attributes.CM_MASK) == Attributes.CM_P16 || (colorCode & Attributes.CM_MASK) == Attributes.CM;
}



