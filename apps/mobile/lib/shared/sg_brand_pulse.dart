import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/generated/sargoshi_tokens.g.dart';

/// A lightweight, non-blocking brand pulse for startup and loading moments.
///
/// The three arcs are phase-shifted by one Sargoshi micro-motion interval.
class SgBrandPulse extends StatefulWidget {
  const SgBrandPulse({
    required this.child,
    this.size,
    this.animate = true,
    super.key,
  });

  final Widget child;
  final double? size;
  final bool animate;

  @override
  State<SgBrandPulse> createState() => _SgBrandPulseState();
}

class _SgBrandPulseState extends State<SgBrandPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SargoshiMotion.screen,
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant SgBrandPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? SargoshiLayout.brandMarkSize;
    final colors = Theme.of(context).extension<SargoshiColors>()!;
    return SizedBox(
      width: size * 1.7,
      height: size * 1.7,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.animate)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                key: const ValueKey('sargoshi-brand-pulse-arcs'),
                size: Size.square(size * 1.7),
                painter: _BrandArcPainter(
                  progress: _controller.value,
                  color: colors.glow,
                  strokeWidth: SargoshiStroke.ghost,
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

class _BrandArcPainter extends CustomPainter {
  const _BrandArcPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.36;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < 3; index++) {
      final phase = (progress - index * 0.12 + 1) % 1;
      final scale = 0.7 + phase * 0.65;
      final alpha = (1 - phase) * 0.6;
      paint.color = color.withValues(alpha: alpha.clamp(0.0, 0.6));
      final sweep = math.pi * (0.48 + phase * 0.2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * scale),
        -math.pi / 2 - sweep / 2,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BrandArcPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}
