import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String username;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      username: json['userName'] ?? '',
    );
  }
}

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
      print('Błąd pobierania danych użytkownika: ${response.statusCode}');
      print('Treść: ${response.body}');
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
          print('Brak tokena w odpowiedzi logowania');
          return null;
        }

        await _saveToken(token);

        return await fetchCurrentUser();
      } else {
        print('Błąd logowania: ${response.statusCode}');
        print('Treść: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Wyjątek podczas logowania: $e');
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
      print('Błąd rejestracji: ${response.statusCode}');
      print('Treść: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Wyjątek podczas rejestracji: $e');
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
        print('Błąd zmiany hasła: ${response.statusCode}');
        print('Treść: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Wyjątek podczas zmiany hasła: $e');
      return false;
    }
  }
}
