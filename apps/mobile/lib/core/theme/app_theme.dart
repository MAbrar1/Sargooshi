import 'package:flutter/material.dart';

import 'generated/sargoshi_tokens.g.dart';

enum SargoshiThemePreset {
  system,
  dark,
  light,
  amoled,
  midnightSky,
  highContrast,
  dynamic,
}

abstract final class AppTheme {
  static ThemeData build({
    required Brightness brightness,
    required SargoshiThemePreset preset,
    ColorScheme? dynamicScheme,
  }) {
    const base = SargoshiColors.defaults;
    final isDynamic =
        preset == SargoshiThemePreset.dynamic && dynamicScheme != null;
    final colors = _resolveColors(
      base: base,
      preset: preset,
      brightness: brightness,
      dynamicScheme: isDynamic ? dynamicScheme : null,
    );
    final scheme = isDynamic
        ? dynamicScheme
        : _resolveScheme(
            colors: colors,
            brightness: brightness,
            preset: preset,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.ink,
      fontFamily: 'Inter',
      extensions: <ThemeExtension<dynamic>>[colors],
      textTheme: const TextTheme(
        displayLarge: SargoshiType.displayL,
        displayMedium: SargoshiType.display,
        headlineLarge: SargoshiType.headline,
        titleLarge: SargoshiType.title,
        titleMedium: SargoshiType.titleS,
        bodyLarge: SargoshiType.bodyL,
        bodyMedium: SargoshiType.body,
        bodySmall: SargoshiType.caption,
        labelLarge: SargoshiType.label,
        labelSmall: SargoshiType.caption,
      ).apply(
        bodyColor: colors.moon,
        displayColor: colors.moon,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.ink,
        foregroundColor: colors.moon,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: SargoshiType.titleS.copyWith(color: colors.moon),
      ),
      cardTheme: CardThemeData(
        color: colors.dusk,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.card),
          side: BorderSide(
              color:
                  colors.line.withValues(alpha: SargoshiOpacity.cardOutline)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: colors.paper,
          backgroundColor: colors.ember,
          disabledForegroundColor:
              colors.mist.withValues(alpha: SargoshiOpacity.disabledContent),
          disabledBackgroundColor: colors.dusk2,
          minimumSize: const Size(0, SargoshiBreakpoint.minInteractiveTarget),
          padding: const EdgeInsets.symmetric(horizontal: SargoshiSpace.s20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SargoshiShape.button),
          ),
          textStyle: SargoshiType.label,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.moon,
          minimumSize: const Size(0, SargoshiBreakpoint.minInteractiveTarget),
          side: BorderSide(color: colors.line, width: SargoshiStroke.ghost),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SargoshiShape.button),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.dusk2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SargoshiSpace.s16,
          vertical: SargoshiSpace.s16,
        ),
        hintStyle: SargoshiType.body.copyWith(color: colors.mist),
        labelStyle: SargoshiType.body.copyWith(color: colors.mist),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.button),
          borderSide: BorderSide(color: colors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.button),
          borderSide: BorderSide(color: colors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.button),
          borderSide:
              BorderSide(color: colors.glow, width: SargoshiStroke.focus),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.button),
          borderSide: BorderSide(color: colors.coral),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.button),
          borderSide:
              BorderSide(color: colors.coral, width: SargoshiStroke.focus),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.line,
        thickness: SargoshiStroke.hairline,
        space: SargoshiSpace.s16,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.dusk3,
        contentTextStyle: SargoshiType.body.copyWith(color: colors.moon),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.card),
        ),
      ),
      iconTheme: IconThemeData(color: colors.mist),
      focusColor: colors.glow.withValues(alpha: SargoshiOpacity.focusedOverlay),
      splashColor:
          colors.glow.withValues(alpha: SargoshiOpacity.pressedOverlay),
      highlightColor:
          colors.glow.withValues(alpha: SargoshiOpacity.pressedOverlay),
      visualDensity: VisualDensity.standard,
    );
  }

  static ThemeMode flutterModeFor(SargoshiThemePreset preset) {
    return switch (preset) {
      SargoshiThemePreset.light => ThemeMode.light,
      SargoshiThemePreset.dark ||
      SargoshiThemePreset.amoled ||
      SargoshiThemePreset.midnightSky ||
      SargoshiThemePreset.highContrast =>
        ThemeMode.dark,
      SargoshiThemePreset.system ||
      SargoshiThemePreset.dynamic =>
        ThemeMode.system,
    };
  }

  static SargoshiColors _resolveColors({
    required SargoshiColors base,
    required SargoshiThemePreset preset,
    required Brightness brightness,
    ColorScheme? dynamicScheme,
  }) {
    if (dynamicScheme != null) {
      return base.copyWith(
        ink: dynamicScheme.surface,
        dusk: dynamicScheme.surfaceContainerLow,
        dusk2: dynamicScheme.surfaceContainerHigh,
        dusk3: dynamicScheme.surfaceContainerHighest,
        line: dynamicScheme.outlineVariant,
        moon: dynamicScheme.onSurface,
        mist: dynamicScheme.onSurfaceVariant,
        ember: dynamicScheme.primary,
        rose: dynamicScheme.secondary,
      );
    }

    if (brightness == Brightness.light || preset == SargoshiThemePreset.light) {
      return base.copyWith(
        ink: base.parchment,
        dusk: base.paper,
        dusk2: base.paper,
        dusk3: base.parchment,
        line: base.lightSecondary
            .withValues(alpha: SargoshiOpacity.subtleOutline),
        moon: base.ink,
        mist: base.lightSecondary,
        ember: base.lightAccentText,
      );
    }

    if (preset == SargoshiThemePreset.amoled) {
      return base.copyWith(
        ink: base.amoled,
        dusk: base.amoled,
        dusk2: base.dusk,
        dusk3: base.dusk2,
      );
    }

    return base;
  }

  static ColorScheme _resolveScheme({
    required SargoshiColors colors,
    required Brightness brightness,
    required SargoshiThemePreset preset,
  }) {
    final isLight =
        brightness == Brightness.light || preset == SargoshiThemePreset.light;
    final highContrast = preset == SargoshiThemePreset.highContrast;
    final primary =
        preset == SargoshiThemePreset.midnightSky ? colors.sky : colors.ember;

    final base = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: isLight ? Brightness.light : Brightness.dark,
      surface: isLight ? colors.parchment : colors.ink,
      contrastLevel: highContrast ? 1.0 : 0.0,
    );

    return base.copyWith(
      primary: primary,
      onPrimary: colors.paper,
      secondary: colors.rose,
      onSecondary: colors.paper,
      error: colors.coral,
      onError: colors.ink,
      surface: isLight ? colors.parchment : colors.ink,
      onSurface: isLight ? colors.ink : colors.moon,
      surfaceContainerLowest: isLight ? colors.paper : colors.ink,
      surfaceContainerLow: isLight ? colors.paper : colors.dusk,
      surfaceContainer: isLight ? colors.paper : colors.dusk,
      surfaceContainerHigh: isLight ? colors.parchment : colors.dusk2,
      surfaceContainerHighest: isLight ? colors.parchment : colors.dusk3,
      outline: colors.line,
      outlineVariant: colors.line,
    );
  }
}
