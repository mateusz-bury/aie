import 'package:flutter/foundation.dart';

/// Centralne miejsce konfiguracji API.
///
/// Nadpisywanie (DEV):
/// flutter run --dart-define=API_SCHEME=https --dart-define=API_HOST=localhost --dart-define=API_PORT=7221
class ApiConfig {
  static const String _scheme = String.fromEnvironment(
    'API_SCHEME',
    defaultValue: 'https',
  );
  static const String _host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'localhost',
  );
  static const int _port = int.fromEnvironment(
    'API_PORT',
    defaultValue: 7221,
  );

  /// Bazowy adres (np. https://localhost:7221)
  static String get origin {
    // Flutter Web: nie mamy Platform.isAndroid, ale host zwykle jest OK.
    if (kIsWeb) {
      return '$_scheme://$_host:$_port';
    }
    // Mobile/desktop: host można podać przez dart-define.
    return '$_scheme://$_host:$_port';
  }

  static Uri uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse(origin).replace(
      path: path.startsWith('/') ? path : '/$path',
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );
  }
}
