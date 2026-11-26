import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import 'router.dart';

class SargoshiApp extends ConsumerWidget {
  const SargoshiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final preset = ref.watch(themePresetProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp.router(
          title: 'Sargoshi',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(
            brightness: Brightness.light,
            preset: preset,
            dynamicScheme: lightDynamic,
          ),
          darkTheme: AppTheme.build(
            brightness: Brightness.dark,
            preset: preset,
            dynamicScheme: darkDynamic,
          ),
          themeMode: AppTheme.flutterModeFor(preset),
          routerConfig: router,
        );
      },
    );
  }
}
