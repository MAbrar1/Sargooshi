import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/app/sargoshi_app.dart';

void main() {
  testWidgets('English welcome copy renders from generated resources',
      (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(const ProviderScope(child: SargoshiApp()));

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

    await tester.pumpWidget(const ProviderScope(child: SargoshiApp()));

    expect(find.text('سرگوشی'), findsOneWidget);
    expect(find.text('آہستگی سے کہیے۔'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('سرگوشی'))),
      TextDirection.rtl,
    );
  });
}
