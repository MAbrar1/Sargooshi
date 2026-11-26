// GENERATED FILE — DO NOT EDIT BY HAND.
// Source: docs/blueprint/design-tokens.json
// Regenerate: node tools/gen-tokens.mjs

import 'package:flutter/material.dart';

@immutable
class SargoshiColors extends ThemeExtension<SargoshiColors> {
  const SargoshiColors._(this.tokens);

  final Map<String, Color> tokens;

  static const Map<String, Color> palette = {
    'ink': Color(0xFF0B0D1A),
    'dusk': Color(0xFF161A33),
    'dusk2': Color(0xFF20254A),
    'dusk3': Color(0xFF2A3060),
    'line': Color(0xFF2E3463),
    'moon': Color(0xFFEDEBFF),
    'mist': Color(0xFFA7A9C7),
    'ember': Color(0xFFC2410C),
    'rose': Color(0xFFBE185D),
    'glow': Color(0xFFFF8A4C),
    'mint': Color(0xFF4ADE9C),
    'amber': Color(0xFFFFC857),
    'coral': Color(0xFFFF6B6B),
    'sky': Color(0xFF6EA8FF),
    'vaultIndigo': Color(0xFF4A3FD6),
    'vaultLilac': Color(0xFFB9B1FF),
    'amoled': Color(0xFF000000),
    'parchment': Color(0xFFFAF7F2),
    'paper': Color(0xFFFFFFFF),
    'lightSecondary': Color(0xFF5B5F7E),
    'lightAccentText': Color(0xFF9A3412),
  };

  static const SargoshiColors defaults = SargoshiColors._(palette);

  Color get ink => tokens['ink']!;
  Color get dusk => tokens['dusk']!;
  Color get dusk2 => tokens['dusk2']!;
  Color get dusk3 => tokens['dusk3']!;
  Color get line => tokens['line']!;
  Color get moon => tokens['moon']!;
  Color get mist => tokens['mist']!;
  Color get ember => tokens['ember']!;
  Color get rose => tokens['rose']!;
  Color get glow => tokens['glow']!;
  Color get mint => tokens['mint']!;
  Color get amber => tokens['amber']!;
  Color get coral => tokens['coral']!;
  Color get sky => tokens['sky']!;
  Color get vaultIndigo => tokens['vaultIndigo']!;
  Color get vaultLilac => tokens['vaultLilac']!;
  Color get amoled => tokens['amoled']!;
  Color get parchment => tokens['parchment']!;
  Color get paper => tokens['paper']!;
  Color get lightSecondary => tokens['lightSecondary']!;
  Color get lightAccentText => tokens['lightAccentText']!;

  static const List<Color> brandGradient = [Color(0xFFC2410C), Color(0xFFBE185D)];
  static const List<Color> vaultGradient = [Color(0xFF4A3FD6), Color(0xFF2B2397)];

  @override
  SargoshiColors copyWith({
    Color? ink,
    Color? dusk,
    Color? dusk2,
    Color? dusk3,
    Color? line,
    Color? moon,
    Color? mist,
    Color? ember,
    Color? rose,
    Color? glow,
    Color? mint,
    Color? amber,
    Color? coral,
    Color? sky,
    Color? vaultIndigo,
    Color? vaultLilac,
    Color? amoled,
    Color? parchment,
    Color? paper,
    Color? lightSecondary,
    Color? lightAccentText,
  }) => SargoshiColors._({
      'ink': ink ?? this.ink,
      'dusk': dusk ?? this.dusk,
      'dusk2': dusk2 ?? this.dusk2,
      'dusk3': dusk3 ?? this.dusk3,
      'line': line ?? this.line,
      'moon': moon ?? this.moon,
      'mist': mist ?? this.mist,
      'ember': ember ?? this.ember,
      'rose': rose ?? this.rose,
      'glow': glow ?? this.glow,
      'mint': mint ?? this.mint,
      'amber': amber ?? this.amber,
      'coral': coral ?? this.coral,
      'sky': sky ?? this.sky,
      'vaultIndigo': vaultIndigo ?? this.vaultIndigo,
      'vaultLilac': vaultLilac ?? this.vaultLilac,
      'amoled': amoled ?? this.amoled,
      'parchment': parchment ?? this.parchment,
      'paper': paper ?? this.paper,
      'lightSecondary': lightSecondary ?? this.lightSecondary,
      'lightAccentText': lightAccentText ?? this.lightAccentText,
  });

  @override
  SargoshiColors lerp(covariant SargoshiColors? other, double t) {
    if (other == null) return this;
    return SargoshiColors._({
      'ink': Color.lerp(ink, other.ink, t)!,
      'dusk': Color.lerp(dusk, other.dusk, t)!,
      'dusk2': Color.lerp(dusk2, other.dusk2, t)!,
      'dusk3': Color.lerp(dusk3, other.dusk3, t)!,
      'line': Color.lerp(line, other.line, t)!,
      'moon': Color.lerp(moon, other.moon, t)!,
      'mist': Color.lerp(mist, other.mist, t)!,
      'ember': Color.lerp(ember, other.ember, t)!,
      'rose': Color.lerp(rose, other.rose, t)!,
      'glow': Color.lerp(glow, other.glow, t)!,
      'mint': Color.lerp(mint, other.mint, t)!,
      'amber': Color.lerp(amber, other.amber, t)!,
      'coral': Color.lerp(coral, other.coral, t)!,
      'sky': Color.lerp(sky, other.sky, t)!,
      'vaultIndigo': Color.lerp(vaultIndigo, other.vaultIndigo, t)!,
      'vaultLilac': Color.lerp(vaultLilac, other.vaultLilac, t)!,
      'amoled': Color.lerp(amoled, other.amoled, t)!,
      'parchment': Color.lerp(parchment, other.parchment, t)!,
      'paper': Color.lerp(paper, other.paper, t)!,
      'lightSecondary': Color.lerp(lightSecondary, other.lightSecondary, t)!,
      'lightAccentText': Color.lerp(lightAccentText, other.lightAccentText, t)!,
    });
  }
}

abstract final class SargoshiSpace {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s64 = 64;
}

abstract final class SargoshiShape {
  static const double button = 14;
  static const double card = 16;
  static const double bubble = 18;
  static const double sheet = 28;
  static const double chip = 999;
  static const double fab = 18;
}

abstract final class SargoshiMotion {
  static const Duration micro = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 200);
  static const Duration screen = Duration(milliseconds: 320);
  static const Duration undoSnackbar = Duration(milliseconds: 5000);
  static const Duration tier1Screen = Duration(milliseconds: 150);
  static const double springSheetStiffness = 400;
  static const double springSheetDamping = 0.8;
}

abstract final class SargoshiOpacity {
  static const double pressedOverlay = 0.08;
  static const double focusedOverlay = 0.12;
  static const double disabledContent = 0.38;
  static const double subtleOutline = 0.24;
  static const double cardOutline = 0.62;
}

abstract final class SargoshiStroke {
  static const double hairline = 1;
  static const double ghost = 1.5;
  static const double focus = 2;
}

abstract final class SargoshiIconSize {
  static const double standard = 24;
  static const double boldThreshold = 18;
  static const double duotoneSecondaryOpacity = 0.2;
}

abstract final class SargoshiLayout {
  static const double welcomeMark = 76;
  static const double welcomeMarkIcon = 38;
  static const double welcomeContentMaxWidth = 560;
  static const double welcomePrincipleIcon = 22;
  static const double compactMargin = 16;
  static const double mediumMargin = 24;
  static const double expandedMargin = 32;
  static const double compactGutter = 8;
  static const double mediumGutter = 16;
  static const double expandedGutter = 16;
  static const double compactColumns = 4;
  static const double mediumColumns = 8;
  static const double expandedColumns = 12;
  static const double listPaneWidth = 340;
  static const double infoPaneWidth = 320;
  static const double minChatPaneWidth = 420;
}

abstract final class SargoshiComponents {
  static const double buttonHeight = 48;
  static const double chipHeight = 32;
  static const double segmentedHeight = 36;
  static const double textFieldHeight = 56;
  static const double searchHeight = 44;
  static const double toggleWidth = 46;
  static const double toggleHeight = 26;
  static const double switchThumb = 20;
  static const double sliderTrack = 4;
  static const double sliderThumb = 20;
  static const double checkboxSize = 24;
  static const double badgeHeight = 22;
  static const double listTileOneLine = 56;
  static const double listTileTwoLine = 72;
  static const double listTileThreeLine = 88;
  static const double ruleIcon = 15;
  static const double reactionBarHeight = 44;
  static const double composerMinHeight = 56;
  static const double topBarHeight = 64;
  static const double largeTopBarHeight = 112;
  static const double bottomNavigationHeight = 80;
  static const double navigationRailWidth = 72;
  static const double fabSize = 56;
  static const double dialogMaxWidth = 360;
  static const double alertEdge = 5;
  static const double pinKeySize = 52;
  static const double pinKeyGap = 12;
  static const double statRingSize = 88;
  static const double statRingStroke = 10;
  static const double progressMinThickness = 4;
  static const double progressMaxThickness = 10;
  static const double emptyIconSize = 80;
  static const double avatarDefaultSize = 48;
  static const double chatBubbleMaxWidth = 560;
}

abstract final class SargoshiEffects {
  static const double glassBlurSigma = 12;
}

abstract final class SargoshiElevation {
  static const double card = 2;
  static const double glass = 4;
}

abstract final class SargoshiType {
  static const TextStyle displayL = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontWeight: FontWeight.w800,
    fontSize: 36,
    height: 1.2222222222222223,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle display = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontWeight: FontWeight.w700,
    fontSize: 30,
    height: 1.2666666666666666,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle headline = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.3333333333333333,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle title = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.4,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle titleS = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 17,
    height: 1.411764705882353,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle bodyL = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle message = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.375,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.4666666666666666,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 1.3846153846153846,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.3333333333333333,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle mono = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.4666666666666666,
    fontFamilyFallback: ['NotoNaskhArabic'],
  );

  static const TextStyle urduBody = TextStyle(
    fontFamily: 'NotoNaskhArabic',
    fontWeight: FontWeight.w400,
    fontSize: 17,
    height: 1.7647058823529411,
  );

}

abstract final class SargoshiBreakpoint {
  static const double compact = 0;
  static const double medium = 600;
  static const double expanded = 840;
  static const double minInteractiveTarget = 48;
}
