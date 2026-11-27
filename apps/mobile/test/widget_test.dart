import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/app/sargoshi_app.dart';
import 'package:sargoshi/core/settings/app_settings.dart';
import 'support/memory_app_settings_preferences.dart';

Widget _testApp({
  bool disableAnimations = false,
  AppLanguage language = AppLanguage.system,
}) {
  final app = ProviderScope(
    overrides: [
      appSettingsStoreProvider.overrideWithValue(
        createMemoryAppSettingsStore(
          initialValues: language == AppLanguage.system
              ? const {}
              : {'sargoshi.settings.app_language': language.name},
        ),
      ),
    ],
    child: const SargoshiApp(),
  );

  // Route/shell tests validate content and navigation, not continuous motion.
  // Animation-specific behavior is covered by sg_brand_pulse_test.dart.
  return disableAnimations ? TickerMode(enabled: false, child: app) : app;
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

  testWidgets('Urdu language preference selects Urdu copy and RTL direction',
      (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('ur');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(_testApp(language: AppLanguage.urdu));
    // Both the persisted preference and Flutter's platform locale are set to
    // Urdu; pump the async provider rebuild before asserting localized widgets.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump();

    expect(find.text('سرگوشی'), findsOneWidget);
    expect(find.text('آہستگی سے کہیے۔'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('سرگوشی'))),
      TextDirection.rtl,
    );
  });
  testWidgets('welcome action opens the local inbox preview', (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(_testApp(disableAnimations: true));
    final inboxAction = find.byKey(
      const ValueKey<String>('welcome-inbox-preview'),
    );
    await tester.ensureVisible(inboxAction);
    await tester.tap(inboxAction);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('LOCAL PREVIEW'), findsOneWidget);
    expect(find.text('Ayesha Khan'), findsOneWidget);
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

    // Scroll the gallery's own ListView. The footer is a lazy child and does
    // not exist in the element tree until the list reaches that position.
    final galleryList = find.byKey(
      const ValueKey<String>('debug-component-gallery-scroll'),
    );
    final galleryScrollable = find
        .descendant(
          of: galleryList,
          matching: find.byType(Scrollable),
        )
        .first;
    final galleryFooter = find.text(
      'Debug gallery only — no production operations are wired here.',
    );
    await tester.scrollUntilVisible(
      galleryFooter,
      320,
      scrollable: galleryScrollable,
    );
    expect(galleryFooter, findsOneWidget);
  });
}
