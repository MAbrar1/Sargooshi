import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/app/sargoshi_app.dart';
import 'package:sargoshi/core/settings/app_settings.dart';
import 'support/memory_app_settings_preferences.dart';

Widget _testApp({bool disableAnimations = false}) {
  final app = ProviderScope(
    overrides: [
      appSettingsStoreProvider.overrideWithValue(
        createMemoryAppSettingsStore(),
      ),
    ],
    child: const SargoshiApp(),
  );

  // Route/shell tests validate content and navigation, not continuous motion.
  // Animation-specific behavior is covered by sg_brand_pulse_test.dart.
  return disableAnimations
      ? TickerMode(enabled: false, child: app)
      : app;
}

void main() {
  testWidgets('English welcome copy renders from generated resources',
      (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(_testApp());

    expect(find.text('Sargoshi'), findsOneWidget);
    expect(find.text('Say it softly.'), findsOneWidget);
    expect(
      find.text(
        'Private by default. Only you and the people you message can read your chats.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Urdu locale selects Urdu copy and right-to-left direction',
      (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('ur');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(_testApp());

    expect(find.text('سرگوشی'), findsOneWidget);
    expect(find.text('آہستگی سے کہیے۔'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('سرگوشی'))),
      TextDirection.rtl,
    );
  });
  testWidgets('debug-only component gallery is reachable from welcome screen',
      (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(_testApp(disableAnimations: true));
    expect(find.byTooltip('Open debug component gallery'), findsOneWidget);

    await tester.tap(find.byTooltip('Open debug component gallery'));

    // The welcome screen pulse and gallery loading indicator are intentionally
    // repeating animations, so pump the finite route transition explicitly.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Design system gallery'), findsOneWidget);
    expect(find.text('Runtime preferences'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('App language'), findsOneWidget);
    expect(find.text('Lite UI'), findsOneWidget);
    expect(find.text('Performance tier'), findsOneWidget);

    // The gallery is intentionally scrollable; bring its footer into the
    // viewport before asserting against the lazily-built list child.
    await tester.scrollUntilVisible(
      find.text('Debug gallery only — no production operations are wired here.'),
      320,
    );
    expect(
      find.text('Debug gallery only — no production operations are wired here.'),
      findsOneWidget,
    );
  });

}
