import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/settings/app_settings.dart';
import 'package:sargoshi/core/theme/app_theme.dart';
import '../../support/memory_app_settings_preferences.dart';

void main() {
  test('theme preset defaults to dark and persists a selected appearance',
      () async {
    final store = createMemoryAppSettingsStore();

    expect(await store.readThemePreset(), SargoshiThemePreset.dark);

    await store.writeThemePreset(SargoshiThemePreset.amoled);
    expect(await store.readThemePreset(), SargoshiThemePreset.amoled);
  });

  // SG:STG-06
  test('Lite UI setting defaults to Auto and persists each explicit choice',
      () async {
    final store = createMemoryAppSettingsStore();

    expect(await store.readLiteUiMode(), LiteUiMode.auto);

    await store.writeLiteUiMode(LiteUiMode.on);
    expect(await store.readLiteUiMode(), LiteUiMode.on);

    await store.writeLiteUiMode(LiteUiMode.off);
    expect(await store.readLiteUiMode(), LiteUiMode.off);
  });

  // SG:STL-01
  test('app language defaults to System and persists Urdu selection', () async {
    final store = createMemoryAppSettingsStore();

    expect(await store.readAppLanguage(), AppLanguage.system);

    await store.writeAppLanguage(AppLanguage.urdu);
    expect(await store.readAppLanguage(), AppLanguage.urdu);
    expect(AppLanguage.urdu.locale?.languageCode, 'ur');
    expect(AppLanguage.system.locale, isNull);
  });

  test('performance tier selection defaults to Auto and persists an override',
      () async {
    final store = createMemoryAppSettingsStore();

    expect(
      await store.readPerformanceTierChoice(),
      PerformanceTierChoice.auto,
    );

    await store.writePerformanceTierChoice(PerformanceTierChoice.t3);
    expect(
      await store.readPerformanceTierChoice(),
      PerformanceTierChoice.t3,
    );
  });

  test('invalid persisted enum value is safely restored to its default',
      () async {
    final store = createMemoryAppSettingsStore(
      initialValues: {
        'sargoshi.settings.lite_ui_mode': 'unknown',
        'sargoshi.settings.app_language': 'unknown',
      },
    );

    expect(await store.readLiteUiMode(), LiteUiMode.auto);
    expect(await store.readAppLanguage(), AppLanguage.system);
  });
}
