import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

// SG:STG-06
enum LiteUiMode { auto, on, off }

// SG:STL-01
enum AppLanguage { system, english, urdu }

enum PerformanceTierChoice { auto, t1, t2, t3 }

extension AppLanguageX on AppLanguage {
  Locale? get locale => switch (this) {
        AppLanguage.system => null,
        AppLanguage.english => const Locale('en'),
        AppLanguage.urdu => const Locale('ur'),
      };
}

final appSettingsStoreProvider = Provider<AppSettingsStore>(
  (ref) => AppSettingsStore(SharedPreferencesSettingsPreferences()),
);

final liteUiModeProvider =
    AsyncNotifierProvider<LiteUiModeController, LiteUiMode>(
  LiteUiModeController.new,
);

final appLanguageProvider =
    AsyncNotifierProvider<AppLanguageController, AppLanguage>(
  AppLanguageController.new,
);

final performanceTierChoiceProvider =
    AsyncNotifierProvider<PerformanceTierChoiceController, PerformanceTierChoice>(
  PerformanceTierChoiceController.new,
);

/// Minimal asynchronous contract used by the settings domain.
abstract interface class AppSettingsPreferences {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
}

/// Production adapter backed by the platform's asynchronous preferences API.
class SharedPreferencesSettingsPreferences
    implements AppSettingsPreferences {
  SharedPreferencesSettingsPreferences([SharedPreferencesAsync? preferences])
      : _preferences = preferences ?? SharedPreferencesAsync();

  final AppSettingsPreferences _preferences;

  @override
  Future<String?> getString(String key) => _preferences.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _preferences.setString(key, value);
}

class AppSettingsStore {
  const AppSettingsStore(this._preferences);

  static const _liteUiModeKey = 'sargoshi.settings.lite_ui_mode';
  static const _appLanguageKey = 'sargoshi.settings.app_language';
  static const _performanceTierKey = 'sargoshi.settings.performance_tier';
  static const _themePresetKey = 'sargoshi.settings.theme_preset';

  final SharedPreferencesAsync _preferences;

  Future<SargoshiThemePreset> readThemePreset() async {
    final stored = await _preferences.getString(_themePresetKey);
    return SargoshiThemePreset.values.firstWhere(
      (preset) => preset.name == stored,
      orElse: () => SargoshiThemePreset.dark,
    );
  }

  Future<void> writeThemePreset(SargoshiThemePreset preset) {
    return _preferences.setString(_themePresetKey, preset.name);
  }

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

  Future<PerformanceTierChoice> readPerformanceTierChoice() async {
    final stored = await _preferences.getString(_performanceTierKey);
    return PerformanceTierChoice.values.firstWhere(
      (choice) => choice.name == stored,
      orElse: () => PerformanceTierChoice.auto,
    );
  }

  Future<void> writePerformanceTierChoice(PerformanceTierChoice choice) {
    return _preferences.setString(_performanceTierKey, choice.name);
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

class PerformanceTierChoiceController
    extends AsyncNotifier<PerformanceTierChoice> {
  @override
  Future<PerformanceTierChoice> build() {
    return ref.watch(appSettingsStoreProvider).readPerformanceTierChoice();
  }

  Future<void> setChoice(PerformanceTierChoice choice) async {
    final store = ref.read(appSettingsStoreProvider);
    try {
      await store.writePerformanceTierChoice(choice);
      state = AsyncData(choice);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
