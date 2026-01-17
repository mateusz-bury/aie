import 'package:flutter/foundation.dart';

// Centralne miejsce konfiguracji API.

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

  // Bazowy adres (np. https://localhost:7221)
  static String get origin {
    if (kIsWeb) {
      return '$_scheme://$_host:$_port';
    }
    return '$_scheme://$_host:$_port';
  }

  static Uri uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse(origin).replace(
      path: path.startsWith('/') ? path : '/$path',
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );
  }
}
