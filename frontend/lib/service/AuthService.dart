import 'dart:convert';
import 'package:http/http.dart' as http;

/// Klasa reprezentująca użytkownika po zalogowaniu
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
      username: json['username'] ?? '',
    );
  }
}

/// Serwis do obsługi uwierzytelniania
class AuthService {
  static const String baseUrl = 'https://localhost:7221/api/auth';

  /// Logowanie użytkownika – zwraca obiekt User po poprawnym zalogowaniu
  static Future<User?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return User.fromJson(json);
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

  /// Rejestracja użytkownika (opcjonalnie, jeśli potrzebujesz)
  static Future<bool> register({
  required String firstName,
  required String lastName,
  required String email,
  required String username,
  required String password,
}) async {
  final url = Uri.parse('$baseUrl/register');
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'username': username,
    'password': password,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Błąd rejestracji: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Wyjątek podczas rejestracji: $e');
    return false;
  }
}

}
