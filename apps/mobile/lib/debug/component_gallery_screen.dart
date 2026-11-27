import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/settings/app_settings.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../core/theme/generated/sargoshi_tokens.g.dart';
import '../shared/sg_components.dart';
import '../shared/sg_icon.dart';

class DebugComponentGalleryScreen extends StatefulWidget {
  const DebugComponentGalleryScreen({super.key});

  @override
  State<DebugComponentGalleryScreen> createState() =>
      _DebugComponentGalleryScreenState();
}

class _DebugComponentGalleryScreenState
    extends State<DebugComponentGalleryScreen> {
  bool _toggle = true;
  bool _checked = false;
  bool _filterSelected = false;
  int _segment = 0;
  int _navigationIndex = 0;
  double _slider = 0.6;
  String _lastAction = 'No interaction yet';

  void _recordAction(String action) {
    setState(() => _lastAction = action);
    SgSnackbar.show(context: context, message: action);
  }

  Future<void> _showSheet() async {
    await SgBottomSheet.show<void>(
      context: context,
      builder: (context) => const SgEmptyState(
        icon: SgIconName.appearance,
        title: 'Bottom sheet preview',
        message: 'This surface is a component gallery example.',
      ),
    );
  }

  Future<void> _showDialog() async {
    final result = await SgDialog.confirmDestructive(
      context: context,
      title: 'Destructive action',
      message: 'This is a preview. No account data will be changed.',
      cancelLabel: 'Cancel',
      confirmLabel: 'Confirm preview',
    );
    if (!mounted) return;
    _recordAction(result == true ? 'Dialog confirmed' : 'Dialog dismissed');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SargoshiColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sargoshi components'),
        actions: [
          const Padding(
            padding: EdgeInsetsDirectional.only(end: SargoshiSpace.s16),
            child: Center(
              child: SgRuleBadge(
                label: 'DEBUG ONLY',
                icon: SgIconName.verified,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        key: const ValueKey<String>('debug-component-gallery-scroll'),
        padding: const EdgeInsets.all(SargoshiSpace.s24),
        children: [
          Text(
            'Design system gallery',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: SargoshiSpace.s8),
          Text(
            'Preview the shared UI primitives, interaction states, responsive '
            'surfaces and accessibility behavior. Gallery content is not '
            'production data.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: SargoshiSpace.s24),
          SgCard(
            child: Row(
              children: [
                const SgIcon(SgIconName.pointer),
                const SizedBox(width: SargoshiSpace.s12),
                Expanded(
                  child: Text(
                    'Last interaction: $_lastAction',
                    style: SargoshiType.body,
                  ),
                ),
              ],
            ),
          ),
          _section('Runtime preferences', const [
            _DebugPreferenceControls(),
          ]),
          _section('Buttons and actions', [
            Wrap(
              spacing: SargoshiSpace.s8,
              runSpacing: SargoshiSpace.s8,
              children: [
                SgButton(
                  label: 'Primary',
                  onPressed: () => _recordAction('Primary button pressed'),
                ),
                SgButton(
                  label: 'Tonal',
                  variant: SgButtonVariant.tonal,
                  onPressed: () => _recordAction('Tonal button pressed'),
                ),
                SgButton(
                  label: 'Ghost',
                  variant: SgButtonVariant.ghost,
                  onPressed: () => _recordAction('Ghost button pressed'),
                ),
                SgButton(
                  label: 'Vault',
                  variant: SgButtonVariant.vault,
                  onPressed: () => _recordAction('Vault button pressed'),
                ),
                const SgButton(
                  label: 'Loading',
                  isLoading: true,
                  onPressed: null,
                ),
              ],
            ),
            Wrap(
              spacing: SargoshiSpace.s8,
              children: [
                SgIconButton(
                  icon: SgIconName.settings,
                  tooltip: 'Settings',
                  onPressed: () => _recordAction('Icon button pressed'),
                  selected: true,
                ),
                SgFab(
                  icon: SgIconName.chats,
                  tooltip: 'New chat',
                  onPressed: () => _recordAction('Floating action pressed'),
                ),
                SgFab(
                  icon: SgIconName.vault,
                  tooltip: 'Vault action',
                  onPressed: () => _recordAction('Vault action pressed'),
                  vault: true,
                  label: 'Vault',
                ),
              ],
            ),
          ]),
          _section('Selection and input', [
            Wrap(
              spacing: SargoshiSpace.s8,
              children: [
                SgChip(
                  label: 'Unread',
                  variant: SgChipVariant.filter,
                  selected: _filterSelected,
                  onSelected: (value) =>
                      setState(() => _filterSelected = value),
                ),
                const SgChip(
                  label: 'Assist',
                  variant: SgChipVariant.assist,
                  onSelected: _noopBool,
                ),
                SgChip(
                  label: 'Selected topic',
                  variant: SgChipVariant.input,
                  selected: true,
                  onDeleted: () => _recordAction('Input chip deleted'),
                ),
              ],
            ),
            SgSegmentedControl<int>(
              values: const [0, 1, 2],
              selected: _segment,
              labelFor: (value) => ['All', 'Unread', 'Pinned'][value],
              onSelectionChanged: (value) => setState(() => _segment = value),
            ),
            const SgTextField(
              label: 'Search',
              variant: SgTextFieldVariant.search,
              hint: 'Search conversations',
            ),
            const SgTextField(
              label: 'Vault passphrase',
              variant: SgTextFieldVariant.passphrase,
              revealTooltip: 'Show passphrase',
              concealTooltip: 'Hide passphrase',
              hint: 'Enter a preview value',
            ),
            SgToggle(
              title: 'App lock',
              description: 'Require device authentication',
              value: _toggle,
              onChanged: (value) => setState(() => _toggle = value),
            ),
            SgSlider(
              value: _slider,
              min: 0,
              max: 1,
              label: 'Preview intensity',
              onChanged: (value) => setState(() => _slider = value),
            ),
            SgCheckbox(
              value: _checked,
              title: 'Remember selection',
              onChanged: (value) => setState(() => _checked = value ?? false),
            ),
            const SgRadio<String>(
              value: 'system',
              groupValue: 'system',
              title: 'System appearance',
              onChanged: _noopNullableString,
            ),
          ]),
          _section('Identity and conversation', [
            const Wrap(
              spacing: SargoshiSpace.s12,
              runSpacing: SargoshiSpace.s12,
              children: [
                SgAvatar(initials: 'SA', size: 48),
                SgAvatar(
                  initials: 'VA',
                  size: 64,
                  shape: SgAvatarShape.roundedSquare,
                ),
                SgAvatar(
                  initials: 'AB',
                  size: 32,
                  shape: SgAvatarShape.circle,
                ),
                SgBadge.count(count: 4),
                SgBadge.count(count: 120),
                SgBadge.dot(),
              ],
            ),
            const SgListTile(
              title: 'Private conversation',
              subtitle: 'Last message preview',
              lines: 2,
              leading: SgAvatar(initials: 'SA'),
              trailing: SgBadge.count(count: 2),
            ),
            const SgCard(
              variant: SgCardVariant.outlined,
              child: Text('Outlined surface'),
            ),
            const SgChatDateChip(label: 'Today — 27 Nov'),
            SgCard(
              variant: SgCardVariant.alert,
              alertColor: colors.amber,
              child: const Text('Card with status edge'),
            ),
            const SgChatBubble(
              message: 'A private incoming message.',
              timestamp: '09:41',
              variant: SgChatBubbleVariant.incoming,
            ),
            const SgChatBubble(
              message: 'A branded outgoing message.',
              timestamp: '09:42',
              status: 'Delivered',
              variant: SgChatBubbleVariant.outgoing,
            ),
            const SgChatBubble(
              message: 'This is a protected whisper.',
              timestamp: '09:43',
              variant: SgChatBubbleVariant.whisper,
            ),
            const SgRuleBadge(
              label: 'Forwarding disabled',
              icon: SgIconName.hidden,
            ),
            SgReactionBar(
              reactions: const [
                SgReaction(emoji: '👍', count: 3),
                SgReaction(emoji: '❤️', count: 1, selected: true),
              ],
              onReaction: (value) => _recordAction('Reaction: $value'),
            ),
            SgComposer(
              hint: 'Write a preview message…',
              sendTooltip: 'Send preview message',
              attachTooltip: 'Attach preview item',
              voiceTooltip: 'Record preview audio',
              onAttach: () => _recordAction('Attachment action preview'),
              onVoice: () => _recordAction('Voice action preview'),
              onSend: (value) => _recordAction('Composer callback: $value'),
            ),
          ]),
          _section('Navigation and surfaces', [
            SgBottomNavigation(
              destinations: const [
                SgNavigationDestination(label: 'Chats', icon: SgIconName.chats),
                SgNavigationDestination(label: 'Vault', icon: SgIconName.vault),
                SgNavigationDestination(label: 'Calls', icon: SgIconName.calls),
                SgNavigationDestination(label: 'You', icon: SgIconName.you),
              ],
              selectedIndex: _navigationIndex,
              onDestinationSelected: (value) =>
                  setState(() => _navigationIndex = value),
            ),
            // A NavigationRail is intended for a bounded-height app shell.
            // Give the gallery preview the same finite vertical constraint.
            SizedBox(
              height: 360,
              child: SgNavigationRail(
                destinations: const [
                  SgNavigationDestination(
                      label: 'Chats', icon: SgIconName.chats),
                  SgNavigationDestination(
                      label: 'Vault', icon: SgIconName.vault),
                  SgNavigationDestination(
                      label: 'Calls', icon: SgIconName.calls),
                  SgNavigationDestination(label: 'You', icon: SgIconName.you),
                ],
                selectedIndex: _navigationIndex,
                onDestinationSelected: (value) =>
                    setState(() => _navigationIndex = value),
              ),
            ),
            SgButton(
              label: 'Open bottom sheet',
              variant: SgButtonVariant.tonal,
              onPressed: _showSheet,
            ),
            SgButton(
              label: 'Open dialog',
              variant: SgButtonVariant.dangerOutline,
              onPressed: _showDialog,
            ),
            SgButton(
              label: 'Show snackbar',
              variant: SgButtonVariant.ghost,
              onPressed: () => _recordAction('Snackbar preview'),
            ),
          ]),
          _section('Feedback and status', [
            SgBanner(
              title: 'Connection paused',
              message: 'Messages remain queued on this device.',
              variant: SgBannerVariant.info,
              actionLabel: 'Review',
              onAction: () => _recordAction('Banner action'),
              dismissTooltip: 'Dismiss banner',
              onDismiss: () => _recordAction('Banner dismissed'),
            ),
            const SgAlertCard(
              title: 'Security notice',
              message: 'Review your active devices.',
              severity: SgAlertSeverity.warning,
              actionLabel: 'Review devices',
              onAction: _noop,
            ),
            SgPinPad(
              onDigit: (value) => _recordAction('PIN digit $value selected'),
              onBackspace: () => _recordAction('PIN backspace'),
              backspaceTooltip: 'Delete last digit',
              digitSemanticLabel: (value) => 'Digit $value',
            ),
            const SgStatRing(
              value: 0.72,
              valueLabel: '72%',
              label: 'Complete',
            ),
            const SgProgress(value: 0.55, label: 'Upload progress'),
            const SgProgress(
              value: 0.55,
              variant: SgProgressVariant.ring,
            ),
            const SgProgress(
              value: 0.55,
              variant: SgProgressVariant.segmented,
            ),
            const SgSkeleton(variant: SgSkeletonVariant.listRow),
            const SgSkeleton(variant: SgSkeletonVariant.gridCell, width: 96),
            const SgSkeleton(variant: SgSkeletonVariant.card),
            const SgEmptyState(
              icon: SgIconName.chats,
              title: 'No conversations',
              message: 'Start a private conversation when you are ready.',
              actionLabel: 'Start preview',
              onAction: _noop,
            ),
          ]),
          const SizedBox(height: SargoshiSpace.s48),
          Text(
            'Debug gallery only — no production operations are wired here.',
            style: SargoshiType.caption.copyWith(color: colors.mist),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(top: SargoshiSpace.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: SargoshiType.title),
          const SizedBox(height: SargoshiSpace.s16),
          ...children.expand(
            (child) => [child, const SizedBox(height: SargoshiSpace.s16)],
          ),
        ],
      ),
    );
  }
}

void _noop() {}
void _noopBool(bool value) {}
void _noopNullableString(String? value) {}

class _DebugPreferenceControls extends ConsumerWidget {
  const _DebugPreferenceControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset =
        ref.watch(themePresetProvider).valueOrNull ?? SargoshiThemePreset.dark;
    final language =
        ref.watch(appLanguageProvider).valueOrNull ?? AppLanguage.system;
    final liteUi = ref.watch(liteUiModeProvider).valueOrNull ?? LiteUiMode.auto;
    final tier = ref.watch(performanceTierChoiceProvider).valueOrNull ??
        PerformanceTierChoice.auto;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _preferenceDropdown<SargoshiThemePreset>(
          context,
          title: 'Appearance',
          value: preset,
          values: SargoshiThemePreset.values,
          label: _themeLabel,
          onChanged: (value) {
            if (value != null) {
              _save(
                  context,
                  () =>
                      ref.read(themePresetProvider.notifier).setPreset(value));
            }
          },
        ),
        _preferenceDropdown<AppLanguage>(
          context,
          title: 'App language',
          value: language,
          values: AppLanguage.values,
          label: _languageLabel,
          onChanged: (value) {
            if (value != null) {
              _save(
                  context,
                  () => ref
                      .read(appLanguageProvider.notifier)
                      .setLanguage(value));
            }
          },
        ),
        _preferenceDropdown<LiteUiMode>(
          context,
          title: 'Lite UI',
          value: liteUi,
          values: LiteUiMode.values,
          label: _liteUiLabel,
          onChanged: (value) {
            if (value != null) {
              _save(context,
                  () => ref.read(liteUiModeProvider.notifier).setMode(value));
            }
          },
        ),
        _preferenceDropdown<PerformanceTierChoice>(
          context,
          title: 'Performance tier',
          value: tier,
          values: PerformanceTierChoice.values,
          label: _tierLabel,
          onChanged: (value) {
            if (value != null) {
              _save(
                  context,
                  () => ref
                      .read(performanceTierChoiceProvider.notifier)
                      .setChoice(value));
            }
          },
        ),
        const SizedBox(height: SargoshiSpace.s8),
        const Text(
          'Preferences are stored locally. Device capability and visual tier '
          'are kept separate.',
          style: SargoshiType.caption,
        ),
      ],
    );
  }

  void _save(
    BuildContext context,
    Future<void> Function() operation,
  ) {
    unawaited(_persist(context, operation));
  }

  Future<void> _persist(
    BuildContext context,
    Future<void> Function() operation,
  ) async {
    try {
      await operation();
    } catch (_) {
      if (!context.mounted) return;
      SgSnackbar.show(
        context: context,
        message: 'Could not save this preference. Please try again.',
      );
    }
  }

  Widget _preferenceDropdown<T>(
    BuildContext context, {
    required String title,
    required T value,
    required List<T> values,
    required String Function(T value) label,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SargoshiSpace.s16),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(labelText: title),
        items: values
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(label(item)),
              ),
            )
            .toList(growable: false),
        onChanged: onChanged,
      ),
    );
  }

  String _themeLabel(SargoshiThemePreset value) => switch (value) {
        SargoshiThemePreset.system => 'System',
        SargoshiThemePreset.dark => 'Dark',
        SargoshiThemePreset.light => 'Light / Parchment',
        SargoshiThemePreset.amoled => 'AMOLED',
        SargoshiThemePreset.midnightSky => 'Midnight Sky',
        SargoshiThemePreset.highContrast => 'High contrast',
        SargoshiThemePreset.dynamic => 'Dynamic',
      };

  String _languageLabel(AppLanguage value) => switch (value) {
        AppLanguage.system => 'System language',
        AppLanguage.english => 'English',
        AppLanguage.urdu => 'اردو',
      };

  String _liteUiLabel(LiteUiMode value) => switch (value) {
        LiteUiMode.auto => 'Auto',
        LiteUiMode.on => 'On',
        LiteUiMode.off => 'Off',
      };

  String _tierLabel(PerformanceTierChoice value) => switch (value) {
        PerformanceTierChoice.auto => 'Automatic',
        PerformanceTierChoice.t1 => 'T1 — Lite',
        PerformanceTierChoice.t2 => 'T2 — Standard',
        PerformanceTierChoice.t3 => 'T3 — Premium visuals',
      };
}
