import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/app_settings.dart';
import 'app_theme.dart';

final themePresetProvider =
    AsyncNotifierProvider<ThemePresetController, SargoshiThemePreset>(
  ThemePresetController.new,
);

class ThemePresetController extends AsyncNotifier<SargoshiThemePreset> {
  @override
  Future<SargoshiThemePreset> build() {
    return ref.watch(appSettingsStoreProvider).readThemePreset();
  }

  Future<void> setPreset(SargoshiThemePreset preset) async {
    final store = ref.read(appSettingsStoreProvider);
    try {
      await store.writeThemePreset(preset);
      state = AsyncData(preset);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
