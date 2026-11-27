import 'package:sargoshi/core/settings/app_settings.dart';

class MemoryAppSettingsPreferences implements AppSettingsPreferences {
  MemoryAppSettingsPreferences({
    Map<String, String> initialValues = const {},
  }) : _values = Map<String, String>.of(initialValues);

  final Map<String, String> _values;

  @override
  Future<String?> getString(String key) async => _values[key];

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }
}

AppSettingsStore createMemoryAppSettingsStore({
  Map<String, String> initialValues = const {},
}) {
  return AppSettingsStore(
    MemoryAppSettingsPreferences(initialValues: initialValues),
  );
}
