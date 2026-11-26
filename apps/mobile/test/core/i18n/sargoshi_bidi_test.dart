import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/i18n/sargoshi_bidi.dart';

// SG:LOC-01
void main() {
  test('direction follows the first strong character, not the first digit', () {
    expect(
      SargoshiBidi.firstStrongDirection('123 سلام hello'),
      TextDirection.rtl,
    );
    expect(
      SargoshiBidi.firstStrongDirection(' 42 Sargoshi سلام'),
      TextDirection.ltr,
    );
    expect(
      SargoshiBidi.firstStrongDirection('12345'),
      TextDirection.ltr,
    );
    expect(
      SargoshiBidi.firstStrongDirection(
        '12345',
        fallback: TextDirection.rtl,
      ),
      TextDirection.rtl,
    );
  });

  test('user-controlled fragments are safely wrapped in FSI and PDI', () {
    expect(
      SargoshiBidi.isolate('user_123'),
      '\u2068user_123\u2069',
    );
    expect(
      SargoshiBidi.isolate('\u2067name\u2069'),
      '\u2068name\u2069',
    );
  });

  test('search normalization folds common Arabic and Urdu variants', () {
    expect(
      SargoshiBidi.normalizeUrduForSearch('علي كافر هدايه'),
      'علی کافر ہدایہ',
    );
  });

  test('Eastern Arabic digits are opt-in and preserve other characters', () {
    expect(
      SargoshiBidi.toEasternArabicDigits('PIN 2048 / 09'),
      'PIN ٢٠٤٨ / ٠٩',
    );
    expect(
      SargoshiBidi.toEasternArabicDigits('١٢٣'),
      '١٢٣',
    );
  });
}
