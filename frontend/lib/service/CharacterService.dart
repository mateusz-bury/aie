// lib/service/CharacterService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aie/service/AuthService.dart';
import '../models/Character.dart';

class CharacterService {
  static const String baseUrl = 'https://localhost:7221/api/character';

  static Future<List<Character>> fetchCharacters() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      print('Błąd pobierania postaci: ${response.statusCode}');
      return [];
    }
  }
}
