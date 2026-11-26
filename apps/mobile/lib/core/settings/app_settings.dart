import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LiteUiMode { auto, on, off }

enum AppLanguage { system, english, urdu }

extension AppLanguageX on AppLanguage {
  Locale? get locale => switch (this) {
        AppLanguage.system => null,
        AppLanguage.english => const Locale('en'),
        AppLanguage.urdu => const Locale('ur'),
      };
}

final appSettingsStoreProvider = Provider<AppSettingsStore>(
  (ref) => AppSettingsStore(SharedPreferencesAsync()),
);

final liteUiModeProvider =
    AsyncNotifierProvider<LiteUiModeController, LiteUiMode>(
  LiteUiModeController.new,
);

final appLanguageProvider =
    AsyncNotifierProvider<AppLanguageController, AppLanguage>(
  AppLanguageController.new,
);

class AppSettingsStore {
  const AppSettingsStore(this._preferences);

  static const _liteUiModeKey = 'sargoshi.settings.lite_ui_mode';
  static const _appLanguageKey = 'sargoshi.settings.app_language';

  final SharedPreferencesAsync _preferences;

  Future<LiteUiMode> readLiteUiMode() async {
    final stored = await _preferences.getString(_liteUiModeKey);
    return LiteUiMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => LiteUiMode.auto,
    );
  }

  Future<void> writeLiteUiMode(LiteUiMode mode) {
    return _preferences.setString(_liteUiModeKey, mode.name);
  }

  Future<AppLanguage> readAppLanguage() async {
    final stored = await _preferences.getString(_appLanguageKey);
    return AppLanguage.values.firstWhere(
      (language) => language.name == stored,
      orElse: () => AppLanguage.system,
    );
  }

  Future<void> writeAppLanguage(AppLanguage language) {
    return _preferences.setString(_appLanguageKey, language.name);
  }
}

class LiteUiModeController extends AsyncNotifier<LiteUiMode> {
  @override
  Future<LiteUiMode> build() {
    return ref.watch(appSettingsStoreProvider).readLiteUiMode();
  }

  Future<void> setMode(LiteUiMode mode) async {
    final store = ref.read(appSettingsStoreProvider);
    try {
      await store.writeLiteUiMode(mode);
      state = AsyncData(mode);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

class AppLanguageController extends AsyncNotifier<AppLanguage> {
  @override
  Future<AppLanguage> build() {
    return ref.watch(appSettingsStoreProvider).readAppLanguage();
  }

  Future<void> setLanguage(AppLanguage language) async {
    final store = ref.read(appSettingsStoreProvider);
    try {
      await store.writeAppLanguage(language);
      state = AsyncData(language);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
