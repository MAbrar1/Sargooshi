import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/material.dart';

enum SgFoldablePosture { none, book, tabletop }

@immutable
class SgFoldablePostureInfo {
  const SgFoldablePostureInfo({
    required this.posture,
    this.feature,
  });

  final SgFoldablePosture posture;
  final DisplayFeature? feature;

  static const none = SgFoldablePostureInfo(
    posture: SgFoldablePosture.none,
  );

  factory SgFoldablePostureInfo.detect(
    Iterable<DisplayFeature> displayFeatures,
  ) {
    DisplayFeature? bookFeature;
    DisplayFeature? tabletopFeature;

    for (final feature in displayFeatures) {
      if (feature.type != DisplayFeatureType.fold &&
          feature.type != DisplayFeatureType.hinge) {
        continue;
      }

      final isHorizontal = feature.bounds.width >= feature.bounds.height;
      if (isHorizontal) {
        if (feature.state == DisplayFeatureState.postureHalfOpened &&
            (tabletopFeature == null ||
                feature.bounds.width > tabletopFeature.bounds.width)) {
          tabletopFeature = feature;
        }
      } else if (bookFeature == null ||
          feature.bounds.height > bookFeature.bounds.height) {
        bookFeature = feature;
      }
    }

    if (tabletopFeature != null) {
      return SgFoldablePostureInfo(
        posture: SgFoldablePosture.tabletop,
        feature: tabletopFeature,
      );
    }
    if (bookFeature != null) {
      return SgFoldablePostureInfo(
        posture: SgFoldablePosture.book,
        feature: bookFeature,
      );
    }
    return none;
  }
}

// SG:NET-01
class SgFoldableLayout extends StatelessWidget {
  const SgFoldableLayout({
    required this.regularLayout,
    required this.bookListPane,
    required this.bookChatPane,
    required this.tabletopVideoPane,
    required this.tabletopControlsPane,
    super.key,
  });

  final Widget regularLayout;
  final Widget bookListPane;
  final Widget bookChatPane;
  final Widget tabletopVideoPane;
  final Widget tabletopControlsPane;

  @override
  Widget build(BuildContext context) {
    final posture = SgFoldablePostureInfo.detect(
      MediaQuery.displayFeaturesOf(context),
    );
    final feature = posture.feature;

    return switch (posture.posture) {
      SgFoldablePosture.none => regularLayout,
      SgFoldablePosture.book => _buildBookLayout(
          context,
          hingeWidth: feature?.bounds.width ?? 0,
        ),
      SgFoldablePosture.tabletop => _buildTabletopLayout(
          hingeHeight: feature?.bounds.height ?? 0,
        ),
    };
  }

  Widget _buildBookLayout(
    BuildContext context, {
    required double hingeWidth,
  }) {
    final gap = SizedBox(width: hingeWidth);
    final direction = Directionality.of(context);

    return Row(
      children: direction == TextDirection.ltr
          ? [
              Expanded(child: bookListPane),
              gap,
              Expanded(child: bookChatPane),
            ]
          : [
              Expanded(child: bookChatPane),
              gap,
              Expanded(child: bookListPane),
            ],
    );
  }

  Widget _buildTabletopLayout({required double hingeHeight}) {
    return Column(
      children: [
        Expanded(child: tabletopVideoPane),
        SizedBox(height: hingeHeight),
        Expanded(child: tabletopControlsPane),
      ],
    );
  }
}
