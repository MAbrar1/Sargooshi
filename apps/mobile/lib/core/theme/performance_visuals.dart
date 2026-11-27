import 'package:flutter/material.dart';

@immutable
class SargoshiPerformanceVisuals
    extends ThemeExtension<SargoshiPerformanceVisuals> {
  const SargoshiPerformanceVisuals({
    required this.transitionDuration,
    required this.enableGlass,
    required this.enableSharedElementTransitions,
    required this.enableSoftShadows,
    required this.blurSigma,
    required this.surfaceElevation,
  });

  final Duration transitionDuration;
  final bool enableGlass;
  final bool enableSharedElementTransitions;
  final bool enableSoftShadows;
  final double blurSigma;
  final double surfaceElevation;

  @override
  SargoshiPerformanceVisuals copyWith({
    Duration? transitionDuration,
    bool? enableGlass,
    bool? enableSharedElementTransitions,
    bool? enableSoftShadows,
    double? blurSigma,
    double? surfaceElevation,
  }) {
    return SargoshiPerformanceVisuals(
      transitionDuration: transitionDuration ?? this.transitionDuration,
      enableGlass: enableGlass ?? this.enableGlass,
      enableSharedElementTransitions:
          enableSharedElementTransitions ?? this.enableSharedElementTransitions,
      enableSoftShadows: enableSoftShadows ?? this.enableSoftShadows,
      blurSigma: blurSigma ?? this.blurSigma,
      surfaceElevation: surfaceElevation ?? this.surfaceElevation,
    );
  }

  @override
  SargoshiPerformanceVisuals lerp(
    covariant SargoshiPerformanceVisuals? other,
    double t,
  ) {
    if (other == null) return this;
    final milliseconds = transitionDuration.inMilliseconds +
        ((other.transitionDuration.inMilliseconds -
                    transitionDuration.inMilliseconds) *
                t)
            .round();
    return SargoshiPerformanceVisuals(
      transitionDuration: Duration(milliseconds: milliseconds),
      enableGlass: t < 0.5 ? enableGlass : other.enableGlass,
      enableSharedElementTransitions: t < 0.5
          ? enableSharedElementTransitions
          : other.enableSharedElementTransitions,
      enableSoftShadows: t < 0.5 ? enableSoftShadows : other.enableSoftShadows,
      blurSigma: blurSigma + (other.blurSigma - blurSigma) * t,
      surfaceElevation:
          surfaceElevation + (other.surfaceElevation - surfaceElevation) * t,
    );
  }
}
