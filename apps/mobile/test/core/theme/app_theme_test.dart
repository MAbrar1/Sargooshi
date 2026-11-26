import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/theme/app_theme.dart';
import 'package:sargoshi/core/theme/generated/sargoshi_tokens.g.dart';

void main() {
  test('dark is the product default and uses blueprint ink tokens', () {
    final theme = AppTheme.build(
      brightness: Brightness.dark,
      preset: SargoshiThemePreset.dark,
    );

    expect(AppTheme.flutterModeFor(SargoshiThemePreset.dark), ThemeMode.dark);
    expect(theme.scaffoldBackgroundColor, SargoshiColors.defaults.ink);
    expect(
      theme.extension<SargoshiColors>()?.dusk2,
      SargoshiColors.defaults.dusk2,
    );
  });

  test('light preset uses parchment and paper surfaces', () {
    final theme = AppTheme.build(
      brightness: Brightness.light,
      preset: SargoshiThemePreset.light,
    );
    final colors = theme.extension<SargoshiColors>()!;

    expect(theme.brightness, Brightness.light);
    expect(colors.ink, SargoshiColors.defaults.parchment);
    expect(colors.dusk, SargoshiColors.defaults.paper);
  });

  test('AMOLED preset uses pure black as the root surface', () {
    final theme = AppTheme.build(
      brightness: Brightness.dark,
      preset: SargoshiThemePreset.amoled,
    );

    expect(theme.scaffoldBackgroundColor, const Color(0xFF000000));
  });

  test('dynamic preset adopts a supplied platform scheme', () {
    const dynamicScheme = ColorScheme.dark(
      primary: Color(0xFF345678),
      surface: Color(0xFF112233),
      onSurface: Color(0xFFF0F0F0),
    );
    final theme = AppTheme.build(
      brightness: Brightness.dark,
      preset: SargoshiThemePreset.dynamic,
      dynamicScheme: dynamicScheme,
    );

    expect(theme.colorScheme.primary, dynamicScheme.primary);
    expect(theme.scaffoldBackgroundColor, dynamicScheme.surface);
  });
}
