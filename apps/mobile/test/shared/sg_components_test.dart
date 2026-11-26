import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/theme/app_theme.dart';
import 'package:sargoshi/shared/sg_components.dart';
import 'package:sargoshi/shared/sg_icon.dart';

Widget buildGalleryHarness({
  required TextDirection direction,
  required double textScale,
}) {
  final destinations = [
    const SgNavigationDestination(label: 'Chats', icon: SgIconName.chats),
    const SgNavigationDestination(label: 'Vault', icon: SgIconName.vault),
    const SgNavigationDestination(label: 'Calls', icon: SgIconName.calls),
    const SgNavigationDestination(label: 'You', icon: SgIconName.you),
  ];

  return MaterialApp(
    theme: AppTheme.build(
      brightness: Brightness.dark,
      preset: SargoshiThemePreset.dark,
    ),
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Directionality(
        textDirection: direction,
        child: Scaffold(
          appBar: const SgTopAppBar(title: 'Component review'),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SgButton(label: 'Primary', onPressed: _noop),
              const SizedBox(height: 8),
              const SgButton(
                label: 'Tonal',
                variant: SgButtonVariant.tonal,
                onPressed: _noop,
              ),
              const SizedBox(height: 8),
              const SgButton(
                label: 'Ghost',
                variant: SgButtonVariant.ghost,
                onPressed: _noop,
              ),
              const SgIconButton(
                icon: SgIconName.settings,
                tooltip: 'Settings',
                onPressed: _noop,
              ),
              const SgFab(
                icon: SgIconName.chats,
                tooltip: 'Start chat',
                onPressed: _noop,
              ),
              const SgChip(
                label: 'Unread',
                variant: SgChipVariant.filter,
              ),
              SgSegmentedControl<int>(
                values: const [0, 1],
                selected: 0,
                labelFor: (value) => value == 0 ? 'All' : 'Unread',
                onSelectionChanged: _noopInt,
              ),
              const SgTextField(
                label: 'Passphrase',
                variant: SgTextFieldVariant.passphrase,
                revealTooltip: 'Show passphrase',
                concealTooltip: 'Hide passphrase',
              ),
              const SgToggle(
                title: 'App lock',
                description: 'Protect this app',
                value: true,
                onChanged: _noopBool,
              ),
              const SgSlider(
                value: 40,
                label: 'Media quality',
                onChanged: _noopDouble,
              ),
              const SgCheckbox(
                value: true,
                title: 'Remember this device',
                onChanged: _noopNullableBool,
              ),
              const SgRadio<String>(
                value: 'dark',
                groupValue: 'dark',
                title: 'Dark theme',
                onChanged: _noopNullableString,
              ),
              const SgAvatar(initials: 'SA'),
              const Row(
                children: [
                  SgBadge.count(count: 12),
                  SizedBox(width: 8),
                  SgBadge.dot(),
                ],
              ),
              const SgListTile(
                title: 'Privacy',
                subtitle: 'Manage your private settings',
                lines: 2,
              ),
              const SgCard(child: Text('Surface card')),
              const SgCard(
                variant: SgCardVariant.outlined,
                child: Text('Outlined card'),
              ),
              const SgChatBubble(
                message: 'Hello there',
                timestamp: '09:30',
                variant: SgChatBubbleVariant.incoming,
              ),
              const SgChatBubble(
                message: 'A private reply',
                timestamp: '09:31',
                variant: SgChatBubbleVariant.outgoing,
              ),
              const SgRuleBadge(
                label: 'Forwarding disabled',
                icon: SgIconName.hidden,
              ),
              const SgReactionBar(
                reactions: [
                  SgReaction(emoji: '👍', count: 2, selected: true),
                  SgReaction(emoji: '❤️', count: 1),
                ],
                onReaction: _noopString,
              ),
              const SgComposer(onSend: _noopString, sendTooltip: 'Send'),
              const SgNavigationRail(
                destinations: [
                  SgNavigationDestination(label: 'Chats', icon: SgIconName.chats),
                  SgNavigationDestination(label: 'Vault', icon: SgIconName.vault),
                  SgNavigationDestination(label: 'Calls', icon: SgIconName.calls),
                  SgNavigationDestination(label: 'You', icon: SgIconName.you),
                ],
                selectedIndex: 0,
                onDestinationSelected: _noopInt,
              ),
              const SgBottomSheet(child: Text('Sheet content')),
              const SgBanner(
                title: 'Connection paused',
                message: 'Messages will send when your connection returns.',
                variant: SgBannerVariant.info,
              ),
              const SgAlertCard(
                title: 'Security notice',
                message: 'Review your active devices.',
                severity: SgAlertSeverity.warning,
              ),
              SgPinPad(
                onDigit: _noopInt,
                onBackspace: _noop,
                backspaceTooltip: 'Delete last digit',
                digitSemanticLabel: (digit) => 'Digit $digit',
              ),
              const SgStatRing(
                value: 0.75,
                valueLabel: '75%',
                label: 'Complete',
              ),
              const SgProgress(value: 0.65, label: 'Upload'),
              const SgProgress(
                value: 0.65,
                variant: SgProgressVariant.ring,
              ),
              const SgProgress(
                value: 0.65,
                variant: SgProgressVariant.segmented,
              ),
              const SgSkeleton(variant: SgSkeletonVariant.listRow),
              const SgSkeleton(
                variant: SgSkeletonVariant.gridCell,
                width: 96,
              ),
              const SgSkeleton(variant: SgSkeletonVariant.card),
              const SgEmptyState(
                icon: SgIconName.chats,
                title: 'No conversations',
                message: 'Start a private conversation.',
                actionLabel: 'Start chat',
                onAction: _noop,
              ),
              SgBottomNavigation(
                destinations: destinations,
                selectedIndex: 0,
                onDestinationSelected: _noopInt,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _noop() {}
void _noopInt(int value) {}
void _noopBool(bool value) {}
void _noopNullableBool(bool? value) {}
void _noopDouble(double value) {}
void _noopNullableString(String? value) {}
void _noopString(String value) {}

void main() {
  for (final direction in TextDirection.values) {
    testWidgets(
      'shared component catalogue lays out at 200 percent text in $direction',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(600, 1600));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          buildGalleryHarness(direction: direction, textScale: 2),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.byType(SgButton), findsNWidgets(4));
        expect(find.byType(SgIconButton), findsWidgets);
        expect(find.byType(SgPinPad), findsOneWidget);
        expect(find.byType(SgEmptyState), findsOneWidget);
      },
    );
  }

  testWidgets('primary action and PIN keypad return user selections',
      (tester) async {
    var buttonPressed = false;
    int? selectedDigit;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: Scaffold(
          body: ListView(
            children: [
              SgButton(
                label: 'Continue',
                onPressed: () => buttonPressed = true,
              ),
              SgPinPad(
                onDigit: (digit) => selectedDigit = digit,
                onBackspace: _noop,
                backspaceTooltip: 'Delete last digit',
                digitSemanticLabel: (digit) => 'Digit $digit',
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(buttonPressed, isTrue);

    await tester.tap(find.text('1').first);
    await tester.pump();
    expect(selectedDigit, 1);
  });
}
