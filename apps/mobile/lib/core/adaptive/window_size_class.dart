import 'package:flutter/widgets.dart';

import '../theme/generated/sargoshi_tokens.g.dart';

enum WindowSizeClass { compact, medium, expanded }

extension WindowSizeClassX on WindowSizeClass {
  bool get isCompact => this == WindowSizeClass.compact;
  bool get isMedium => this == WindowSizeClass.medium;
  bool get isExpanded => this == WindowSizeClass.expanded;

  static WindowSizeClass fromWidth(double width) {
    if (width < SargoshiBreakpoint.medium) {
      return WindowSizeClass.compact;
    }
    if (width < SargoshiBreakpoint.expanded) {
      return WindowSizeClass.medium;
    }
    return WindowSizeClass.expanded;
  }

  static WindowSizeClass of(BuildContext context) {
    return fromWidth(MediaQuery.sizeOf(context).width);
  }

  double get margin => switch (this) {
        WindowSizeClass.compact => SargoshiLayout.compactMargin,
        WindowSizeClass.medium => SargoshiLayout.mediumMargin,
        WindowSizeClass.expanded => SargoshiLayout.expandedMargin,
      };

  double get gutter => switch (this) {
        WindowSizeClass.compact => SargoshiLayout.compactGutter,
        WindowSizeClass.medium => SargoshiLayout.mediumGutter,
        WindowSizeClass.expanded => SargoshiLayout.expandedGutter,
      };

  int get gridColumns => switch (this) {
        WindowSizeClass.compact => SargoshiLayout.compactColumns.toInt(),
        WindowSizeClass.medium => SargoshiLayout.mediumColumns.toInt(),
        WindowSizeClass.expanded => SargoshiLayout.expandedColumns.toInt(),
      };
}
