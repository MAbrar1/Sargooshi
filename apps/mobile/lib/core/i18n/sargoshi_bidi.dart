import 'package:flutter/widgets.dart';

// SG:LOC-01
abstract final class SargoshiBidi {
  static const String _firstStrongIsolate = '\u2068';
  static const String _popDirectionalIsolate = '\u2069';

  static const Set<int> _directionalControls = {
    0x061C, // Arabic Letter Mark
    0x200E, // Left-to-right mark
    0x200F, // Right-to-left mark
    0x202A, // Left-to-right embedding
    0x202B, // Right-to-left embedding
    0x202C, // Pop directional formatting
    0x202D, // Left-to-right override
    0x202E, // Right-to-left override
    0x2066, // Left-to-right isolate
    0x2067, // Right-to-left isolate
    0x2068, // First-strong isolate
    0x2069, // Pop directional isolate
  };

  static TextDirection firstStrongDirection(
    String text, {
    TextDirection fallback = TextDirection.ltr,
  }) {
    for (final rune in text.runes) {
      if (_isRtlStrong(rune)) return TextDirection.rtl;
      if (_isLtrStrong(rune)) return TextDirection.ltr;
    }
    return fallback;
  }

  static String isolate(String value) {
    final safe = String.fromCharCodes(
      value.runes.where((rune) => !_directionalControls.contains(rune)),
    );
    return '$_firstStrongIsolate$safe$_popDirectionalIsolate';
  }

  static String normalizeUrduForSearch(String value) {
    return value
        .replaceAll('\u064A', '\u06CC') // Arabic yeh -> Farsi/Urdu yeh
        .replaceAll('\u0649', '\u06CC') // alef maksura -> yeh
        .replaceAll('\u0643', '\u06A9') // Arabic kaf -> Urdu kaf
        .replaceAll('\u0647', '\u06C1') // Arabic heh -> Urdu heh goal
        .replaceAll('\u0629', '\u06C1') // ta marbuta -> Urdu heh goal
        .replaceAll(
            '\u06BE', '\u06C1') // do-chashmee heh -> heh goal for search
        .replaceAll('\u06C2', '\u06C1'); // heh with hamza above -> heh goal
  }

  static String toEasternArabicDigits(String value) {
    const western = '0123456789';
    const eastern = '٠١٢٣٤٥٦٧٨٩';
    return value.split('').map((character) {
      final index = western.indexOf(character);
      return index < 0 ? character : eastern[index];
    }).join();
  }

  static bool _isRtlStrong(int codePoint) {
    return (codePoint >= 0x0590 && codePoint <= 0x08FF) ||
        (codePoint >= 0xFB1D && codePoint <= 0xFDFF) ||
        (codePoint >= 0xFE70 && codePoint <= 0xFEFF) ||
        (codePoint >= 0x10800 && codePoint <= 0x10FFF) ||
        (codePoint >= 0x1E800 && codePoint <= 0x1EEFF);
  }

  static bool _isLtrStrong(int codePoint) {
    return (codePoint >= 0x0041 && codePoint <= 0x005A) ||
        (codePoint >= 0x0061 && codePoint <= 0x007A) ||
        (codePoint >= 0x00C0 && codePoint <= 0x02E4) ||
        (codePoint >= 0x0370 && codePoint <= 0x058F) ||
        (codePoint >= 0x0900 && codePoint <= 0x1FFF) ||
        (codePoint >= 0x2C00 && codePoint <= 0xD7FF) ||
        (codePoint >= 0xF900 && codePoint <= 0xFAFF);
  }
}
