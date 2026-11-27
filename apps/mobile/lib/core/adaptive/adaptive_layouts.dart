import 'package:flutter/material.dart';

import '../theme/generated/sargoshi_tokens.g.dart';
import '../../shared/sg_components.dart';
import 'window_size_class.dart';

// SG:NET-01
class SgAdaptiveScaffold extends StatelessWidget {
  const SgAdaptiveScaffold({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.extendedRailLabels = true,
    super.key,
  });

  final List<SgNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool extendedRailLabels;

  @override
  Widget build(BuildContext context) {
    assert(destinations.length == 4);
    assert(selectedIndex >= 0 && selectedIndex < 4);

    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = WindowSizeClasses.fromWidth(constraints.maxWidth);
        final compact = sizeClass.isCompact;
        final expanded = sizeClass.isExpanded;
        final content = compact
            ? body
            : Row(
                children: [
                  SgNavigationRail(
                    destinations: destinations,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                    extended: expanded && extendedRailLabels,
                  ),
                  VerticalDivider(
                    width: SargoshiStroke.hairline,
                    thickness: SargoshiStroke.hairline,
                    color: Theme.of(context).dividerColor,
                  ),
                  Expanded(child: body),
                ],
              );

        return Scaffold(
          appBar: appBar,
          body: content,
          bottomNavigationBar: compact
              ? SgBottomNavigation(
                  destinations: destinations,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                )
              : null,
          floatingActionButton: floatingActionButton,
        );
      },
    );
  }
}

class SgAdaptivePaneLayout extends StatelessWidget {
  const SgAdaptivePaneLayout({
    required this.listPane,
    required this.chatPane,
    this.infoPane,
    this.compactPane,
    this.listWidth = SargoshiLayout.listPaneWidth,
    this.infoWidth = SargoshiLayout.infoPaneWidth,
    super.key,
  });

  final Widget listPane;
  final Widget chatPane;
  final Widget? infoPane;
  final Widget? compactPane;
  final double listWidth;
  final double infoWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = WindowSizeClasses.fromWidth(constraints.maxWidth);
        if (sizeClass.isCompact) return compactPane ?? chatPane;

        final canShowInfo = sizeClass.isExpanded &&
            infoPane != null &&
            constraints.maxWidth >=
                listWidth +
                    infoWidth +
                    SargoshiLayout.minChatPaneWidth +
                    2 * SargoshiStroke.hairline;
        final resolvedInfoWidth = canShowInfo ? infoWidth : 0.0;

        return Row(
          children: [
            SizedBox(
              width: listWidth,
              child: listPane,
            ),
            const VerticalDivider(
              width: SargoshiStroke.hairline,
              thickness: SargoshiStroke.hairline,
            ),
            Expanded(child: chatPane),
            if (canShowInfo) ...[
              const VerticalDivider(
                width: SargoshiStroke.hairline,
                thickness: SargoshiStroke.hairline,
              ),
              SizedBox(
                width: resolvedInfoWidth,
                child: infoPane,
              ),
            ],
          ],
        );
      },
    );
  }
}

class SgAdaptiveGrid extends StatelessWidget {
  const SgAdaptiveGrid({
    required this.children,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio = 1,
    super.key,
  });

  final List<Widget> children;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = WindowSizeClasses.fromWidth(constraints.maxWidth);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: sizeClass.margin),
          crossAxisCount: sizeClass.gridColumns,
          mainAxisSpacing: mainAxisSpacing ?? sizeClass.gutter,
          crossAxisSpacing: crossAxisSpacing ?? sizeClass.gutter,
          childAspectRatio: childAspectRatio,
          children: children,
        );
      },
    );
  }
}
