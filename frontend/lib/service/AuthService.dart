// lib/service/AuthService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        username: json['username'],
      );
}

class AuthService {
  static User? _currentUser;

  static Future<bool> login(String username, String password) async {
    final url = Uri.parse('http://localhost:7221/api/auth/login'); // ZMIEŃ na swój adres IP/port jeśli testujesz na emulatorze/telefonie

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _currentUser = User.fromJson(data);
      return true;
    } else {
      return false;
    }
  }

  static User? getCurrentUser() => _currentUser;
}
