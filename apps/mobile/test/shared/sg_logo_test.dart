import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sargoshi/core/theme/app_theme.dart';
import 'package:sargoshi/shared/sg_logo.dart';

void main() {
  testWidgets('mark-only lockup exposes one accessible image semantic',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: const Scaffold(
          body: Center(
            child: SgLogo(
              layout: SgLogoLayout.mark,
              tone: SgLogoTone.gradient,
              semanticLabel: 'Sargoshi brand mark',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.bySemanticsLabel('Sargoshi brand mark'), findsOneWidget);
  });

  testWidgets('horizontal lockup includes wordmark and optional tagline',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: const Scaffold(
          body: Center(
            child: SgLogo(
              layout: SgLogoLayout.horizontal,
              tone: SgLogoTone.onDark,
              showTagline: true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('Sargoshi'), findsOneWidget);
    expect(find.text('Say it softly.'), findsOneWidget);
  });

  testWidgets('stacked lockup supports the light surface treatment',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.light,
          preset: SargoshiThemePreset.light,
        ),
        home: const Scaffold(
          body: Center(
            child: SgLogo(
              layout: SgLogoLayout.stacked,
              tone: SgLogoTone.onLight,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('Sargoshi'), findsOneWidget);
    expect(find.bySemanticsLabel('Sargoshi — Say it softly.'), findsOneWidget);
  });

  testWidgets('adaptive logo remains available in both theme brightnesses',
      (tester) async {
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.build(
            brightness: brightness,
            preset: brightness == Brightness.dark
                ? SargoshiThemePreset.dark
                : SargoshiThemePreset.light,
          ),
          home: const Scaffold(
            body: Center(
              child: SgLogo(
                layout: SgLogoLayout.horizontal,
                tone: SgLogoTone.adaptive,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(
          find.bySemanticsLabel('Sargoshi — Say it softly.'), findsOneWidget);
    }
  });
}
