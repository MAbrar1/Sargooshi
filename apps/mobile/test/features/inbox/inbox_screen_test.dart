import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/theme/app_theme.dart';
import 'package:sargoshi/features/inbox/inbox_screen.dart';
import 'package:sargoshi/l10n/generated/app_localizations.dart';

Widget _testInboxApp({Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.build(
      brightness: Brightness.dark,
      preset: SargoshiThemePreset.dark,
    ),
    home: const InboxScreen(),
  );
}

void main() {
  testWidgets('inbox clearly identifies sample conversations', (tester) async {
    await tester.pumpWidget(_testInboxApp());

    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('LOCAL PREVIEW'), findsOneWidget);
    expect(find.text('Ayesha Khan'), findsOneWidget);
    expect(find.text('Hamza Ali'), findsOneWidget);
    expect(find.text('Family Circle'), findsOneWidget);
    expect(find.text('Sara Ahmed'), findsOneWidget);
  });

  testWidgets('search matches conversation names and message previews',
      (tester) async {
    await tester.pumpWidget(_testInboxApp());

    await tester.enterText(
      find.byKey(const ValueKey<String>('inbox-search')),
      'coffee',
    );
    await tester.pump();

    expect(find.text('Ayesha Khan'), findsOneWidget);
    expect(find.text('Hamza Ali'), findsNothing);
    expect(find.text('Family Circle'), findsNothing);
  });

  testWidgets('search normalizes Arabic and Urdu letter variants',
      (tester) async {
    await tester.pumpWidget(_testInboxApp());

    await tester.enterText(
      find.byKey(const ValueKey<String>('inbox-search')),
      'الله',
    );
    await tester.pump();

    expect(find.text('Family Circle'), findsOneWidget);
    expect(find.text('Ayesha Khan'), findsNothing);
  });

  testWidgets('unread filter only shows conversations with unread messages',
      (tester) async {
    await tester.pumpWidget(_testInboxApp());

    await tester.tap(
      find.byKey(const ValueKey<String>('inbox-filter-unread')),
    );
    await tester.pump();

    expect(find.text('Ayesha Khan'), findsOneWidget);
    expect(find.text('Family Circle'), findsOneWidget);
    expect(find.text('Hamza Ali'), findsNothing);
    expect(find.text('Sara Ahmed'), findsNothing);
  });

  testWidgets('groups filter excludes one-to-one conversations',
      (tester) async {
    await tester.pumpWidget(_testInboxApp());

    await tester.tap(
      find.byKey(const ValueKey<String>('inbox-filter-groups')),
    );
    await tester.pump();

    expect(find.text('Family Circle'), findsOneWidget);
    expect(find.text('Ayesha Khan'), findsNothing);
    expect(find.text('Hamza Ali'), findsNothing);
  });

  testWidgets('no-result state appears when search has no matches',
      (tester) async {
    await tester.pumpWidget(_testInboxApp());

    await tester.enterText(
      find.byKey(const ValueKey<String>('inbox-search')),
      'no matching conversation',
    );
    await tester.pump();

    expect(find.text('Nothing matched'), findsOneWidget);
    expect(find.text('Ayesha Khan'), findsNothing);
  });

  testWidgets('opening a sample conversation explains preview-only behavior',
      (tester) async {
    await tester.pumpWidget(_testInboxApp());

    await tester.tap(
      find.byKey(const ValueKey<String>('inbox-conversation-ayesha')),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Ayesha Khan'),
      ),
      findsOneWidget,
    );
    expect(
      find.text('Sample content only. Messaging is not connected yet.'),
      findsOneWidget,
    );
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('Urdu locale applies RTL direction and translated inbox labels',
      (tester) async {
    await tester.pumpWidget(_testInboxApp(locale: const Locale('ur')));

    expect(find.text('پیغامات'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('پیغامات'))),
      TextDirection.rtl,
    );
    expect(find.text('مقامی پیش نظارہ'), findsOneWidget);
  });
}
