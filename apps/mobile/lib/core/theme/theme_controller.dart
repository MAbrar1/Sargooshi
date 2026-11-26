import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';

final themePresetProvider = StateProvider<SargoshiThemePreset>(
  (ref) => SargoshiThemePreset.system,
);
