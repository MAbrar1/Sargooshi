import 'package:flutter/material.dart';

import '../../core/i18n/sargoshi_bidi.dart';
import '../../core/theme/generated/sargoshi_tokens.g.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/sg_icon.dart';

enum _InboxFilter { all, unread, people, groups }

class _ConversationSample {
  const _ConversationSample({
    required this.id,
    required this.name,
    required this.initials,
    required this.message,
    required this.timeLabel,
    required this.unreadCount,
    required this.isGroup,
    required this.accent,
  });

  final String id;
  final String name;
  final String initials;
  final String message;
  final String timeLabel;
  final int unreadCount;
  final bool isGroup;
  final Color accent;
}

const _conversationSamples = <_ConversationSample>[
  _ConversationSample(
    id: 'ayesha',
    name: 'Ayesha Khan',
    initials: 'AK',
    message: 'Are we still on for coffee?',
    timeLabel: '09:41',
    unreadCount: 2,
    isGroup: false,
    accent: Color(0xFF6EA8FF),
  ),
  _ConversationSample(
    id: 'hamza',
    name: 'Hamza Ali',
    initials: 'HA',
    message: 'Sent you the location.',
    timeLabel: '09:12',
    unreadCount: 0,
    isGroup: false,
    accent: Color(0xFF4ADE9C),
  ),
  _ConversationSample(
    id: 'family',
    name: 'Family Circle',
    initials: 'FC',
    message: 'امی: اللہ حافظ، اپنا خیال رکھنا۔',
    timeLabel: 'yesterday',
    unreadCount: 4,
    isGroup: true,
    accent: Color(0xFFFFC857),
  ),
  _ConversationSample(
    id: 'sara',
    name: 'Sara Ahmed',
    initials: 'SA',
    message: 'The photos turned out beautifully ✨',
    timeLabel: 'monday',
    unreadCount: 0,
    isGroup: false,
    accent: Color(0xFFFF8A4C),
  ),
];

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final TextEditingController _searchController = TextEditingController();
  _InboxFilter _selectedFilter = _InboxFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalize(String value) {
    return SargoshiBidi.normalizeUrduForSearch(value).toLowerCase().trim();
  }

  String _filterLabel(AppLocalizations l10n, _InboxFilter filter) {
    return switch (filter) {
      _InboxFilter.all => l10n.inboxFilterAll,
      _InboxFilter.unread => l10n.inboxFilterUnread,
      _InboxFilter.people => l10n.inboxFilterPeople,
      _InboxFilter.groups => l10n.inboxFilterGroups,
    };
  }

  String _timeLabel(
    AppLocalizations l10n,
    _ConversationSample conversation,
  ) {
    return switch (conversation.timeLabel) {
      'yesterday' => l10n.inboxYesterday,
      'monday' => l10n.inboxMondayShort,
      _ => conversation.timeLabel,
    };
  }

  List<_ConversationSample> _visibleConversations() {
    final query = _normalize(_query);

    return _conversationSamples.where((conversation) {
      final matchesFilter = switch (_selectedFilter) {
        _InboxFilter.all => true,
        _InboxFilter.unread => conversation.unreadCount > 0,
        _InboxFilter.people => !conversation.isGroup,
        _InboxFilter.groups => conversation.isGroup,
      };

      final searchableText = _normalize(
        [conversation.name, conversation.message].join(' '),
      );
      final matchesQuery = query.isEmpty || searchableText.contains(query);

      return matchesFilter && matchesQuery;
    }).toList(growable: false);
  }

  void _showConversationPreview(
    _ConversationSample conversation,
    AppLocalizations l10n,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colors = Theme.of(dialogContext)
                .extension<SargoshiColors>() ??
            SargoshiColors.defaults;

        return AlertDialog(
          title: Text(conversation.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(conversation.message),
              const SizedBox(height: SargoshiSpace.s16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SargoshiSpace.s12),
                decoration: BoxDecoration(
                  color: colors.dusk,
                  borderRadius: BorderRadius.circular(SargoshiShape.card),
                  border: Border.all(color: colors.line),
                ),
                child: Text(
                  l10n.inboxPreviewOnlyNotice,
                  style: Theme.of(dialogContext).textTheme.bodySmall?.copyWith(
                        color: colors.mist,
                      ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.inboxClose),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<SargoshiColors>() ??
        SargoshiColors.defaults;
    final conversations = _visibleConversations();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inboxTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SargoshiSpace.s20,
              SargoshiSpace.s12,
              SargoshiSpace.s20,
              SargoshiSpace.s16,
            ),
            child: _InboxPreviewNotice(
              label: l10n.inboxPreviewTag,
              description: l10n.inboxPreviewDescription,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SargoshiSpace.s20,
            ),
            child: TextField(
              key: const ValueKey<String>('inbox-search'),
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.inboxSearchHint,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(SargoshiSpace.s12),
                  child: SgIcon(SgIconName.search, size: 20),
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.inboxClearSearch,
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: colors.dusk,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SargoshiShape.button),
                  borderSide: BorderSide(color: colors.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SargoshiShape.button),
                  borderSide: BorderSide(color: colors.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SargoshiShape.button),
                  borderSide: BorderSide(color: colors.glow, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: SargoshiSpace.s16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: SargoshiSpace.s20,
            ),
            child: Row(
              children: _InboxFilter.values.map((filter) {
                final selected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: SargoshiSpace.s8,
                  ),
                  child: ChoiceChip(
                    key: ValueKey<String>('inbox-filter-' + filter.name),
                    label: Text(_filterLabel(l10n, filter)),
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: colors.dusk2,
                    backgroundColor: colors.dusk,
                    side: BorderSide(
                      color: selected ? colors.glow : colors.line,
                    ),
                    labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: selected ? colors.glow : colors.mist,
                        ),
                    onSelected: (_) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(growable: false),
            ),
          ),
          const SizedBox(height: SargoshiSpace.s8),
          Expanded(
            child: conversations.isEmpty
                ? _InboxEmptyState(
                    title: l10n.inboxNoResultsTitle,
                    message: l10n.inboxNoResultsBody,
                  )
                : ListView.separated(
                    key: const ValueKey<String>('inbox-conversation-list'),
                    padding: const EdgeInsets.only(
                      top: SargoshiSpace.s8,
                      bottom: SargoshiSpace.s24,
                    ),
                    itemCount: conversations.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsetsDirectional.only(start: 88),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: colors.line.withValues(alpha: 0.58),
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      return _ConversationTile(
                        conversation: conversation,
                        timeLabel: _timeLabel(l10n, conversation),
                        unreadLabel:
                            l10n.inboxUnreadCount(conversation.unreadCount),
                        onTap: () =>
                            _showConversationPreview(conversation, l10n),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _InboxPreviewNotice extends StatelessWidget {
  const _InboxPreviewNotice({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SargoshiColors>() ??
        SargoshiColors.defaults;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SargoshiSpace.s12),
      decoration: BoxDecoration(
        color: colors.dusk,
        borderRadius: BorderRadius.circular(SargoshiShape.card),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: SargoshiSpace.s4,
              end: SargoshiSpace.s12,
            ),
            child: SgIcon(
              SgIconName.chats,
              size: 20,
              color: colors.glow,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.glow,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: SargoshiSpace.s4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.mist,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.timeLabel,
    required this.unreadLabel,
    required this.onTap,
  });

  final _ConversationSample conversation;
  final String timeLabel;
  final String unreadLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SargoshiColors>() ??
        SargoshiColors.defaults;

    return Semantics(
      button: true,
      label: [conversation.name, conversation.message].join('. '),
      child: InkWell(
        key: ValueKey<String>('inbox-conversation-' + conversation.id),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SargoshiSpace.s20,
            vertical: SargoshiSpace.s12,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: conversation.accent.withValues(alpha: 0.17),
                child: Text(
                  conversation.initials,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: conversation.accent,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: SargoshiSpace.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: colors.moon,
                                      fontWeight: conversation.unreadCount > 0
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                          ),
                        ),
                        const SizedBox(width: SargoshiSpace.s8),
                        Text(
                          timeLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: conversation.unreadCount > 0
                                        ? colors.glow
                                        : colors.mist,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SargoshiSpace.s4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Directionality(
                            textDirection: SargoshiBidi.firstStrongDirection(
                              conversation.message,
                              fallback: Directionality.of(context),
                            ),
                            child: Text(
                              conversation.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: conversation.unreadCount > 0
                                        ? colors.moon
                                        : colors.mist,
                                  ),
                            ),
                          ),
                        ),
                        if (conversation.unreadCount > 0) ...[
                          const SizedBox(width: SargoshiSpace.s8),
                          Semantics(
                            label: unreadLabel,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: SargoshiSpace.s8,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors.mint,
                                borderRadius:
                                    BorderRadius.circular(SargoshiShape.chip),
                              ),
                              child: Text(
                                conversation.unreadCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: colors.ink,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InboxEmptyState extends StatelessWidget {
  const _InboxEmptyState({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SargoshiColors>() ??
        SargoshiColors.defaults;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SargoshiSpace.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SgIcon(
              SgIconName.chats,
              size: SargoshiComponents.emptyIconSize,
              color: colors.mist,
              emptyState: true,
            ),
            const SizedBox(height: SargoshiSpace.s20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: SargoshiSpace.s8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.mist,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
