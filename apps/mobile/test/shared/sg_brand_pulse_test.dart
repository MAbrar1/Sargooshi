import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/theme/app_theme.dart';
import 'package:sargoshi/shared/sg_brand_pulse.dart';

void main() {
  testWidgets('pulse renders its child and animated painter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: const Scaffold(
          body: SgBrandPulse(
            size: 40,
            child: SizedBox(width: 40, height: 40, child: Text('Mark')),
          ),
        ),
      ),
    );

    expect(find.text('Mark'), findsOneWidget);
    expect(find.byKey(const ValueKey('sargoshi-brand-pulse-arcs')),
        findsOneWidget);
    await tester.pump(const Duration(milliseconds: 120));
    expect(find.text('Mark'), findsOneWidget);
  });

  testWidgets('static pulse mode does not render animated arcs',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.light,
          preset: SargoshiThemePreset.light,
        ),
        home: const Scaffold(
          body: SgBrandPulse(
            animate: false,
            child: SizedBox(width: 40, height: 40, child: Text('Static mark')),
          ),
        ),
      ),
    );

    expect(find.text('Static mark'), findsOneWidget);
    expect(
        find.byKey(const ValueKey('sargoshi-brand-pulse-arcs')), findsNothing);
  });

  testWidgets('changing animation preference stops and restarts animation',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: const Scaffold(
          body: SgBrandPulse(
            animate: false,
            child: SizedBox(width: 40, height: 40),
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          brightness: Brightness.dark,
          preset: SargoshiThemePreset.dark,
        ),
        home: const Scaffold(
          body: SgBrandPulse(
            animate: true,
            child: SizedBox(width: 40, height: 40),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(SgBrandPulse), findsOneWidget);
  });
}
