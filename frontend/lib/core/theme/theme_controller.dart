import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aie/core/theme/app_theme.dart';

enum AieThemeKey { blue, red, gray }

class ThemeController {
  static final ThemeController instance = ThemeController._();
  ThemeController._();

  static const _storage = FlutterSecureStorage();
  static const _key = 'aie_theme_key';

  final ValueNotifier<AieThemeKey> current = ValueNotifier(AieThemeKey.blue);

  ThemeData get themeData => AppTheme.forKeyName(current.value.name);

  Future<void> load() async {
    final v = await _storage.read(key: _key);
    switch (v) {
      case 'red':
        current.value = AieThemeKey.red;
        break;
      case 'gray':
        current.value = AieThemeKey.gray;
        break;
      case 'blue':
      default:
        current.value = AieThemeKey.blue;
        break;
    }
  }

  Future<void> setTheme(AieThemeKey key) async {
    current.value = key;
    await _storage.write(key: _key, value: key.name);
  }
}
