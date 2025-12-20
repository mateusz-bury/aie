import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:aie/core/utils/app_logger.dart';
import 'package:aie/features/auth/domain/user.dart';

class AuthService {
  static const String baseUrl = 'https://localhost:7221/api/account';
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

    final url = Uri.parse('$baseUrl/user');

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
    final url = Uri.parse('$baseUrl/login');
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

  static Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
    required String repeatPassword,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'Email': email,
      'Password': password,
      'ConfirmPassword': repeatPassword,
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': username,
      'RoleId': 1, // domyślna rola użytkownika
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        AppLogger.w('Błąd rejestracji: ${response.statusCode}');
        AppLogger.d('Treść: ${response.body}');
        return false;
      }
    } catch (e) {
      AppLogger.e('Wyjątek podczas rejestracji: $e', e);
      return false;
    }
  }

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = await getToken();
    if (token == null) return false;

    final url = Uri.parse('$baseUrl/changePassword');
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
