import 'dart:convert';

import 'package:aie/core/api/api_config.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:http/http.dart' as http;

class CharacterAbilityService {
  static Uri _endpoint(int characterId, [String path = '']) =>
      ApiConfig.uri('/api/character/$characterId/abilities$path');

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

  static Future<void> addAbility({
    required int characterId,
    required int abilityId,
  }) async {
    final headers = await _authHeaders(json: true);
    final body = jsonEncode({
      'abilities': [
        {'abilityId': abilityId, 'characterId': characterId}
      ]
    });

    final response = await http.post(
      _endpoint(characterId),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Błąd dodawania ability: ${response.statusCode} ${response.body}');
    }
  }

  static Future<void> removeAbility({
    required int characterId,
    required int abilityId,
  }) async {
    final headers = await _authHeaders(json: true);
    final body = jsonEncode({
      'abilities': [
        {'abilityId': abilityId, 'characterId': characterId}
      ]
    });

    final response = await http.delete(
      _endpoint(characterId),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Błąd usuwania ability: ${response.statusCode} ${response.body}');
    }
  }
}
