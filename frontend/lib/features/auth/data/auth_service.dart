import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:aie/core/utils/app_logger.dart';
import 'package:aie/features/auth/domain/user.dart';
import 'package:aie/core/api/api_config.dart';

class RegisterResult {
  final bool success;
  final String? message;
  const RegisterResult(this.success, {this.message});
}

class AuthService {
  static Uri _endpoint(String path) => ApiConfig.uri('/api/account$path');
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<void> _saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> logOut() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<User?> fetchCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    final url = _endpoint('/user');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return User.fromJson(json);
    } else {
      AppLogger.w('Błąd pobierania danych użytkownika: ${response.statusCode}');
      AppLogger.d('Treść: ${response.body}');
      return null;
    }
  }

  static Future<User?> login(String email, String password) async {
    final url = _endpoint('/login');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final String token = response.body.trim();

        if (token.isEmpty) {
          AppLogger.w('Brak tokena w odpowiedzi logowania');
          return null;
        }

        await _saveToken(token);

        return await fetchCurrentUser();
      } else {
        AppLogger.w('Błąd logowania: ${response.statusCode}');
        AppLogger.d('Treść: ${response.body}');
        return null;
      }
    } catch (e) {
      AppLogger.e('Wyjątek podczas logowania: $e', e);
      return null;
    }
  }

  static Future<RegisterResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
    required String repeatPassword,
  }) async {
    final url = _endpoint('/register');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'Email': email,
      'Password': password,
      'ConfirmPassword': repeatPassword,
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': username,
      'RoleId': 4,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const RegisterResult(true);
      }


      String message = response.body.trim();
      if (message.isEmpty) {
        message = 'Błąd rejestracji (${response.statusCode}).';
      } else {
        // Jeśli backend zwróci ProblemDetails / ValidationProblemDetails
        try {
          final decoded = jsonDecode(message);
          if (decoded is Map<String, dynamic>) {
            if (decoded['errors'] is Map) {
              final errors = decoded['errors'] as Map;
              final firstKey =
                  errors.keys.isNotEmpty ? errors.keys.first : null;
              if (firstKey != null &&
                  errors[firstKey] is List &&
                  (errors[firstKey] as List).isNotEmpty) {
                message = (errors[firstKey] as List).first.toString();
              } else {
                message = 'Nieprawidłowe dane rejestracji.';
              }
            } else if (decoded['title'] != null) {
              message = decoded['title'].toString();
            }
          }
        } catch (_) {
          // body nie jest JSONem — zostaw tekst jak jest
        }
      }

      AppLogger.w('Błąd rejestracji: ${response.statusCode}');
      AppLogger.d('Treść: ${response.body}');
      return RegisterResult(false, message: message);
    } catch (e) {
      AppLogger.e('Wyjątek podczas rejestracji: $e', e);
      return RegisterResult(false, message: 'Wyjątek podczas rejestracji: $e');
    }
  }

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = await getToken();
    if (token == null) return false;

    final url = _endpoint('/changePassword');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        AppLogger.w('Błąd zmiany hasła: ${response.statusCode}');
        AppLogger.d('Treść: ${response.body}');
        return false;
      }
    } catch (e) {
      AppLogger.e('Wyjątek podczas zmiany hasła: $e', e);
      return false;
    }
  }
}
