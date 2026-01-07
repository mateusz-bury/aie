import 'dart:convert';

import 'package:aie/core/api/api_config.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/items/domain/character_item.dart';
import 'package:http/http.dart' as http;

class CharacterItemService {
  static Uri _endpoint(int characterId, [String path = '']) =>
      ApiConfig.uri('/api/character/$characterId/item$path');

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

  static Future<List<CharacterItem>> fetchInventory(int characterId) async {
    final headers = await _authHeaders();
    final response = await http.get(_endpoint(characterId), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => CharacterItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Błąd pobierania ekwipunku: ${response.statusCode} ${response.body}');
  }

  static Future<void> addItem({
    required int characterId,
    required int itemId,
    required int count,
  }) async {
    final headers = await _authHeaders(json: true);
    final response = await http.post(
      _endpoint(characterId),
      headers: headers,
      body: jsonEncode({'itemId': itemId, 'count': count}),
    );

    if (response.statusCode != 201) {
      throw Exception('Błąd dodawania itemu do postaci: ${response.statusCode} ${response.body}');
    }
  }

  static Future<void> removeItem({
    required int characterId,
    required int itemId,
  }) async {
    final headers = await _authHeaders();
    final response = await http.delete(_endpoint(characterId, '/$itemId'), headers: headers);
    if (response.statusCode != 204) {
      throw Exception('Błąd usuwania itemu z postaci: ${response.statusCode} ${response.body}');
    }
  }
}
