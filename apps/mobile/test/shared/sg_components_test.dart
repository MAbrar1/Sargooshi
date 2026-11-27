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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SgChatBubble(
                message: 'A quiet whisper',
                timestamp: '09:32',
                variant: SgChatBubbleVariant.whisper,
              ),
              const SgChatBubble(
                message: 'System update',
                timestamp: '09:33',
                variant: SgChatBubbleVariant.system,
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
              SizedBox(
                height: 360,
                child: SgNavigationRail(
                  destinations: destinations,
                  selectedIndex: 0,
                  onDestinationSelected: _noopInt,
                ),
              ),
              ],
            ),
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
  testWidgets('SG:CMP-01 disabled buttons stay inert and loading shows progress',
      (tester) async {
    var actions = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: Scaffold(
          body: Column(
            children: [
              const SgButton(label: 'Disabled action', onPressed: null),
              SgButton(
                label: 'Loading action',
                isLoading: true,
                onPressed: () => actions += 1,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Disabled action'));
    await tester.tap(find.text('Loading action'));
    await tester.pump();
    expect(actions, 0);
  });

  testWidgets('SG:CMP-16 whisper bubble uses the prescribed 78 percent fill',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: const Scaffold(
          body: SgChatBubble(
            message: 'Whisper message',
            timestamp: '09:32',
            variant: SgChatBubbleVariant.whisper,
          ),
        ),
      ),
    );

    final ancestorContainers = tester.widgetList<Container>(
      find.ancestor(
        of: find.text('Whisper message'),
        matching: find.byType(Container),
      ),
    );
    final bubble = ancestorContainers.firstWhere(
      (container) =>
          container.decoration is BoxDecoration &&
          (container.decoration! as BoxDecoration).color != null,
    );
    final fill = (bubble.decoration! as BoxDecoration).color!;
    expect(fill.a, closeTo(0.78, 0.01));
  });

  testWidgets('SG:CMP-19 composer exposes attach, voice, six-line input and send',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var attachCount = 0;
    var voiceCount = 0;
    String? sentMessage;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: Scaffold(
          body: SgComposer(
            controller: controller,
            hint: 'Write a message',
            attachTooltip: 'Attach file',
            voiceTooltip: 'Record voice',
            sendTooltip: 'Send message',
            onAttach: () => attachCount += 1,
            onVoice: () => voiceCount += 1,
            onSend: (value) => sentMessage = value,
          ),
        ),
      ),
    );

    expect(tester.widget<TextField>(find.byType(TextField)).maxLines, 6);
    await tester.tap(find.byTooltip('Attach file'));
    await tester.tap(find.byTooltip('Record voice'));
    expect(attachCount, 1);
    expect(voiceCount, 1);

    await tester.enterText(find.byType(TextField), '  Hello privately  ');
    await tester.pump();
    await tester.tap(find.byTooltip('Send message'));
    await tester.pump();

    expect(sentMessage, 'Hello privately');
    expect(controller.text, isEmpty);
    expect(find.byTooltip('Record voice'), findsOneWidget);
  });

  testWidgets('SG:CMP-06 filter, assist, input and suggestion chips dispatch selection',
      (tester) async {
    final selected = <String, bool>{};
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: Scaffold(
          body: Wrap(
            children: [
              SgChip(
                label: 'Filter chip',
                variant: SgChipVariant.filter,
                onSelected: (value) => selected['filter'] = value,
              ),
              SgChip(
                label: 'Assist chip',
                variant: SgChipVariant.assist,
                onSelected: (value) => selected['assist'] = value,
              ),
              SgChip(
                label: 'Input chip',
                variant: SgChipVariant.input,
                onSelected: (value) => selected['input'] = value,
              ),
              SgChip(
                label: 'Suggestion chip',
                variant: SgChipVariant.suggestion,
                onSelected: (value) => selected['suggestion'] = value,
              ),
            ],
          ),
        ),
      ),
    );

    for (final label in [
      'Filter chip',
      'Assist chip',
      'Input chip',
      'Suggestion chip',
    ]) {
      await tester.tap(find.text(label));
      await tester.pump();
    }

    expect(selected, {
      'filter': true,
      'assist': true,
      'input': true,
      'suggestion': true,
    });
  });

  testWidgets('SG:CMP-08 search, PIN, passphrase reveal and error states render',
      (tester) async {
    final passphraseController = TextEditingController();
    addTearDown(passphraseController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: Scaffold(
          body: ListView(
            children: [
              const SgTextField(
                label: 'Search',
                variant: SgTextFieldVariant.search,
                hint: 'Search privately',
              ),
              const SgTextField(
                label: 'PIN',
                variant: SgTextFieldVariant.pin,
                showVisibilityToggle: false,
                maxLength: 6,
              ),
              SgTextField(
                label: 'Passphrase',
                controller: passphraseController,
                variant: SgTextFieldVariant.passphrase,
                revealTooltip: 'Reveal passphrase',
                concealTooltip: 'Conceal passphrase',
              ),
              const SgTextField(
                label: 'Username',
                error: 'That username is unavailable.',
              ),
            ],
          ),
        ),
      ),
    );

    final fields = tester.widgetList<TextField>(find.byType(TextField)).toList();
    expect(fields, hasLength(4));
    expect(fields[0].keyboardType, TextInputType.text);
    expect(fields[1].keyboardType, TextInputType.number);
    expect(fields[1].maxLength, 6);
    expect(fields[2].obscureText, isTrue);
    expect(find.text('That username is unavailable.'), findsOneWidget);

    await tester.tap(find.byTooltip('Reveal passphrase'));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField).at(2)).obscureText,
        isFalse);
    await tester.tap(find.byTooltip('Conceal passphrase'));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField).at(2)).obscureText,
        isTrue);
  });

  mainComponentRegistryCoverage();
}


final _componentCases = <({
  String tag,
  String name,
  void Function(WidgetTester tester) verify,
})>[
  (tag: 'SG:CMP-01', name: 'primary button', verify: (tester) {
    expect(find.text('Primary'), findsOneWidget);
  }),
  (tag: 'SG:CMP-02', name: 'tonal button', verify: (tester) {
    expect(find.text('Tonal'), findsOneWidget);
  }),
  (tag: 'SG:CMP-03', name: 'ghost button', verify: (tester) {
    expect(find.text('Ghost'), findsOneWidget);
  }),
  (tag: 'SG:CMP-04', name: 'icon button', verify: (tester) {
    expect(find.byType(SgIconButton), findsOneWidget);
  }),
  (tag: 'SG:CMP-05', name: 'floating action button', verify: (tester) {
    expect(find.byType(SgFab), findsOneWidget);
  }),
  (tag: 'SG:CMP-06', name: 'chip', verify: (tester) {
    expect(find.byType(SgChip), findsOneWidget);
  }),
  (tag: 'SG:CMP-07', name: 'segmented control', verify: (tester) {
    expect(find.byType(SgSegmentedControl<int>), findsOneWidget);
  }),
  (tag: 'SG:CMP-08', name: 'text field', verify: (tester) {
    expect(find.byType(SgTextField), findsOneWidget);
  }),
  (tag: 'SG:CMP-09', name: 'toggle', verify: (tester) {
    expect(find.byType(SgToggle), findsOneWidget);
  }),
  (tag: 'SG:CMP-10', name: 'slider', verify: (tester) {
    expect(find.byType(SgSlider), findsOneWidget);
  }),
  (tag: 'SG:CMP-11', name: 'checkbox and radio', verify: (tester) {
    expect(find.byType(SgCheckbox), findsOneWidget);
    expect(find.byType(SgRadio<String>), findsOneWidget);
  }),
  (tag: 'SG:CMP-12', name: 'avatar', verify: (tester) {
    expect(find.byType(SgAvatar), findsOneWidget);
  }),
  (tag: 'SG:CMP-13', name: 'badge', verify: (tester) {
    expect(find.byType(SgBadge), findsNWidgets(2));
  }),
  (tag: 'SG:CMP-14', name: 'list tile', verify: (tester) {
    expect(find.byType(SgListTile), findsOneWidget);
  }),
  (tag: 'SG:CMP-15', name: 'card', verify: (tester) {
    expect(find.byType(SgCard), findsNWidgets(3));
  }),
  (tag: 'SG:CMP-16', name: 'chat bubble', verify: (tester) {
    expect(find.byType(SgChatBubble), findsNWidgets(4));
  }),
  (tag: 'SG:CMP-17', name: 'rule badge', verify: (tester) {
    expect(find.byType(SgRuleBadge), findsOneWidget);
  }),
  (tag: 'SG:CMP-18', name: 'reaction bar', verify: (tester) {
    expect(find.byType(SgReactionBar), findsOneWidget);
  }),
  (tag: 'SG:CMP-19', name: 'composer', verify: (tester) {
    expect(find.byType(SgComposer), findsOneWidget);
  }),
  (tag: 'SG:CMP-20', name: 'top app bar', verify: (tester) {
    expect(find.byType(SgTopAppBar), findsOneWidget);
  }),
  (tag: 'SG:CMP-21', name: 'bottom navigation', verify: (tester) {
    expect(find.byType(SgBottomNavigation), findsOneWidget);
  }),
  (tag: 'SG:CMP-22', name: 'navigation rail', verify: (tester) {
    expect(find.byType(SgNavigationRail), findsOneWidget);
  }),
  (tag: 'SG:CMP-23', name: 'bottom sheet', verify: (tester) {
    expect(find.byType(SgBottomSheet), findsOneWidget);
  }),
  (tag: 'SG:CMP-26', name: 'banner', verify: (tester) {
    expect(find.byType(SgBanner), findsOneWidget);
  }),
  (tag: 'SG:CMP-27', name: 'alert card', verify: (tester) {
    expect(find.byType(SgAlertCard), findsOneWidget);
  }),
  (tag: 'SG:CMP-28', name: 'PIN pad', verify: (tester) {
    expect(find.byType(SgPinPad), findsOneWidget);
  }),
  (tag: 'SG:CMP-29', name: 'stat ring', verify: (tester) {
    expect(find.byType(SgStatRing), findsOneWidget);
  }),
  (tag: 'SG:CMP-30', name: 'progress variants', verify: (tester) {
    expect(find.byType(SgProgress), findsNWidgets(3));
  }),
  (tag: 'SG:CMP-31', name: 'skeleton variants', verify: (tester) {
    expect(find.byType(SgSkeleton), findsNWidgets(3));
  }),
  (tag: 'SG:CMP-32', name: 'empty state', verify: (tester) {
    expect(find.byType(SgEmptyState), findsOneWidget);
  }),
];

void mainComponentRegistryCoverage() {
  for (final component in _componentCases) {
    for (final direction in TextDirection.values) {
      testWidgets(
        '${component.tag} ${component.name} renders at 200 percent in $direction',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(600, 1600));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            buildGalleryHarness(direction: direction, textScale: 2),
          );
          component.verify(tester);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('SG:CMP-24 destructive dialog returns the chosen result',
      (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await SgDialog.confirmDestructive(
                  context: context,
                  title: 'Delete account?',
                  message: 'This action cannot be undone.',
                  cancelLabel: 'Cancel',
                  confirmLabel: 'Delete',
                );
              },
              child: const Text('Open confirm dialog'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open confirm dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Delete account?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('SG:CMP-25 snackbar undo invokes its action',
      (tester) async {
    var undoCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => SgSnackbar.show(
                context: context,
                message: 'Message sent',
                undoLabel: 'Undo',
                onUndo: () => undoCount += 1,
              ),
              child: const Text('Show snackbar'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show snackbar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Message sent'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(undoCount, 1);
  });

  testWidgets('SG:CMP-28 scrambled PIN pad exposes all ten digits',
      (tester) async {
    final selected = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: Scaffold(
          body: SgPinPad(
            scrambled: true,
            onDigit: selected.add,
            onBackspace: _noop,
            backspaceTooltip: 'Delete last digit',
            digitSemanticLabel: (digit) => 'Digit $digit',
          ),
        ),
      ),
    );
    for (var digit = 0; digit <= 9; digit += 1) {
      expect(find.text('$digit'), findsOneWidget);
    }
    await tester.tap(find.text('7'));
    expect(selected, hasLength(1));
    expect(selected.single, 7);
  });
}
