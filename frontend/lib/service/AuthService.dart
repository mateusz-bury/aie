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
    final url = Uri.parse('https://localhost:7221/api/auth/login');

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

  // NOWA METODA REJESTRACJI
  static Future<bool> register({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    final url = Uri.parse('http://localhost:7221/api/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      }),
    );

    if (response.statusCode == 201) {
      // Załóżmy, że backend zwraca 201 Created przy sukcesie rejestracji
      return true;
    } else {
      return false;
    }
  }
}
