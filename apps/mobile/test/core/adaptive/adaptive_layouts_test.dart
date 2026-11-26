import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/adaptive/adaptive_layouts.dart';
import 'package:sargoshi/core/theme/app_theme.dart';
import 'package:sargoshi/shared/sg_components.dart';
import 'package:sargoshi/shared/sg_icon.dart';

const _destinations = [
  SgNavigationDestination(label: 'Chats', icon: SgIconName.chats),
  SgNavigationDestination(label: 'Vault', icon: SgIconName.vault),
  SgNavigationDestination(label: 'Calls', icon: SgIconName.calls),
  SgNavigationDestination(label: 'You', icon: SgIconName.you),
];

Widget _harness({required double width, required Widget child}) {
  return MaterialApp(
    theme: AppTheme.build(
      brightness: Brightness.dark,
      preset: SargoshiThemePreset.dark,
    ),
    home: MediaQuery(
      data: MediaQueryData(size: Size(width, 900)),
      child: child,
    ),
  );
}

void main() {
  testWidgets('adaptive scaffold uses bottom navigation on compact widths',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        width: 500,
        child: const SgAdaptiveScaffold(
          destinations: _destinations,
          selectedIndex: 0,
          onDestinationSelected: _noopIndex,
          body: Text('Compact content'),
        ),
      ),
    );

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('adaptive scaffold uses a compact rail at medium widths',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(700, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        width: 700,
        child: const SgAdaptiveScaffold(
          destinations: _destinations,
          selectedIndex: 0,
          onDestinationSelected: _noopIndex,
          body: Text('Medium content'),
        ),
      ),
    );

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse);
  });

  testWidgets('adaptive scaffold extends rail on expanded widths',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1100, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        width: 1100,
        child: const SgAdaptiveScaffold(
          destinations: _destinations,
          selectedIndex: 0,
          onDestinationSelected: _noopIndex,
          body: Text('Expanded content'),
        ),
      ),
    );

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isTrue);
  });

  testWidgets('three-pane layout waits until the chat pane has usable width',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        width: 900,
        child: const SgAdaptivePaneLayout(
          listPane: Text('Conversation list'),
          chatPane: Text('Conversation'),
          infoPane: Text('Conversation details'),
          compactPane: Text('Compact conversation'),
        ),
      ),
    );

    expect(find.text('Conversation list'), findsOneWidget);
    expect(find.text('Conversation'), findsOneWidget);
    expect(find.text('Conversation details'), findsNothing);
  });

  testWidgets('three-pane layout appears when all pane minimums fit',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        width: 1280,
        child: const SgAdaptivePaneLayout(
          listPane: Text('Conversation list'),
          chatPane: Text('Conversation'),
          infoPane: Text('Conversation details'),
          compactPane: Text('Compact conversation'),
        ),
      ),
    );

    expect(find.text('Conversation details'), findsOneWidget);
  });

  testWidgets('compact pane is used instead of rendering hidden columns',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        width: 390,
        child: const SgAdaptivePaneLayout(
          listPane: Text('Conversation list'),
          chatPane: Text('Conversation'),
          compactPane: Text('Selected conversation'),
        ),
      ),
    );

    expect(find.text('Selected conversation'), findsOneWidget);
    expect(find.text('Conversation list'), findsNothing);
  });
}

void _noopIndex(int _) {}
