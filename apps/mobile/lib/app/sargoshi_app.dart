import 'package:dynamic_color/dynamic_color.dart' as dynamic_color;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/performance/performance_profile.dart';
import '../core/settings/app_settings.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../l10n/generated/app_localizations.dart';
import 'router.dart';

// SG:LOC-01
class SargoshiApp extends ConsumerWidget {
  const SargoshiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final preset = ref.watch(themePresetProvider).valueOrNull ??
        SargoshiThemePreset.dark;
    final language = ref.watch(appLanguageProvider).valueOrNull ??
        AppLanguage.system;
    final performance = ref.watch(performanceProfileProvider);

    ThemeData withPerformance(ThemeData theme) {
      return theme.copyWith(
        extensions: <ThemeExtension<dynamic>>[
          ...theme.extensions.values,
          performance.themeVisuals,
        ],
      );
    }

    return dynamic_color.DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp.router(
          title: 'Sargoshi',
          locale: language.locale,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: withPerformance(
            AppTheme.build(
              brightness: Brightness.light,
              preset: preset,
              dynamicScheme: lightDynamic,
            ),
          ),
          darkTheme: withPerformance(
            AppTheme.build(
              brightness: Brightness.dark,
              preset: preset,
              dynamicScheme: darkDynamic,
            ),
          ),
          themeMode: AppTheme.flutterModeFor(preset),
          routerConfig: router,
        );
      },
    );
  }
}
