import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'package:sargoshi/shared/sg_icon.dart';

void main() {
  test('every canonical icon exposes all required weights', () {
    for (final name in SgIconName.values) {
      expect(SgIcon.resolve(name).codePoint, greaterThan(0), reason: '$name regular');
      expect(
        SgIcon.resolve(name, selected: true).fontFamily,
        'PhosphorFill',
        reason: '$name fill',
      );
      expect(
        SgIcon.resolve(name, size: 16).fontFamily,
        'PhosphorBold',
        reason: '$name bold',
      );
      expect(
        SgIcon.resolve(name, emptyState: true).fontFamily,
        'PhosphorDuotone',
        reason: '$name duotone',
      );
    }
  });

  test('semantic icon inventory contains the source registry and nav actions', () {
    expect(SgIconName.values.length, 51);
    expect(SgIcon.resolve(SgIconName.visible).codePoint, greaterThan(0));
    expect(SgIcon.directional, containsAll({
      SgIconName.back,
      SgIconName.forward,
      SgIconName.send,
      SgIconName.undo,
      SgIconName.redo,
    }));
    expect(SgIcon.directional, isNot(contains(SgIconName.vault)));
  });

  testWidgets('only directional icons mirror in RTL', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              SgIcon(SgIconName.back),
              SgIcon(SgIconName.vault),
            ],
          ),
        ),
      ),
    );

    final icons = tester.widgetList<PhosphorIcon>(
      find.byType(PhosphorIcon),
    ).toList();

    expect(icons, hasLength(2));
    expect(
      find.byKey(const ValueKey<String>('sg-icon-rtl-directional')),
      findsOneWidget,
    );
    expect(icons[0].icon, PhosphorIconsRegular.arrowLeft);
    expect(icons[1].icon, PhosphorIconsRegular.vault);
  });
}
