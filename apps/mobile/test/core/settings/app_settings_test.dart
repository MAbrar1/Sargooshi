import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sargoshi/core/settings/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Lite UI setting defaults to Auto and persists each explicit choice',
      () async {
    final store = AppSettingsStore(SharedPreferencesAsync());

    expect(await store.readLiteUiMode(), LiteUiMode.auto);

    await store.writeLiteUiMode(LiteUiMode.on);
    expect(await store.readLiteUiMode(), LiteUiMode.on);

    await store.writeLiteUiMode(LiteUiMode.off);
    expect(await store.readLiteUiMode(), LiteUiMode.off);
  });

  test('app language defaults to System and persists Urdu selection',
      () async {
    final store = AppSettingsStore(SharedPreferencesAsync());

    expect(await store.readAppLanguage(), AppLanguage.system);

    await store.writeAppLanguage(AppLanguage.urdu);
    expect(await store.readAppLanguage(), AppLanguage.urdu);
    expect(AppLanguage.urdu.locale?.languageCode, 'ur');
    expect(AppLanguage.system.locale, isNull);
  });

  test('invalid persisted enum value is safely restored to its default',
      () async {
    final preferences = SharedPreferencesAsync();
    await preferences.setString('sargoshi.settings.lite_ui_mode', 'unknown');
    await preferences.setString('sargoshi.settings.app_language', 'unknown');

    final store = AppSettingsStore(preferences);

    expect(await store.readLiteUiMode(), LiteUiMode.auto);
    expect(await store.readAppLanguage(), AppLanguage.system);
  });
}
