import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/theme/generated/sargoshi_tokens.g.dart';

enum SgLogoLayout { mark, horizontal, stacked }

enum SgLogoTone { adaptive, gradient, onLight, onDark }

class SgLogo extends StatelessWidget {
  const SgLogo({
    this.layout = SgLogoLayout.horizontal,
    this.tone = SgLogoTone.adaptive,
    this.markSize = 40,
    this.showTagline = false,
    this.semanticLabel = 'Sargoshi — Say it softly.',
    super.key,
  });

  final SgLogoLayout layout;
  final SgLogoTone tone;
  final double markSize;
  final bool showTagline;
  final String semanticLabel;

  String _assetFor(SgLogoTone resolvedTone) {
    return switch (resolvedTone) {
      SgLogoTone.adaptive || SgLogoTone.gradient =>
        'assets/brand/sargoshi-mark-gradient.svg',
      SgLogoTone.onLight => 'assets/brand/sargoshi-mark-ink.svg',
      SgLogoTone.onDark => 'assets/brand/sargoshi-mark-white.svg',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SargoshiColors>()!;
    final resolvedTone = tone == SgLogoTone.adaptive
        ? (Theme.of(context).brightness == Brightness.dark
            ? SgLogoTone.onDark
            : SgLogoTone.onLight)
        : tone;
    final wordColor = switch (resolvedTone) {
      SgLogoTone.onLight => colors.ink,
      SgLogoTone.onDark => colors.moon,
      SgLogoTone.adaptive => colors.moon,
      SgLogoTone.gradient => colors.moon,
    };
    final mark = ExcludeSemantics(
      child: SvgPicture.asset(
        _assetFor(resolvedTone),
        width: markSize,
        height: markSize,
        fit: BoxFit.contain,
      ),
    );

    if (layout == SgLogoLayout.mark) {
      return Semantics(
        container: true,
        image: true,
        label: semanticLabel,
        child: mark,
      );
    }

    final wordmark = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: layout == SgLogoLayout.stacked
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Sargoshi',
          style: SargoshiType.headline.copyWith(
            color: wordColor,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: SargoshiSpace.s4),
          Text(
            'Say it softly.',
            style: SargoshiType.caption.copyWith(color: wordColor),
          ),
        ],
      ],
    );

    final child = layout == SgLogoLayout.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              mark,
              const SizedBox(width: SargoshiSpace.s12),
              Flexible(child: wordmark),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              mark,
              const SizedBox(height: SargoshiSpace.s12),
              wordmark,
            ],
          );

    return Semantics(
      container: true,
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(child: child),
    );
  }
}
