import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType, Rect;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/adaptive/adaptive_layouts.dart';
import 'package:sargoshi/core/adaptive/foldable_layout.dart';
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

// SG:NET-01
void main() {
  testWidgets('adaptive scaffold uses bottom navigation on compact widths',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _harness(
        width: 500,
        child: SgAdaptiveScaffold(
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
        child: SgAdaptiveScaffold(
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
        child: SgAdaptiveScaffold(
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
  testWidgets('foldable book posture places list and chat on separate pages',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final hinge = DisplayFeature(
      bounds: const Rect.fromLTWH(496, 0, 8, 900),
      type: DisplayFeatureType.hinge,
      state: DisplayFeatureState.postureFlat,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(1000, 900),
            displayFeatures: [hinge],
          ),
          child: const SgFoldableLayout(
            regularLayout: Text('Regular layout'),
            bookListPane: Text('Book list'),
            bookChatPane: Text('Book chat'),
            tabletopVideoPane: Text('Tabletop video'),
            tabletopControlsPane: Text('Tabletop controls'),
          ),
        ),
      ),
    );

    expect(find.text('Regular layout'), findsNothing);
    expect(tester.getTopLeft(find.text('Book list')).dx,
        lessThan(tester.getTopLeft(find.text('Book chat')).dx));
  });

  testWidgets('foldable book layout mirrors its pages in RTL',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final hinge = DisplayFeature(
      bounds: const Rect.fromLTWH(496, 0, 8, 900),
      type: DisplayFeatureType.fold,
      state: DisplayFeatureState.postureFlat,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(1000, 900),
            displayFeatures: [hinge],
          ),
          child: const Directionality(
            textDirection: TextDirection.rtl,
            child: SgFoldableLayout(
              regularLayout: Text('Regular layout'),
              bookListPane: Text('Book list'),
              bookChatPane: Text('Book chat'),
              tabletopVideoPane: Text('Tabletop video'),
              tabletopControlsPane: Text('Tabletop controls'),
            ),
          ),
        ),
      ),
    );

    expect(tester.getTopLeft(find.text('Book chat')).dx,
        lessThan(tester.getTopLeft(find.text('Book list')).dx));
  });

  testWidgets('half-open horizontal hinge uses tabletop video and controls',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final hinge = DisplayFeature(
      bounds: const Rect.fromLTWH(0, 440, 900, 20),
      type: DisplayFeatureType.hinge,
      state: DisplayFeatureState.postureHalfOpened,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(900, 900),
            displayFeatures: [hinge],
          ),
          child: const SgFoldableLayout(
            regularLayout: Text('Regular layout'),
            bookListPane: Text('Book list'),
            bookChatPane: Text('Book chat'),
            tabletopVideoPane: Text('Tabletop video'),
            tabletopControlsPane: Text('Tabletop controls'),
          ),
        ),
      ),
    );

    expect(find.text('Regular layout'), findsNothing);
    expect(tester.getCenter(find.text('Tabletop video')).dy,
        lessThan(tester.getCenter(find.text('Tabletop controls')).dy));
  });

  testWidgets('camera cutouts are ignored by foldable posture detection',
      (tester) async {
    final cutout = DisplayFeature(
      bounds: const Rect.fromLTWH(0, 0, 32, 900),
      type: DisplayFeatureType.cutout,
      state: DisplayFeatureState.unknown,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(390, 844),
            displayFeatures: [cutout],
          ),
          child: const SgFoldableLayout(
            regularLayout: Text('Regular layout'),
            bookListPane: Text('Book list'),
            bookChatPane: Text('Book chat'),
            tabletopVideoPane: Text('Tabletop video'),
            tabletopControlsPane: Text('Tabletop controls'),
          ),
        ),
      ),
    );

    expect(find.text('Regular layout'), findsOneWidget);
    expect(find.text('Book list'), findsNothing);
  });

}

void _noopIndex(int _) {}
