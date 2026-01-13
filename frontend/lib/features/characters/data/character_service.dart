import 'dart:convert';

import 'package:aie/core/api/api_config.dart';
import 'package:aie/core/utils/app_logger.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/characters/domain/character.dart';
import 'package:aie/features/characters/domain/playable_character.dart';
import 'package:http/http.dart' as http;

class CharacterService {
  static Uri _endpoint([String path = '']) => ApiConfig.uri('/api/character$path');

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

  static Future<List<Character>> fetchCharacters() async {
    try {
      final headers = await _authHeaders();
      final response = await http.get(_endpoint(), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Character.fromJson(json)).toList();
      }

      AppLogger.w('Błąd pobierania postaci: ${response.statusCode}');
      AppLogger.d('Treść: ${response.body}');
      return [];
    } catch (e) {
      AppLogger.e('Błąd fetchCharacters: $e', e);
      return [];
    }
  }

  static Future<PlayableCharacter> fetchCharacterById(int id) async {
    final headers = await _authHeaders();
    final response = await http.get(_endpoint('/$id'), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PlayableCharacter.fromJson(data);
    }

    throw Exception('Błąd pobierania postaci o id $id: ${response.statusCode} ${response.body}');
  }

  /// Backend: PUT /api/character/{id} przyjmuje UpdateCharacterDto (z CampaignId, bez statystyk).
  static Future<void> updateCharacterBasic(PlayableCharacter character) async {
    final headers = await _authHeaders(json: true);
    final response = await http.put(
      _endpoint('/${character.id}'),
      headers: headers,
      body: jsonEncode(character.toUpdateDtoJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Błąd aktualizacji postaci: ${response.statusCode} ${response.body}');
    }
  }


  static String _statisticTypeToApiValue(int type) {
    switch (type) {
      case 1:
        return 'Current';
      case 2:
        return 'Temporary';
      case 3:
        return 'Template';
      case 0:
      default:
        return 'Base';
    }
  }

  /// Wariant niskopoziomowy: pozwala wysłać statystyki z mapy wartości (np. Base i Current osobno).
  /// statsKeys muszą być w camelCase zgodnym z backendowym UpdateStatisticDto (np. ballisticSkill, movement).
  static Future<void> updateCharacterStatsRaw({
    required int characterId,
    required int statisticType,
    required Map<String, int> stats,
  }) async {
    final headers = await _authHeaders(json: true);

    final body = <String, dynamic>{
      'statisticType': _statisticTypeToApiValue(statisticType),
      ...stats,
    };

    final response = await http.post(
      _endpoint('/$characterId/statistics'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Błąd aktualizacji statystyk: ${response.statusCode} ${response.body}');
    }
  }

  /// Backend: POST /api/character/{id}/statistics przyjmuje UpdateStatisticDto.
  /// Używamy statisticType=1 (Current) jako "edytowalne" staty.
  static Future<void> updateCharacterStats(PlayableCharacter character, {int statisticType = 1}) async {
    final headers = await _authHeaders(json: true);
    final response = await http.post(
      _endpoint('/${character.id}/statistics'),
      headers: headers,
      body: jsonEncode(character.toUpdateStatisticDtoJson(statisticType: statisticType)),
    );

    if (response.statusCode != 200) {
      throw Exception('Błąd aktualizacji statystyk: ${response.statusCode} ${response.body}');
    }
  }

  /// Backend: POST /api/character przyjmuje CreateCharacterDto i zwraca 201 Created z Location.
  static Future<int?> createCharacter(PlayableCharacter character) async {
    final headers = await _authHeaders(json: true);
    final response = await http.post(
      _endpoint(),
      headers: headers,
      body: jsonEncode(character.toCreateDtoJson()),
    );

    if (response.statusCode == 201) {
      final location = response.headers['location'];
      if (location == null) return null;
      // location w backendzie: "api/character/{id}" (często bez hosta)
      final parts = location.split('/');
      final idStr = parts.isNotEmpty ? parts.last : '';
      return int.tryParse(idStr);
    }

    if (response.statusCode == 400) {
      throw Exception('Nieprawidłowe dane (400): ${response.body}');
    }
    if (response.statusCode == 401) {
      throw Exception('Brak autoryzacji (401) – zaloguj się ponownie.');
    }

    throw Exception('Błąd tworzenia postaci: ${response.statusCode} ${response.body}');
  }

  static Future<void> deleteCharacter(int characterId) async {
    final headers = await _authHeaders();
    final response = await http.delete(_endpoint('/$characterId'), headers: headers);
    if (response.statusCode != 204) {
      throw Exception('Błąd usuwania postaci: ${response.statusCode} ${response.body}');
    }
  }

  /// Przypina istniejącą postać do kampanii.
  ///
  /// Backend: (opcja 1) zwykłe PUT /api/character/{id} z UpdateCharacterDto,
  /// który zawiera CampaignId.
  static Future<void> assignCharacterToCampaign({required int characterId, required int campaignId}) async {
    // UpdateCharacterDto wymaga też pól podstawowych, więc pobieramy aktualną postać
    // i wysyłamy pełny payload z podmienionym campaignId.
    final current = await fetchCharacterById(characterId);
    final payload = current.toUpdateDtoJson();
    payload['campaignId'] = campaignId;

    final headers = await _authHeaders(json: true);
    final response = await http.put(
      _endpoint('/$characterId'),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception('Błąd przypisania postaci do kampanii: ${response.statusCode} ${response.body}');
    }
  }
}
