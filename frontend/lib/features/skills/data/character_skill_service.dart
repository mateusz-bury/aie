import 'dart:convert';

import 'package:aie/core/api/api_config.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:http/http.dart' as http;

class CharacterSkillService {
  static Uri _endpoint(int characterId, [String path = '']) =>
      ApiConfig.uri('/api/character/$characterId/skills$path');

  static Future<Map<String, String>> _authHeaders({bool json = false}) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Brak tokena autoryzacyjnego – zaloguj się ponownie.');
    }
    return {
      'Authorization': 'Bearer $token',
      if (json) 'Content-Type': 'application/json',
    };
  }

  static Future<void> addSkill({
    required int characterId,
    required int skillId,
  }) async {
    final headers = await _authHeaders(json: true);
    final body = jsonEncode({
      'skills': [
        {'skillId': skillId, 'characterId': characterId}
      ]
    });

    final response = await http.post(
      _endpoint(characterId),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Błąd dodawania skilla: ${response.statusCode} ${response.body}');
    }
  }

  static Future<void> removeSkill({
    required int characterId,
    required int skillId,
  }) async {
    final headers = await _authHeaders(json: true);
    final body = jsonEncode({
      'skills': [
        {'skillId': skillId, 'characterId': characterId}
      ]
    });

    final response = await http.delete(
      _endpoint(characterId),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Błąd usuwania skilla: ${response.statusCode} ${response.body}');
    }
  }
}
