import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/adaptive/window_size_class.dart';

void main() {
  group('WindowSizeClass.fromWidth', () {
    test('compact is strictly below 600 dp', () {
      expect(WindowSizeClassX.fromWidth(359), WindowSizeClass.compact);
      expect(WindowSizeClassX.fromWidth(599.99), WindowSizeClass.compact);
    });

    test('medium includes 600 and stops below 840 dp', () {
      expect(WindowSizeClassX.fromWidth(600), WindowSizeClass.medium);
      expect(WindowSizeClassX.fromWidth(839.99), WindowSizeClass.medium);
    });

    test('expanded starts at 840 dp', () {
      expect(WindowSizeClassX.fromWidth(840), WindowSizeClass.expanded);
      expect(WindowSizeClassX.fromWidth(1280), WindowSizeClass.expanded);
    });

    test('grid metrics follow the product layout specification', () {
      expect(WindowSizeClass.compact.margin, 16);
      expect(WindowSizeClass.compact.gutter, 8);
      expect(WindowSizeClass.compact.gridColumns, 4);
      expect(WindowSizeClass.medium.margin, 24);
      expect(WindowSizeClass.medium.gutter, 16);
      expect(WindowSizeClass.medium.gridColumns, 8);
      expect(WindowSizeClass.expanded.margin, 32);
      expect(WindowSizeClass.expanded.gutter, 16);
      expect(WindowSizeClass.expanded.gridColumns, 12);
    });
  });
}
